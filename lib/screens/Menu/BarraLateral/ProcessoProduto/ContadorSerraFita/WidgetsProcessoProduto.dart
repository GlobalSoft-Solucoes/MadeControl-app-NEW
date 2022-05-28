import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:madecontrol_desenvolvimento/Statics/Static_Recebimento.dart';
import 'package:madecontrol_desenvolvimento/Widget/Botao.dart';
import 'package:madecontrol_desenvolvimento/Widget/Cabecalho.dart';
import 'package:get/get.dart';
import 'package:madecontrol_desenvolvimento/Widget/CheckBox.dart';
import 'package:madecontrol_desenvolvimento/Widget/ListFieldsDataBase.dart';
import 'package:madecontrol_desenvolvimento/Widget/MsgPopup.dart';
import 'package:madecontrol_desenvolvimento/Widget/TextField.dart';
import 'package:madecontrol_desenvolvimento/funcoes/FuncoesParaDatas.dart';
import 'package:madecontrol_desenvolvimento/models/Models_Recebimento.dart';
import 'package:madecontrol_desenvolvimento/models/Models_Usuario.dart';
import 'package:http/http.dart' as http;
import 'package:madecontrol_desenvolvimento/models/constantes.dart';

import 'SelectProcessoProduto.dart';

class WidgetsProcessoProduto extends StatefulWidget {
  WidgetsProcessoProduto({Key? key}) : super(key: key);
  @override
  WidgetsProcessoProdutoState createState() => WidgetsProcessoProdutoState();
}

class PermissaoExcluir {
  static RxBool? permissao = false.obs;
}

class WidgetsProcessoProdutoState extends State<WidgetsProcessoProduto> {
  _CadProcessoProdutoState() {}
  var dadosListagem = <ModelsRecebimento>[];
  var dadosParcelamento = <ModelsParcelaRecibo>[];
  TextEditingController controllerData =
      MaskedTextController(mask: '00/00/0000');
  RxBool? loading = true.obs;
  int? idRecebimento;
  DateTime currentDate = DateTime.now();
  int? idParcelaRecibo;

  var tipoMadeira;
  bool? madPinus = false;
  bool? madEucalipto = false;
  bool? madOutro = false;

  var tipoPrancha;
  bool? prancha40 = false;
  bool? prancha35 = false;
  bool? prancha30 = false;

  var opcButtonMedida;
  var valorButtonMedida;
  var mudarCor = Colors.yellow;
  var corAno = Colors.orange[700];
  var corTextoEscolhido = Colors.black;
  var corTexto = Colors.white;

