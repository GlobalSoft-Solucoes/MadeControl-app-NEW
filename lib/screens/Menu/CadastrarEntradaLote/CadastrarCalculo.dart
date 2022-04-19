import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:madecontrol_desenvolvimento/Widget/Botao.dart';
import 'package:madecontrol_desenvolvimento/Widget/Cabecalho.dart';
import 'package:madecontrol_desenvolvimento/Widget/MsgPopup.dart';
import 'package:madecontrol_desenvolvimento/Widget/TextField.dart';
import 'package:madecontrol_desenvolvimento/models/ClassesStaticas.dart';
import 'package:madecontrol_desenvolvimento/models/Models_Usuario.dart';
import 'package:madecontrol_desenvolvimento/models/constantes.dart';
import 'package:madecontrol_desenvolvimento/Widget/CheckBox.dart';

class CadastrarMedidas extends StatefulWidget {
  final int? idLote;
  CadastrarMedidas({Key? key, @required this.idLote}) : super(key: key);
  @override
  _CadastrarMedidasState createState() =>
      _CadastrarMedidasState(idLote: idLote);
}

class _CadastrarMedidasState extends State<CadastrarMedidas> {
  _CadastrarMedidasState({@required this.idLote});

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _controllerDiametroMenor = TextEditingController();
  TextEditingController _controllerComprimento = TextEditingController();
  TextEditingController _controllerResultado = TextEditingController();
  TextEditingController _controllerResultado2 = TextEditingController();
  TextEditingController _controllerResultado3 = TextEditingController();
  TextEditingController _controllerResultado4 = TextEditingController();
  int? quantidade = 0;
  double? totalLote = 0;
  double? media = 0;
  List<double> _result = <double>[];
  final int? idLote;
  double? total = 0;
  bool? opcSalvar;

  var dia;
  var mes;
  var ano;
  var dias;

  double? diametroMenor;
  double? comprimento;
  double? result;

  bool? resultTotal = true;
  bool? medidaUnitaria = false;
  int? tipoCalculo = 2;

  var totalquantidade;
  _calcularLote() {
    _result.forEach((element) => totalLote = totalLote! + element);
    total = LotesConfirm.resultado! + totalLote!;
    totalquantidade = quantidade! + LotesConfirm.quantidade!;
    media = total! / totalquantidade;
    pegardata();
    print(totalLote);
    _controllerResultado.text = total!.toStringAsFixed(4);
    _controllerResultado2.text = dias;
    _controllerResultado3.text = totalquantidade.toString();
    _controllerResultado4.text = media.toString();
  }

  // Metodo para realizar o calculo!
  void calcularCarga() {
    diametroMenor = double.tryParse(_controllerDiametroMenor.text);
    comprimento = double.tryParse(_controllerComprimento.text);
    setState(() {
      quantidade = quantidade! + 1;
    });
    setState(
      () {
        result = ((((3.1415 * diametroMenor!) / 2) / 4.95) *
                (((3.1415 * diametroMenor!) / 2) / 4.95)) *
            (comprimento! / 1000);

        _result.add(result!);

        popupShowDialog();
      },
    );
  }

  Future<dynamic> salvarCalcHTTP() async {
    print(idLote);
    var bodyy = jsonEncode(
      {
        'idlote': idLote,
        'diametromenor': diametroMenor,
        'comprimento': comprimento,
        'resultado': medidaUnitaria == true
            ? result!.toStringAsFixed(4)
            : double.tryParse(_controllerResultado.text),
        'tipo_calculo': tipoCalculo,
      },
    );

    var response = await http.post(
      Uri.parse(CadastrarDadosCalculo + ModelsUsuarios.caminhoBaseUser.toString()),
      headers: {
        "Content-Type": "application/json",
        "authorization": ModelsUsuarios.tokenAuth.toString()
      },
      body: bodyy,
    );
    print(bodyy);
    print(response.statusCode);
    if (response.statusCode == 201) {
      if (resultTotal == true) {
        Navigator.pop(context);
      }
    }
  }

