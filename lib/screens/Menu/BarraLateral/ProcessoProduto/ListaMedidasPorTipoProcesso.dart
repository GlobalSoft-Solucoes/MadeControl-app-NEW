import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:madecontrol_desenvolvimento/Widget/Cabecalho.dart';
import 'package:get/get.dart';
import 'package:madecontrol_desenvolvimento/Widget/ListFieldsDataBase.dart';
import 'package:madecontrol_desenvolvimento/Widget/TextField.dart';
import 'package:madecontrol_desenvolvimento/funcoes/FuncoesParaDatas.dart';

import 'package:madecontrol_desenvolvimento/models/Models_ProcessoProduto.dart';
import 'package:madecontrol_desenvolvimento/models/Models_Usuario.dart';
import 'package:http/http.dart' as http;
import 'package:madecontrol_desenvolvimento/models/constantes.dart';

import 'ListaPorTipoProcesso.dart';
import 'TelaProcProduto.dart';

class dadosOpcProduto {
  static String? tipoMedida;
  static int? numProduto;
  static String? pacotes;
  static String? metrosCubicos;
}

class ListaMedidasPorTipoProcesso extends StatefulWidget {
  @override
  _ListaMedidasPorTipoProcessoState createState() =>
      _ListaMedidasPorTipoProcessoState();
}

