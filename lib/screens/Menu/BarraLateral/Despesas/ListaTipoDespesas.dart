import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:madecontrol_desenvolvimento/Statics/Static_SubTipoDespesa.dart';
import 'package:madecontrol_desenvolvimento/Widget/Botao.dart';
import 'package:madecontrol_desenvolvimento/Widget/Cabecalho.dart';
import 'package:madecontrol_desenvolvimento/Widget/ListFieldsDataBase.dart';
import 'package:madecontrol_desenvolvimento/Widget/MsgPopup.dart';
import 'package:madecontrol_desenvolvimento/Widget/TextField.dart';
import 'package:madecontrol_desenvolvimento/models/Models_TipoDespesa.dart';
import 'package:madecontrol_desenvolvimento/models/Models_Usuario.dart';
import 'package:madecontrol_desenvolvimento/models/constantes.dart';
import 'package:http/http.dart' as http;
import 'package:madecontrol_desenvolvimento/Statics/Static_Despesa.dart';

import 'ListaSubTipoDespesas.dart';
import 'ResumoTipoDespesasAnual.dart';

class ListarTipoDespesa extends StatefulWidget {
  @override
  _ListarTipoDespesaState createState() => _ListarTipoDespesaState();
}

class _ListarTipoDespesaState extends State<ListarTipoDespesa> {
  TextEditingController controllerNomeDespesa = TextEditingController();
  TextEditingController controllerDescricao = TextEditingController();

  var dadosListagem = <ModelsTipoDespesa>[];
  RxBool? loading = true.obs;
  Future<dynamic> listarDados() async {
    final response = await http.get(
      Uri.parse(
          ListarTodosTipoDespesa + ModelsUsuarios.caminhoBaseUser.toString()),
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
          dadosListagem =
              lista.map((model) => ModelsTipoDespesa.fromJson(model)).toList();
          FieldsSubTipoDespesa()
              .totalDespesaPorGrupoDespesa(FieldsSubTipoDespesa.idTipoDespesa);
        },
      );
    loading!.value = false;
  }

