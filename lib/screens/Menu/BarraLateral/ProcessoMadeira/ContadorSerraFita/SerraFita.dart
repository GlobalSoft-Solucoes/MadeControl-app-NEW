import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:madecontrol_desenvolvimento/Widget/MsgPopup.dart';
import 'package:madecontrol_desenvolvimento/funcoes/FuncoesParaDatas.dart';
import 'package:madecontrol_desenvolvimento/models/Models_Usuario.dart';
import 'package:madecontrol_desenvolvimento/models/constantes.dart';

class SerraFita extends StatefulWidget {
  @override
  _SerraFitaState createState() => _SerraFitaState();
}

class _SerraFitaState extends State<SerraFita> {
  var iniciarContagem = false;

  var media;
  var duracao;
  int? idProcessoMadeira;
  bool? enabled = false;
  var counter = 0;
  int? tipoTora;

//Salva o tempo de cada Madeira
  salvarDadosporMadeira() async {
    var bodyy = jsonEncode(
      {
        'idusuario': ModelsUsuarios.idDoUsuario,
        // 'tempo_processo': duracao.toString(),
        // 'idprocesso_madeira': idProcessoMadeira,
        'data': DataAtual().pegardataBR() as String,
        'tipo_tora': tipoTora
      },
    );
    if (duracao.toString() != '0:00:00.000000') {
      print('duração: '+duracao.toString());
     
      var response = await http.post(
        Uri.parse(
            CadastrarMadProcessada + ModelsUsuarios.caminhoBaseUser.toString()),
        headers: {
          "Content-Type": "application/json",
          "authorization": ModelsUsuarios.tokenAuth.toString()
        },
        body: bodyy,
      );
      print(response.statusCode);
      print(bodyy);
      if (response.statusCode == 400) {
        MsgPopup().msgDirecionamento(
            context,
            '\nOcorreu um erro, verifique sua internet ou entre em contato com nossa empresa.',
            'Erro',
            () => Navigator.pushNamed(context, '/Home'));
      }
    }
  }

  Color? cor = Colors.green[200];

  //zera o contador quando a tela inicia
  zerarcounter() {
    setState(() {
      counter = -1;
    });
  }

//muda a cor de volta para verde
  mudarcor() {
    setState(() {
      cor = Colors.green[200];
    });
  }

  Stopwatch stopwatch = new Stopwatch();
//starta o timer de 15 segundos, e deixa a tela vermelha. tambem a função que não permite que a tela seja pressionada até ficar verde
  void timer() async {
    if (enabled == true) {
      MsgPopup().msgFeedback(
          context, 'Aguarde até a tela ficar verde novamente.', '');
    } else {
      if (counter >= 0) {
        await popupEscolhaTora();
      }
      duracao = stopwatch.elapsed;
      salvarDadosporMadeira();
      stopwatch.reset();
      stopwatch.start();
      setState(() {
        counter++;
        cor = Colors.red;
        enabled = true;
      });

      Timer(
        Duration(seconds: 2),
        () {
          mudarcor();
          enabled = false;
        },
      );
      // popupEscolhaTora();
    }
  }

  void _finalizarProcesso() {
    return MsgPopup().msgComDoisBotoes(
      context,
      'Deseja Finalizar este lote?',
      'Não',
      'Sim',
      () => Navigator.pop(context),
      () => {
        Navigator.pushNamed(context, '/Home'),
      },
    );
  }

  popupEscolhaTora() {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          title: Text(
            'Escolha o tipo da tora:',
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
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ================== TORA FINA =================
                Container(
                  alignment: Alignment.center,
                  child: FloatingActionButton.extended(
                    backgroundColor: Colors.green,
                    label: Text(
                      ' Tora Fina ',
                      style: TextStyle(fontSize: 23),
                    ),
                    onPressed: () async {
                      tipoTora = 1;
                      Navigator.pop(context);
                    },
                  ),
                ),
                // ================== TORA MEDIA =================
                SizedBox(
                  width: Get.width * 0.04,
                ),
                Container(
                  alignment: Alignment.center,
                  child: FloatingActionButton.extended(
                    backgroundColor: Colors.green,
                    label: Text(
                      'Tora Média',
                      style: TextStyle(fontSize: 23),
                    ),
                    onPressed: () async {
                      tipoTora = 2;
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
            SizedBox(
              height: Get.width * 0.17,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ================== TORA GROSSA =================
                Container(
                  child: FloatingActionButton.extended(
                    backgroundColor: Colors.green,
                    label: Text(
                      'Tora Grossa',
                      style: TextStyle(fontSize: 23),
                    ),
                    onPressed: () async {
                      tipoTora = 3;
                      Navigator.pop(context);
                    },
                  ),
                ),
                // ================== TORA DO PÉ =================
                SizedBox(
                  width: Get.width * 0.03,
                ),
                Container(
                  child: FloatingActionButton.extended(
                    backgroundColor: Colors.green,
                    label: Text(
                      'Tora do Pé',
                      style: TextStyle(fontSize: 23),
                    ),
                    onPressed: () async {
                      tipoTora = 4;
                      Navigator.pop(context);
                    },
                  ),
                ),
                SizedBox(
                  height: Get.height * 0.05,
                ),
              ],
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
  void initState() {
    super.initState();
    this.zerarcounter();
    //  this.cronometro();
    // this.salvarDadosBancoTotal();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    Size size = mediaQuery.size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        actions: [
          Padding(
            padding: EdgeInsets.only(
                right: size.width * 0.05, top: size.width * 0.015),
            child: GestureDetector(
                child: Text(
                  'Finalizar',
                  style: TextStyle(fontSize: 40),
                ),
                onTap: () async {
                  _finalizarProcesso();
                }),
          )
        ],
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back),
          iconSize: 35,
        ),
      ),
      body: iniciarContagem == false
          ? SafeArea(
              child: SingleChildScrollView(
                child: Container(
                  color: Colors.green[200],
                  height: MediaQuery.of(context).size.height - 40,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Center(
                        child: GestureDetector(
                          onTap: () async {
                            // await popupEscolhaTora();
                            enabled = false;
                            timer();
                            iniciarContagem = true;
                          },
                          child: Container(
                            height: 230,
                            width: 230,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(120),
                                color: Colors.green[700]),
                            child: Text(
                              "INICIAR",
                              style: TextStyle(
                                fontSize: 27,
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : GestureDetector(
              onTap: () {
                timer();
              },
              child: Container(
                color: cor,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Text(
                        counter.toString(),
                        style: TextStyle(fontSize: 150),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
