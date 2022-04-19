import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:madecontrol_desenvolvimento/Widget/Cabecalho.dart';
import 'package:madecontrol_desenvolvimento/Widget/ListFieldsDataBase.dart';
import 'package:madecontrol_desenvolvimento/models/Models_Pedidos.dart';
import 'package:http/http.dart' as http;
import 'package:madecontrol_desenvolvimento/models/Models_Usuario.dart';
import 'package:madecontrol_desenvolvimento/models/constantes.dart';
import 'package:madecontrol_desenvolvimento/screens/pedido/DetalhesDoPedidoDoCliente.dart';

class HistoricoPedidosCliente extends StatefulWidget {
  final int? idGrupoPedido;
  HistoricoPedidosCliente({Key? key, @required this.idGrupoPedido})
      : super(key: key);
  @override
  _HistoricoPedidosClienteState createState() =>
      _HistoricoPedidosClienteState(idGrupoPedido: idGrupoPedido);
}

class _HistoricoPedidosClienteState extends State<HistoricoPedidosCliente> {
  _HistoricoPedidosClienteState({@required this.idGrupoPedido}) {
    listarDados(idGrupoPedido);
  }

  int? idGrupoPedido;
  var dadosListagem = <ModelsPedidos>[];
  RxBool? loading = true.obs;
  Future<dynamic> listarDados(id) async {
    final response = await http.get(
      Uri.parse(ListarPorGrupoPedido +
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
      setState(
        () {
          Iterable lista = json.decode(response.body);
          dadosListagem =
              lista.map((model) => ModelsPedidos.fromJson(model)).toList();
        },
      );
    }
    loading!.value = false;
  }

  Future<dynamic> deletar(idPedido) async {
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
                    '',
                    iconeVoltar: true,
                    sizeTextTitulo: 0.065,
                    marginBottom: 0.05,
                    sizeIcone: 38,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: size.width * 0.02,
                        right: size.width * 0.02,
                        bottom: size.height * 0.02),
                    child: Container(
                      padding: EdgeInsets.only(
                        top: 5,
                        bottom: 5,
                      ),
                      width: size.width,
                      height: size.height * 0.83,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      child: FutureBuilder(
                        future: listarDados(idGrupoPedido),
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
                                        padding: EdgeInsets.only(
                                          left: size.width * 0.015,
                                          right: size.width * 0.015,
                                          top: size.width * 0.01,
                                          bottom: size.width * 0.01,
                                        ),
                                        child: Container(
                                          child: Slidable(
                                              key: const ValueKey(0),
                                          startActionPane: ActionPane(
                                            motion: const ScrollMotion(),
                                            children: [
                                            ],
                                          ),
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        ListarDadosPedido(
                                                            idPedido:
                                                                dadosListagem[
                                                                        index]
                                                                    .idPedido),
                                                  ),
                                                );
                                              },
                                              child: Container(
                                                alignment: Alignment.center,
                                                height: size.height * 0.15,
                                                width: size.width,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    5,
                                                  ),
                                                  color: Color(0XFFD1D6DC),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 0, right: 10),
                                                  child: SingleChildScrollView(
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color:
                                                            Color(0XFFD1D6DC),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                          15,
                                                        ),
                                                      ),
                                                      child: ListTile(
                                                        title: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                FieldsDatabase()
                                                                    .listaDadosBanco(
                                                                  'Data: ',
                                                                  dadosListagem[
                                                                          index]
                                                                      .dataPedido,
                                                                ),
                                                                FieldsDatabase()
                                                                    .listaDadosBanco(
                                                                  '  -  Hora: ',
                                                                  dadosListagem[
                                                                          index]
                                                                      .horaPedido!
                                                                      .substring(
                                                                          0, 5),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(height: 3),
                                                            FieldsDatabase()
                                                                .listaDadosBanco(
                                                              'Valor total: ',
                                                              dadosListagem[
                                                                      index]
                                                                  .valorTotal,
                                                            ),
                                                            if (dadosListagem[
                                                                        index]
                                                                    .nomeProduto !=
                                                                null)
                                                              SizedBox(
                                                                  height: 3),
                                                            if (dadosListagem[
                                                                        index]
                                                                    .nomeProduto !=
                                                                null)
                                                              FieldsDatabase()
                                                                  .listaDadosBanco(
                                                                'Produto: ',
                                                                dadosListagem[
                                                                        index]
                                                                    .nomeProduto,
                                                              ),
                                                            if (dadosListagem[
                                                                        index]
                                                                    .nomeMadeira !=
                                                                null)
                                                              SizedBox(
                                                                  height: 3),
                                                            if (dadosListagem[
                                                                        index]
                                                                    .nomeMadeira !=
                                                                null)
                                                              FieldsDatabase()
                                                                  .listaDadosBanco(
                                                                'Madeira: ',
                                                                dadosListagem[
                                                                        index]
                                                                    .nomeMadeira,
                                                              ),
                                                          ],
                                                        ),
                                                      ),
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
