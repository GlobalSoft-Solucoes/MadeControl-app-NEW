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

  //Corrige e atualiza os valores finais
  Future<dynamic> atualizarValores() async {
    var horaFinal = TimeOfDay.now();
    var horas = horaFinal.hour;
    var minuto = horaFinal.minute;
    var horaCorrigida = horas - 0;
    var horafinalCerta = horaCorrigida.toString() + ':' + minuto.toString();

    duracaototal.stop();
    var transform = duracaototal.elapsedMilliseconds / 1000;
    var minutos = transform;

    minutos.toStringAsFixed(4);
    print(minutos);
    print(counter);
    media = minutos / counter;

    var bodyy = jsonEncode(
      {
        'hora_fim': horafinalCerta,
        'data_processo': DataAtual().pegardataBR() as String,
        'media': media.toStringAsFixed(2),
        'qtd_total': counter,
        'duracao_processo': duracaototal.elapsed.toString(),
        'status_processo': 'Cadastrado'
      },
    );

    print(bodyy);

    await http.put(
      Uri.parse(EditarProcessoMadeira +
          idProcessoMadeira.toString() +
          '/' +
          ModelsUsuarios.caminhoBaseUser.toString()),
      headers: {
        "Content-Type": "application/json",
        "authorization": ModelsUsuarios.tokenAuth.toString()
      },
      body: bodyy,
    );
  }

//Salva o valor inicial e busca o ID
  Future salvarDadosBancoTotal() async {
    var horainicial = TimeOfDay.now();
    var minuto = horainicial.minute;
    var horaCorrigida = DateTime.now().hour - 0;
    var horainicialCerta = horaCorrigida.toString() + ':' + minuto.toString();

    var bodyy = jsonEncode(
      {
        'idusuario': ModelsUsuarios.idDoUsuario,
        'hora_inicio': horainicialCerta,
        'data_processo': DataAtual().pegardataBR() as String,
        'media': "0",
        'qtd_total': "0",
        'duracao_processo': "00:00",
        'tipo_tora': tipoTora
      },
    );

    var response = await http.post(
      Uri.parse(
          CadastrarProcessoMadeira + ModelsUsuarios.caminhoBaseUser.toString()),
      headers: {
        "Content-Type": "application/json",
        "authorization": ModelsUsuarios.tokenAuth.toString()
      },
      body: bodyy,
    );
    print(bodyy);
    if (response.statusCode == 201) {
      var state = await http.get(
        Uri.parse(
          BuscarUltimoProcessoMadeiraCadastrado +
              ModelsUsuarios.caminhoBaseUser.toString(),
        ),
        headers: {
          "Content-Type": "application/json",
          "authorization": ModelsUsuarios.tokenAuth.toString()
        },
      );
      print(response.body);
      String? retorno = state.body;
      if (retorno != "[]") {
        // Repara para mostra apenas o valor da chave primária
        String? valorRetorno = retorno
            .substring(retorno.indexOf(':'), retorno.indexOf('}'))
            .replaceAll(':', '');

        // caso haja valor na variável, quer dizer que contém um registro
        if (valorRetorno.length > 0) {
          setState(() {
            idProcessoMadeira = int.parse(valorRetorno);
          });
        } else if (response.statusCode == 401) {
          Navigator.pushNamed(context, '/login');
        }
      }
      return;
    } else if (response.statusCode == 400) {
      MsgPopup().msgDirecionamento(
          context,
          '\nOcorreu um erro, verifique sua internet, caso tiver problemas contante nossa empresa.',
          'Erro',
          () => Navigator.pushNamed(context, '/Home'));
    }
  }

//Salva o tempo de cada Madeira
  salvarDadosporMadeira() async {
    var bodyy = jsonEncode(
      {
        'tempo_processo': duracao.toString(),
        'idprocesso_madeira': idProcessoMadeira,
      },
    );
    if (duracao.toString() != '0:00:00.000000') {
      print(duracao.toString());
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
  void timer() {
    if (enabled == true) {
      MsgPopup().msgFeedback(
          context, 'Aguarde até a tela ficar verde novamente.', '');
    } else {
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
    }
  }

  Stopwatch duracaototal = Stopwatch();
  void cronometro() {
    duracaototal.start();
  }

  void _finalizarProcesso() {
    return MsgPopup().msgComDoisBotoes(
        context,
        'Deseja Finalizar este lote?',
        'Não',
        'Sim',
        () => Navigator.pop(context),
        () => {atualizarValores(), Navigator.pushNamed(context, '/Home')});
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
            // ================== TORA FINA =================
            SizedBox(
              height: Get.width * 0.04,
            ),
            Container(
              alignment: Alignment.center,
              child: FloatingActionButton.extended(
                backgroundColor: Colors.green,
                label: Text(
                  '  Tora Fina  ',
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
              height: Get.width * 0.04,
            ),
            Container(
              alignment: Alignment.center,
              child: FloatingActionButton.extended(
                backgroundColor: Colors.green,
                label: Text(
                  ' Tora Média ',
                  style: TextStyle(fontSize: 23),
                ),
                onPressed: () async {
                  tipoTora = 2;
                  Navigator.pop(context);
                },
              ),
            ),
            // ================== TORA GROSSA =================
            SizedBox(
              height: Get.width * 0.04,
            ),
            Container(
              alignment: Alignment.center,
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
              height: Get.width * 0.04,
            ),
            Container(
              alignment: Alignment.center,
              child: FloatingActionButton.extended(
                backgroundColor: Colors.green,
                label: Text(
                  ' Tora do Pé ',
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
                            await popupEscolhaTora();
                            salvarDadosBancoTotal();
                            cronometro();
                            timer();
                            iniciarContagem = true;
                            print(idProcessoMadeira);
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
