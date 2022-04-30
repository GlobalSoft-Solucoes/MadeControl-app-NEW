import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:madecontrol_desenvolvimento/Statics/Static_SubTipoDespesa.dart';
import 'package:madecontrol_desenvolvimento/Widget/Cabecalho.dart';
import 'package:get/get.dart';
import 'package:madecontrol_desenvolvimento/Widget/ListFieldsDataBase.dart';
import 'package:madecontrol_desenvolvimento/Widget/MsgPopup.dart';
import 'package:madecontrol_desenvolvimento/models/Models_Despesa.dart';
import 'package:madecontrol_desenvolvimento/models/Models_Usuario.dart';
import 'package:madecontrol_desenvolvimento/models/constantes.dart';
import 'package:http/http.dart' as http;
import 'package:madecontrol_desenvolvimento/Statics/Static_Despesa.dart';

import 'DetalhesParcelaDespesa.dart';

class ListarDespesas extends StatefulWidget {
  final int? idSubTipoDespesa;
  ListarDespesas({Key? key, @required this.idSubTipoDespesa}) : super(key: key);
  @override
  _ListarDespesasState createState() =>
      _ListarDespesasState(idSubTipoDespesa: idSubTipoDespesa);
}

class _ListarDespesasState extends State<ListarDespesas> {
  _ListarDespesasState({@required this.idSubTipoDespesa}) {
    listarDados(idSubTipoDespesa);
  }
  final TextEditingController controllerHora =
      MaskedTextController(mask: '00:00');
  TextEditingController controllerData =
      MaskedTextController(mask: '00/00/0000');
  MoneyMaskedTextController controllerValorDespesa =
      MoneyMaskedTextController();
  TextEditingController controllerDescricao = TextEditingController();
  TextEditingController controllerObservacoes = TextEditingController();
  // variaveis para validação de data e hora
  var diaDespesa;
  var mesDespesa;
  var anoDespesa;
  var dataDespesa;
  var horaDespesa;
  var minutoDespesa;
  var horarioDespesa;

  bool? iniciarMedicao = false;
  bool? salvarlote = false;
  bool? verificou = false;
  int? idTipoDespesaSelecionado;

  int? idSubTipoDespesa;
  var dadosListagem = <ModelsDespesa>[];
  RxBool? loading = true.obs;
  Future<dynamic> listarDados(id) async {
    final response = await http.get(
      Uri.parse(ListaDespesasPorSubGrupo +
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
            lista.map((model) => ModelsDespesa.fromJson(model)).toList();
      });
    }
    loading!.value = false;
  }

  Future<dynamic> deletar(iddespesa) async {
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

  msgConfirmacaoDeletarDespesa(idDespesa) {
    MsgPopup().msgComDoisBotoes(
      context,
      'Você deseja deletar esta despesa?',
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
        Navigator.pushNamed(context, '/CadastroDespesa');
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
            color: Colors.green[200],
            height: size.height,
            width: size.width,
            child: Column(
              children: [
                Cabecalho().tituloCabecalho(
                  context,
                  'Relatorio de despesas',
                  iconeVoltar: true,
                  marginBottom: 0,
                ),
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
                            '${FieldsSubTipoDespesa.nomeSubTipoDespesa}',
                            style: TextStyle(
                              fontSize: Get.height * 0.027,
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
                            SizedBox(height: 10),
                            FieldsDatabase().listaDadosBanco(
                              'Valor total gasto: ',
                              FieldsSubTipoDespesa.totalSubGrupoDespesa,
                              sizeCampoBanco: Get.height * 0.024,
                              sizeTextoCampo: Get.height * 0.024,
                            ),
                            SizedBox(height: size.height * 0.005),
                            FieldsDatabase().listaDadosBanco(
                              'Despesas cadastradas: ',
                              FieldsSubTipoDespesa.qtdDespesasSubGrupo,
                              sizeCampoBanco: Get.height * 0.024,
                              sizeTextoCampo: Get.height * 0.024,
                            ),
                            SizedBox(height: size.height * 0.005),
                            FieldsDatabase().listaDadosBanco(
                              'Média gasto por despesa: ',
                              FieldsSubTipoDespesa.mediaGastoPorDespesa,
                              sizeCampoBanco: Get.height * 0.024,
                              sizeTextoCampo: Get.height * 0.024,
                            ),
                            SizedBox(height: size.height * 0.005),
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
                    bottom: size.height * 0.02,
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
                      future: listarDados(idSubTipoDespesa),
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
                                                              .idDespesa);
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
                                                            .idDespesa),
                                              ),
                                            ],
                                          ),
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      DetalhesParcelasDespesa(
                                                    idDespesa:
                                                        dadosListagem[index]
                                                            .idDespesa,
                                                    key: null,
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              height: size.height * 0.13,
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
                                                          Row(
                                                            children: [
                                                              FieldsDatabase().listaDadosBanco(
                                                                  'Data: ',
                                                                  dadosListagem[
                                                                          index]
                                                                      .dataDespesa),
                                                              FieldsDatabase().listaDadosBanco(
                                                                  '  -   Hora: ',
                                                                  dadosListagem[
                                                                          index]
                                                                      .horaDespesa),
                                                            ],
                                                          ),
                                                          SizedBox(
                                                              height:
                                                                  Get.height *
                                                                      0.01),
                                                          FieldsDatabase()
                                                              .listaDadosBanco(
                                                                  'Valor: ',
                                                                  dadosListagem[
                                                                          index]
                                                                      .valorDespesa),
                                                          SizedBox(
                                                              height:
                                                                  Get.height *
                                                                      0.01),
                                                          FieldsDatabase()
                                                              .listaDadosBanco(
                                                                  'Parcelas: ',
                                                                  dadosListagem[
                                                                          index]
                                                                      .numParcelas),
                                                          if (dadosListagem[
                                                                      index]
                                                                  .observacoes !=
                                                              '')
                                                            SizedBox(
                                                                height:
                                                                    Get.height *
                                                                        0.01),
                                                          if (dadosListagem[
                                                                      index]
                                                                  .observacoes !=
                                                              '')
                                                            FieldsDatabase().listaDadosBanco(
                                                                'Observações: ',
                                                                dadosListagem[
                                                                        index]
                                                                    .observacoes),
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
