import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:madecontrol_desenvolvimento/Statics/Static_Recebimento.dart';
import 'package:madecontrol_desenvolvimento/Widget/Cabecalho.dart';
import 'package:get/get.dart';
import 'package:madecontrol_desenvolvimento/Widget/ListFieldsDataBase.dart';
import 'package:madecontrol_desenvolvimento/Widget/MsgPopup.dart';
import 'package:madecontrol_desenvolvimento/Widget/TextField.dart';
import 'package:madecontrol_desenvolvimento/funcoes/FuncoesParaDatas.dart';
import 'package:madecontrol_desenvolvimento/models/Models_Recebimento.dart';
import 'package:madecontrol_desenvolvimento/models/Models_Usuario.dart';
import 'package:http/http.dart' as http;
import 'package:madecontrol_desenvolvimento/models/constantes.dart';

class DetalhesRecebimento extends StatefulWidget {
  final int? idRecebimento;
  DetalhesRecebimento({Key? key, @required this.idRecebimento})
      : super(key: key);
  @override
  _DetalhesRecebimentoState createState() =>
      _DetalhesRecebimentoState(idRecebimento: idRecebimento);
}

class PermissaoExcluir {
  static RxBool? permissao = false.obs;
}

class _DetalhesRecebimentoState extends State<DetalhesRecebimento> {
  _DetalhesRecebimentoState({@required this.idRecebimento}) {
    fetchPost(idRecebimento);
  }
  var dadosListagem = <ModelsRecebimento>[];
  var dadosParcelamento = <ModelsParcelaRecibo>[];
  TextEditingController controllerData =
      MaskedTextController(mask: '00/00/0000');
  RxBool? loading = true.obs;
  int? idRecebimento;
  DateTime currentDate = DateTime.now();
  int? idParcelaRecibo;

  Future<dynamic> fetchPost(int? id) async {
    final response = await http.get(
      Uri.parse(BuscarRecebimentoPorId +
          idRecebimento.toString() +
          '/' +
          ModelsUsuarios.caminhoBaseUser.toString()),
      headers: {
        "Content-Type": "application/json",
        "authorization": ModelsUsuarios.tokenAuth.toString()
      },
    );

    if (mounted) {
      setState(
        () {
          Iterable lista = json.decode(response.body);
          dadosListagem =
              lista.map((model) => ModelsRecebimento.fromJson(model)).toList();
        },
      );
    }
    loading!.value = false;
  }

  Future<void> selectDate(BuildContext context) async {
    var datePicked = await DatePicker.showSimpleDatePicker(
      context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime(2050),
      dateFormat: "dd-MMMM-yyyy",
      locale: DateTimePickerLocale.pt_br,
      looping: true,
    );
    if (datePicked != null && datePicked != currentDate) {
      setState(() {
        currentDate = datePicked;
        print(currentDate);
      });
    }
  }

  converterData() {
    var dia;
    var mes;
    var ano;
    var dataBr;
    String? dataConversao = currentDate.toString();

    ano = dataConversao.substring(0, 4);
    mes = dataConversao.substring(5, 7);
    dia = dataConversao.substring(8, 10);
    dataBr = dia + '/' + mes + '/' + ano;

    print(dataBr);
    return dataBr.toString();
  }

