import 'dart:async';
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
import 'package:http/http.dart' as http;
import 'package:madecontrol_desenvolvimento/models/Models_TipoDespesa.dart';
import 'package:madecontrol_desenvolvimento/models/Models_Usuario.dart';
import 'package:madecontrol_desenvolvimento/models/constantes.dart';
import 'ListaDespesas.dart';

class ListaSubTipoDespesa extends StatefulWidget {
  final int? idTipoDespesa;
  ListaSubTipoDespesa({Key? key, @required this.idTipoDespesa})
      : super(key: key);
  @override
  _ListaSubTipoDespesaState createState() =>
      _ListaSubTipoDespesaState(idTipoDespesa: idTipoDespesa);
}

class _ListaSubTipoDespesaState extends State<ListaSubTipoDespesa> {
  _ListaSubTipoDespesaState({@required this.idTipoDespesa}) {
    listarDados(idTipoDespesa);
  }
  TextEditingController controllerNomeDespesa = TextEditingController();
  final 

  int? idTipoDespesa;
  var dadosListagem = <ModelsSubTipoDespesa>[];
  RxBool? loading = true.obs;
  Future<dynamic> listarDados(id) async {
    final response = await http.get(
      Uri.parse(ListarSubTipoDespesaPorIdTipoDespesa +
          id.toString() +
          '/' +
          ModelsUsuarios.caminhoBaseUser.toString()),
      headers: {"authorization": ModelsUsuarios.tokenAuth.toString()},
    );
    if (response.statusCode == 401) {
      Navigator.pushNamed(context, '/login');
    }
    //IF(MOUNTED) É nescessario para não recarregar a arvore apos retornar das outras listas
    if (mounted) {
      setState(() {
        Iterable lista = json.decode(response.body);
        dadosListagem =
            lista.map((model) => ModelsSubTipoDespesa.fromJson(model)).toList();

        FieldsSubTipoDespesa().totalDespesaPorSubGrupoDespesa(
            FieldsSubTipoDespesa.idSubTipoDespesa);
      });
    }
    loading!.value = false;
  }

// Salva os dados no banco
  salvarBanco() async {
    var bodyy = jsonEncode(
      {
        'idtipo_despesa': idTipoDespesa,
        'nome': controllerNomeDespesa.text,
      },
    );
    var state = await http.post(
      Uri.parse(CadastrarSubTipoDespesa + ModelsUsuarios.caminhoBaseUser.toString()),
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
  cadastroSubTipo() {
    return showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          title: Text(
            'Novo identificador de despesa:',
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
                height: MediaQuery.of(context).size.height * 0.20,
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
                          'Nome da despesa:',
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
      Uri.parse(ExcluirSubTipoDespesa +
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
      animatedIcon: AnimatedIcons.add_event,
      animatedIconTheme: IconThemeData(size: 35),
      child: Icon(Icons.add),
      visible: true,
      curve: Curves.bounceIn,
      overlayColor: Colors.white,
      overlayOpacity: 0.6,
      tooltip: 'Speed Dial',
      heroTag: 'speed-dial-hero-tag',
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white70,
      elevation: 8.0,
      shape: CircleBorder(),
      onPress: () {
        cadastroSubTipo();
      },
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
            color: Colors.grey[300],
            height: size.height,
            width: size.width,
            child: Column(
              children: [
                Cabecalho().tituloCabecalho(context, 'Sub grupo',
                    iconeVoltar: true, marginLeft: 0.01, marginBottom: 0.0),
                Container(
                  padding: EdgeInsets.only(
                    left: size.width * 0.025,
                    top: size.height * 0.01,
                    bottom: size.height * 0.014,
                    right: size.width * 0.025,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Center(
                          child: Text(
                            '${FieldsSubTipoDespesa.nomeTipoDespesa}',
                            style: TextStyle(
                              fontSize: 22,
                              color: Colors.blue[700],
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: size.width * 0.02,
                    right: size.width * 0.02,
                    // bottom: size.height * 0.02,
                  ),
                  child: Container(
                    height: size.height * 0.15,
                    padding: EdgeInsets.only(left: size.width * 0.03),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black, width: 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.centerLeft,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: 30),
                            FieldsDatabase().listaDadosBanco(
                              'Valor total gasto: ',
                              FieldsSubTipoDespesa.totalGrupoDespesa,
                              sizeCampoBanco: 22,
                              sizeTextoCampo: 22,
                            ),
                            SizedBox(height: 15),
                            FieldsDatabase().listaDadosBanco(
                              'Despesas cadastradas: ',
                              FieldsSubTipoDespesa.qtdDespesasGrupo,
                              sizeCampoBanco: 22,
                              sizeTextoCampo: 22,
                            ),
                            SizedBox(height: 15),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.014),
                Padding(
                  padding: EdgeInsets.only(
                    left: size.width * 0.02,
                    right: size.width * 0.02,
                    // bottom: size.height * 0.02,
                  ),
                  child: Container(
                    padding: const EdgeInsets.only(
                      bottom: 5,
                      top: 5,
                    ),
                    width: size.width,
                    height: size.height * 0.64,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 1),
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: FutureBuilder(
                      future: listarDados(idTipoDespesa),
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
                                                label: 'Excluir',
                                                backgroundColor: Colors.red,
                                                icon: Icons.delete_forever,
                                                onPressed: (BuildContext
                                                        context) =>
                                                   msgConfirmacaoDeletarDespesa(
                                                          dadosListagem[index]
                                                              .idSubTipoDespesa)
                                              ),
                                            ],
                                          ),
                                          child: GestureDetector(
                                            onTap: () async {
                                              FieldsSubTipoDespesa
                                                      .nomeSubTipoDespesa =
                                                  dadosListagem[index].nome;
                                              FieldsSubTipoDespesa
                                                      .idSubTipoDespesa =
                                                  dadosListagem[index]
                                                      .idSubTipoDespesa;
                                              await FieldsSubTipoDespesa()
                                                  .totalDespesaPorSubGrupoDespesa(
                                                      dadosListagem[index]
                                                          .idSubTipoDespesa);
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ListarDespesas(
                                                    idSubTipoDespesa:
                                                        dadosListagem[index]
                                                            .idSubTipoDespesa,
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              height: size.height * 0.09,
                                              width: size.width,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  5,
                                                ),
                                                color: Colors.grey[400],
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
                                                          SizedBox(height: 10),
                                                          FieldsDatabase()
                                                              .listaDadosBanco(
                                                                  'Despesa acumulada: ',
                                                                  dadosListagem[
                                                                          index]
                                                                      .totalSubGrupoDespesa),
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
