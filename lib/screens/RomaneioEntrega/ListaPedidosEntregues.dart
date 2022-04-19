import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:madecontrol_desenvolvimento/Statics/Static_Romaneio.dart';
import 'package:madecontrol_desenvolvimento/Widget/Cabecalho.dart';
import 'package:get/get.dart';
import 'package:madecontrol_desenvolvimento/Widget/ListFieldsDataBase.dart';
import 'package:madecontrol_desenvolvimento/Widget/MsgPopup.dart';
import 'package:madecontrol_desenvolvimento/models/Models_Romaneios.dart';
import 'package:madecontrol_desenvolvimento/models/Models_Usuario.dart';
import 'package:madecontrol_desenvolvimento/models/constantes.dart';
import 'package:http/http.dart' as http;
import 'package:madecontrol_desenvolvimento/screens/RomaneioEntrega/DetalhesRomaneio.dart';

class RomaneiosEntregues extends StatefulWidget {
  @override
  _RomaneiosEntreguesState createState() => _RomaneiosEntreguesState();
}

class _RomaneiosEntreguesState extends State<RomaneiosEntregues> {
  int? idPedido;
  RxBool? loading = false.obs;
  Future<dynamic> alterarStatus() async {
    var response = await http.put(
     Uri.parse( AlteraTodosStatusGrupoParaExcluido +
          ModelsUsuarios.caminhoBaseUser.toString()),
      headers: {"authorization": ModelsUsuarios.tokenAuth.toString()},
    );

    if (response.statusCode == 401) {
      Navigator.pushNamed(context, '/login');
    }
  }

// abre a tela para edição do romaneio
  popupEditarRomaneio() {
    MsgPopup().msgComDoisBotoes(
      context,
      'Deseja editar o romaneio selecionado?',
      'Não',
      'Sim',
      () => {
        Navigator.pop(context),
      },
      () => {
        Navigator.pop(context),
        Navigator.pushNamed(context, '/EditarRomaneio')
      },
      sairAoPressionar: true,
    );
  }

  var dadosListagem = <ModelsRomaneio>[];
  Future<dynamic> listarRomaneios() async {
    final response = await http.get(
      Uri.parse(ListarTodosRomaneiosCadastrados +
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
              lista.map((model) => ModelsRomaneio.fromJson(model)).toList();
        },
      );
    }
    loading!.value = false;
  }

  Future<dynamic> alterarstatusRemovido(id) async {
    var response = await http.put(
      Uri.parse(AlteraStatusRomaneioParaRemovido +
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

  msgRemoverRomaneio(idRomaneio) {
    MsgPopup().msgComDoisBotoes(
      context,
      'Você deseja remover este romaneio?',
      'Não',
      'Sim',
      () => Navigator.pop(context),
      () {
        alterarstatusRemovido(idRomaneio);
      },
    );
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
                  'Romaneios Concluídos',
                  iconeVoltar: true,
                  sizeTextTitulo: 0.065,
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: size.width * 0.02,
                    right: size.width * 0.02,
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: 5, bottom: 5),
                        width: size.width,
                        height: size.height * 0.84,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        child: FutureBuilder(
                          future: listarRomaneios(),
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
                                                    backgroundColor:
                                                        Colors.white,
                                                    icon: Icons.edit_outlined,
                                                    onPressed: (BuildContext
                                                        context) async {
                                                      popupEditarRomaneio();
                                                      await BuscaRomaneioPorId()
                                                          .capturaDadosRomaneio(
                                                        dadosListagem[index]
                                                            .idRomaneio,
                                                      );
                                                    },
                                                  ),
                                                  SlidableAction(
                                                    label: 'Excluir',
                                                    backgroundColor: Colors.red,
                                                    icon: Icons.delete_forever,
                                                    onPressed: (BuildContext
                                                            context) =>
                                                        msgRemoverRomaneio(
                                                      dadosListagem[index]
                                                          .idRomaneio,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              child: GestureDetector(
                                                onTap: () async {
                                                  await BuscaRomaneioPorId()
                                                      .capturaDadosRomaneio(
                                                          dadosListagem[index]
                                                              .idRomaneio);
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          DetalhesRomaneio(
                                                              idGrupoPedido:
                                                                  dadosListagem[
                                                                          index]
                                                                      .idGrupoPedido),
                                                    ),
                                                  );
                                                },
                                                child: SingleChildScrollView(
                                                  child: Container(
                                                    height: size.height * 0.17,
                                                    alignment: Alignment.center,
                                                    width: size.width,
                                                    decoration: BoxDecoration(
                                                      color: Colors.grey[400],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                        5,
                                                      ),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 0,
                                                              right: 10),
                                                      child:
                                                          SingleChildScrollView(
                                                        child: Container(
                                                          alignment:
                                                              Alignment.center,
                                                          decoration:
                                                              BoxDecoration(
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
                                                                  'Código do grupo: ',
                                                                  dadosListagem[
                                                                          index]
                                                                      .codigoGrupo,
                                                                ),
                                                                FieldsDatabase()
                                                                    .listaDadosBanco(
                                                                  'Data: ',
                                                                  dadosListagem[
                                                                          index]
                                                                      .dataentrega!
                                                                      .substring(
                                                                          0,
                                                                          10),
                                                                ),
                                                                SizedBox(
                                                                    height: 3),
                                                                FieldsDatabase()
                                                                    .listaDadosBanco(
                                                                  'Motorista: ',
                                                                  dadosListagem[
                                                                          index]
                                                                      .nomeMotorista
                                                                      .toString(),
                                                                ),
                                                                SizedBox(
                                                                    height: 3),
                                                                FieldsDatabase()
                                                                    .listaDadosBanco(
                                                                  'Destino: ',
                                                                  dadosListagem[
                                                                          index]
                                                                      .destino,
                                                                ),
                                                                SizedBox(
                                                                    height: 3),
                                                                FieldsDatabase()
                                                                    .listaDadosBanco(
                                                                  'Cliente: ',
                                                                  dadosListagem[
                                                                          index]
                                                                      .nomeCliente,
                                                                  sizeCampoBanco:
                                                                      17.5,
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
