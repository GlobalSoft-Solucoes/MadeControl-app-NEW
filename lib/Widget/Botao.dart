// import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'ButtonEfect.dart';

//BOTAO PADRÃO PARA UTILIZAÇÃO GERAL
class Botao {
  botaoPadrao(label, ontap(),
      {Color? color,
      double? tamanhoLetra,
      fontWeight,
      double? altura,
      Color? corFonte,
      border,
      comprimento}) {
    return GestureDetector(
      onTap: () {
        ontap();
      },
      child: Center(
        child: Padding(
          padding: EdgeInsets.only(bottom: 20),
          child: Container(
            alignment: Alignment.center,
            height: altura ?? 45,
            width: comprimento ?? 320,
            decoration: BoxDecoration(
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    offset: Offset(3.0, 5.0),
                    blurRadius: 7)
              ],
              color: color ?? Colors.grey[200],
              borderRadius: border ?? BorderRadius.circular(10),
              border: Border.all(
                color: Colors.black12,
                width: 2,
              ),
            ),
            child: GestureDetector(
              onTap: () {
                ontap();
              },
              child: Text(
                label,
                style: TextStyle(
                    fontSize: tamanhoLetra ?? 28,
                    fontWeight: fontWeight ?? FontWeight.w500,
                    color: corFonte ?? Colors.black),
              ),
            ),
          ),
        ),
      ),
    );
  }

  botaoPadraoComAnimacaoLoading(label, ontap(), Color? color, bool? isloading,
      {double? tamanhoLetra,
      fontWeight,
      double? altura,
      Color? corFonte,
      border,
      largura}) {
    return GestureDetector(
      onTap: () {
        ontap();
      },
      child: Center(
        child: Padding(
          padding: EdgeInsets.only(bottom: 20),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 2000),
            alignment: Alignment.center,
            height: altura ?? 45,
            width: isloading! ? 60 : largura ?? 320,
            decoration: BoxDecoration(
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    offset: Offset(3.0, 5.0),
                    blurRadius: 7)
              ],
              color: color,
              borderRadius: isloading
                  ? BorderRadius.circular(50)
                  : border ?? BorderRadius.circular(20),
            ),
            child: GestureDetector(
              onTap: () {
                ontap();
              },
              child: AnimatedCrossFade(
                duration: Duration(milliseconds: 1000),
                firstChild: Text(
                  label,
                  style: TextStyle(
                      fontSize: tamanhoLetra ?? 28,
                      fontWeight: fontWeight ?? FontWeight.w500,
                      color: corFonte ?? Colors.black),
                ),
                secondChild: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                  ),
                ),
                crossFadeState: isloading
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
              ),
            ),
          ),
        ),
      ),
    );
  }

  botaoPadraoComAnimacaoOnPressed(
      label, ontap(), Color? color1, Color? color2, bool? isloading,
      {double? tamanhoLetra,
      fontWeight,
      double? altura,
      Color? corFonte,
      border,
      largura}) {
    return GestureDetector(
      onTap: () {
        ontap();
      },
      child: Center(
        child: Padding(
          padding: EdgeInsets.only(bottom: 20),
          child: AnimatedContainer(
            duration: Duration(microseconds: 2000),
            alignment: Alignment.center,
            height: altura ?? 45,
            width: largura ?? 320,
            decoration: BoxDecoration(
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    offset: Offset(3.0, 5.0),
                    blurRadius: 7)
              ],
              color: isloading! ? color2 : color1,
              borderRadius: border ?? BorderRadius.circular(20),
            ),
            child: GestureDetector(
              onTap: () {
                ontap();
              },
              child: Text(
                label,
                style: TextStyle(
                    fontSize: tamanhoLetra ?? 28,
                    fontWeight: fontWeight ?? FontWeight.w500,
                    color: corFonte ?? Colors.black),
              ),
            ),
          ),
        ),
      ),
    );
  }

  botaoAnimacaoLoadindText(BuildContext context,
      {textInicial,
      textonTap,
      Color? colorButton,
      double? timeLoading,
      Function? onTap,
      double? borderRadius,
      double? fontSizeButton}) {
    return ArgonTimerButton(
      height: MediaQuery.of(context).size.height * 0.055,
      width: MediaQuery.of(context).size.width * 0.35,
      minWidth: MediaQuery.of(context).size.width * 0.25,
      highlightColor: Colors.transparent,
      highlightElevation: 0,
      roundLoadingShape: false,
      onTap: (startTimer, btnState) {
        if (btnState == ButtonState.Idle) {
          onTap!();
          startTimer(timeLoading ?? 3);
        }
      },
      child: Text(
        textInicial ?? "Salvar",
        style: TextStyle(
            color: Colors.black54,
            fontSize: fontSizeButton ?? 24,
            fontWeight: FontWeight.w700),
      ),
      loader: (timeLeft) {
        return Text(
          textonTap ?? "Loading...",
          style: TextStyle(
              color: Colors.black54, fontSize: 18, fontWeight: FontWeight.w700),
        );
      },
      borderRadius: borderRadius ?? 5.0,
      color: colorButton ?? Colors.green,
      elevation: 5,
    );
  }

  botaoAnimacaoLoading(
    BuildContext context, {
    txtbutton,
    Color? colorButton,
    timeLoading,
    Function? onTap,
    double? borderRadius,
    double? tamanhoLetra,
    double? comprimento,
    double? minComprimento,
    double? altura,
    Color? corFonte,
    fontWeigh,
    animacao,
  }) {
    return ArgonTimerButton(
      height: altura ?? MediaQuery.of(context).size.height * 0.055,
      minWidth: minComprimento ?? MediaQuery.of(context).size.width * 0,
      width: comprimento ?? MediaQuery.of(context).size.width * 0.38,

      onTap: (startTimer, btnState) {
        if (btnState == ButtonState.Idle) {
          onTap!();
          startTimer(timeLoading ?? 3);
        }
      },
      child: Text(
        txtbutton ?? "Salvar",
        style: TextStyle(
            color: corFonte ?? Colors.black54,
            fontSize: tamanhoLetra ?? 25,
            fontWeight: fontWeigh ?? FontWeight.w600),
      ),
      loader: (timeLeft) {
        return Padding(
          padding: EdgeInsets.all(8),
          child: animacao ??
              SpinKitRotatingCircle(
                color: Colors.white,
                // size: loaderWidth ,
              ),
        );
      },
      // curve: 23,
      borderRadius: borderRadius ?? 5,
      color: colorButton ?? Colors.grey[200],
      elevation: 5,
      borderSide: BorderSide(color: Colors.grey, width: 1),
    );
  }
}
