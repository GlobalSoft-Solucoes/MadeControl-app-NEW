import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";

class Cabecalho {
  tituloCabecalho(
    BuildContext context,
    textTitulo, {
    bool? iconeVoltar,
    double?sizeTextTitulo,
    double?sizeIcone,
    corTextoTitulo,
    corIcone,
    double?marginLeft,
    double?marginTop,
    double?marginBottom,
    double?tituloMarginLeft,
  }) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    Size size = mediaQuery.size;
    return Padding(
      padding: EdgeInsets.only(
        top: marginTop != null
            ? size.width * marginTop
            : size.height * 0, //size.height * 0.032,
        bottom: marginBottom != null
            ? size.width * marginBottom
            : size.height * 0.018,
        left: marginLeft != null ? size.width * marginLeft : size.width * 0.0,
      ),
      child: Stack(
        children: [
          if (iconeVoltar == true)
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
              iconSize: sizeIcone ?? 33,
              color: corIcone ?? Colors.white,
            ),
          Padding(
            padding: EdgeInsets.only(
              top: size.height * 0.008,
              left: tituloMarginLeft != null
                  ? size.width * tituloMarginLeft
                  : size.width * 0.0,
            ),
            child: Center(
              child: Text(
                textTitulo ?? 'Titulo da página',
                style: TextStyle(
                    fontSize: sizeTextTitulo != null
                        ? size.width * sizeTextTitulo.toDouble()
                        : size.width * 0.06,
                    color: corTextoTitulo ?? Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  fecharTela(
    BuildContext context,
  ) {
    Navigator.pop(context);
  }
}