  void msgFinalizar() {
    if (_result.length != 0) {
      _calcularLote();
      MsgPopup().msgDirecionamento(
          context,
          'calculo finalizado com sucesso! \n\n'
              "Total: ${totalLote!.toStringAsFixed(4)}",
          'Sucesso',
          () => Navigator.pushNamed(context, '/Home'));
    } else {
      MsgPopup().msgDirecionamento(
          context, 'Nenhum calculo encontrado', 'Erro', () {});
    }
  }

//------------------------- Alerta do resultado do calculo! -----------------------------------
  void popupShowDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text("Metro(s) cubico(s) de madeira:"),
          content: new Padding(
            padding: EdgeInsets.only(left: 30),
            child: new Text(
              'M² = ' + _result.last.toStringAsFixed(3),
              style: new TextStyle(color: Colors.green, fontSize: 24),
            ),
          ),
          actions: <Widget>[
            Container(
              alignment: Alignment.center,
              child: new Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new FloatingActionButton.extended(
                    backgroundColor: Colors.green,
                    label: Text(
                      '   Salvar   ',
                      style: new TextStyle(fontSize: 16),
                    ),
                    onPressed: () {
                      opcSalvar = true;
                      salvarCalcHTTP();
                      _controllerDiametroMenor.clear();

                      Navigator.of(context).pop();
                    },
                  ),
                  SizedBox(width: 10),
                  new FloatingActionButton.extended(
                    backgroundColor: Colors.red,
                    label: new Text(
                      'Cancelar',
                      style: TextStyle(fontSize: 16),
                    ),
                    onPressed: () async {
                      opcSalvar = false;
                      _result.removeLast();
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

// =================== CÓDIGO NECESSARIO PARA GERAR RESULTADOS NA PLANILHA ====================

  pegardata() {
    dia = DateTime.now().day;
    mes = DateTime.now().month;
    ano = DateTime.now().year;

    return dias = '$dia/$mes/$ano';
  }

  showSnackbar(String? message) {
    final snackBar = SnackBar(content: Text(message!));
    // ignore: deprecated_member_use
    _scaffoldKey.currentState!.showSnackBar(snackBar);
  }

  medidaPorUnidade() {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    Size size = mediaQuery.size;
    return Padding(
      padding: EdgeInsets.only(
          left: size.width * 0.02,
          right: size.width * 0.02,
          top: size.height * 0.04),
      child: Container(
        width: size.width,
        height: size.height * 0.28,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Colors.white),
        child: Column(
          children: [
            SizedBox(height: size.height * 0.05),
            CampoText().textField(
              _controllerComprimento,
              'Comprimento:',
            ),
            SizedBox(height: size.height * 0.01),
            CampoText().textField(
              _controllerDiametroMenor,
              'Diâmentro:',
            ),
          ],
        ),
      ),
    );
  }

  opcResultadoTotal() {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    Size size = mediaQuery.size;
    return Padding(
      padding: EdgeInsets.only(
          left: size.width * 0.02,
          right: size.width * 0.02,
          top: size.height * 0.07),
      child: Container(
        width: size.width,
        height: size.height * 0.18,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Colors.white),
        child: Column(
          children: [
            SizedBox(height: size.height * 0.05),
            CampoText().textField(
              _controllerResultado,
              'Metros cúbicos:',
            ),
            SizedBox(height: size.height * 0.01),
          ],
        ),
      ),
    );
  }

  //------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    Size size = mediaQuery.size;
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        body: SingleChildScrollView(
          child: Container(
            width: size.width,
            height: size.height,
            color: Colors.green[200],
            child: Column(
              children: [
                Cabecalho().tituloCabecalho(
                  context,
                  'Cadastro de medidas',
                  iconeVoltar: true,
                  sizeTextTitulo: 0.065,
                ),
                SizedBox(height: size.height * 0.015),
                CheckBox().checkBoxDuasOpcoes(
                  context,
                  'Tipo do cadastro:',
                  'Resultado total',
                  'Media por unidade',
                  resultTotal,
                  medidaUnitaria,
                  () => {
                    setState(
                      () {
                        resultTotal = true;
                        medidaUnitaria = false;
                        tipoCalculo = 2;
                      },
                    ),
                  },
                  () => {
                    setState(
                      () {
                        medidaUnitaria = true;
                        resultTotal = false;
                        tipoCalculo = 1;
                      },
                    ),
                  },
                  marginLeft: 0.02,
                  distanciaTituloDosChecks: 0.015,
                  backgroundColor: Colors.white.withOpacity(0.9),
                ),
                medidaUnitaria == true
                    ? medidaPorUnidade()
                    : opcResultadoTotal(),
                SizedBox(height: size.height * 0.03),
                Botao().botaoAnimacaoLoading(
                  context,
                  txtbutton: medidaUnitaria == true ? 'Calcular' : 'Salvar',
                  onTap: () {
                    medidaUnitaria == true ? calcularCarga() : salvarCalcHTTP();
                  },
                  comprimento: size.width * 0.6,
                  tamanhoLetra: 27,
                ),
                SizedBox(height: size.height * 0.02),
                medidaUnitaria == true
                    ? Botao().botaoAnimacaoLoading(
                        context,
                        txtbutton: 'Finalizar',
                        onTap: () {
                          Navigator.pop(context);
                          // _msgFinalizar();
                        },
                        comprimento: size.width * 0.6,
                        tamanhoLetra: 27,
                      )
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