class _ListaMedidasPorTipoProcessoState
    extends State<ListaMedidasPorTipoProcesso> {
  var dadosList = <ModelsProcProduto>[];
  TextEditingController controllerDataInicio =
      MaskedTextController(mask: '00/00/0000');
  TextEditingController controllerDataFim =
      MaskedTextController(mask: '00/00/0000');
  RxBool? loading = true.obs;
  static String dataInicio = '';
  static String dataFim = '';
  DateTime currentDate = DateTime.now();
  var urlApi;
  var qtdPacotePorTipo = null;
  var qtdCubicoPorTipo = null;
  var qtdPecasPorTipo = null;

  Future<dynamic> listarDados() async {
    final response = await http.get(
      Uri.parse(urlApi + ModelsUsuarios.caminhoBaseUser.toString()),
      headers: {"authorization": ModelsUsuarios.tokenAuth.toString()},
    );
    if (response.statusCode == 401) {
      Navigator.pushNamed(context, '/login');
    }

    //IF(MOUNTED) É nescessario para não recarregar a arvore apos retornar das outras listas
    if (mounted) {
      setState(() {
        Iterable lista = json.decode(response.body);
        dadosList =
            lista.map((model) => ModelsProcProduto.fromJson(model)).toList();
        if (dadosList.length == 0) {
          qtdPacotePorTipo = 0;
          qtdCubicoPorTipo = 0;
          qtdPecasPorTipo = 0;
        }
      });
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

  converterDataParaEua(data) {
    var dia;
    var mes;
    var ano;
    var dataEua;

    String? dataConversao = data.toString();

    dia = dataConversao.substring(0, 2);
    mes = dataConversao.substring(3, 5);
    ano = dataConversao.substring(6, 10);

    dataEua = ano + '-' + mes + '-' + dia;

    print(dataEua);
    return dataEua.toString();
  }

  popupFiltroPesquisaRecebimentos(
    BuildContext context,
    controllerDataInicio,
    controllerDataFim, {
    mensagemTitulo,
    double? bordaPopup,
    double? fontText,
    mascara,
    iconeText,
    double? fontMsg,
    Color? corMsg,
    Color? corBotaoEsq,
    Color? corBotaoDir,
    txtButton,
    textoCampo,
    fonteButton,
    fontWeightButton,
    Function? onTapInicial,
    Function? onTapFinal,
  }) {
    return showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(bordaPopup ?? 10)),
          ),
          title: const Text(
            'Pesquisas:',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),
          // ======= email =========
          actions: <Widget>[
            Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.005,
                bottom: MediaQuery.of(context).size.height * 0.005,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.39,
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.01,
                    ),
                    child: CampoText().textFieldIconButton(
                      controllerDataInicio,
                      'Inicial:',
                      tipoTexto: TextInputType.number,
                      fontSize: Get.height * 0.02,
                      fontLabel: Get.height * 0.025,
                      icone: Icons.calendar_today_outlined,
                      confPadding:
                          EdgeInsets.only(top: 5, left: 0, right: 5, bottom: 5),
                      onTapIcon: () {
                        onTapInicial!();
                      },
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.39,
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.01,
                    ),
                    child: CampoText().textFieldIconButton(
                        controllerDataFim, 'Final:',
                        tipoTexto: TextInputType.number,
                        fontSize: Get.height * 0.02,
                        fontLabel: Get.height * 0.025,
                        icone: Icons.calendar_today_outlined,
                        confPadding: const EdgeInsets.only(
                            top: 5,
                            left: 5,
                            right: 0,
                            bottom: 5), onTapIcon: () {
                      onTapFinal!();
                    }),
                  ),
                ],
              ),
            ),

            // ================== BOTÃO DE PESQUISA =================
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.03,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.61,
              padding: EdgeInsets.only(
                top: 15,
                bottom: 5,
                right: MediaQuery.of(context).size.width * 0.17,
              ),
              child: FloatingActionButton.extended(
                backgroundColor: Colors.green,
                label: const Text(
                  'Pesquisar',
                  style: TextStyle(fontSize: 23),
                ),
                onPressed: () async {
                  converterDataParaEua(controllerDataInicio.text);
                  Navigator.pop(context);
                  dataFim = converterDataParaEua(controllerDataFim.text);
                  dataInicio = converterDataParaEua(controllerDataInicio.text);
                  // pesquisaProdutos(dataInicio, dataFim);
                  urlApi = AgrupaPorTipoMedidaEData +
                      dataProcessProduto.numProduto.toString() +
                      '/' +
                      dataInicio.toString() +
                      '/' +
                      dataFim.toString() +
                      '/';
                },
              ),
            ),
            // =========== ICONBUTTON PARA LIMPAR OS DADOS ============
            IconButton(
              iconSize: 34,
              icon: const Icon(
                Icons.cleaning_services_outlined,
                color: Colors.red,
              ),
              onPressed: () async {
                setState(() {
                  controllerDataInicio.text = "";
                  controllerDataFim.text = "";
                  Navigator.pop(context);
                });
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    print('data: ' + DataAtual().pegardataEUA().toString());
    urlApi = AgrupaPorTipoMedidaEData +
        dataProcessProduto.numProduto.toString() +
        '/' +
        '1999-01-01' +
        '/' +
        DataAtual().pegardataEUA() +
        '/';
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
                Row(
                  children: [
                    Container(
                      alignment: Alignment.bottomLeft,
                      padding:
                          EdgeInsets.only(top: size.height * 0.01, left: 10),
                      child: Container(
                        color: Colors.black26,
                        width: size.width * 0.11,
                        height: size.height * 0.055,
                        child: IconButton(
                          icon: Icon(Icons.arrow_back),
                          onPressed: () => Navigator.pop(context),
                          iconSize: 35,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Container(
                      height: size.height * 0.055,
                      width: size.width * 0.7,
                      child: Center(
                        child: Text(
                          dataProcessProduto.numProduto == 1
                              ? 'DORMENTE'
                              : dataProcessProduto.numProduto == 2
                                  ? 'PRANCHA'
                                  : dataProcessProduto.numProduto == 3
                                      ? 'TABUA'
                                      : dataProcessProduto.numProduto == 4
                                          ? 'PALETE'
                                          : ' ',
                          style: TextStyle(
                            fontSize: size.height * 0.026,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.filter_list,
                        color: Colors.black26,
                      ),
                      onPressed: () async {
                        await popupFiltroPesquisaRecebimentos(
                            context, controllerDataInicio, controllerDataFim,
                            onTapInicial: () async {
                          await selectDate(context);
                          controllerDataInicio.text = converterData();
                        }, onTapFinal: () async {
                          await selectDate(context);
                          controllerDataFim.text = converterData();
                        });
                        setState(() {});
                      },
                      iconSize: size.width * 0.08,
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: size.width * 0.02,
                    right: size.width * 0.02,
                    top: size.height * 0.01,
                  ),
                  child: Container(
                    height: size.height * 0.18,
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
                            SizedBox(height: 15),
                            FieldsDatabase().listaDadosBanco(
                              'Total Metros Cúbicos: ',
                              qtdCubicoPorTipo,
                              sizeCampoBanco: size.height * 0.025,
                              sizeTextoCampo: size.height * 0.025,
                            ),
                            SizedBox(height: 15),
                            FieldsDatabase().listaDadosBanco(
                              'Total Pacotes: ',
                              qtdPacotePorTipo,
                              sizeCampoBanco: size.height * 0.025,
                              sizeTextoCampo: size.height * 0.025,
                            ),
                            SizedBox(height: 15),
                            FieldsDatabase().listaDadosBanco(
                              'Total Peças: ',
                              qtdPecasPorTipo,
                              sizeCampoBanco: size.height * 0.025,
                              sizeTextoCampo: size.height * 0.025,
                            ),
                            SizedBox(height: 15),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: size.width * 0.02,
                      right: size.width * 0.02,
                      top: size.height * 0.01),
                  child: Container(
                    padding: const EdgeInsets.only(bottom: 5, top: 5),
                    width: size.width,
                    height: size.height * 0.7,
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
                                  itemCount: dadosList.length,
                                  itemBuilder: (context, index) {
                                    // if (dadosList.length > 0) {
                                    qtdPacotePorTipo =
                                        dadosList[index].qtdPacotePorTipo;
                                    qtdCubicoPorTipo =
                                        dadosList[index].qtdCubicosPorTipo;
                                    qtdPecasPorTipo =
                                        dadosList[index].qtdPecasPorTipo;
                                    // } else {
                                    //   qtdPacotePorTipo = 0;
                                    //   qtdCubicoPorTipo = 0;
                                    // }

                                    return GestureDetector(
                                      onTap: () async {
                                        dadosOpcProduto.tipoMedida =
                                            dadosList[index].opcMedida;
                                        dadosOpcProduto.numProduto =
                                            dadosList[index].numProduto;
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ListaPorTipoProcesso(),
                                          ),
                                        );
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 4,
                                          top: 4,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 7, right: 7),
                                          child: Container(
                                            alignment: Alignment.center,
                                            height: size.height * 0.17,
                                            width: size.width,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                10,
                                              ),
                                              color: Color(0XFFD1D6DC),
                                            ),
                                            child: Container(
                                              padding: const EdgeInsets.only(
                                                left: 5,
                                                right: 10,
                                              ),
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
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            FieldsDatabase()
                                                                .listaDadosBanco(
                                                                    '',
                                                                    dadosList[
                                                                            index]
                                                                        .opcMedida),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                            height:
                                                                size.height *
                                                                    0.02),
                                                        FieldsDatabase().listaDadosBanco(
                                                            'Pacotes:  ',
                                                            dadosList[index]
                                                                    .metrosCubicos ??
                                                                dadosList[index]
                                                                    .totalPacotesPorTipoMedida),
                                                        SizedBox(
                                                            height:
                                                                size.height *
                                                                    0.01),
                                                        FieldsDatabase()
                                                            .listaDadosBanco(
                                                                'Peças:  ',
                                                                dadosList[index]
                                                                    .totalPecasPorTipoMedida),
                                                        SizedBox(
                                                            height:
                                                                size.height *
                                                                    0.01),
                                                        FieldsDatabase().listaDadosBanco(
                                                            'Metros cúbicos:  ',
                                                            dadosList[index]
                                                                    .metrosCubicos ??
                                                                dadosList[index]
                                                                    .totalCubicosPorTipoMedida),
                                                      ],
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
