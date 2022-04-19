import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:madecontrol_desenvolvimento/Statics/Static_GrupoPedido.dart';
import 'package:madecontrol_desenvolvimento/Widget/Cabecalho.dart';
import 'package:madecontrol_desenvolvimento/Widget/ListFieldsDataBase.dart';
import 'package:http/http.dart' as http;
import 'package:madecontrol_desenvolvimento/models/Models_ProcessoMad.dart';
import 'package:madecontrol_desenvolvimento/models/Models_Usuario.dart';
import 'package:madecontrol_desenvolvimento/models/constantes.dart';

class DetalhesMadProcessada extends StatefulWidget {
  final int? idProcesso;
  DetalhesMadProcessada({Key? key, @required this.idProcesso}) : super(key: key);
  @override
  _DetalhesMadProcessadaState createState() =>
      _DetalhesMadProcessadaState(idProcesso: idProcesso);
}

class _DetalhesMadProcessadaState extends State<DetalhesMadProcessada> {
  _DetalhesMadProcessadaState({@required this.idProcesso}) {
    listarDados(idProcesso);
  }
  RxBool? loading = true.obs;
  int? idProcesso;
  var dadosListagem = <MadProcessada>[];
  Future<dynamic> listarDados(id) async {
    final response = await http.get(
      Uri.parse(ListarTodosMadProcessada +
          id.toString() +
          '/' +
          ModelsUsuarios.caminhoBaseUser.toString()),
      headers: {"authorization": ModelsUsuarios.tokenAuth.toString()},
    );
    if (response.statusCode == 401) {
      Navigator.pushNamed(context, '/login');
    }
    //IF(MOUNTED) É nescessario para não recarregar a arvore apos retornar das outras listas
    if (mounted) {
      setState(() {
        Iterable lista = json.decode(response.body);
        dadosListagem =
            lista.map((model) => MadProcessada.fromJson(model)).toList();
      });
    }
    loading!.value = false;
  }

  alterarstatuspronto() async {
    if (FieldsGrupoPedido.tipoVenda != 'Balcao') {
      var response = await http.put(
       Uri.parse(AlteraStatusGrupoPedidoParaPronto +
            idProcesso.toString() +
            '/' +
            ModelsUsuarios.caminhoBaseUser.toString()),
        headers: {"authorization": ModelsUsuarios.tokenAuth.toString()},
      );
      if (response.statusCode == 200) {
        Navigator.pushNamed(context, '/GrupoPedidosCadastrados');
      }
      if (response.statusCode == 401) {
        Navigator.pushNamed(context, '/login');
      }
    } else {
      var response = await http.put(
        Uri.parse(AlteraStatusGrupoPedidoParaEntregue +
            idProcesso.toString() +
            '/' +
            ModelsUsuarios.caminhoBaseUser.toString()),
        headers: {"authorization": ModelsUsuarios.tokenAuth.toString()},
      );
      if (response.statusCode == 200) {
        Navigator.pushNamed(context, '/GrupoPedidosCadastrados');
      }
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
            height: size.height,
            width: size.width,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Cabecalho().tituloCabecalho(
                    context,
                    'Detalhes do processo',
                    iconeVoltar: true,
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      left: size.width * 0.025,
                      // top: size.height * 0.005,
                      // bottom: size.height * 0.014,
                      right: size.width * 0.025,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: size.width * 0.02,
                        right: size.width * 0.02,
                        bottom: size.height * 0.02),
                    child: Container(
                      width: size.width,
                      height: size.height * 0.82,
                      padding: const EdgeInsets.only(bottom: 5, top: 5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white),
                      child: FutureBuilder(
                        future: listarDados(idProcesso),
                        builder: (BuildContext context, snapshot) {
                          return Obx(
                            () => loading!.value == true
                                ? Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : ListView.builder(
                                    itemCount: dadosListagem.length,
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            bottom: 0,
                                            top: 8,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 5, right: 5),
                                            child: Container(
                                              alignment: Alignment.center,
                                              height: size.height * 0.09,
                                              width: size.width,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  10,
                                                ),
                                                color: Color(0XFFD1D6DC),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 0, right: 10),
                                                child: SingleChildScrollView(
                                                  child: ListTile(
                                                    leading: Text(
                                                      '${index + 1}',
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                      ),
                                                    ),
                                                    subtitle: FieldsDatabase()
                                                        .listaDadosBanco(
                                                      'Tempo: ',
                                                      dadosListagem[index]
                                                          .tempoProcesso,
                                                      sizeCampoBanco: 22,
                                                      sizeTextoCampo: 22,
                                                    ),
                                                  ),
                                                ),
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
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
