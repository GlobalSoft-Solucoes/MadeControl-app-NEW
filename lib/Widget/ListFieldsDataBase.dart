import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FieldsDatabase {
  listaDadosBanco(
    textoCampo,
    campoBanco, {
    double?sizeTextoCampo,
    double?sizeCampoBanco,
    Color?corTextoCampo,
    Color?corCampoBanco,
  }) {
    return RichText(
      text: TextSpan(
        text: textoCampo,
        style: TextStyle(
          fontSize: sizeTextoCampo ?? 19,
          fontWeight: FontWeight.w600,
          color: corTextoCampo ?? Colors.grey[900],
        ),
        children: <TextSpan>[
          TextSpan(
            text: campoBanco.toString(),
            style: TextStyle(
              fontSize: sizeCampoBanco ?? 19,
              color: corCampoBanco ?? Colors.blue[800],
            ),
          ),
        ],
      ),
    );
  }
}
