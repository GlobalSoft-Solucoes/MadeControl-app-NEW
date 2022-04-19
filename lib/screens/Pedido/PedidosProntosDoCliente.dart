import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:madecontrol_desenvolvimento/Statics/Static_GrupoPedido.dart';
import 'package:madecontrol_desenvolvimento/Widget/Cabecalho.dart';
import 'package:madecontrol_desenvolvimento/Widget/ListFieldsDataBase.dart';
import 'package:madecontrol_desenvolvimento/Widget/MsgPopup.dart';
import 'package:madecontrol_desenvolvimento/models/Models_Pedidos.dart';
import 'package:http/http.dart' as http;
import 'package:madecontrol_desenvolvimento/models/Models_Usuario.dart';
import 'package:madecontrol_desenvolvimento/models/constantes.dart';
import 'package:madecontrol_desenvolvimento/screens/Pedido/DetalhesDoPedidoDoCliente.dart';
import 'package:madecontrol_desenvolvimento/Statics/Static_Cliente.dart';

class PedidosProntosCliente extends StatefulWidget {
  final int? idGrupoPedido;
  PedidosProntosCliente({Key? key, @required this.idGrupoPedido})
      : super(key: key);
  @override
  _PedidosProntosClienteState createState() =>
      _PedidosProntosClienteState(idGrupoPedido: idGrupoPedido);
}

class _PedidosProntosClienteState extends State<PedidosProntosCliente> {
  _PedidosProntosClienteState({@required this.idGrupoPedido}) {
    listarDados(idGrupoPedido);
  }

  RxBool? loading = true.obs;
  int? idGrupoPedido;
  var dadosListagem = <ModelsPedidos>[];
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

  mostrarSpeedDial() {
    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: IconThemeData(size: 30),
      child: Icon(Icons.add),
      visible: true,
      curve: Curves.bounceIn,
      overlayColor: Colors.white,
      overlayOpacity: 0.6,
      // onOpen: () => print('OPENING DIAL'),
      // onClose: () => print('DIAL CLOSED'),
      tooltip: 'Speed Dial',
      heroTag: 'speed-dial-hero-tag',
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 8.0,
      shape: CircleBorder(),
      children: [
        SpeedDialChild(
          child: Icon(Icons.directions_railway_outlined, size: 35),
          backgroundColor: Colors.green,
          label: 'Fazer romaneio',
          labelStyle: TextStyle(fontSize: 20),
          onTap: () => {
            Navigator.pushNamed(context, '/romaneio'),
          },
        ),
        SpeedDialChild(
          child: Icon(Icons.info_outline_rounded, size: 35),
          backgroundColor: Colors.grey,
          label: 'Resumo dos pedidos',
          labelStyle: TextStyle(fontSize: 20),
          onTap: () => {
            FieldsGrupoPedido.idGrupoPedido = idGrupoPedido,
            Navigator.pushNamed(context, '/DetalhesGrupoPedido'),
          },
        ),
      ],
    );
  }

  msgConfirmacaoDeletarPedido(idPedido) {
    MsgPopup().msgComDoisBotoes(
      context,
      'Você deseja remover este pedido?',
      'Não',
      'Sim',
      () => Navigator.pop(context),
      () {
        deletar(idPedido);
        Navigator.pop(context);
      },
    );
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
        floatingActionButton: mostrarSpeedDial(),
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
                    'Pedidos cadastrados',
                    iconeVoltar: true,
                    sizeTextTitulo: 0.065,
                    marginBottom: 0,
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      left: size.width * 0.025,
                      top: size.height * 0.015,
                      bottom: size.height * 0.014,
                      right: size.width * 0.025,
                    ),
                    child: FieldsDatabase().listaDadosBanco(
                      '',
                      '${Cliente.nomeCliente!.toUpperCase()}',
                      sizeCampoBanco: size.width * 0.05,
                      corCampoBanco: Colors.blue[700],
                    ),
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
                      height: size.height * 0.79,
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
                                                SlidableAction(
                                                  label: 'Excluir',
                                                  backgroundColor: Colors.red,
                                                  icon: Icons.delete_forever,
                                                  onPressed: (BuildContext
                                                          context) =>
                                                      msgConfirmacaoDeletarPedido(
                                                          dadosListagem[index]
                                                              .idPedido),
                                                ),
                                              ],
                                            ),
                                            child: GestureDetector(
                                              onTap: () {
                                                PermissaoExcluir
                                                    .permissao!.value = true;
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
                                                height: size.height * 0.18,
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
                                                            FieldsDatabase()
                                                                .listaDadosBanco(
                                                              'Codigo pedido: ',
                                                              dadosListagem[
                                                                      index]
                                                                  .codPedido,
                                                            ),
                                                            SizedBox(height: 3),
                                                            if (dadosListagem[
                                                                        index]
                                                                    .idPallet !=
                                                                null)
                                                              FieldsDatabase()
                                                                  .listaDadosBanco(
                                                                'Produto: ',
                                                                'Pallet ' +
                                                                    '${dadosListagem[index].nomePallet}',
                                                              ),
                                                            if (dadosListagem[
                                                                        index]
                                                                    .idPallet ==
                                                                null)
                                                              FieldsDatabase()
                                                                  .listaDadosBanco(
                                                                'Produto: ',
                                                                dadosListagem[
                                                                        index]
                                                                    .nomeProduto,
                                                              ),
                                                            SizedBox(height: 3),
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
                                                              'Madeira: ',
                                                              dadosListagem[
                                                                      index]
                                                                  .nomeMadeira,
                                                            ),
                                                            SizedBox(height: 3),
                                                            if (dadosListagem[
                                                                        index]
                                                                    .qtdMetros !=
                                                                null)
                                                              FieldsDatabase()
                                                                  .listaDadosBanco(
                                                                dadosListagem[index]
                                                                            .idUnidadeMedida ==
                                                                        3
                                                                    ? 'Metros corridos: '
                                                                    : dadosListagem[index].idUnidadeMedida ==
                                                                            2
                                                                        ? 'Metros quadrados: '
                                                                        : 'Metros cúbicos: ',
                                                                dadosListagem[
                                                                        index]
                                                                    .qtdMetros
                                                                    .toString(),
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
