import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:madecontrol_desenvolvimento/Widget/Cabecalho.dart';
import 'package:madecontrol_desenvolvimento/Widget/ListFieldsDataBase.dart';
import 'package:madecontrol_desenvolvimento/Widget/MsgPopup.dart';
import 'package:madecontrol_desenvolvimento/models/Estatisticas/Models_EstClientes.dart';
import 'package:madecontrol_desenvolvimento/models/Models_Usuario.dart';
import 'package:http/http.dart' as http;
import 'package:madecontrol_desenvolvimento/models/constantes.dart';

class DetalhesEstatisticaCliente extends StatefulWidget {
  final int? idCliente;
  DetalhesEstatisticaCliente({Key? key, @required this.idCliente, int? idAno})
      : super(key: key);
  @override
  _DetalhesEstatisticaClienteState createState() =>
      _DetalhesEstatisticaClienteState(idCliente: idCliente);
}

class _DetalhesEstatisticaClienteState
    extends State<DetalhesEstatisticaCliente> {
  _DetalhesEstatisticaClienteState({@required this.idCliente}) {
    fetchPost(idCliente);
  }
  int? idCliente;
  var dadosListagem = <ModelsEstClientes>[];
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
              lista.map((model) => ModelsEstClientes.fromJson(model)).toList();
        },
      );
    }
    loading!.value = false;
  }

  msgConfirmacaoDeletarPedido() {
    MsgPopup().msgComDoisBotoes(
      context,
      'Você deseja remover este pedido?',
      'Não',
      'Sim',
      () => Navigator.pop(context),
      () {
        deletar();
        Navigator.pop(context);
        Navigator.pop(context);
      },
    );
  }

  Future<dynamic> deletar() async {
    var response = await http.delete(
      Uri.parse(DeletarPedido +
          idCliente.toString() +
          '/' +
          ModelsUsuarios.caminhoBaseUser.toString()),
      headers: {"authorization": ModelsUsuarios.tokenAuth.toString()},
    );
    print(response.statusCode);
    print(idCliente);
    if (response.statusCode == 401) {
      Navigator.pushNamed(context, '/login');
    } else if (response.statusCode == 201) {
      Navigator.pop(context);
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
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(
                    left: size.width * 0.02,
                    right: size.width * 0.02,
                    top: size.height * 0.06,
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: size.height * 0.15,
                        width: size.width,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 2),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: FutureBuilder(
                          future: fetchPost(idCliente),
                          builder: (BuildContext context, snapshot) {
                            return ListView.builder(
                              itemCount: dadosListagem.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  child: Column(
                                    children: [
                                      Container(
                                        color: Colors.white,
                                        child: Container(
                                          height: size.height * 0.15,
                                          padding: EdgeInsets.only(
                                            left: size.width * 0.03,
                                          ),
                                          alignment: Alignment.centerLeft,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              FieldsDatabase().listaDadosBanco(
                                                'Cliente: ',
                                                dadosListagem[index]
                                                    .nomeCliente,
                                                sizeCampoBanco: 22,
                                                sizeTextoCampo: 22,
                                              ),
                                              SizedBox(height: 15),
                                              FieldsDatabase().listaDadosBanco(
                                                'CNPJ: ',
                                                dadosListagem[index].cnpj,
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
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 15),
                      Container(
                        height: size.height * 0.35,
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
                                                  height: size.height * 0.35,
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
                                                        'Data último pedido: ',
                                                        dadosListagem[index]
                                                            .dataUltimoPedido
                                                            .toString(),
                                                        sizeCampoBanco: 23,
                                                        sizeTextoCampo: 23,
                                                      ),
                                                      SizedBox(height: 15),
                                                      FieldsDatabase()
                                                          .listaDadosBanco(
                                                        'Faturamento total: ',
                                                        dadosListagem[index]
                                                            .faturamentoCliente,
                                                        sizeCampoBanco: 23,
                                                        sizeTextoCampo: 23,
                                                      ),
                                                      SizedBox(height: 15),
                                                      FieldsDatabase()
                                                          .listaDadosBanco(
                                                        'Qtd total de pedidos: ',
                                                        dadosListagem[index]
                                                            .qtdTotalPedidosCliente,
                                                        sizeCampoBanco: 23,
                                                        sizeTextoCampo: 23,
                                                      ),
                                                      SizedBox(height: 15),
                                                      FieldsDatabase()
                                                          .listaDadosBanco(
                                                        'Media faturamento por pedido: ',
                                                        dadosListagem[index]
                                                            .mediaFaturamentoCliente
                                                            .toString(),
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
