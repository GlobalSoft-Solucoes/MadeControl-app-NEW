import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MsgPopup {
  // Nesta Popup, é disparada uma mensagem informativa para o usuário ficar consciente
  // de algo que aconteceu. É um popup que tem apenas um botão botão "OK"
  msgFeedback(BuildContext context, mensagem, titulo,
      {Function? onPressed,
      Color?corMsg,
      double?sizeTitulo,
      double?fontMsg,
      txtButton}) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => new CupertinoAlertDialog(
        title: new Text(
          titulo,
          style: TextStyle(
            fontSize: sizeTitulo ?? 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        content: new Text(
          mensagem,
          style: TextStyle(
            fontSize: fontMsg ?? 18,
            color: corMsg ?? Colors.black,
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          FloatingActionButton(
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            focusColor: Colors.red,
            child: Text(
              txtButton ?? 'OK',
              style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w600,
                  color: Colors.black),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }

// NESTE POPUP, É DISPARADO UMA MENSAGEM QUE QUANDO CONFIRMADA, FAZ UM DIRECIONAMENTO PARA OUTRA ROTA OU CHAMADA DE FUNÇÃO
// para fazer o redirecionamento, é preciso passar como parametro o "onPressed()" que será responsável por conter todas as
// rotas e funções necessárias
  msgDirecionamento(
    BuildContext context,
    mensagem,
    titulo,
    onPressed(), {
    Color?corMsg,
    txtButton,
    double?fonteMsg,
    fontWeightMsg,
    double?fonteButton,
    fontWeightButton,
  }) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => new CupertinoAlertDialog(
        title: new Text(titulo),
        content: new Text(
          mensagem,
          style: TextStyle(
            fontSize: fonteMsg ?? 19,
            color: corMsg ??
                Colors
                    .black, // Caso nenhuma cor for passada como parametro, pega a cor default para a mensagem
            fontWeight: fontWeightMsg ?? FontWeight.w800,
          ),
        ),
        actions: <Widget>[
          FloatingActionButton(
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            child: Text(
              txtButton ?? "Ok",
              style: new TextStyle(
                fontSize: fonteButton ?? 18,
                fontWeight: fontWeightButton ?? FontWeight.w600,
              ),
            ),
            onPressed: () {
              onPressed();
            },
          )
        ],
      ),
    );
  }

  // ====== MENSAGEM COM TEXTO PARA DIGITAÇÃO E DOIS BOTÕES PARA O USUÁRIO TER OPÇÕES DE RESPOSTA =======
  msgComDoisBotoes(BuildContext context, mensagem, textoBotaoEsq, textoBotaoDir,
      onTap(), onPressed(),
      {double?fontMsg,
      Color?corMsg,
      Color?corBotaoEsq,
      Color?corBotaoDir,
      bool? sairAoPressionar}) {
    return showDialog(
      barrierDismissible: sairAoPressionar ?? false,
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          title: Text(
            mensagem,
            textAlign: TextAlign.center,
            style: new TextStyle(
              fontSize: fontMsg ?? 22,
              fontWeight: FontWeight.w600,
              color: corMsg ?? Colors.black,
            ),
          ),
          elevation: 12,
          actions: <Widget>[
            // ===================== BOTÕES ==========================
            new Container(
              padding: EdgeInsets.only(top: 20),
              width: MediaQuery.of(context).size.width,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 70),
                  ),
                  // ============= PRIMEIRO BOTÃO ==============
                  Container(
                    child: new FloatingActionButton.extended(
                      backgroundColor: corBotaoEsq ?? Color(0XFFF4485C),
                      label: new Text(
                        textoBotaoEsq,
                        style: TextStyle(fontSize: 19),
                      ),
                      onPressed: () {
                        onTap();
                      },
                    ),
                    width: MediaQuery.of(context).size.width * 0.33,
                  ),
                  SizedBox(width: 10),
                  // ============= SEGUNDO BOTÃO ==============
                  Container(
                    child: new FloatingActionButton.extended(
                      backgroundColor: corBotaoDir ?? Color(0XFF0099FF),
                      label: Text(
                        textoBotaoDir,
                        style: new TextStyle(fontSize: 19),
                      ),
                      onPressed: () {
                        onPressed();
                      },
                    ),
                    width: MediaQuery.of(context).size.width * 0.33,
                  ),
                  //-----------------------------------------
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  // ====== MENSAGEM COM DOIS BOTÕES PARA O USUÁRIO TER OPÇÕES DE RESPOSTA =======
  campoTextoComDoisBotoes(
    BuildContext context,
    mensagem,
    textoLabel,
    textoBotaoEsq,
    textoBotaoDir,
    onTap(),
    onPressed(), {
    double?bordaPopup,
    controller,
    double?fontText,
    iconeText,
    double?fontMsg,
    Color?corMsg,
    Color?corBotaoEsq,
    Color?corBotaoDir,
  }) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(bordaPopup ?? 20)),
          ),
          title: Text(
            mensagem,
            textAlign: TextAlign.center,
            style: new TextStyle(
              fontSize: fontMsg ?? 22,
              fontWeight: FontWeight.w600,
            ),
          ),
          elevation: 12,
          actions: <Widget>[
            // ================ CAMPO TEXTO PARA DIGITAÇÃO ==================
            new Container(
              alignment: Alignment(0, 0),
              width: MediaQuery.of(context).size.width,
              child: TextField(
                controller: controller,
                style: new TextStyle(
                  fontSize: fontText ?? 18,
                ),
                decoration: new InputDecoration(
                  prefixIcon: new Icon(iconeText ?? Icons.code),
                  labelText: textoLabel,
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(
                      10,
                    ),
                  ),
                ),
              ),
            ),
            // ==================== BOTÕES ======================
            new Container(
              padding: EdgeInsets.only(top: 20),
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 70),
                  ),
                  // ============= PRIMEIRO BOTÃO ==============
                  Container(
                    child: new FloatingActionButton.extended(
                      backgroundColor: corBotaoEsq ?? Color(0XFFF4485C),
                      label: new Text(
                        textoBotaoEsq,
                        style: TextStyle(fontSize: 19),
                      ),
                      onPressed: () {
                        onTap();
                      },
                    ),
                    padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.065,
                    ),
                    width: MediaQuery.of(context).size.width * 0.36,
                  ),
                  // ============= SEGUNDO BOTÃO ==============
                  Container(
                    child: new FloatingActionButton.extended(
                      backgroundColor: corBotaoDir ?? Color(0XFF0099FF),
                      label: Text(
                        textoBotaoDir,
                        style: new TextStyle(fontSize: 19),
                      ),
                      onPressed: () {
                        onPressed();
                      },
                    ),
                    padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.065,
                    ),
                    width: MediaQuery.of(context).size.width * 0.36,
                  ),
                  //-----------------------------------------
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
