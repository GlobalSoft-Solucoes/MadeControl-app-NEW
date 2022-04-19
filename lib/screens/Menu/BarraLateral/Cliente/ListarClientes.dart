import 'dart:convert';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:madecontrol_desenvolvimento/Statics/Static_Cliente.dart';
import 'package:madecontrol_desenvolvimento/Widget/Cabecalho.dart';
import 'package:madecontrol_desenvolvimento/Widget/ListFieldsDataBase.dart';
import 'package:madecontrol_desenvolvimento/Widget/MsgPopup.dart';
import 'package:madecontrol_desenvolvimento/models/Models_Clientes.dart';
import 'package:madecontrol_desenvolvimento/models/Models_Usuario.dart';
import 'package:madecontrol_desenvolvimento/models/constantes.dart';
import 'package:madecontrol_desenvolvimento/screens/Menu/BarraLateral/Cliente/DetalheDoCliente.dart';

class ListadeClientes extends StatefulWidget {
  @override
  _ListadeClientesState createState() => _ListadeClientesState();
}

class _ListadeClientesState extends State<ListadeClientes> {
  var dadosClientes = <ModelsClientes>[];
  RxBool? loading = true.obs;
  Future<dynamic> listarDados() async {
    final response = await http.get(
      Uri.parse(ListarTodosClientes + ModelsUsuarios.caminhoBaseUser.toString()),
      headers: {"authorization": ModelsUsuarios.tokenAuth.toString()},
    );
    if (response.statusCode == 401) {
      Navigator.pushNamed(context, '/Login');
    }
    //IF(MOUNTED) É nescessario para não recarregar a arvore apos retornar das outras listas
    if (mounted)
      setState(
        () {
          Iterable lista = json.decode(response.body);
          dadosClientes =
              lista.map((model) => ModelsClientes.fromJson(model)).toList();
        },
      );
    loading!.value = false;
  }

  Future<dynamic> delete(int? id) async {
    var response = await http.delete(
        Uri.parse(DeletarCliente + id.toString() + '/' + ModelsUsuarios.caminhoBaseUser.toString()),
        headers: {"authorization": ModelsUsuarios.tokenAuth.toString()});
    print(response.statusCode);

    if (response.statusCode == 400) {
      msgErro(
          'Este usuário não pode ser excluído pois tem dependências com outros registros!',
          titulo: 'Atenção');
    }

    if (response.statusCode == 401) {
      Navigator.pushNamed(context, '/Login');
    }
  }

  msgErro(mensagem, {titulo}) {
    MsgPopup().msgFeedback(
      context,
      '\n' + mensagem,
      titulo,
    );
  }

  confExcluir(id) {
    MsgPopup().msgComDoisBotoes(
      context,
      'Deseja excluir o Cliente selecionado?',
      'Cancelar',
      'Confirmar',
      () => {
        Navigator.pop(context),
      },
      () => {
        delete(id),
        Navigator.pop(context),
      },
    );
  }

// Abre a tela para edição do Cliente
  popupEditarCliente(idCliente) {
    MsgPopup().msgComDoisBotoes(
      context,
      'Deseja editar o cliente selecionado?',
      'Não',
      'Sim',
      () => {
        Navigator.pop(context),
      },
      () async {
        Navigator.pop(context);
        await BuscaClientePorId().capturaDadosCliente(idCliente);
        Navigator.pushNamed(context, '/EditarCliente');
      },
      sairAoPressionar: true,
    );
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
          child: Icon(Icons.add, size: 30),
          backgroundColor: Colors.blue,
          label: 'Cadastrar cliente',
          labelStyle: TextStyle(fontSize: 20),
          onTap: () => {Navigator.pushNamed(context, '/CadastrarCliente')},
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
            width: size.width,
            height: size.height,
            color: Colors.green[200],
            child: Column(
              children: [
                Cabecalho().tituloCabecalho(
                  context,
                  'Lista de clientes',
                  iconeVoltar: true,
                  sizeTextTitulo: 0.065,
                  marginBottom: 0.02,
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: size.width * 0.02,
                      right: size.width * 0.02,
                      top: size.height * 0.00,
                      bottom: size.height * 0.01),
                  child: Container(
                    padding: EdgeInsets.only(top: 5, bottom: 5),
                    width: size.width,
                    height: size.height * 0.86,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
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
                                  itemCount: dadosClientes.length,
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
                                                onPressed: (BuildContext
                                                        context) =>
                                                  popupEditarCliente(
                                                  dadosClientes[index]
                                                      .idCliente),
                                              ),
                                                SlidableAction(
                                                label: 'Excluir',
                                                backgroundColor: Colors.red,
                                                icon: Icons.delete_forever,
                                                onPressed: (BuildContext
                                                        context) =>
                                                   confExcluir(
                                                  dadosClientes[index]
                                                      .idCliente),
                                              ),
                                            ],
                                          ),
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ListarDadosCliente(
                                                          idCliente:
                                                              dadosClientes[
                                                                      index]
                                                                  .idCliente),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              alignment: Alignment.center,
                                              height: size.height * 0.16,
                                              width: size.width,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  5,
                                                ),
                                                color: Color(0XFFD1D6DC),
                                              ),
                                              child: SingleChildScrollView(
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  child: ListTile(
                                                    title: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        FieldsDatabase()
                                                            .listaDadosBanco(
                                                                'Nome: ',
                                                                dadosClientes[
                                                                        index]
                                                                    .nome),
                                                        SizedBox(height: 3),
                                                        FieldsDatabase()
                                                            .listaDadosBanco(
                                                                'Cidade: ',
                                                                dadosClientes[
                                                                        index]
                                                                    .cidade),
                                                        SizedBox(height: 3),
                                                        FieldsDatabase()
                                                            .listaDadosBanco(
                                                                'Telefone: ',
                                                                dadosClientes[
                                                                        index]
                                                                    .telefone),
                                                        SizedBox(height: 3),
                                                        FieldsDatabase()
                                                            .listaDadosBanco(
                                                          'Possui DOF?: ',
                                                          dadosClientes[index]
                                                              .dof
                                                              .toString()
                                                              .replaceAll(
                                                                  'false',
                                                                  'Não')
                                                              .replaceAll(
                                                                  'true',
                                                                  'Sim'),
                                                        ),
                                                        if (dadosClientes[index]
                                                                .codigoCliente !=
                                                            null)
                                                          SizedBox(height: 3),
                                                        if (dadosClientes[index]
                                                                .codigoCliente !=
                                                            null)
                                                          FieldsDatabase()
                                                              .listaDadosBanco(
                                                                  'Código cliente: ',
                                                                  dadosClientes[
                                                                          index]
                                                                      .codigoCliente),
                                                      ],
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
