import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:madecontrol_desenvolvimento/Widget/Botao.dart';
import 'package:madecontrol_desenvolvimento/Widget/Cabecalho.dart';
import 'package:get/get.dart';
import 'package:madecontrol_desenvolvimento/Widget/CheckBox.dart';
import 'package:madecontrol_desenvolvimento/Widget/MsgPopup.dart';
import 'package:madecontrol_desenvolvimento/funcoes/FuncoesParaDatas.dart';
import 'package:madecontrol_desenvolvimento/models/Models_Recebimento.dart';
import 'package:madecontrol_desenvolvimento/models/Models_Usuario.dart';
import 'package:http/http.dart' as http;
import 'package:madecontrol_desenvolvimento/models/constantes.dart';
import 'SelectProcessoProduto.dart';

class CadProcessoProduto extends StatefulWidget {
  CadProcessoProduto({Key? key}) : super(key: key);
  @override
  _CadProcessoProdutoState createState() => _CadProcessoProdutoState();
}

class PermissaoExcluir {
  static RxBool? permissao = false.obs;
}

class _CadProcessoProdutoState extends State<CadProcessoProduto> {
  _CadProcessoProdutoState() {}
  var dadosListagem = <ModelsRecebimento>[];
  var dadosParcelamento = <ModelsParcelaRecibo>[];
  TextEditingController controllerData =
      MaskedTextController(mask: '00/00/0000');
  RxBool? loading = true.obs;
  int? idRecebimento;
  DateTime currentDate = DateTime.now();
  int? idParcelaRecibo;
  int? qtdPacote;
  double? mtsCubicos;
  var tipoMedida;
  bool? opcTabuaLarga;

  var tipoMadeira;
  bool? madPinus = false;
  bool? madEucalipto = false;
  bool? madOutro = false;

  bool? prancha40 = false;
  bool? prancha35 = false;
  bool? prancha30 = false;

  bool? tabuaLarga = false;
  bool? tabua08 = false;
  bool? tabua10 = false;
  bool? tabua12 = false;
  bool? tabua15 = false;

  bool? pallet07 = false;
  bool? pallet10 = false;
  bool? pallet12 = false;
  bool? pallet15 = false;

  var opcButtonMedida;
  var valorButtonMedida;
  var mudarCor = Colors.yellow;
  var corMedida = Colors.orange[700];
  var corTextoEscolhido = Colors.black;
  var corTexto = Colors.white;

  Future<dynamic> salvarReg() async {
    var corpoReq = jsonEncode(
      {
        'produto': opcProcessproduto.produto,
        'quantidade': qtdPacote,
        'metros_cubicos': mtsCubicos,
        'madeira': tipoMadeira,
        'tipo_medida': tipoMedida,
        'medida': valorButtonMedida,
        "num_produto": opcProcessproduto.numproduto,
        'data': DataAtual().pegardataEUA().toString(),
        'hora': DataAtual().pegarHora().toString(),
      },
    );
    var response = await http.post(
      Uri.parse(
          ProcessoProdutoCadastrar + ModelsUsuarios.caminhoBaseUser.toString()),
      headers: {
        "Content-Type": "application/json",
        "authorization": ModelsUsuarios.tokenAuth.toString()
      },
      body: corpoReq,
    );
    print(response.statusCode);
    print(corpoReq);
    if (response.statusCode == 201) {
      // Navigator.pop(context);
    }
  }

