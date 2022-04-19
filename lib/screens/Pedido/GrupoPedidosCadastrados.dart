import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:madecontrol_desenvolvimento/Statics/Static_Cliente.dart';
import 'package:madecontrol_desenvolvimento/Statics/Static_GrupoPedido.dart';
import 'package:madecontrol_desenvolvimento/Widget/Cabecalho.dart';
import 'package:madecontrol_desenvolvimento/Widget/MsgPopup.dart';
import 'package:madecontrol_desenvolvimento/models/Models_GrupoPedido.dart';
import 'package:madecontrol_desenvolvimento/models/Models_Usuario.dart';
import 'package:madecontrol_desenvolvimento/models/constantes.dart';
import 'package:http/http.dart' as http;
import 'package:madecontrol_desenvolvimento/screens/Pedido/EditarGrupoPedido.dart';
import 'package:madecontrol_desenvolvimento/screens/Pedido/PedidosCadastradosDoCliente.dart';
import 'package:get/get.dart';

class GrupoPedidosCadastrados extends StatefulWidget {
  @override
  _GrupoPedidosCadastradosState createState() =>
      _GrupoPedidosCadastradosState();
}

class _GrupoPedidosCadastradosState extends State<GrupoPedidosCadastrados> {
  var dadosListagem = <ModelsGrupoPedido>[];
  RxBool? loading = true.obs;
  Future<dynamic> listarDados() async {
    final response = await http.get(
      Uri.parse(ListarGruposPedidosCadastrados +
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
            lista.map((model) => ModelsGrupoPedido.fromJson(model)).toList();
      });
    }
    loading!.value = false;
  }

