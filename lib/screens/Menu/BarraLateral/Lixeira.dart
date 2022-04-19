import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:madecontrol_desenvolvimento/Widget/Cabecalho.dart';
import 'package:madecontrol_desenvolvimento/Widget/ListFieldsDataBase.dart';
import 'package:madecontrol_desenvolvimento/Widget/MsgPopup.dart';
import 'package:madecontrol_desenvolvimento/models/Models_GrupoPedido.dart';
import 'package:madecontrol_desenvolvimento/models/Models_Usuario.dart';
import 'package:madecontrol_desenvolvimento/models/constantes.dart';
import 'package:http/http.dart' as http;

class Lixeira extends StatefulWidget {
  @override
  _LixeiraState createState() => _LixeiraState();
}

class _LixeiraState extends State<Lixeira> {
  var dadosListagem = <ModelsGrupoPedido>[];
  RxBool? loading = true.obs;
  Future<dynamic> fetchPost() async {
    final response = await http.get(
      Uri.parse(ListarGrupoPedidosRemovidos +
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
              lista.map((model) => ModelsGrupoPedido.fromJson(model)).toList();
        },
      );
    }
    loading!.value = false;
  }

//pop de confirmar exclusao
  confirmarExclusao(id) {
    MsgPopup().msgComDoisBotoes(
      context,
      'Você deseja excluir este grupo de pedido permanentemente?',
      'Não',
      'Sim',
      () => Navigator.pop(context),
      () => excluirPermanente(id),
    );
  }

  confirmarRestauracao(id) {
    MsgPopup().msgComDoisBotoes(
      context,
      'Você deseja restaurar este grupo de pedidos?',
      'Não',
      'Sim',
      () => Navigator.pop(context),
      () => restaurar(id),
    );
  }

  Future<dynamic> excluirPermanente(id) async {
    var response = await http.put(
      Uri.parse(AlteraStatusGrupoPedidoParaExcluido +
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
    } else if (response.statusCode == 201) {
      Navigator.pop(context);
    }
  }

  //restaura o grupo
  Future<dynamic> restaurar(id) async {
    var response = await http.put(
     Uri.parse(AlteraStatusGrupoPedidoParaCadastrado +
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
                  'Grupos de pedidos removidos',
                  iconeVoltar: true,
                  sizeTextTitulo: 0.055,
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: size.width * 0.02,
                    right: size.width * 0.02,
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(
                          bottom: 5,
                          top: 5,
                        ),
                        width: size.width,
                        height: size.height * 0.86,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white),
                        child: FutureBuilder(
                          future: fetchPost(),
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
                                            top: size.width * 0.008,
                                            bottom: size.width * 0.008,
                                          ),
                                          child: Container(
                                            child: Slidable(
                                              key: const ValueKey(0),
                                              startActionPane: ActionPane(
                                                motion: const ScrollMotion(),
                                                children: [
                                                  SlidableAction(
                                                    label: 'Restaurar',
                                                    backgroundColor:
                                                        Colors.white,
                                                    icon: Icons.restore,
                                                    onPressed: (BuildContext
                                                        context) async {
                                                      await confirmarRestauracao(
                                                          dadosListagem[index]
                                                              .idGrupoPedido);
                                                    },
                                                  ),
                                                  SlidableAction(
                                                    label: 'Excluir',
                                                    backgroundColor: Colors.red,
                                                    icon: Icons.delete_forever,
                                                    onPressed: (BuildContext
                                                        context) async {
                                                      await confirmarExclusao(
                                                          dadosListagem[index]
                                                              .idGrupoPedido);
                                                    },
                                                  ),
                                                ],
                                              ),
                                              child: Container(
                                                child: Container(
                                                  padding: EdgeInsets.only(
                                                    top: 10,
                                                  ),
                                                  height: size.height * 0.13,
                                                  width: size.width,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      5,
                                                    ),
                                                    color: Colors.grey[400],
                                                  ),
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    child: Column(
                                                      children: [
                                                        ListTile(
                                                          title: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              FieldsDatabase().listaDadosBanco(
                                                                  'Código do grupo: ',
                                                                  dadosListagem[
                                                                          index]
                                                                      .codigoGrupo),
                                                              SizedBox(
                                                                  height: 3),
                                                              FieldsDatabase().listaDadosBanco(
                                                                  'Cliente: ',
                                                                  dadosListagem[
                                                                          index]
                                                                      .nomeCliente),
                                                              SizedBox(
                                                                  height: 3),
                                                              FieldsDatabase()
                                                                  .listaDadosBanco(
                                                                'Data: ',
                                                                dadosListagem[
                                                                        index]
                                                                    .dataCadastro!
                                                                    .substring(
                                                                        0, 10),
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      ],
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