  Future<dynamic> buscarDadosParcelamento(id) async {
    final response = await http.get(
      Uri.parse(ListaParcelasPorRecebimento +
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
        dadosParcelamento =
            lista.map((model) => ModelsParcelaRecibo.fromJson(model)).toList();
      });
    }
    loading!.value = false;
  }

  Future<dynamic> salvarEdicao() async {
    var corpoReq = jsonEncode(
      {
        'vencimento': controllerData.text,
      },
    );
    http.Response state = await http.put(
      Uri.parse(EditarParcelaRecibo +
          idParcelaRecibo.toString() +
          '/' +
          ModelsUsuarios.caminhoBaseUser.toString()),
      headers: {
        "Content-Type": "application/json",
        "authorization": ModelsUsuarios.tokenAuth.toString()
      },
      body: corpoReq,
    );
    print(state.statusCode);
    print(corpoReq);
    if (state.statusCode == 200) {
      Navigator.pop(context);
    }
  }

  msgConfirmacaoDeletarRecebimento() {
    MsgPopup().msgComDoisBotoes(
      context,
      'Você deseja excluir este recebimento?',
      'Não',
      'Sim',
      () => Navigator.pop(context),
      () {
        excluiRecebimento();
        Navigator.pop(context);
        Navigator.pop(context);
      },
    );
  }

  //restaura o grupo
  Future<dynamic> excluiRecebimento() async {
    var response = await http.delete(
      Uri.parse(ExcluirRecebimento +
          idRecebimento.toString() +
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

  popupModificarData(numParcela) {
    return showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          title: Text(
            'Modificar data de vencimento:',
            textAlign: TextAlign.center,
            style: new TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),
          // ======= email =========
          actions: <Widget>[
            SizedBox(
              height: Get.width * 0.07,
            ),
            Container(
              alignment: Alignment.center,
              child: Text(
                'Parcela número: ${numParcela}',
                style: (TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w600,
                )),
              ),
            ),
            SizedBox(
              height: Get.height * 0.04,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ================== TORA GROSSA =================
                Container(
                  alignment: Alignment.topLeft,
                  width: Get.width * 0.54,
                  child: CampoText().textFieldIconButton(
                    controllerData,
                    'Data vencimento:',
                    tipoTexto: TextInputType.number,
                    fontSize: 22,
                    fontLabel: 22,
                    icone: Icons.calendar_today_outlined,
                    confPadding:
                        EdgeInsets.only(top: 5, left: 5, right: 0, bottom: 5),
                    onTapIcon: () async {
                      await selectDate(context);
                      controllerData.text = converterData();
                    },
                  ),
                ),
              ],
            ),
            SizedBox(
              height: Get.height * 0.06,
            ),
            Container(
              alignment: Alignment.center,
              child: FloatingActionButton.extended(
                backgroundColor: Colors.green,
                label: Text(
                  '  SALVAR  ',
                  style: TextStyle(fontSize: 23),
                ),
                onPressed: () async {
                  salvarEdicao();
                },
              ),
            ),
            SizedBox(
              height: Get.width * 0.1,
            ),
          ],
        );
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
                  'Detalhes do recebimento',
                  iconeVoltar: true,
                  sizeTextTitulo: 0.065,
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: size.width * 0.02,
                    right: size.width * 0.02,
                    top: Get.height * 0.03,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: size.width,
                        height: size.height * 0.35,
                        padding: EdgeInsets.only(
                            left: 5, right: 5, top: Get.height * 0.03),
                        alignment: Alignment.topRight,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white),
                        child: FutureBuilder(
                          future: fetchPost(idRecebimento),
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
                                          padding: const EdgeInsets.only(
                                              left: 4, right: 4),
                                          child: Container(
                                            alignment: Alignment.center,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                    height: Get.height * 0.008),
                                                FieldsDatabase()
                                                    .listaDadosBanco(
                                                  'Cliente: ',
                                                  dadosListagem[index]
                                                      .nomeCliente,
                                                  sizeCampoBanco: 24,
                                                  sizeTextoCampo: 24,
                                                ),
                                                SizedBox(height: 15),
                                                Row(
                                                  children: [
                                                    FieldsDatabase()
                                                        .listaDadosBanco(
                                                      'Data: ',
                                                      dadosListagem[index]
                                                          .dataRecebimento!
                                                          .substring(0, 10),
                                                      sizeCampoBanco: 24,
                                                      sizeTextoCampo: 24,
                                                    ),
                                                    FieldsDatabase()
                                                        .listaDadosBanco(
                                                      '  -  Hora: ',
                                                      dadosListagem[index]
                                                          .horaRecebimento!
                                                          .substring(0, 5),
                                                      sizeCampoBanco: 24,
                                                      sizeTextoCampo: 24,
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 15),
                                                FieldsDatabase()
                                                    .listaDadosBanco(
                                                  'Valor recebido: ',
                                                  dadosListagem[index]
                                                      .valorRecebido,
                                                  sizeCampoBanco: 24,
                                                  sizeTextoCampo: 24,
                                                ),
                                                SizedBox(height: 15),
                                                FieldsDatabase()
                                                    .listaDadosBanco(
                                                  'Tipo do pagamento: ',
                                                  dadosListagem[index]
                                                      .tipoPagamento,
                                                  sizeCampoBanco: 24,
                                                  sizeTextoCampo: 24,
                                                ),
                                                if (dadosListagem[index]
                                                        .numParcelas !=
                                                    null)
                                                  SizedBox(height: 15),
                                                if (dadosListagem[index]
                                                        .numParcelas !=
                                                    null)
                                                  FieldsDatabase()
                                                      .listaDadosBanco(
                                                    'Número de parcelas: ',
                                                    dadosListagem[index]
                                                        .numParcelas,
                                                    sizeCampoBanco: 24,
                                                    sizeTextoCampo: 24,
                                                  ),
                                                SizedBox(height: 15),
                                                if (dadosListagem[index]
                                                        .observacoes !=
                                                    '')
                                                  FieldsDatabase()
                                                      .listaDadosBanco(
                                                    'Observações: ',
                                                    dadosListagem[index]
                                                        .observacoes
                                                        .toString(),
                                                    sizeCampoBanco: 24,
                                                    sizeTextoCampo: 24,
                                                  ),
                                                if (dadosListagem[index]
                                                        .observacoes !=
                                                    '')
                                                  SizedBox(height: 15),
                                                //====================================================
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
                      SizedBox(height: size.height * 0.03),
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
                          height: size.height * 0.4,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 1),
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          child: FutureBuilder(
                            future: buscarDadosParcelamento(idRecebimento),
                            builder: (BuildContext context, snapshot) {
                              return Obx(
                                () => loading!.value == true
                                    ? Center(
                                        child: CircularProgressIndicator(),
                                      )
                                    : ListView.builder(
                                        itemCount: dadosParcelamento.length,
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
                                                  children: [],
                                                ),
                                                child: GestureDetector(
                                                  onTap: () async {
                                                    idParcelaRecibo =
                                                        dadosParcelamento[index]
                                                            .idParcelaRecibo;
                                                    controllerData.text =
                                                        dadosParcelamento[index]
                                                            .vencimento
                                                            .toString();
                                                    popupModificarData(
                                                        dadosParcelamento[index]
                                                            .numParcela);
                                                  },
                                                  child: Container(
                                                    height: size.height * 0.11,
                                                    width: size.width,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                        5,
                                                      ),
                                                      color: Colors.grey[400],
                                                    ),
                                                    child: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      child:
                                                          SingleChildScrollView(
                                                        child: Container(
                                                          child: ListTile(
                                                            title: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                FieldsDatabase().listaDadosBanco(
                                                                    'Número parcela: ',
                                                                    dadosParcelamento[
                                                                            index]
                                                                        .numParcela),
                                                                SizedBox(
                                                                    height: 5),
                                                                FieldsDatabase().listaDadosBanco(
                                                                    'Valor parcela: ',
                                                                    dadosParcelamento[
                                                                            index]
                                                                        .valorParcela),
                                                                SizedBox(
                                                                    height: 5),
                                                                FieldsDatabase().listaDadosBanco(
                                                                    'Vencimento: ',
                                                                    dadosParcelamento[
                                                                            index]
                                                                        .vencimento),
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
                      ),
                      Obx(
                        () => PermissaoExcluir.permissao!.value == true
                            ? Padding(
                                padding:
                                    EdgeInsets.only(top: size.height * 0.03),
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: Padding(
                                      padding: EdgeInsets.only(
                                          bottom: size.height * 0.02),
                                      child: IconButton(
                                        icon: Icon(Icons.delete_forever),
                                        onPressed: () => {
                                          msgConfirmacaoDeletarRecebimento()
                                        },
                                        iconSize: 45,
                                        color: Colors.red,
                                      ),
                                    ))
                                  ],
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