  medidaPrancha() {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    Size size = mediaQuery.size;
    Container(
      padding: EdgeInsets.only(
        left: 5,
        right: 5,
        top: Get.height * 0.02,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            width: 2,
            color: Colors.black,
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          children: [
            const Text(
              'Medida',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: Get.height * 0.01,
            ),
            Container(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: CheckboxListTile(
                          title: const Text(
                            '40',
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 20),
                          ),
                          key: Key('check1'),
                          value: prancha40,
                          onChanged: (bool? valor) {
                            setState(
                              () {
                                prancha30 = false;
                                prancha35 = false;
                                prancha40 = true;
                                tipoPrancha = '40';
                              },
                            );
                          },
                        ),
                      ),
                      Expanded(
                        child: CheckboxListTile(
                          title: const Text(
                            '35',
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 20),
                          ),
                          key: Key('check1'),
                          value: prancha35,
                          onChanged: (bool? valor) {
                            setState(
                              () {
                                prancha30 = false;
                                prancha35 = true;
                                prancha40 = false;
                                tipoPrancha = '35';
                              },
                            );
                          },
                        ),
                      ),
                      SizedBox(width: size.width * 0.02),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CheckboxListTile(
                            title: const Text(
                              '30',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 20),
                            ),
                            key: Key('check3'),
                            value: prancha30,
                            onChanged: (bool? valor) {
                              setState(() {
                                prancha30 = true;
                                prancha35 = false;
                                prancha40 = false;
                                tipoPrancha = '30';
                              });
                            }),
                      ),
                      SizedBox(width: size.width * 0.5),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  medidaTabua() {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    Size size = mediaQuery.size;
    Container(
      padding: EdgeInsets.only(
        left: 5,
        right: 5,
        top: Get.height * 0.02,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            width: 2,
            color: Colors.black,
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          children: [
            const Text(
              'Medida',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: Get.height * 0.01,
            ),
            Container(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: CheckboxListTile(
                          title: const Text(
                            '40',
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 20),
                          ),
                          key: Key('check1'),
                          value: prancha40,
                          onChanged: (bool? valor) {
                            setState(
                              () {
                                prancha30 = false;
                                prancha35 = false;
                                prancha40 = true;
                                tipoPrancha = '40';
                              },
                            );
                          },
                        ),
                      ),
                      Expanded(
                        child: CheckboxListTile(
                          title: const Text(
                            '35',
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 20),
                          ),
                          key: Key('check1'),
                          value: prancha35,
                          onChanged: (bool? valor) {
                            setState(
                              () {
                                prancha30 = false;
                                prancha35 = true;
                                prancha40 = false;
                                tipoPrancha = '35';
                              },
                            );
                          },
                        ),
                      ),
                      SizedBox(width: size.width * 0.02),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CheckboxListTile(
                            title: const Text(
                              '30',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 20),
                            ),
                            key: Key('check3'),
                            value: prancha30,
                            onChanged: (bool? valor) {
                              setState(() {
                                prancha30 = true;
                                prancha35 = false;
                                prancha40 = false;
                                tipoPrancha = '30';
                              });
                            }),
                      ),
                      SizedBox(width: size.width * 0.5),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
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
                  opcProcessproduto.produto,
                  iconeVoltar: true,
                  sizeTextTitulo: 0.065,
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: size.width * 0.02,
                    right: size.width * 0.02,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: size.width,
                        height: opcProcessproduto.numproduto == 2
                            ? size.height * 0.43
                            : opcProcessproduto.numproduto == 3
                                ? size.height * 0.43
                                : size.height * 0.3,
                        padding: EdgeInsets.only(
                            left: 5, right: 5, top: Get.height * 0.0),
                        alignment: Alignment.topRight,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.only(
                                left: 5,
                                right: 5,
                              ),
                              child: Container(
                                height: size.height * 0.23,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    width: 2,
                                    color: Colors.black,
                                    style: BorderStyle.solid,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    const Text(
                                      'Madeira',
                                      style: TextStyle(
                                        fontSize: 21,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      height: Get.height * 0.02,
                                    ),
                                    Container(
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: CheckboxListTile(
                                                  title: const Text(
                                                    'PINUS',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontSize: 20),
                                                  ),
                                                  key: Key('check1'),
                                                  value: madPinus,
                                                  onChanged: (bool? valor) {
                                                    setState(
                                                      () {
                                                        madOutro = false;
                                                        madEucalipto = false;
                                                        madPinus = true;
                                                        tipoMadeira = 'PINUS';
                                                      },
                                                    );
                                                  },
                                                ),
                                              ),
                                              Expanded(
                                                child: CheckboxListTile(
                                                    title: const Text(
                                                      'EUCALIPTO',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontSize: 20),
                                                    ),
                                                    key: Key('check2'),
                                                    value: madEucalipto,
                                                    onChanged: (bool? valor) {
                                                      setState(() {
                                                        madOutro = false;
                                                        madPinus = false;
                                                        madEucalipto = true;
                                                        tipoMadeira =
                                                            'EUCALIPTO';
                                                      });
                                                    }),
                                              ),
                                              SizedBox(
                                                  width: size.width * 0.02),
                                            ],
                                          ),
                                          SizedBox(
                                            height: Get.height * 0.02,
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: CheckboxListTile(
                                                  title: const Text(
                                                    'OUTRO',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontSize: 20),
                                                  ),
                                                  key: Key('check3'),
                                                  value: madOutro,
                                                  onChanged: (bool? valor) {
                                                    setState(
                                                      () {
                                                        madPinus = false;
                                                        madEucalipto = false;
                                                        madOutro = true;
                                                        tipoMadeira = 'OUTRO';
                                                      },
                                                    );
                                                  },
                                                ),
                                              ),
                                              SizedBox(width: size.width * 0.5),
                                            ],
                                          ),
                                          SizedBox(
                                            height: Get.height * 0.025,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: size.height * 0.03),
                      if (opcProcessproduto.numproduto != 4)
                        Container(
                          padding: const EdgeInsets.only(
                            bottom: 5,
                            top: 5,
                          ),
                          width: size.width,
                          height: size.height * 0.32,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      setState(() {
                                        opcButtonMedida = '1';
                                        opcProcessproduto.numproduto == 1
                                            ? valorButtonMedida = '2,8'
                                            : opcProcessproduto.numproduto == 2
                                                ? valorButtonMedida = '3'
                                                : opcProcessproduto
                                                            .numproduto ==
                                                        3
                                                    ? valorButtonMedida = '3'
                                                    : valorButtonMedida = '';
                                      });
                                    },
                                    child: Container(
                                      width: size.width * 0.4,
                                      height: size.height * 0.08,
                                      alignment: Alignment.center,
                                      child: Text(
                                        opcProcessproduto.numproduto == 1
                                            ? '2,8'
                                            : opcProcessproduto.numproduto == 2
                                                ? '3'
                                                : opcProcessproduto
                                                            .numproduto ==
                                                        3
                                                    ? '3'
                                                    : '',
                                        style: TextStyle(
                                            color: opcButtonMedida == '1'
                                                ? corTextoEscolhido
                                                : corTexto,
                                            fontSize: 21,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: opcButtonMedida == '1'
                                            ? mudarCor
                                            : corAno,
                                        border: Border.all(
                                          color: Colors.red[100]!,
                                          width: 3,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: Get.width * 0.08),
                                  GestureDetector(
                                    onTap: () async {
                                      setState(() {
                                        opcButtonMedida = '2';

                                        opcProcessproduto.numproduto == 1
                                            ? valorButtonMedida = '2,2'
                                            : opcProcessproduto.numproduto == 2
                                                ? valorButtonMedida = '2,8'
                                                : opcProcessproduto
                                                            .numproduto ==
                                                        3
                                                    ? valorButtonMedida = '2,8'
                                                    : valorButtonMedida = '';
                                      });
                                    },
                                    child: Container(
                                      width: size.width * 0.4,
                                      height: size.height * 0.08,
                                      alignment: Alignment.center,
                                      child: Text(
                                        opcProcessproduto.numproduto == 1
                                            ? '2,2'
                                            : opcProcessproduto.numproduto == 2
                                                ? '2,8'
                                                : opcProcessproduto
                                                            .numproduto ==
                                                        3
                                                    ? '2,8'
                                                    : '',
                                        style: TextStyle(
                                            color: opcButtonMedida == '2'
                                                ? corTextoEscolhido
                                                : corTexto,
                                            fontSize: 21,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: opcButtonMedida == '2'
                                            ? mudarCor
                                            : corAno,
                                        border: Border.all(
                                          color: Colors.red[100]!,
                                          width: 3,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: Get.height * 0.06),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      setState(() {
                                        opcButtonMedida = '3';

                                        opcProcessproduto.numproduto == 1
                                            ? valorButtonMedida = '2'
                                            : opcProcessproduto.numproduto == 2
                                                ? valorButtonMedida = '2,2'
                                                : opcProcessproduto
                                                            .numproduto ==
                                                        3
                                                    ? valorButtonMedida = '2,2'
                                                    : valorButtonMedida = '';
                                      });
                                    },
                                    child: Container(
                                      width: size.width * 0.4,
                                      height: size.height * 0.08,
                                      alignment: Alignment.center,
                                      child: Text(
                                        opcProcessproduto.numproduto == 1
                                            ? '2'
                                            : opcProcessproduto.numproduto == 2
                                                ? '2,2'
                                                : opcProcessproduto
                                                            .numproduto ==
                                                        3
                                                    ? '2,2'
                                                    : '',
                                        style: TextStyle(
                                            color: opcButtonMedida == '3'
                                                ? corTextoEscolhido
                                                : corTexto,
                                            fontSize: 21,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: opcButtonMedida == '3'
                                            ? mudarCor
                                            : corAno,
                                        border: Border.all(
                                          color: Colors.red[100]!,
                                          width: 3,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: Get.width * 0.08),
                                  GestureDetector(
                                    onTap: () async {
                                      setState(() {
                                        opcButtonMedida = '4';

                                        opcProcessproduto.numproduto == 1
                                            ? valorButtonMedida = '2 FACES'
                                            : opcProcessproduto.numproduto == 2
                                                ? valorButtonMedida = '2'
                                                : opcProcessproduto
                                                            .numproduto ==
                                                        3
                                                    ? valorButtonMedida = '2'
                                                    : valorButtonMedida = '';
                                      });
                                    },
                                    child: Container(
                                      width: size.width * 0.4,
                                      height: size.height * 0.08,
                                      alignment: Alignment.center,
                                      child: Text(
                                        opcProcessproduto.numproduto == 1
                                            ? '2 FACES'
                                            : opcProcessproduto.numproduto == 2
                                                ? '2'
                                                : opcProcessproduto
                                                            .numproduto ==
                                                        3
                                                    ? '2'
                                                    : '',
                                        style: TextStyle(
                                            color: opcButtonMedida == '4'
                                                ? corTextoEscolhido
                                                : corTexto,
                                            fontSize: 21,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: opcButtonMedida == '4'
                                            ? mudarCor
                                            : corAno,
                                        border: Border.all(
                                          color: Colors.red[100]!,
                                          width: 3,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                    ],
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
