import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:madecontrol_desenvolvimento/Widget/Cabecalho.dart';
import 'package:madecontrol_desenvolvimento/Widget/ListFieldsDataBase.dart';
import 'package:madecontrol_desenvolvimento/models/Models_ProcessoMad.dart';
import 'package:madecontrol_desenvolvimento/models/Models_Usuario.dart';
import 'package:http/http.dart' as http;
import 'package:madecontrol_desenvolvimento/models/constantes.dart';

class ParametroData {
  static String dataInicio = '';
  static String dataFim = '';
}

class DetalhesTorasPorData extends StatefulWidget {
  DetalhesTorasPorData({Key? key}) : super(key: key);
  @override
  _DetalhesTorasPorDataState createState() => _DetalhesTorasPorDataState();
}

class PermissaoExcluir {
  static RxBool? permissao = false.obs;
}

class _DetalhesTorasPorDataState extends State<DetalhesTorasPorData> {
  var dadosListagem = <MadProcessada>[];
  RxBool? loading = true.obs;
  Future<dynamic> fetchPost(dataini, dataf) async {
    final response = await http.get(
      Uri.parse(BuscaTotalTorasPorData +
          dataini.toString() +
          '/' +
          dataf.toString() +
          '/' +
          ModelsUsuarios.caminhoBaseUser.toString()),
      headers: {
        "Content-Type": "application/json",
        "authorization": ModelsUsuarios.tokenAuth.toString()
      },
    );

    if (mounted) {
      setState(
        () {
          Iterable lista = json.decode(response.body);
          dadosListagem =
              lista.map((model) => MadProcessada.fromJson(model)).toList();
        },
      );
      loading!.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    Size size = mediaQuery.size;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            color: Colors.green[200],
            width: size.width,
            height: size.height,
            child: Column(
              children: [
                Cabecalho().tituloCabecalho(
                  context,
                  'Detalhes do pedido',
                  iconeVoltar: true,
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: size.width * 0.02,
                    right: size.width * 0.02,
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: size.width,
                        height: size.height * 0.75,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white),
                        child: FutureBuilder(
                          future: fetchPost(ParametroData.dataInicio.toString(),
                              ParametroData.dataFim.toString()),
                          builder: (BuildContext context, snapshot) {
                            return Obx(
                              () => loading!.value == true
                                  ? Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : ListView.builder(
                                      itemCount: dadosListagem.length,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                              left: 4, right: 4),
                                          child: Container(
                                            width: size.width,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                15,
                                              ),
                                            ),
                                            child: Container(
                                              alignment: Alignment.center,
                                              child: Container(
                                                padding:
                                                    EdgeInsets.only(left: 5),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    15,
                                                  ),
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    SizedBox(height: 15),
                                                    FieldsDatabase()
                                                        .listaDadosBanco(
                                                            dadosListagem[index]
                                                                        .tipoTora ==
                                                                    1
                                                                ? 'TORRA FINA'
                                                                : dadosListagem[index]
                                                                            .tipoTora ==
                                                                        2
                                                                    ? 'TORRA MÉDIA'
                                                                    : dadosListagem[index].tipoTora ==
                                                                            3
                                                                        ? 'TORRA GROSSA'
                                                                        : dadosListagem[index].tipoTora ==
                                                                                4
                                                                            ? 'TORRA DO PÉ'
                                                                            : 'TOTAL  ',
                                                            '',
                                                            corTextoCampo:
                                                                dadosListagem[index]
                                                                            .tipoTora ==
                                                                        null
                                                                    ? Colors.red
                                                                    : Colors
                                                                        .black),
                                                    SizedBox(height: 5),
                                                    FieldsDatabase()
                                                        .listaDadosBanco(
                                                            'Quantidade: ',
                                                            dadosListagem[index]
                                                                .qtdTorrasPorTipoTora
                                                                .toString()),
                                                    SizedBox(height: 5),

                                                    SizedBox(height: 15),
                                                    //========================================================
                                                    Container(
                                                        margin:
                                                            EdgeInsets.fromLTRB(
                                                                10, 0, 10, 0),
                                                        height: 2,
                                                        color: Colors.black,
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 20)),

                                                    //==================================================
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
