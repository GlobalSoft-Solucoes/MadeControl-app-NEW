import 'dart:convert';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:madecontrol_desenvolvimento/Widget/Cabecalho.dart';
import 'package:madecontrol_desenvolvimento/Widget/ListFieldsDataBase.dart';
import 'package:madecontrol_desenvolvimento/Widget/MsgPopup.dart';
import 'package:madecontrol_desenvolvimento/models/ModelsLog.dart';
import 'package:madecontrol_desenvolvimento/models/Models_Usuario.dart';
import 'package:madecontrol_desenvolvimento/models/constantes.dart';

class ListaLogsUsuarioData extends StatefulWidget {
  final String? data;
  ListaLogsUsuarioData({Key? key, @required this.data}) : super(key: key);
  @override
  _ListaLogsUsuarioDataState createState() =>
      _ListaLogsUsuarioDataState(data: data);
}

class _ListaLogsUsuarioDataState extends State<ListaLogsUsuarioData> {
  _ListaLogsUsuarioDataState({@required this.data}) {
    listarDados(data);
  }
  String? data;
  var dadosLog = <ModelsLogUsuario>[];
  RxBool? loading = true.obs;
  
  listarDados(data) async {
    final response = await http.get(
      Uri.parse(ListarRegistrosPorData +
          data.toString().replaceAll('/', '-') +
          '/' +
          ModelsUsuarios.caminhoBaseUser.toString()),
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

  Future<dynamic> delete(int? id) async {
    var response = await http.delete(
      Uri.parse(DeletarCliente + id.toString() + '/' + ModelsUsuarios.caminhoBaseUser.toString()),
      headers: {
        "authorization": ModelsUsuarios.tokenAuth.toString(),
      },
    );

    if (response.statusCode == 401) {
      Navigator.pushNamed(context, '/login');
    }
  }

  confExcluir(id) {
    MsgPopup().msgComDoisBotoes(
      context,
      'Deseja excluir o cliente selecionado?',
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

  @override
  void initState() {
    super.initState();
    this.listarDados(data);
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
                  'Logs por usuário',
                  iconeVoltar: true,
                  sizeTextTitulo: 0.065,
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
                      future: listarDados(data),
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
                                        bottom: 4,
                                        top: 4,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 4, right: 4),
                                        child: Container(
                                          height: size.height * 0.11,
                                          width: size.width,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              10,
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
                                              child: ListTile(
                                                title: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    FieldsDatabase()
                                                        .listaDadosBanco(
                                                            'Nome: ',
                                                            dadosLog[index]
                                                                .nomeUsuario),
                                                    FieldsDatabase()
                                                        .listaDadosBanco(
                                                            'Hora: ',
                                                            dadosLog[index]
                                                                .horaLogin),
                                                    FieldsDatabase()
                                                        .listaDadosBanco(
                                                      'Mensagem: ',
                                                      dadosLog[index].mensagem,
                                                    ),
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
