import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:madecontrol_desenvolvimento/Widget/Cabecalho.dart';
import 'package:get/get.dart';
import 'package:madecontrol_desenvolvimento/Widget/ListFieldsDataBase.dart';
import 'package:madecontrol_desenvolvimento/Widget/MsgPopup.dart';
import 'package:madecontrol_desenvolvimento/models/Models_ProcessoMad.dart';
import 'package:madecontrol_desenvolvimento/models/Models_Usuario.dart';
import 'package:http/http.dart' as http;
import 'package:madecontrol_desenvolvimento/models/constantes.dart';
import 'package:madecontrol_desenvolvimento/screens/Menu/BarraLateral/ProcessoMadeira/DetalhesMadProcessada.dart';

class ListaProcessoSerraFita extends StatefulWidget {
  @override
  _ListaProcessoSerraFitaState createState() => _ListaProcessoSerraFitaState();
}

class _ListaProcessoSerraFitaState extends State<ListaProcessoSerraFita> {
  var dadosMadProcessada = <MadProcessada>[];
  RxBool? loading = true.obs;
  Future<dynamic> listarDados() async {
    final response = await http.get(
      Uri.parse(
          ListarTodosMadProcessada + ModelsUsuarios.caminhoBaseUser.toString()),
      headers: {"authorization": ModelsUsuarios.tokenAuth.toString()},
    );
    if (response.statusCode == 401) {
      Navigator.pushNamed(context, '/login');
    }

    //IF(MOUNTED) É nescessario para não recarregar a arvore apos retornar das outras listas
    if (mounted)
      setState(() {
        Iterable lista = json.decode(response.body);
        dadosMadProcessada =
            lista.map((model) => MadProcessada.fromJson(model)).toList();
      });
    loading!.value = false;
  }

  delete(int? id) async {
    var response = await http.put(
      Uri.parse(AlterarStatusProcessoMadParaRemovido +
          id.toString() +
          '/' +
          ModelsUsuarios.caminhoBaseUser.toString()),
      headers: {
        "authorization": ModelsUsuarios.tokenAuth.toString(),
      },
    );
    print(response.body);
    if (response.statusCode == 401) {
      Navigator.pushNamed(context, '/login');
    }
  }

  confExcluir(id) {
    MsgPopup().msgComDoisBotoes(
      context,
      'Deseja excluir este lote processado?',
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
                  'Madeira processada',
                  iconeVoltar: true,
                  marginBottom: 0.01,
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: size.width * 0.02,
                      right: size.width * 0.02,
                      top: size.height * 0.01),
                  child: Container(
                    padding: const EdgeInsets.only(bottom: 5, top: 5),
                    width: size.width,
                    height: size.height * 0.85,
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
                                  itemCount: dadosMadProcessada.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () async {
                                        // Navigator.push(
                                        //   context,
                                        //   MaterialPageRoute(
                                        //     builder: (context) =>
                                        //         DetalhesMadProcessada(
                                        //       idProcesso:
                                        //           dadosMadProcessada[index]
                                        //               .idProcessoMadeira,
                                        //     ),
                                        //   ),
                                        // );
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 4,
                                          top: 4,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 5, right: 5),
                                          child: Container(
                                            alignment: Alignment.center,
                                            height: size.height * 0.19,
                                            width: size.width,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Color(0XFFD1D6DC),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 5, right: 10),
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
                                                    title: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        FieldsDatabase()
                                                            .listaDadosBanco(
                                                                'Responsável: ',
                                                                dadosMadProcessada[
                                                                        index]
                                                                    .nomeUsuario),
                                                        SizedBox(height: 5),
                                                        if (dadosMadProcessada[
                                                                    index]
                                                                .tipoTora !=
                                                            null)
                                                          FieldsDatabase().listaDadosBanco(
                                                              'Tipo da tora: ',
                                                              dadosMadProcessada[index].tipoTora == 1
                                                                  ? 'Fina'
                                                                  : dadosMadProcessada[index].tipoTora == 2
                                                                      ? 'Média'
                                                                      : dadosMadProcessada[index].tipoTora == 3
                                                                          ? 'Grossa'
                                                                          : dadosMadProcessada[index].tipoTora == 4
                                                                              ? 'Do Pé'
                                                                              : ''),
                                                        SizedBox(height: 5),
                                                        FieldsDatabase()
                                                            .listaDadosBanco(
                                                                'Data: ',
                                                                dadosMadProcessada[
                                                                        index]
                                                                    .data),
                                                        SizedBox(height: 5),
                                                        if (dadosMadProcessada[
                                                                    index]
                                                                .tempoProcesso !=
                                                            null)
                                                          FieldsDatabase()
                                                              .listaDadosBanco(
                                                            'Duração: ',
                                                            dadosMadProcessada[
                                                                    index]
                                                                .tempoProcesso!
                                                                .substring(
                                                                    0, 8),
                                                          ),
                                                      ],
                                                    ),
                                                    trailing: IconButton(
                                                      icon: Icon(
                                                        Icons.delete_forever,
                                                        color: Colors.red,
                                                        size: 32,
                                                      ),
                                                      padding: EdgeInsets.only(
                                                        left: 25,
                                                        top: 30,
                                                      ),
                                                      onPressed: () => {
                                                        confExcluir(
                                                          dadosMadProcessada[
                                                                  index]
                                                              .idProcessoMadeira,
                                                        ),
                                                      },
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