// abre a tela para edição do grupo de pedidos
  popupEditarGrupoPedidos(id, idcliente, tipoVenda, dataEntrega) {
    MsgPopup().msgComDoisBotoes(
      context,
      'Deseja editar o grupo de pedido selecionado?',
      'Não',
      'Sim',
      () {
        Navigator.pop(context);
      },
      () {
        FieldsGrupoPedido.idCliente = idcliente;
        FieldsGrupoPedido.tipoVenda = tipoVenda;
        FieldsGrupoPedido.dataEntrega = dataEntrega;
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditarGrupoPedido(idGrupoPedido: id),
          ),
        );
      },
      sairAoPressionar: true,
    );
  }

  //restaura o grupo
  Future<dynamic> alterarstatusRemovido(id) async {
    var response = await http.put(
      Uri.parse(AlteraStatusGrupoPedidoParaRemovido +
          id.toString() +
          '/' +
          ModelsUsuarios.caminhoBaseUser.toString()),
      headers: {
        "Content-Type": "application/json",
        "authorization": ModelsUsuarios.tokenAuth.toString()
      },
    );
    if (response.statusCode == 401) {
      Navigator.pushNamed(context, '/login');
    } else if (response.statusCode == 200) {
      Navigator.pop(context);
    }
  }

  mostrarSpeedDial() {
    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: IconThemeData(size: 30),
      child: Icon(Icons.add),
      visible: true,
      curve: Curves.bounceIn,
      overlayColor: Colors.blue[50],
      overlayOpacity: 0.6,
      tooltip: 'Speed Dial',
      heroTag: 'speed-dial-hero-tag',
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 8.0,
      shape: CircleBorder(),
      children: [
        SpeedDialChild(
          child: Icon(Icons.add, size: 35),
          backgroundColor: Colors.green[300],
          label: 'Cadastrar grupo',
          labelStyle: TextStyle(fontSize: 20),
          onTap: () => {
            Navigator.pushNamed(context, '/CadastrarGrupodePedidos'),
          },
        ),
      ],
    );
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
            child: Column(
              children: [
                Cabecalho().tituloCabecalho(
                  context,
                  'Relatorio de pedidos cadastrados',
                  iconeVoltar: true,
                  sizeTextTitulo: 0.05,
                  tituloMarginLeft: 0.02,
                  marginBottom: 0,
                ),
                Container(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Text(
                    'Lista dos pedidos cadastrados:',
                    style: TextStyle(
                      fontSize: size.width * 0.053,
                      color: Colors.green[700],
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: size.width * 0.02,
                    right: size.width * 0.02,
                    bottom: size.height * 0.02,
                  ),
                  child: Container(
                    padding: EdgeInsets.only(top: 5, bottom: 5),
                    width: size.width,
                    height: size.height * 0.79,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: FutureBuilder(
                      future: listarDados(),
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
                                                label: 'Editar',
                                                backgroundColor: Colors.white,
                                                icon: Icons.delete_forever,
                                                onPressed:
                                                    (BuildContext context) =>
                                                        popupEditarGrupoPedidos(
                                                  dadosListagem[index]
                                                      .idGrupoPedido,
                                                  dadosListagem[index]
                                                      .idCliente,
                                                  dadosListagem[index]
                                                      .tipoVenda,
                                                  dadosListagem[index]
                                                      .dataEntrega,
                                                ),
                                              ),
                                              SlidableAction(
                                                label: 'Excluir',
                                                backgroundColor: Colors.red,
                                                icon: Icons.delete_forever,
                                                onPressed:
                                                    (BuildContext context) => {
                                                  MsgPopup().msgComDoisBotoes(
                                                    context,
                                                    'Você deseja remover este Grupo de Pedidos?',
                                                    'Não',
                                                    'Sim',
                                                    () =>
                                                        Navigator.pop(context),
                                                    () {
                                                      alterarstatusRemovido(
                                                          dadosListagem[index]
                                                              .idGrupoPedido);
                                                    },
                                                  )
                                                },
                                              ),
                                            ],
                                          ),
                                          child: GestureDetector(
                                            onTap: () async {
                                              print(
                                                  FieldsGrupoPedido.tipoVenda =
                                                      dadosListagem[index]
                                                          .tipoVenda);

                                              Cliente.nomeCliente =
                                                  dadosListagem[index]
                                                      .nomeCliente;

                                              FieldsGrupoPedido.tipoVenda =
                                                  dadosListagem[index]
                                                      .tipoVenda;

                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      PedidosCadastradosCliente(
                                                          idGrupoPedido:
                                                              dadosListagem[
                                                                      index]
                                                                  .idGrupoPedido),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              height: size.height * 0.17,
                                              width: size.width,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    5,
                                                  ),
                                                  color: Colors.grey[400]),
                                              child: Container(
                                                alignment: Alignment.center,
                                                padding: const EdgeInsets.only(
                                                    left: 0, right: 10),
                                                child: SingleChildScrollView(
                                                  child: Container(
                                                    child: ListTile(
                                                      title: Text(
                                                        'Código do grupo: ${dadosListagem[index].codigoGrupo}' +
                                                            '\nCliente: ${dadosListagem[index].nomeCliente}' +
                                                            '\nCadastro: ${dadosListagem[index].dataCadastro}' +
                                                            '${dadosListagem[index].dataEntrega != null ? '\nEntrega: ${dadosListagem[index].dataEntrega}' : ''}'
                                                                '\nStatus: ${dadosListagem[index].status}',
                                                        style: TextStyle(
                                                          fontSize: 20,
                                                          color: dadosListagem[
                                                                          index]
                                                                      .status!
                                                                      .toUpperCase() ==
                                                                  "PRONTO"
                                                              ? Colors.blue[700]
                                                              : dadosListagem[index]
                                                                          .tipoVenda ==
                                                                      "Balcao"
                                                                  ? Colors.yellow[
                                                                      300]
                                                                  : dadosListagem[index]
                                                                              .status!
                                                                              .toUpperCase() ==
                                                                          "PRODUCAO"
                                                                      ? Colors.brown[
                                                                          400]
                                                                      : Colors
                                                                          .black,
                                                        ),
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
