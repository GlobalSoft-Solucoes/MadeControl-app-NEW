import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:madecontrol_desenvolvimento/Widget/Cabecalho.dart';
import 'package:get/get.dart';
import 'package:madecontrol_desenvolvimento/Widget/ListFieldsDataBase.dart';
import 'package:madecontrol_desenvolvimento/Widget/MsgPopup.dart';
import 'package:madecontrol_desenvolvimento/models/ModelsLog.dart';
import 'package:madecontrol_desenvolvimento/models/Models_Usuario.dart';
import 'package:madecontrol_desenvolvimento/models/constantes.dart';
import 'package:http/http.dart' as http;
import 'package:madecontrol_desenvolvimento/screens/Menu/BarraLateral/usuario/LogUsuarioPorData.dart';

class ListaLogUsuario extends StatefulWidget {
  @override
  _ListaLogUsuarioState createState() => _ListaLogUsuarioState();
}

class _ListaLogUsuarioState extends State<ListaLogUsuario> {
  var dadosLog = <ModelsLogUsuario>[];
  RxBool? loading = true.obs;
  Future<dynamic> listarDados() async {
    final response = await http.get(
      Uri.parse(ListarDatasRegistros + ModelsUsuarios.caminhoBaseUser.toString()),
      headers: {"authorization": ModelsUsuarios.tokenAuth.toString()},
    );
    if (response.statusCode == 401) {
      Navigator.pushNamed(context, '/login');
    }
    //IF(MOUNTED) É nescessario para não recarregar a arvore apos retornar das outras listas
    if (mounted)
      setState(
        () {
          Iterable lista = json.decode(response.body);
          dadosLog =
              lista.map((model) => ModelsLogUsuario.fromJson(model)).toList();
        },
      );
    loading!.value = false;
  }

//pop de confirmar exclusao
  confirmarExclusao(dataReg) {
    MsgPopup().msgComDoisBotoes(
      context,
      'Você deseja excluir este grupo de pedido permanentemente?',
      'Não',
      'Sim',
      () {
        Navigator.pop(context);
      },
      () {
        excluirLogsData(dataReg);
      },
    );
  }

// Faz a exclusão de todos os logs de uma determinada data
  Future<dynamic> excluirLogsData(dataReg) async {
    var response = await http.delete(
      Uri.parse(DeletarLoginsPorData +
          DateTime.parse(dataReg).toString().substring(0, 10) +
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
            width: size.width,
            height: size.height,
            color: Colors.green[200],
            child: Column(
              children: [
                Cabecalho().tituloCabecalho(
                  context,
                  'Datas dos logs registrados',
                  iconeVoltar: true,
                  sizeTextTitulo: 0.058,
                  marginBottom: 0,
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: size.width * 0.02,
                      right: size.width * 0.02,
                      top: size.height * 0.01),
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
                                  itemCount: dadosLog.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          left: 4, right: 4, top: 10),
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ListaLogsUsuarioData(
                                                data: dadosLog[index].dataLogin!,
                                              ),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          height: size.height * 0.09,
                                          width: size.width,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              5,
                                            ),
                                            color: Color(0XFFD1D6DC),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                              top: 10,
                                              left: 5,
                                              right: 10,
                                            ),
                                            child: SingleChildScrollView(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Color(0XFFD1D6DC),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    15,
                                                  ),
                                                ),
                                                child: ListTile(
                                                  title: FieldsDatabase()
                                                      .listaDadosBanco(
                                                    'Data: ',
                                                    dadosLog[index].dataLogin,
                                                    sizeCampoBanco: 22,
                                                    sizeTextoCampo: 22,
                                                  ),
                                                  // ====== Icone da direira ======
                                                  trailing: IconButton(
                                                    icon: Icon(
                                                      Icons.delete_forever,
                                                      color: Colors.red,
                                                      size: 30,
                                                    ),
                                                    padding: EdgeInsets.only(
                                                      left: 25,
                                                      top: 0,
                                                    ),
                                                    onPressed: () => {
                                                      confirmarExclusao(
                                                        dadosLog[index]
                                                            .dataLogin!
                                                            .substring(0, 10)
                                                            .replaceAll(
                                                                ' " ', ' '),
                                                      )
                                                    },
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
