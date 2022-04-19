import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:madecontrol_desenvolvimento/Statics/Static_ConfigAcesso.dart';
import 'package:madecontrol_desenvolvimento/Statics/Static_Usuario.dart';
import 'package:madecontrol_desenvolvimento/Widget/Cabecalho.dart';
import 'package:madecontrol_desenvolvimento/Widget/ListFieldsDataBase.dart';
import 'package:madecontrol_desenvolvimento/Widget/MsgPopup.dart';
import 'package:madecontrol_desenvolvimento/models/constantes.dart';
import 'package:http/http.dart' as http;
import '../../../../models/Models_Usuario.dart';
import '../../../../models/constantes.dart';
import 'ConfigAcessoTelas.dart';

//TELA PARA LISTAR TODOS OS ENDEREÇOS CADASTRADOS
class ListaUsuarios extends StatefulWidget {
  @override
  _ListaUsuariosState createState() => _ListaUsuariosState();

  static fromJson(model) {}
}

class _ListaUsuariosState extends State<ListaUsuarios> {
  TextEditingController controllerExcluirGrupo = TextEditingController();
  var dadosListagem = <ModelsUsuarios>[];
  RxBool? loading = true.obs;
  //CONFIRMAÇÃO DE EXCLUSAO DO GRUPO
  confExcluir(id) {
    MsgPopup().msgComDoisBotoes(
      context,
      'Deseja excluir este usuário selecionado?',
      'Cancelar',
      'Confirmar',
      () => {
        Navigator.pop(context),
      },
      () => {
        _deletarReg(id),
        Navigator.pop(context),
      },
    );
  }

  //DELETA O USUÁRIO
  _deletarReg(id) async {
    var response = await http.delete(
      Uri.parse(DeletarUsuario +
          id.toString() +
          '/' +
          ModelsUsuarios.caminhoBaseUser.toString()),
      headers: {"authorization": ModelsUsuarios.tokenAuth.toString()},
    );
    if (response.statusCode == 401) {
      Navigator.pushNamed(context, '/login');
    }
  }

  //FUNÇÃO PARA BUSCAR OS DADOS NA DB
  Future<dynamic> listarDados() async {
    final response = await http.get(
      Uri.parse(
          ListarTodosUsuarios + ModelsUsuarios.caminhoBaseUser.toString()),
      headers: {"authorization": ModelsUsuarios.tokenAuth.toString()},
    );
    if (response.statusCode == 401) {
      Navigator.pushNamed(context, '/login');
    }
    //IF(MOUNTED) É nescessario para não recarregar a arvore apos retornar das outras listas
    if (mounted)
      setState(() {
        Iterable lista = json.decode(response.body);
        dadosListagem =
            lista.map((model) => ModelsUsuarios.fromJson(model)).toList();
      });
    loading!.value = false;
  }

// POPUP DISPARADO AO CLICAR SOBRE O REGISTRO, COM AS OPÇÕES DE EDITAR O USUÁRIO OU CONFIGURAR O ACESSO DAS TELAS
  editarUsuario() {
    MsgPopup().msgComDoisBotoes(
      context,
      'O que você pretende fazer?',
      'Editar usuário',
      'Config acesso',
      () => {
        Navigator.pop(context),
        Navigator.pushNamed(context, '/EditarDadosUsuario'),
      },
      () => {
        Navigator.pop(context),
        Navigator.pushNamed(context, '/ConfigAcessoTelas'),
      },
      corBotaoDir: Colors.green[400],
      corBotaoEsq: Colors.green[400],
      sairAoPressionar: true,
    );
  }

  //FUNÇÃO PARA DELETAR OS DADOS DA DATABASE
  Future<dynamic> delete(int? id) async {
    var response = await http.delete(
        Uri.parse(DeletarUsuario +
            id.toString() +
            '/' +
            ModelsUsuarios.caminhoBaseUser.toString()),
        headers: {"authorization": ModelsUsuarios.tokenAuth.toString()});
    if (response.statusCode == 401) {
      Navigator.pushNamed(context, '/login');
    }
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
      tooltip: 'Speed Dial',
      heroTag: 'speed-dial-hero-tag',
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 8.0,
      shape: CircleBorder(),
      children: [
        SpeedDialChild(
          child: Icon(Icons.add, size: 30),
          backgroundColor: Colors.blue,
          label: 'Cadastrar usuário',
          labelStyle: TextStyle(fontSize: 20),
          onTap: () => {Navigator.pushNamed(context, '/CadastroUsuario')},
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
            width: size.width,
            height: size.height,
            child: Column(
              children: [
                Cabecalho().tituloCabecalho(
                  context,
                  'Usuários cadastrados',
                  iconeVoltar: true,
                ),
                Container(
                  color: Colors.green[200],
                  height: size.height * 0.83,
                  width: size.width,
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
                                              icon: Icons.edit_outlined,
                                              onPressed:
                                                  (BuildContext context) async {
                                                await BuscaDadosUsuarioPorId()
                                                    .capturaDadosUsuariosPorId(
                                                  dadosListagem[index]
                                                      .idUsuario,
                                                );
                                                Navigator.pushNamed(context,
                                                    '/EditarDadosUsuario');
                                              },
                                            ),
                                            SlidableAction(
                                              label: 'Excluir',
                                              backgroundColor: Colors.red,
                                              icon: Icons.delete_forever,
                                              onPressed:
                                                  (BuildContext context) =>
                                                      dadosListagem[index]
                                                          .idUsuario,
                                            ),
                                          ],
                                        ),
                                        child: Container(
                                          height: 140,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                            color: Color(0XFFD1D6DC),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 0, right: 15),
                                            child: GestureDetector(
                                              onTap: () async {
                                                await FieldsAcessoTelas()
                                                    .capturaConfigAcessoTelasUsuario(
                                                  dadosListagem[index]
                                                      .idUsuario,
                                                );
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        ConfigAcessoTelas(
                                                      idUsuario:
                                                          dadosListagem[index]
                                                              .idUsuario,
                                                    ),
                                                  ),
                                                );
                                                // BuscaDadosUsuarioPorId()
                                                //     .capturaDadosUsuariosPorId(
                                                //   dadosListagem[index].idUsuario,
                                                // );
                                              },
                                              child: SingleChildScrollView(
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    color: Color(0XFFD1D6DC),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      15,
                                                    ),
                                                  ),
                                                  child: ListTile(
                                                    leading: Text(
                                                      '${index + 1}',
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                      ),
                                                    ),
                                                    title: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        FieldsDatabase()
                                                            .listaDadosBanco(
                                                                'Nome: ',
                                                                dadosListagem[
                                                                        index]
                                                                    .name),
                                                        FieldsDatabase()
                                                            .listaDadosBanco(
                                                                'E-mail: ',
                                                                dadosListagem[
                                                                        index]
                                                                    .email),
                                                        FieldsDatabase()
                                                            .listaDadosBanco(
                                                                'Data Cadastro: ',
                                                                dadosListagem[
                                                                        index]
                                                                    .dataCadastro),
                                                        FieldsDatabase()
                                                            .listaDadosBanco(
                                                          'Cargo: ',
                                                          dadosListagem[index]
                                                              .cargoUsuario,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
