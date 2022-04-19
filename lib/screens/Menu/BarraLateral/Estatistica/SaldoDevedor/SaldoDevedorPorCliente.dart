import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:madecontrol_desenvolvimento/Statics/Static_SaldoDevedor.dart';
import 'package:madecontrol_desenvolvimento/Widget/Cabecalho.dart';
import 'package:madecontrol_desenvolvimento/Widget/ListFieldsDataBase.dart';
import 'package:madecontrol_desenvolvimento/models/Models_SaldoDevedor.dart';
import 'package:madecontrol_desenvolvimento/models/Models_Usuario.dart';
import 'package:http/http.dart' as http;
import 'package:madecontrol_desenvolvimento/models/constantes.dart';

class SaldoDevedorPorCliente extends StatefulWidget {
  final int? idCliente;
  SaldoDevedorPorCliente({Key? key, @required this.idCliente}) : super(key: key);
  @override
  _SaldoDevedorPorClienteState createState() =>
      _SaldoDevedorPorClienteState(idCliente: idCliente);
}

class _SaldoDevedorPorClienteState extends State<SaldoDevedorPorCliente> {
  _SaldoDevedorPorClienteState({@required this.idCliente}) {
    fetchPost(idCliente);
  }
  int? idCliente;
  var dadosListagem = <ModelsSaldoDevedor>[];
  RxBool? loading = true.obs;
  Future<dynamic> fetchPost(int? id) async {
    final response = await http.get(
      Uri.parse(EstatisticaBuscarClientePorId +
          idCliente.toString() +
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
              lista.map((model) => ModelsSaldoDevedor.fromJson(model)).toList();
        },
      );
    }
    loading!.value = false;
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    Size size = mediaQuery.size;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            color: Colors.black12,
            width: size.width,
            height: size.height,
            child: Column(
              children: [
                Cabecalho().tituloCabecalho(
                  context,
                  'Detalhes do cliente',
                  iconeVoltar: true,
                  sizeTextTitulo: 0.065,
                  corIcone: Colors.black,
                  corTextoTitulo: Colors.black54,
                ),
                Container(
                  padding: EdgeInsets.only(
                    left: size.width * 0.02,
                    right: size.width * 0.02,
                    top: size.height * 0.06,
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: size.height * 0.60,
                        width: size.width,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 2),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: FutureBuilder(
                          future: fetchPost(idCliente),
                          builder: (BuildContext context, snapshot) {
                            return Obx(
                              () => loading!.value == true
                                  ? Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : ListView.builder(
                                      itemCount: dadosListagem.length,
                                      itemBuilder: (context, index) {
                                        return Container(
                                          child: Column(
                                            children: [
                                              Container(
                                                color: Colors.white,
                                                child: Container(
                                                  height: size.height * 0.60,
                                                  padding: EdgeInsets.only(
                                                    left: size.width * 0.03,
                                                  ),
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      FieldsDatabase()
                                                          .listaDadosBanco(
                                                        'Cliente: ',
                                                        dadosListagem[index]
                                                            .nomeCliente,
                                                        sizeCampoBanco: 22,
                                                        sizeTextoCampo: 22,
                                                      ),
                                                      SizedBox(
                                                          height: size.height *
                                                              0.025),
                                                      FieldsDatabase()
                                                          .listaDadosBanco(
                                                        'CNPJ: ',
                                                        FieldsSaldoDevedor.cnpj,
                                                        sizeCampoBanco: 22,
                                                        sizeTextoCampo: 22,
                                                      ),
                                                      SizedBox(
                                                          height: size.height *
                                                              0.025),
                                                      FieldsDatabase()
                                                          .listaDadosBanco(
                                                        'Telefone: ',
                                                        FieldsSaldoDevedor
                                                            .telefone,
                                                        sizeCampoBanco: 22,
                                                        sizeTextoCampo: 22,
                                                      ),
                                                      SizedBox(
                                                          height: size.height *
                                                              0.025),
                                                      FieldsDatabase()
                                                          .listaDadosBanco(
                                                        'Cidade: ',
                                                        FieldsSaldoDevedor
                                                            .cidade,
                                                        sizeCampoBanco: 22,
                                                        sizeTextoCampo: 22,
                                                      ),
                                                      SizedBox(
                                                          height: size.height *
                                                              0.025),
                                                      FieldsDatabase()
                                                          .listaDadosBanco(
                                                        'Data do último pedido: ',
                                                        FieldsSaldoDevedor
                                                            .dataUltimoPedido,
                                                        sizeCampoBanco: 22,
                                                        sizeTextoCampo: 22,
                                                      ),
                                                      SizedBox(
                                                          height: size.height *
                                                              0.025),
                                                      FieldsDatabase()
                                                          .listaDadosBanco(
                                                        'Divida total: ',
                                                        FieldsSaldoDevedor
                                                            .dividaCliente,
                                                        sizeCampoBanco: 22,
                                                        sizeTextoCampo: 22,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
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
