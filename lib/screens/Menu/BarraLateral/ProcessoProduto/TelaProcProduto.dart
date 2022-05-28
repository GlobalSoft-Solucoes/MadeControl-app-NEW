import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:madecontrol_desenvolvimento/Widget/ListFieldsDataBase.dart';
import 'package:madecontrol_desenvolvimento/Widget/TextField.dart';
import 'package:madecontrol_desenvolvimento/models/Models_ProcessoProduto.dart';
import 'package:madecontrol_desenvolvimento/models/Models_Usuario.dart';
import 'package:madecontrol_desenvolvimento/models/constantes.dart';
import 'package:http/http.dart' as http;

import 'ListaMedidasPorTipoProcesso.dart';
import 'ListaPorTipoProcesso.dart';

class dataProcessProduto {
  static int? idProcessoProduto;
  static int? numProduto;
  static String? pacotes;
  static String? metrosCubicos;
  static String? qtdPecas;
}

class TelaProcProduto extends StatefulWidget {
  TelaProcProduto({Key? key}) : super(key: key);

  @override
  TelaProcProdutoState createState() => TelaProcProdutoState();
}

class TelaProcProdutoState extends State<TelaProcProduto> {
  TextEditingController controllerDataInicio =
      MaskedTextController(mask: '00/00/0000');
  TextEditingController controllerDataFim =
      MaskedTextController(mask: '00/00/0000');
  DateTime currentDate = DateTime.now();
  RxBool? loading = true.obs;
  var dadosList = <ModelsProcProduto>[];
  static String dataInicio = '';
  static String dataFim = '';
  var urlApi;

  Future<dynamic> buscarDadosList() async {
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
                  urlApi = BuscaTotalProdutosPorData +
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
    urlApi = AgrupaRegistrosPorProduto;
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    Size size = mediaQuery.size;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                Colors.grey[100]!.withAlpha(300),
                Colors.grey.withAlpha(1100)
              ]),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      alignment: Alignment.bottomLeft,
                      padding:
                          EdgeInsets.only(top: size.height * 0.02, left: 10),
                      child: Container(
                        color: Colors.black26,
                        width: size.width * 0.13,
                        height: size.height * 0.06,
                        child: IconButton(
                          icon: Icon(Icons.arrow_back),
                          onPressed: () => Navigator.pop(context),
                          iconSize: 35,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(width: size.width * 0.7),
                    Container(
                      padding: EdgeInsets.only(right: 10),
                      child: IconButton(
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
                    ),
                  ],
                ),
                SizedBox(height: size.height * 0.06),
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
                    height: size.height * 0.73,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 1),
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: FutureBuilder(
                      future: buscarDadosList(),
                      builder: (BuildContext context, snapshot) {
                        return Obx(
                          () => loading!.value == true
                              ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                              : ListView.builder(
                                  itemCount: dadosList.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: EdgeInsets.only(
                                        left: size.width * 0.015,
                                        right: size.width * 0.015,
                                        top: size.width * 0.008,
                                        bottom: size.width * 0.008,
                                      ),
                                      child: GestureDetector(
                                        onTap: () async {
                                          print('num produto: ' +
                                              dadosList[index]
                                                  .numProduto
                                                  .toString());
                                          dataProcessProduto.idProcessoProduto =
                                              dadosList[index]
                                                  .idProcessoProduto;
                                          dataProcessProduto.numProduto =
                                              dadosList[index].numProduto;
                                          dataProcessProduto.pacotes =
                                              dadosList[index].qtdPacote;
                                          dataProcessProduto.qtdPecas =
                                              dadosList[index].qtdPecas;
                                          dataProcessProduto.metrosCubicos =
                                              dadosList[index]
                                                  .qtdCubicos
                                                  .toString();
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ListaMedidasPorTipoProcesso(),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          height: size.height * 0.17,
                                          width: size.width,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              5,
                                            ),
                                            color: Colors.grey[400],
                                          ),
                                          child: Container(
                                            alignment: Alignment.center,
                                            child: SingleChildScrollView(
                                              child: ListTile(
                                                title: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        FieldsDatabase()
                                                            .listaDadosBanco(
                                                                '',
                                                                dadosList[index]
                                                                    .produto),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                        height:
                                                            size.height * 0.02),
                                                    FieldsDatabase()
                                                        .listaDadosBanco(
                                                            'Pacotes: ',
                                                            dadosList[index]
                                                                .qtdPacote),
                                                    SizedBox(
                                                        height:
                                                            size.height * 0.01),
                                                    FieldsDatabase()
                                                        .listaDadosBanco(
                                                            'Qtd Peças: ',
                                                            dadosList[index]
                                                                .qtdPecas),
                                                    SizedBox(
                                                        height:
                                                            size.height * 0.01),
                                                    FieldsDatabase()
                                                        .listaDadosBanco(
                                                            'Metros Cúbicos: ',
                                                            dadosList[index]
                                                                .qtdCubicos),
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
