import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:madecontrol_desenvolvimento/Widget/MsgPopup.dart';
import 'package:madecontrol_desenvolvimento/models/ClassesStaticas.dart';
import 'package:madecontrol_desenvolvimento/models/Models_Usuario.dart';
import 'package:madecontrol_desenvolvimento/models/constantes.dart';
import 'package:madecontrol_desenvolvimento/models/models-calculos.dart';
import '../CadastrarCalculo.dart';

class ListarCalculos extends StatefulWidget {
  final int? idLote;
  ListarCalculos({Key? key, @required this.idLote}) : super(key: key);

  @override
  _ListarCalculosState createState() => _ListarCalculosState(idLote: idLote);
}

class _ListarCalculosState extends State<ListarCalculos> {
  var calculos = <ModelCalculos>[];
  final int? idLote;
  RxBool? loading = true.obs;
  Future<dynamic> fetchPost() async {
    final response = await http.get(
      Uri.parse(ListarCalculoPorLote +
          idLote.toString() +
          '/' +
          ModelsUsuarios.caminhoBaseUser.toString()),
      headers: {
        "Accept": "application/json",
        "authorization": ModelsUsuarios.tokenAuth.toString()
      },
    );
    if (mounted)
      setState(
        () {
          Iterable lista = json.decode(response.body);
          calculos =
              lista.map((model) => ModelCalculos.fromJson(model)).toList();
        },
      );
    loading!.value = false;
  }

  var media;
  double?valorattmedia = 0;
  int? valorattquantidede = 0;
  double?valorattresultado = 0;
  deletarReg(id) {
    MsgPopup().msgComDoisBotoes(
      context,
      'Deseja excluir este cálculo?',
      'Não',
      'Sim',
      () => Navigator.pop(context),
      () => {
        delete(id),
        Navigator.pop(context),
      },
    );
  }

  Future<dynamic> delete(int? id) async {
    print(id);
    var response = await http.delete(
      Uri.parse(DeletarCalculo + id.toString() + '/' + ModelsUsuarios.caminhoBaseUser.toString()),
      headers: {
        "Content-Type": "application/json",
        "authorization": ModelsUsuarios.tokenAuth.toString()
      },
    );
    if (response.statusCode == 200) {
      atualizarValores();
    }
  }

  Future<dynamic> atualizarValores() async {
    var bodyy = jsonEncode({
      'idusuario': ModelsUsuarios.idDoUsuario,
      'resultado': valorattresultado,
      'quantidade': valorattquantidede,
      'media': media,
      'idlote': idLote
    });

    await http.put(
      Uri.parse(EditarLote + idLote.toString() + '/' + ModelsUsuarios.caminhoBaseUser.toString()),
      headers: {
        "Content-Type": "application/json",
        "authorization": ModelsUsuarios.tokenAuth.toString()
      },
      body: bodyy,
    );
  }

  _ListarCalculosState({@required this.idLote});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[300],
        centerTitle: true,
        title: Text(
          'Dados do lote',
          style: TextStyle(
            fontSize: 22,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CadastrarMedidas(idLote: idLote)),
              );
            },
            iconSize: 35,
            color: Colors.white,
          )
        ],
      ),
      body: Container(
        child: FutureBuilder(
            future: fetchPost(),
            builder: (BuildContext context, snapshot) {
              return Obx(() => loading!.value == true
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListView.builder(
                      itemCount: calculos.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(5),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(
                                5,
                              ),
                            ),
                            child: ListTile(
                              leading: Text(
                                '${index + 1}',
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                              title: Text(
                                'resultado: ${calculos[index].resultado!.toStringAsFixed(4)}',
                                style: TextStyle(
                                  fontSize: 22,
                                  color: Colors.green,
                                ),
                              ),
                              subtitle: Text(
                                'Diâmetro menor: ${calculos[index].diametroMenor}' +
                                    '\n'
                                        'comprimento: ${calculos[index].comprimento}',
                                style: TextStyle(
                                  fontSize: 22,
                                ),
                              ),
                              trailing: IconButton(
                                icon: Icon(
                                  Icons.delete_forever,
                                  color: Colors.red,
                                  size: 30,
                                ),
                                onPressed: () {
                                  deletarReg(calculos[index].idCalculos);
                                  setState(
                                    () {
                                      valorattresultado =
                                          EdicaoLotes.resultado! -
                                              calculos[index].resultado!;
                                      valorattquantidede =
                                          calculos[index].quantidade;
                                      media = valorattresultado! /
                                          valorattquantidede!;
                                      valorattquantidede =
                                          valorattquantidede! - 1;
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ));
            }),
      ),
    );
  }
}
