import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:madecontrol_desenvolvimento/Widget/MsgPopup.dart';
import 'package:madecontrol_desenvolvimento/models/ClassesStaticas.dart';
import 'package:madecontrol_desenvolvimento/models/Models_Usuario.dart';
import 'package:madecontrol_desenvolvimento/models/constantes.dart';
import 'package:madecontrol_desenvolvimento/models/models-lotes.dart';
class Historico extends StatefulWidget {
  @override
  _HistoricoState createState() => _HistoricoState();
}

class _HistoricoState extends State<Historico> {
  var lotes = List<ModelsLotes>();
  RxBool? loading = true.obs;
  deletarReg(id) {
    MsgPopup().msgComDoisBotoes(
        context,
        'Deseja Excluir este lote?',
        'Não',
        'Sim',
        () => Navigator.pop(context),
        () => {delete(id), Navigator.pop(context)});
  }

  Future<dynamic> fetchPost() async {
    final response = await http.get(
      Uri.parse(ListarTodosLotes + ModelsUsuarios.caminhoBaseUser.toString()),
      headers: {
        "accept": "application/json",
        "authorization": ModelsUsuarios.tokenAuth.toString()
      },
    );
    if (mounted)
      setState(
        () {
          Iterable lista = json.decode(response.body);
          lotes = lista.map((model) => ModelsLotes.fromJson(model)).toList();
        },
      );
    loading!.value = false;
  }

  Future<dynamic> delete(int? id) async => await http.delete(
        DeletarLote + id.toString() + '/' + ModelsUsuarios.caminhoBaseUser.toString(),
        headers: {
          "Content-Type": "application/json",
          "authorization": ModelsUsuarios.tokenAuth.toString()
        },
      );

  _HistoricoState() {
    fetchPost();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[300],
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.only(right: 40),
          child: new Center(
            child: new Text(
              "Lotes",
              style: TextStyle(
                fontSize: 22,
              ),
            ),
          ),
        ),
      ),
      body: Container(
        color: Colors.green[100],
        child: FutureBuilder(
          future: fetchPost(),
          builder: (BuildContext context, snapshot) {
            return Obx(
              () => loading!.value == true
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListView.builder(
                      itemCount: lotes.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(5),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ListarCalculos(
                                      idLote: lotes[index].idLote),
                                ),
                              );
                              setState(() {
                                EdicaoLotes.media = lotes[index].media;
                                EdicaoLotes.resultado = lotes[index].resultado;
                                EdicaoLotes.quantidade =
                                    lotes[index].quantidade;
                              });
                              LotesConfirm.resultado = lotes[index].resultado;
                              LotesConfirm.quantidade = lotes[index].quantidade;
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(
                                  10,
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
                                  'resultado: ${lotes[index].resultado.toStringAsFixed(4)}',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.green,
                                  ),
                                ),
                                subtitle: Text(
                                  'Data: ${lotes[index].data.substring(0, 10)}'
                                          '\n' +
                                      'quantidade:${lotes[index].quantidade}' +
                                      '\n' +
                                      'media: ${lotes[index].media.toStringAsFixed(4)}',
                                  style: TextStyle(
                                    fontSize: 17,
                                  ),
                                ),
                                trailing: IconButton(
                                  icon: Icon(
                                    Icons.delete_forever,
                                    color: Colors.red,
                                    size: 30,
                                  ),
                                  onPressed: () =>
                                      deletarReg(lotes[index].idLote),
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
    );
  }
}
