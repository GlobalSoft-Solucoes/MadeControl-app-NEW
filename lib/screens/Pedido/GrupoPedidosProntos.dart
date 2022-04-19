import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:madecontrol_desenvolvimento/Widget/Cabecalho.dart';
import 'package:get/get.dart';
import 'package:madecontrol_desenvolvimento/Widget/ListFieldsDataBase.dart';
import 'package:madecontrol_desenvolvimento/Widget/MsgPopup.dart';
import 'package:madecontrol_desenvolvimento/models/Models_GrupoPedido.dart';
import 'package:madecontrol_desenvolvimento/models/Models_Usuario.dart';
import 'package:madecontrol_desenvolvimento/models/constantes.dart';
import 'package:http/http.dart' as http;
import 'package:madecontrol_desenvolvimento/screens/pedido/PedidosProntosDoCliente.dart';
import 'package:madecontrol_desenvolvimento/Statics/Static_Cliente.dart';

class GrupoPedidosProntos extends StatefulWidget {
  @override
  _GrupoPedidosProntosState createState() => _GrupoPedidosProntosState();
}

class _GrupoPedidosProntosState extends State<GrupoPedidosProntos> {
  var dadosListagem = <ModelsGrupoPedido>[];
  RxBool? loading = true.obs;
  Future<dynamic> listarDados() async {
    final response = await http.get(
      Uri.parse(ListarGruposPedidosProntos +
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
              lista.map((model) => ModelsGrupoPedido.fromJson(model)).toList();
        },
      );
    }
    loading!.value = false;
  }

// abre a tela para edição do grupo de pedidos
  popupEditarGrupoPedidos() {
    MsgPopup().msgComDoisBotoes(
      context,
      'Deseja editar o grupo de pedido selecionado?',
      'Não',
      'Sim',
      () => {},
      () => {},
      sairAoPressionar: true,
    );
  }

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
    if (response.statusCode == 200) {
      Navigator.pop(context);
    }
    if (response.statusCode == 401) {
      Navigator.pushNamed(context, '/login');
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
            child: Column(
              children: [
                Cabecalho().tituloCabecalho(
                  context,
                  'Relatorio de pedidos prontos',
                  iconeVoltar: true,
                  sizeTextTitulo: 0.058,
                  marginBottom: 0,
                ),
                Container(
                  padding: EdgeInsets.all(size.width * 0.02),
                  child: Text(
                    'Lista dos pedidos prontos para entrega:',
                    style: TextStyle(
                      fontSize: size.width * 0.048,
                      color: Colors.blue[700],
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: size.width * 0.02,
                    right: size.width * 0.02,
                    bottom: size.height * 0.01,
                  ),
                  child: Container(
                    padding: EdgeInsets.only(
                      top: 5,
                      bottom: 5,
                    ),
                    width: size.width,
                    height: size.height * 0.80,
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
                                                            .idGrupoPedido,
                                                      );
                                                    },
                                                  ),
                                                },
                                              ),
                                            ],
                                          ),
                                          child: GestureDetector(
                                            onTap: () {
                                              Cliente.nomeCliente =
                                                  dadosListagem[index]
                                                      .nomeCliente;
                                              Cliente.idGrupoPedido =
                                                  dadosListagem[index]
                                                      .idGrupoPedido;
                                              Cliente.codigoGrupo =
                                                  dadosListagem[index]
                                                      .codigoGrupo;
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      PedidosProntosCliente(
                                                    idGrupoPedido:
                                                        dadosListagem[index]
                                                            .idGrupoPedido!,
                                                  ),
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
                                                color: Colors.grey[400],
                                              ),
                                              child: Container(
                                                alignment: Alignment.center,
                                                padding: EdgeInsets.only(
                                                  top: 3,
                                                  left: 0,
                                                  right: 0,
                                                ),
                                                child: SingleChildScrollView(
                                                  child: Container(
                                                    child: ListTile(
                                                      title: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          FieldsDatabase()
                                                              .listaDadosBanco(
                                                            'Código do grupo: ',
                                                            dadosListagem[index]
                                                                .codigoGrupo,
                                                            sizeCampoBanco: 20,
                                                            sizeTextoCampo: 20,
                                                          ),
                                                          SizedBox(height: 3),
                                                          FieldsDatabase()
                                                              .listaDadosBanco(
                                                            'Cliente: ',
                                                            dadosListagem[index]
                                                                .nomeCliente,
                                                            sizeCampoBanco: 20,
                                                            sizeTextoCampo: 20,
                                                          ),
                                                          SizedBox(height: 3),
                                                          FieldsDatabase()
                                                              .listaDadosBanco(
                                                            'Cadastro: ',
                                                            dadosListagem[index]
                                                                .dataCadastro,
                                                            sizeCampoBanco: 20,
                                                            sizeTextoCampo: 20,
                                                          ),
                                                          if (dadosListagem[
                                                                      index]
                                                                  .dataEntrega !=
                                                              null)
                                                            SizedBox(height: 3),
                                                          if (dadosListagem[
                                                                      index]
                                                                  .dataEntrega !=
                                                              null)
                                                            FieldsDatabase()
                                                                .listaDadosBanco(
                                                              'Entrega: ',
                                                              dadosListagem[
                                                                      index]
                                                                  .dataEntrega,
                                                              sizeCampoBanco:
                                                                  20,
                                                              sizeTextoCampo:
                                                                  20,
                                                            ),
                                                          SizedBox(height: 3),
                                                          FieldsDatabase()
                                                              .listaDadosBanco(
                                                            'Status: ',
                                                            dadosListagem[index]
                                                                .status,
                                                            sizeCampoBanco: 20,
                                                            sizeTextoCampo: 20,
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
