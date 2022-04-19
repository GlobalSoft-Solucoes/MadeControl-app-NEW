import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:madecontrol_desenvolvimento/Statics/Static_GrupoPedido.dart';
import 'package:madecontrol_desenvolvimento/Widget/ListFieldsDataBase.dart';
import 'package:madecontrol_desenvolvimento/models/Models_GrupoPedido.dart';
import 'package:madecontrol_desenvolvimento/models/Models_UnidadeMedida.dart';
import 'package:madecontrol_desenvolvimento/models/Models_Usuario.dart';
import 'package:http/http.dart' as http;
import 'package:madecontrol_desenvolvimento/models/constantes.dart';
import 'package:madecontrol_desenvolvimento/Widget/Cabecalho.dart';

class ListarDadosGrupoPedido extends StatefulWidget {
  // ListarDadosGrupoPedido({Key key, @required this.idPedido}) : super(key: key);
  @override
  _ListarDadosGrupoPedidoState createState() => _ListarDadosGrupoPedidoState();
}

class _ListarDadosGrupoPedidoState extends State<ListarDadosGrupoPedido> {
  _ListarDadosGrupoPedidoState() {
    fetchPost(idPedido);
    listarDadosUndMedida(idPedido);
  }
  var listaDadosGrupo = <ModelsGrupoPedido>[];
  RxBool? loading = true.obs;
  Future<dynamic> fetchPost(int? id) async {
    final response = await http.get(
      Uri.parse(
        BuscaDetalhesGrupoPedidoPorId +
            FieldsGrupoPedido.idGrupoPedido.toString() +
            '/' +
            ModelsUsuarios.caminhoBaseUser.toString(),
      ),
      headers: {
        "Content-Type": "application/json",
        "authorization": ModelsUsuarios.tokenAuth.toString()
      },
    );

    if (mounted) {
      setState(
        () {
          Iterable lista = json.decode(response.body);
          listaDadosGrupo =
              lista.map((model) => ModelsGrupoPedido.fromJson(model)).toList();
        },
      );
    }
    loading!.value = false;
  }

  var dadosUndMedida = <ModelsUnidadeMedida>[];
  Future<dynamic> listarDadosUndMedida(int? id) async {
    final response = await http.get(
      Uri.parse(
        BuscaQtdMetrosPorUndMedida +
            FieldsGrupoPedido.idGrupoPedido.toString() +
            '/' +
            ModelsUsuarios.caminhoBaseUser.toString(),
      ),
      headers: {
        "Content-Type": "application/json",
        "authorization": ModelsUsuarios.tokenAuth.toString()
      },
    );

    if (mounted) {
      setState(
        () {
          Iterable lista = json.decode(response.body);
          dadosUndMedida = lista
              .map((model) => ModelsUnidadeMedida.fromJson(model))
              .toList();
        },
      );
    }
  }

  Future<dynamic> deletar() async {
    var response = await http.delete(
      Uri.parse(DeletarPedido +
          idPedido.toString() +
          '/' +
          ModelsUsuarios.caminhoBaseUser.toString()),
      headers: {"authorization": ModelsUsuarios.tokenAuth.toString()},
    );
    if (response.statusCode == 401) {
      Navigator.pushNamed(context, '/login');
    } else if (response.statusCode == 201) {
      Navigator.pop(context);
    }
  }

