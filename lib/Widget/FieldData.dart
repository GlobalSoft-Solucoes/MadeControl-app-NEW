//
import 'package:flutter/material.dart';
import 'package:madecontrol_desenvolvimento/Widget/MsgPopup.dart';
import 'package:madecontrol_desenvolvimento/Widget/TextField.dart';

class FiltroDatasPesquisa {
  static String? dataInicial = '1999-01-01';
  static String? dataFinal = '2100-01-01';
}

class FieldData {
  BuildContext? context;

  deletarReg() {
    MsgPopup()
        .msgFeedback(context!, '\nConfira a data informada', 'Data inválida');
  }

  // ======== Validação da data informada no campo de pesquisa ==========
  validarDataSelecionada(controllerDataInicial, controllerDataFinal) async {
    var dia;
    var mes;
    var ano;
    var data;

    // =========== VALIDAÇÕES DO CAMPO DATA INICIAL ============
    if ((controllerDataInicial.text.trim().isEmpty ||
            controllerDataInicial.text == null) ||
        (controllerDataFinal.text.trim().isEmpty ||
            controllerDataFinal.text == null)) {
      FiltroDatasPesquisa.dataInicial = '1990-01-01';
      FiltroDatasPesquisa.dataFinal = '2100-01-01';
    } else {
      dia = controllerDataInicial.text.substring(0, 2);
      mes = controllerDataInicial.text.substring(3, 5);
      ano = controllerDataInicial.text.substring(6, 10);
      data = ano + '-' + mes + '-' + dia;

      if (controllerDataInicial.text.trim().isEmpty) {
        MsgPopup().msgFeedback(
            context!, '\nA data não pode ficar vazia', 'Data inválida');
      } else if (controllerDataInicial.text.length < 10) {
        MsgPopup().msgFeedback(
            context!, '\nConfira a data informada', 'Data inválida');
      } else if (dia.length < 2 || mes.length < 2 || ano.length < 4) {
        MsgPopup().msgFeedback(
            context!, '\nConfira a data informada', 'Data inválida');
      } else if (int.tryParse(dia)! > 31 || int.tryParse(mes)! > 12) {
        // || int.tryParse(ano) > anoAtual.year ){
        MsgPopup().msgFeedback(
            context!, '\nConfira a data informada', 'Data inválida');
      } else {
        FiltroDatasPesquisa.dataInicial = data;
      }

      // =========== VALIDAÇÕES DO CAMPO DATA FINAL ============

      dia = controllerDataFinal.text.substring(0, 2);
      mes = controllerDataFinal.text.substring(3, 5);
      ano = controllerDataFinal.text.substring(6, 10);
      data = ano + '-' + mes + '-' + dia;

      if (controllerDataFinal.text.trim().isEmpty) {
        MsgPopup().msgFeedback(
            context!, '\nA data não pode ficar vazia', 'Data inválida');
      } else if (controllerDataFinal.text.length < 10) {
        MsgPopup().msgFeedback(
            context!, '\nConfira a data informada', 'Data inválida');
      } else if (dia.length < 2 || mes.length < 2 || ano.length < 4) {
        MsgPopup().msgFeedback(
            context!, '\nConfira a data informada', 'Data inválida');
      } else if (int.tryParse(dia)! > 31 || int.tryParse(mes)! > 12) {
      } else {
        FiltroDatasPesquisa.dataFinal = data;
      }
    }
  }

  popupPesquisaDatas(
    BuildContext context,
    controllerDataInicio,
    controllerDataFim, {
    mensagemTitulo,
    double?bordaPopup,
    double?fontText,
    mascara,
    iconeText,
    double?fontMsg,
    Color?corMsg,
    Color?corBotaoEsq,
    Color?corBotaoDir,
    txtButton,
    textoCampo,
    fonteButton,
    fontWeightButton,
    onTapInicial,
    onTapFinal,
  }) {
    return showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(bordaPopup ?? 10)),
          ),
          title: Text(
            'Pesquisa por data:',
            textAlign: TextAlign.center,
            style: new TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),
          // ======= email =========
          actions: <Widget>[
            Container(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.005),
              child: Row(
                children: [
                  Container(
                    alignment: Alignment.topLeft,
                    width: MediaQuery.of(context).size.width * 0.39,
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.01,
                    ),
                    child: CampoText().textFieldIconButton(
                      controllerDataInicio,
                      'Inicial:',
                      tipoTexto: TextInputType.number,
                      fontSize: 18,
                      fontLabel: 18,
                      icone: Icons.calendar_today_outlined,
                      confPadding:
                          EdgeInsets.only(top: 5, left: 0, right: 5, bottom: 5),
                      onTapIcon: () {
                        onTapInicial();
                      },
                    ),
                  ),
                  Container(
                    //  alignment: Alignment.topRight,
                    width: MediaQuery.of(context).size.width * 0.39,
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.01,
                    ),
                    child: CampoText().textFieldIconButton(
                        controllerDataFim, 'Final:',
                        tipoTexto: TextInputType.number,
                        fontSize: 18,
                        fontLabel: 18,
                        icone: Icons.calendar_today_outlined,
                        confPadding: EdgeInsets.only(
                            top: 5,
                            left: 5,
                            right: 0,
                            bottom: 5), onTapIcon: () {
                      onTapFinal();
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
              child: new FloatingActionButton.extended(
                backgroundColor: Colors.green,
                label: Text(
                  'Pesquisar',
                  style: new TextStyle(fontSize: 23),
                ),
                onPressed: () async {
                  validarDataSelecionada(
                      controllerDataInicio, controllerDataFim);
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