  verificarCampos() {
    // if(opcProcessproduto.numproduto != 4){
    if (tipoMadeira == null) {
      MsgPopup()
          .msgFeedback(context, 'Selecione um tipo de madeira!', 'Madeira');
    } else if ((opcProcessproduto.numproduto == 2 && tipoMedida == null) ||
        (opcProcessproduto.numproduto == 3 && tipoMedida == null)) {
      MsgPopup().msgFeedback(context, '\nEscolha uma medida!', 'Medida');
    } else if (opcProcessproduto.numproduto != 4 && valorButtonMedida == null) {
      MsgPopup().msgFeedback(
          context, '\nSelecione um botão de medida!', 'Botão de medida');
    } else {
      salvarReg();
    }
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
                                : opcProcessproduto.numproduto == 4
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
                            CheckBox().checkBoxQuebraTresOpcoes(
                              context,
                              'MADEIRA',
                              'EUCALIPTO',
                              'PINUS',
                              'OUTRO',
                              madEucalipto,
                              madPinus,
                              madOutro,
                              () => {
                                setState(() {
                                  madOutro = false;
                                  madPinus = false;
                                  madEucalipto = true;
                                  tipoMadeira = 'EUCALIPTO';
                                }),
                              },
                              () => {
                                setState(
                                  () {
                                    madOutro = false;
                                    madEucalipto = false;
                                    madPinus = true;
                                    tipoMadeira = 'PINUS';
                                  },
                                ),
                              },
                              () => {
                                setState(
                                  () {
                                    madPinus = false;
                                    madEucalipto = false;
                                    madOutro = true;
                                    tipoMadeira = 'OUTRO';
                                  },
                                ),
                              },
                              distanciaUltimocheck: 0.45,
                            ),
                            if (opcProcessproduto.numproduto == 4)
                              CheckBox().checkBoxQuebraQuatroOpcoes(
                                context,
                                'MEDIDAS',
                                '07',
                                '10',
                                '12',
                                '15',
                                pallet07,
                                pallet10,
                                pallet12,
                                pallet15,
                                () => {
                                  setState(
                                    () {
                                      pallet15 = false;
                                      pallet12 = false;
                                      pallet10 = false;
                                      pallet07 = true;
                                      tipoMedida = '07';

                                      qtdPacote = 390;
                                      opcTabuaLarga = false;
                                    },
                                  ),
                                },
                                () => {
                                  setState(
                                    () {
                                      pallet15 = false;
                                      pallet12 = false;
                                      pallet10 = true;
                                      pallet07 = false;
                                      tipoMedida = '10';

                                      qtdPacote = 300;
                                      opcTabuaLarga = false;
                                    },
                                  ),
                                },
                                () => {
                                  setState(
                                    () {
                                      pallet15 = false;
                                      pallet12 = true;
                                      pallet10 = false;
                                      pallet07 = false;
                                      tipoMedida = '12';

                                      qtdPacote = 240;
                                      opcTabuaLarga = false;
                                    },
                                  ),
                                },
                                () => {
                                  setState(
                                    () {
                                      pallet15 = true;
                                      pallet12 = false;
                                      pallet10 = false;
                                      pallet07 = false;
                                      tipoMedida = '15';

                                      qtdPacote = 210;
                                      opcTabuaLarga = false;
                                    },
                                  ),
                                },
                              ),
                            if (opcProcessproduto.numproduto == 3)
                              CheckBox().checkBoxQuebraCincoOpcoes(
                                context,
                                'MEDIDAS',
                                '08',
                                '10',
                                '12',
                                '15',
                                'TABUA LARGA',
                                tabua08,
                                tabua10,
                                tabua12,
                                tabua15,
                                tabuaLarga,
                                () => {
                                  setState(
                                    () {
                                      tabuaLarga = false;
                                      tabua15 = false;
                                      tabua12 = false;
                                      tabua10 = false;
                                      tabua08 = true;
                                      tipoMedida = '08';

                                      qtdPacote = 240;
                                      opcTabuaLarga = false;
                                    },
                                  ),
                                },
                                () => {
                                  setState(
                                    () {
                                      tabuaLarga = false;
                                      tabua15 = false;
                                      tabua12 = false;
                                      tabua10 = true;
                                      tabua08 = false;
                                      tipoMedida = '10';

                                      qtdPacote = 200;
                                      opcTabuaLarga = false;
                                    },
                                  ),
                                },
                                () => {
                                  setState(
                                    () {
                                      tabuaLarga = false;
                                      tabua15 = false;
                                      tabua12 = true;
                                      tabua10 = false;
                                      tabua08 = false;
                                      tipoMedida = '12';

                                      qtdPacote = 160;
                                      opcTabuaLarga = false;
                                    },
                                  ),
                                },
                                () => {
                                  setState(
                                    () {
                                      tabuaLarga = false;
                                      tabua15 = true;
                                      tabua12 = false;
                                      tabua10 = false;
                                      tabua08 = false;
                                      tipoMedida = '15';

                                      qtdPacote = 140;
                                      opcTabuaLarga = false;
                                    },
                                  ),
                                },
                                () => {
                                  setState(
                                    () {
                                      tabuaLarga = true;
                                      tabua15 = false;
                                      tabua12 = false;
                                      tabua10 = false;
                                      tabua08 = false;
                                      tipoMedida = 'Tabua Larga';

                                      qtdPacote = 20;
                                      opcTabuaLarga = true;
                                    },
                                  ),
                                },
                              ),
                            if (opcProcessproduto.numproduto == 2)
                              CheckBox().checkBoxTresOpcoes(
                                context,
                                'MEDIDAS',
                                '4',
                                '3,5',
                                '3',
                                prancha40,
                                prancha35,
                                prancha30,
                                () => {
                                  setState(
                                    () {
                                      prancha30 = false;
                                      prancha35 = false;
                                      prancha40 = true;
                                      tipoMedida = '4';

                                      qtdPacote = 15;
                                    },
                                  ),
                                },
                                () => {
                                  setState(
                                    () {
                                      prancha30 = false;
                                      prancha35 = true;
                                      prancha40 = false;
                                      tipoMedida = '3,5';

                                      qtdPacote = 15;
                                    },
                                  ),
                                },
                                () => {
                                  setState(
                                    () {
                                      prancha30 = true;
                                      prancha35 = false;
                                      prancha40 = false;
                                      tipoMedida = '3';

                                      qtdPacote = 15;
                                    },
                                  ),
                                },
                              )
                          ],
                        ),
                      ),
                      SizedBox(height: size.height * 0.03),
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
                                      if (opcProcessproduto.numproduto == 1) {
                                        valorButtonMedida = '2,8';
                                        qtdPacote = 14;
                                        mtsCubicos = 1.596;
                                      } else if (opcProcessproduto.numproduto ==
                                          2) {
                                        valorButtonMedida = '3';
                                        if (tipoMedida == '4') {
                                          mtsCubicos = 1.890;
                                        } else if (tipoMedida == '3,5') {
                                          mtsCubicos = 1.653;
                                        } else if (tipoMedida == '3') {
                                          mtsCubicos = 1.417;
                                        }
                                      } else if (opcProcessproduto.numproduto ==
                                          3) {
                                        valorButtonMedida = '3';
                                        if (tipoMedida == '08') {
                                          mtsCubicos = 1.440;
                                        } else if (tipoMedida == '10') {
                                          mtsCubicos = 1.500;
                                        } else if (tipoMedida == '12') {
                                          mtsCubicos = 1.440;
                                        } else if (tipoMedida == '15') {
                                          mtsCubicos = 1.575;
                                        } else if (tipoMedida ==
                                            'Tabua Larga') {
                                          mtsCubicos = 1.500;
                                        }
                                      } else if (opcProcessproduto.numproduto ==
                                          4) {
                                        valorButtonMedida = '3';

                                        if (tipoMedida == '07') {
                                          mtsCubicos = 1.556;
                                        } else if (tipoMedida == '10') {
                                          mtsCubicos = 1.710;
                                        } else if (tipoMedida == '12') {
                                          mtsCubicos = 1.641;
                                        } else if (tipoMedida == '15') {
                                          mtsCubicos = 1.795;
                                        }
                                      } else {
                                        valorButtonMedida = '';
                                      }
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
                                              : opcProcessproduto.numproduto ==
                                                      3
                                                  ? '3'
                                                  : opcProcessproduto
                                                              .numproduto ==
                                                          4
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
                                          : corMedida,
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
                                      if (opcProcessproduto.numproduto == 1) {
                                        valorButtonMedida = '2,2';
                                        qtdPacote = 14;
                                        mtsCubicos = 1.255;
                                      } else if (opcProcessproduto.numproduto ==
                                          2) {
                                        valorButtonMedida = '2,8';
                                        if (tipoMedida == '4') {
                                          mtsCubicos = 1.764;
                                        } else if (tipoMedida == '3,5') {
                                          mtsCubicos = 1.543;
                                        } else if (tipoMedida == '3') {
                                          mtsCubicos = 1.323;
                                        }
                                      } else if (opcProcessproduto.numproduto ==
                                          3) {
                                        valorButtonMedida = '2,8';
                                        if (tipoMedida == '08') {
                                          mtsCubicos = 1.344;
                                        } else if (tipoMedida == '10') {
                                          mtsCubicos = 1.400;
                                        } else if (tipoMedida == '12') {
                                          mtsCubicos = 1.344;
                                        } else if (tipoMedida == '15') {
                                          mtsCubicos = 1.470;
                                        } else if (tipoMedida ==
                                            'Tabua Larga') {
                                          mtsCubicos = 1.400;
                                        }
                                      } else if (opcProcessproduto.numproduto ==
                                          4) {
                                        valorButtonMedida = '2,8';

                                        if (tipoMedida == '07') {
                                          mtsCubicos = 1.452;
                                        } else if (tipoMedida == '10') {
                                          mtsCubicos = 1.596;
                                        } else if (tipoMedida == '12') {
                                          mtsCubicos = 1.532;
                                        } else if (tipoMedida == '15') {
                                          mtsCubicos = 1.675;
                                        }
                                      } else {
                                        valorButtonMedida = '';
                                      }
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
                                              : opcProcessproduto.numproduto ==
                                                      3
                                                  ? '2,8'
                                                  : opcProcessproduto
                                                              .numproduto ==
                                                          4
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
                                          : corMedida,
                                      border: Border.all(
                                        color: Colors.red[100]!,
                                        width: 3,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: Get.height * 0.025),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    setState(() {
                                      opcButtonMedida = '3';

                                      if (opcProcessproduto.numproduto == 1) {
                                        valorButtonMedida = '2';
                                        qtdPacote = 20;
                                        mtsCubicos = 1.408;
                                      } else if (opcProcessproduto.numproduto ==
                                          2) {
                                        valorButtonMedida = '2,2';
                                        if (tipoMedida == '4') {
                                          mtsCubicos = 1.386;
                                        } else if (tipoMedida == '3,5') {
                                          mtsCubicos = 1.212;
                                        } else if (tipoMedida == '3') {
                                          mtsCubicos = 1.039;
                                        }
                                      }

                                      if (opcProcessproduto.numproduto == 3) {
                                        valorButtonMedida = '2,5';
                                        if (tipoMedida == '08') {
                                          mtsCubicos = 1.200;
                                        } else if (tipoMedida == '10') {
                                          mtsCubicos = 1.250;
                                        } else if (tipoMedida == '12') {
                                          mtsCubicos = 1.200;
                                        } else if (tipoMedida == '15') {
                                          mtsCubicos = 1.312;
                                        } else if (tipoMedida ==
                                            'Tabua Larga') {
                                          mtsCubicos = 1.250;
                                        }
                                      } else if (opcProcessproduto.numproduto ==
                                          4) {
                                        valorButtonMedida = '2,5';

                                        if (tipoMedida == '07') {
                                          mtsCubicos = 1.296;
                                        } else if (tipoMedida == '10') {
                                          mtsCubicos = 1.425;
                                        } else if (tipoMedida == '12') {
                                          mtsCubicos = 1.368;
                                        } else if (tipoMedida == '15') {
                                          mtsCubicos = 1.496;
                                        }
                                      } else {
                                        valorButtonMedida = '';
                                      }
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
                                              : opcProcessproduto.numproduto ==
                                                      3
                                                  ? '2,5'
                                                  : opcProcessproduto
                                                              .numproduto ==
                                                          4
                                                      ? '2,5'
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
                                          : corMedida,
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

                                      if (opcProcessproduto.numproduto == 1) {
                                        valorButtonMedida = '2 FACES';
                                        qtdPacote = 16;
                                        mtsCubicos = 1.126;
                                      } else if (opcProcessproduto.numproduto ==
                                          2) {
                                        valorButtonMedida = '2';
                                        if (tipoMedida == '4') {
                                          mtsCubicos = 1.260;
                                        } else if (tipoMedida == '3,5') {
                                          mtsCubicos = 1.102;
                                        } else if (tipoMedida == '3') {
                                          mtsCubicos = 0.945;
                                        }
                                      } else if (opcProcessproduto.numproduto ==
                                          3) {
                                        valorButtonMedida = '2,2';
                                        if (tipoMedida == '08') {
                                          mtsCubicos = 1.056;
                                        } else if (tipoMedida == '10') {
                                          mtsCubicos = 1.100;
                                        } else if (tipoMedida == '12') {
                                          mtsCubicos = 1.056;
                                        } else if (tipoMedida == '15') {
                                          mtsCubicos = 1.155;
                                        } else if (tipoMedida ==
                                            'Tabua Larga') {
                                          mtsCubicos = 1.100;
                                        }
                                      } else if (opcProcessproduto.numproduto ==
                                          4) {
                                        valorButtonMedida = '2,2';

                                        if (tipoMedida == '07') {
                                          mtsCubicos = 1.141;
                                        } else if (tipoMedida == '10') {
                                          mtsCubicos = 1.254;
                                        } else if (tipoMedida == '12') {
                                          mtsCubicos = 1.203;
                                        } else if (tipoMedida == '15') {
                                          mtsCubicos = 1.316;
                                        }
                                      } else {
                                        valorButtonMedida = '';
                                      }
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
                                              : opcProcessproduto.numproduto ==
                                                      3
                                                  ? '2,2'
                                                  : opcProcessproduto
                                                              .numproduto ==
                                                          4
                                                      ? '2,2'
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
                                          : corMedida,
                                      border: Border.all(
                                        color: Colors.red[100]!,
                                        width: 3,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: Get.height * 0.025),
                            if (opcProcessproduto.numproduto == 3 ||
                                opcProcessproduto.numproduto == 4)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if ((opcProcessproduto.numproduto == 3 ||
                                          opcProcessproduto.numproduto == 4) &&
                                      opcTabuaLarga != true)
                                    GestureDetector(
                                      onTap: () async {
                                        setState(() {
                                          if (opcProcessproduto.numproduto ==
                                              3) {
                                            if (tipoMedida == '08') {
                                              mtsCubicos = 1.008;
                                            } else if (tipoMedida == '10') {
                                              mtsCubicos = 1.050;
                                            } else if (tipoMedida == '12') {
                                              mtsCubicos = 1.008;
                                            } else if (tipoMedida == '15') {
                                              mtsCubicos = 1.102;
                                            }
                                          }

                                          if (opcProcessproduto.numproduto ==
                                              4) {
                                            if (tipoMedida == '07') {
                                              mtsCubicos = 1.089;
                                            } else if (tipoMedida == '10') {
                                              mtsCubicos = 1.197;
                                            } else if (tipoMedida == '12') {
                                              mtsCubicos = 1.149;
                                            } else if (tipoMedida == '15') {
                                              mtsCubicos = 1.256;
                                            }
                                          }

                                          opcButtonMedida = '5';
                                          valorButtonMedida = '2,1';
                                        });
                                      },
                                      child: Container(
                                        width: size.width * 0.4,
                                        height: size.height * 0.08,
                                        alignment: Alignment.center,
                                        child: Text(
                                          '2,1',
                                          style: TextStyle(
                                              color: opcButtonMedida == '5'
                                                  ? corTextoEscolhido
                                                  : corTexto,
                                              fontSize: 21,
                                              fontWeight: FontWeight.w700),
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          color: opcButtonMedida == '5'
                                              ? mudarCor
                                              : corMedida,
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
                                        opcButtonMedida = '6';
                                        valorButtonMedida = '2';

                                        if (opcProcessproduto.numproduto == 3) {
                                          if (tipoMedida == '08') {
                                            mtsCubicos = 0.960;
                                          } else if (tipoMedida == '10') {
                                            mtsCubicos = 1.000;
                                          } else if (tipoMedida == '12') {
                                            mtsCubicos = 0.960;
                                          } else if (tipoMedida == '15') {
                                            mtsCubicos = 1.050;
                                          } else if (tipoMedida ==
                                              'Tabua Larga') {
                                            mtsCubicos = 1.000;
                                          }
                                        }
                                        if (opcProcessproduto.numproduto == 4) {
                                          if (tipoMedida == '07') {
                                            mtsCubicos = 1.037;
                                          } else if (tipoMedida == '10') {
                                            mtsCubicos = 1.140;
                                          } else if (tipoMedida == '12') {
                                            mtsCubicos = 1.094;
                                          } else if (tipoMedida == '15') {
                                            mtsCubicos = 1.197;
                                          }
                                        }
                                      });
                                    },
                                    child: Container(
                                      width: size.width * 0.4,
                                      height: size.height * 0.08,
                                      alignment: Alignment.center,
                                      child: Text(
                                        '2',
                                        style: TextStyle(
                                            color: opcButtonMedida == '6'
                                                ? corTextoEscolhido
                                                : corTexto,
                                            fontSize: 21,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: opcButtonMedida == '6'
                                            ? mudarCor
                                            : corMedida,
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
                SizedBox(height: size.height * 0.06),
                Botao().botaoAnimacaoLoading(
                  context,
                  onTap: () {
                    verificarCampos();
                  },
                  altura: Get.height * 0.07,
                  colorButton: Colors.blue[400],
                  corFonte: Colors.white,
                  txtbutton: 'SALVAR',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