  int? idPedido;
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
                  'Resumo dos pedidos',
                  iconeVoltar: true,
                  sizeTextTitulo: 0.065,
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: size.width * 0.07,
                    left: size.width * 0.02,
                    right: size.width * 0.02,
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: size.width,
                        height: size.height * 0.25,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white),
                        child: FutureBuilder(
                          future: fetchPost(idPedido),
                          builder: (BuildContext context, snapshot) {
                            return Obx(
                              () => loading!.value == true
                                  ? Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : ListView.builder(
                                      itemCount: listaDadosGrupo.length,
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
                                              // padding: const EdgeInsets.only(
                                              //     left: 0, right: 10),
                                              child: Container(
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    15,
                                                  ),
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(height: 30),
                                                    FieldsDatabase()
                                                        .listaDadosBanco(
                                                      'Cliente: ',
                                                      listaDadosGrupo[index]
                                                          .nomeCliente,
                                                      sizeCampoBanco: 23,
                                                      sizeTextoCampo: 23,
                                                    ),
                                                    SizedBox(height: 20),
                                                    FieldsDatabase()
                                                        .listaDadosBanco(
                                                      'Data do pedido: ',
                                                      listaDadosGrupo[index]
                                                          .dataCadastro!
                                                          .substring(0, 10),
                                                      sizeCampoBanco: 23,
                                                      sizeTextoCampo: 23,
                                                    ),
                                                    SizedBox(height: 20),
                                                    FieldsDatabase()
                                                        .listaDadosBanco(
                                                      'Valor total dos pedidos: ',
                                                      listaDadosGrupo[index]
                                                          .valorTotalPedidos,
                                                      sizeCampoBanco: 23,
                                                      sizeTextoCampo: 23,
                                                    ),
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
                      SizedBox(height: 10),
                      //---------------------------------  segunda listagem -------------------------------
                      Stack(
                        children: <Widget>[
                          Container(
                            width: size.width,
                            height: size.height * 0.45,
                            padding: EdgeInsets.only(
                                left: size.width * 0.16,
                                top: size.width * 0.006),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white),
                            child: Text(
                              'Metros por unidade de medida:',
                              style: TextStyle(
                                fontSize: size.width * 0.045,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Container(
                            // color: Colors.red,
                            width: size.width,
                            height: size.height * 0.45,
                            // decoration: BoxDecoration(
                            //     borderRadius: BorderRadius.circular(10),
                            //     color: Colors.white),
                            // child: Column(
                            //   children: [
                            //     Text('2323'),
                            padding: EdgeInsets.only(top: size.width * 0.06),
                            child: FutureBuilder(
                              future: listarDadosUndMedida(idPedido),
                              builder: (BuildContext context, snapshot) {
                                return Obx(
                                  () => loading!.value == true
                                      ? Center(
                                          child: CircularProgressIndicator(),
                                        )
                                      : ListView.builder(
                                          itemCount: dadosUndMedida.length,
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
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Container(
                                                    padding: EdgeInsets.only(
                                                        left: 15),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                        15,
                                                      ),
                                                    ),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        SizedBox(height: 25),
                                                        if (dadosUndMedida[
                                                                    index]
                                                                .idunidadeMedida !=
                                                            null)
                                                          FieldsDatabase()
                                                              .listaDadosBanco(
                                                            'Unidade de medida: ',
                                                            dadosUndMedida[index]
                                                                        .idunidadeMedida ==
                                                                    4
                                                                ? dadosUndMedida[
                                                                            index]
                                                                        .nomeUnidade =
                                                                    'Lastro'
                                                                : dadosUndMedida[index]
                                                                            .idunidadeMedida ==
                                                                        3
                                                                    ? dadosUndMedida[
                                                                                index]
                                                                            .nomeUnidade =
                                                                        'Metro corrido'
                                                                    : dadosUndMedida[index].idunidadeMedida ==
                                                                            2
                                                                        ? dadosUndMedida[index].nomeUnidade =
                                                                            'Metro quadrado'
                                                                        : dadosUndMedida[index].idunidadeMedida ==
                                                                                1
                                                                            ? dadosUndMedida[index].nomeUnidade =
                                                                                'Metro cúbico'
                                                                            : '',
                                                            sizeCampoBanco: 23,
                                                            sizeTextoCampo: 23,
                                                          ),
                                                        SizedBox(height: 12),
                                                        if (dadosUndMedida[
                                                                    index]
                                                                .idunidadeMedida !=
                                                            null)
                                                          FieldsDatabase()
                                                              .listaDadosBanco(
                                                            dadosUndMedida[index]
                                                                        .idunidadeMedida ==
                                                                    3
                                                                ? dadosUndMedida[
                                                                            index]
                                                                        .nomeUnidade =
                                                                    'Metros corridos: '
                                                                : dadosUndMedida[index]
                                                                            .idunidadeMedida ==
                                                                        2
                                                                    ? dadosUndMedida[
                                                                                index]
                                                                            .nomeUnidade =
                                                                        'Metros quadrados: '
                                                                    : 'Metros cúbicos: ',
                                                            dadosUndMedida[
                                                                    index]
                                                                .totalQtdMetros
                                                                .toString(),
                                                            sizeCampoBanco: 23,
                                                            sizeTextoCampo: 23,
                                                          ),
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
