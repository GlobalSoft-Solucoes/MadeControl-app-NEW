import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:madecontrol_desenvolvimento/Widget/Cabecalho.dart';
import 'package:get/get.dart';
import 'package:madecontrol_desenvolvimento/Widget/ListFieldsDataBase.dart';
import 'package:madecontrol_desenvolvimento/Widget/MsgPopup.dart';
import 'package:madecontrol_desenvolvimento/models/Models_Despesa.dart';
import 'package:madecontrol_desenvolvimento/models/Models_Usuario.dart';
import 'package:http/http.dart' as http;
import 'package:madecontrol_desenvolvimento/models/constantes.dart';

class ListarDadosDespesa extends StatefulWidget {
  final int? iddespesa;
  ListarDadosDespesa({Key? key, @required this.iddespesa, int? idPedido})
      : super(key: key);
  @override
  _ListarDadosDespesaState createState() =>
      _ListarDadosDespesaState(iddespesa: iddespesa);
}

class PermissaoExcluirDespesa {
  static RxBool? permissao = false.obs;
}

class _ListarDadosDespesaState extends State<ListarDadosDespesa> {
  _ListarDadosDespesaState({@required this.iddespesa}) {
    listarDados(iddespesa);
  }
  RxBool? loading = true.obs;
  int? iddespesa;
  String? traco = ('-');

  separadorTraco() {
    var valor = 40;
    var teste = traco!.length * valor;

    for (var i = 0; i < valor.toInt(); i++) {
      traco = traco! + traco!;
    }
    print(traco);
    return teste.toString();
  }

  var listaDadosDespesa = <ModelsDespesa>[];
  Future<dynamic> listarDados(int? id) async {
    final response = await http.get(
      Uri.parse(
        BuscarDespesaPorId +
            iddespesa.toString() +
            '/' +
            ModelsUsuarios.caminhoBaseUser.toString(),
      ),
      headers: {
        "Content-Type": "application/json",
        "authorization": ModelsUsuarios.tokenAuth.toString()
      },
    );

    if (mounted) {
      setState(
        () {
          Iterable lista = json.decode(response.body);
          listaDadosDespesa =
              lista.map((model) => ModelsDespesa.fromJson(model)).toList();
        },
      );
    }
    loading!.value = false;
  }

  Future<dynamic> deletar() async {
    var response = await http.delete(
      Uri.parse(ExcluirDespesa +
          iddespesa.toString() +
          '/' +
          ModelsUsuarios.caminhoBaseUser.toString()),
      headers: {"authorization": ModelsUsuarios.tokenAuth.toString()},
    );
    if (response.statusCode == 201) {
      Navigator.pop(context);
    }
  }

  msgConfirmacaoDeletarDespesa() {
    MsgPopup().msgComDoisBotoes(
      context,
      'Você deseja deletar esta despesa?',
      'Não',
      'Sim',
      () => Navigator.pop(context),
      () {
        deletar();
        Navigator.pop(context);
        Navigator.pop(context);
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
                  'Detalhes da despesa',
                  iconeVoltar: true,
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: size.width * 0.04,
                    left: size.width * 0.02,
                    right: size.width * 0.02,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        width: size.width,
                        height: size.height * 0.60,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white),
                        child: FutureBuilder(
                          future: listarDados(iddespesa),
                          builder: (BuildContext context, snapshot) {
                            return Obx(
                              () => loading!.value == true
                                  ? Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : ListView.builder(
                                      itemCount: listaDadosDespesa.length,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                              left: 4, right: 4),
                                          child: Container(
                                            padding: EdgeInsets.only(
                                                left: 5, right: 5, top: 70),
                                            alignment: Alignment.centerLeft,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                FieldsDatabase()
                                                    .listaDadosBanco(
                                                  'Tipo da despesa: ',
                                                  listaDadosDespesa[index]
                                                      .nomeTipoDespesa,
                                                  sizeTextoCampo: 25,
                                                  sizeCampoBanco: 25,
                                                ),

                                                SizedBox(
                                                  height: 20,
                                                ),
                                                FieldsDatabase()
                                                    .listaDadosBanco(
                                                  'Descricao: ',
                                                  listaDadosDespesa[index]
                                                      .descricao,
                                                  sizeTextoCampo: 25,
                                                  sizeCampoBanco: 25,
                                                ),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                Row(
                                                  children: [
                                                    FieldsDatabase()
                                                        .listaDadosBanco(
                                                      'Data: ',
                                                      listaDadosDespesa[index]
                                                          .dataDespesa!
                                                          .substring(0, 10),
                                                      sizeTextoCampo: 25,
                                                      sizeCampoBanco: 25,
                                                    ),
                                                    SizedBox(
                                                      height: 20,
                                                    ),
                                                    FieldsDatabase()
                                                        .listaDadosBanco(
                                                      '  -   Hora: ',
                                                      listaDadosDespesa[index]
                                                          .horaDespesa,
                                                      sizeTextoCampo: 25,
                                                      sizeCampoBanco: 25,
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                FieldsDatabase()
                                                    .listaDadosBanco(
                                                  'Valor: ',
                                                  listaDadosDespesa[index]
                                                      .valorDespesa,
                                                  sizeTextoCampo: 25,
                                                  sizeCampoBanco: 25,
                                                ),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                FieldsDatabase()
                                                    .listaDadosBanco(
                                                  'Observações: ',
                                                  listaDadosDespesa[index]
                                                      .observacoes,
                                                  sizeTextoCampo: 25,
                                                  sizeCampoBanco: 25,
                                                ),

                                                //==================================================
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                            );
                          },
                        ),
                      ),
                      Obx(
                        () => PermissaoExcluirDespesa.permissao!.value == true
                            ? Container(
                                padding:
                                    EdgeInsets.only(top: size.height * 0.12),
                                child: IconButton(
                                  icon: Icon(Icons.delete_forever),
                                  onPressed: () =>
                                      {msgConfirmacaoDeletarDespesa()},
                                  iconSize: 40,
                                  color: Colors.red,
                                ),
                              )
                            : Container(),
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