// Salva os dados no banco
  salvarBanco() async {
    var bodyy = jsonEncode(
      {
        'nome': controllerNomeDespesa.text,
        'descricao': controllerDescricao.text
      },
    );
    var state = await http.post(
      Uri.parse(CadastrarTipoDespesa + ModelsUsuarios.caminhoBaseUser.toString()),
      headers: {
        "Content-Type": "application/json",
        "authorization": ModelsUsuarios.tokenAuth.toString()
      },
      body: bodyy,
    );
    print(state.statusCode);
    print(bodyy);
    if (state.statusCode == 201) {
      controllerNomeDespesa.text = "";
      controllerDescricao.text = "";
    } else if (state.statusCode == 401) {
      Navigator.pushNamed(context, '/login');
    }
  }

  validarCampos() {
    if (controllerNomeDespesa.text.isEmpty) {
      MsgPopup().msgFeedback(
          context, '\n' + 'O campo nome da despesa não foi preenchido', 'Erro');
    } else {
      salvarBanco();
    }
  }

  //===================== CADASTRO DO TIPO DE DESPESA ====================
  escolhaTipoCondominio() {
    return showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          title: Text(
            'Novo grupo de despesa:',
            textAlign: TextAlign.center,
            style: new TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          elevation: 12,
          actions: <Widget>[
            // ===================== BOTÕES ==========================
            Padding(
              padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.02,
                right: MediaQuery.of(context).size.width * 0.02,
              ),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.30,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15)),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.01),
                        child: CampoText().textField(
                          controllerNomeDespesa,
                          'Grupo da despesa:',
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.01),
                        child: CampoText().textField(
                          controllerDescricao,
                          'Descrição:',
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.02),
                        child: Botao().botaoAnimacaoLoading(
                          context,
                          onTap: () {
                            validarCampos();
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<dynamic> deletar(iddespesa) async {
    var response = await http.delete(
      Uri.parse(ExcluirTipoDespesa +
          iddespesa.toString() +
          '/' +
          ModelsUsuarios.caminhoBaseUser.toString()),
      headers: {"authorization": ModelsUsuarios.tokenAuth.toString()},
    );
    if (response.statusCode == 201) {
      Navigator.pop(context);
    }
  }

  msgConfirmacaoDeletarDespesa(idDespesa) {
    MsgPopup().msgComDoisBotoes(
      context,
      'Você realmente deseja deletar este grupo de despesas?',
      'Não',
      'Sim',
      () => Navigator.pop(context),
      () {
        deletar(idDespesa);
        Navigator.pop(context);
      },
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
          label: 'Grupo despesa',
          labelStyle: TextStyle(fontSize: 20),
          onTap: () => {
            escolhaTipoCondominio(),
          },
        ),
        SpeedDialChild(
          child: Icon(Icons.info_outline_rounded, size: 35),
          backgroundColor: Colors.grey,
          label: 'Resumo despesas total',
          labelStyle: TextStyle(fontSize: 20),
          onTap: () async {
            await FieldsSubTipoDespesa().resumoDespesasPorAno('2021');
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ResumoTipoDespesaAnual(),
              ),
            );
          },
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
            color: Colors.grey[300], //Color(0XFFE7F0F3),
            height: size.height,
            width: size.width,
            child: Column(
              children: [
                Cabecalho().tituloCabecalho(
                  context,
                  'Grupo de despesa',
                  iconeVoltar: true,
                  sizeTextTitulo: 0.065,
                  marginBottom: 0.01,
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: size.width * 0.02,
                    right: size.width * 0.02,
                    // bottom: size.height * 0.02,
                  ),
                  child: Container(
                    padding: const EdgeInsets.only(bottom: 5, top: 5),
                    width: size.width,
                    height: size.height * 0.84,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 1),
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
                                        top: size.width * 0.008,
                                        bottom: size.width * 0.008,
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
                                                    context) async {
                                                  await EditarDadosDaDespesa()
                                                      .capturaDadosDespesa(
                                                          dadosListagem[index]
                                                              .idtipoDespesa);
                                                  Navigator.pushNamed(context,
                                                      '/EditarDespesa');
                                                },
                                              ),
                                              SlidableAction(
                                                label: 'Excluir',
                                                backgroundColor: Colors.red,
                                                icon: Icons.delete_forever,
                                                onPressed: (BuildContext
                                                        context) =>
                                                    msgConfirmacaoDeletarDespesa(
                                                        dadosListagem[index]
                                                            .idtipoDespesa),
                                              ),
                                            ],
                                          ),
                                          child: GestureDetector(
                                            onTap: () async {
                                              FieldsSubTipoDespesa
                                                      .nomeTipoDespesa =
                                                  dadosListagem[index].nome;
                                              FieldsSubTipoDespesa
                                                      .idTipoDespesa =
                                                  dadosListagem[index]
                                                      .idtipoDespesa;
                                              await FieldsSubTipoDespesa()
                                                  .totalDespesaPorGrupoDespesa(
                                                      dadosListagem[index]
                                                          .idtipoDespesa);
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ListaSubTipoDespesa(
                                                    idTipoDespesa:
                                                        dadosListagem[index]
                                                            .idtipoDespesa,
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              height: size.height * 0.11,
                                              width: size.width,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  5,
                                                ),
                                                color: Colors.grey[300],
                                              ),
                                              child: Container(
                                                alignment: Alignment.center,
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
                                                                  'Tipo da despesa: ',
                                                                  dadosListagem[
                                                                          index]
                                                                      .nome),
                                                          SizedBox(
                                                              height:
                                                                  size.height *
                                                                      0.008),
                                                          if (dadosListagem[
                                                                      index]
                                                                  .descricao !=
                                                              '')
                                                            FieldsDatabase()
                                                                .listaDadosBanco(
                                                                    'Descrição: ',
                                                                    dadosListagem[
                                                                            index]
                                                                        .descricao),
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
