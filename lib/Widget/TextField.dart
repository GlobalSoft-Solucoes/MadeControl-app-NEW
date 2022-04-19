import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CampoText {
  textField(
    nomeController,
    textoCampo, {
    double? largura,
    var mascara,
    double? altura,
    confPadding,
    tipoTexto,
    bool? campoSenha,
    icone,
    double? sizeIcon,
    double? raioBorda,
    bool? enabled,
    double? fontSize,
    FontWeight? fontWeigth,
    onChanged()?,
    Function? onTap,
    Color? corTexto,
    Color? backgroundColor,
    double? fontLabel,
    maxLines,
    minLines,
    maxLength,
  }) {
    return Center(
      child: Container(
        width: largura,
        height: altura,
        padding: confPadding ??
            EdgeInsets.only(top: 5, left: 10, right: 10, bottom: 5),
        child: Center(
          child: TextFormField(
            onTap: () {
              if (onTap != null) onTap();
            },
            onChanged: (context) {
              if (onChanged != null) onChanged();
            },
            minLines: minLines ?? 1,
            maxLines: maxLines ?? 1,
            maxLength: maxLength ?? maxLength,
            autofocus: false,
            enabled: enabled ?? true,
            keyboardType: tipoTexto ?? TextInputType.text,
            controller: nomeController,
            obscureText: campoSenha ?? false,
            style: new TextStyle(
              fontSize: fontSize ?? 20,
              color: corTexto ?? Colors.black,
              fontWeight: fontWeigth ?? FontWeight.w700,
            ),
            decoration: new InputDecoration(
              fillColor: backgroundColor,
              filled: backgroundColor == null ? false : true,
              prefixIcon: new Icon(
                icone,
                size: sizeIcon ?? 25,
              ),
              labelText: textoCampo,
              labelStyle: TextStyle(
                fontSize: fontLabel ?? 20,
              ),
              border: new OutlineInputBorder(
                borderRadius: new BorderRadius.circular(
                  raioBorda ?? 10,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  textFieldComMascara(
    nomeController,
    textoCampo, {
    double? largura,
    var mascara,
    double? altura,
    confPadding,
    tipoTexto,
    bool? campoSenha,
    icone,
    double? raioBorda,
    bool? enabled,
    double? fontSize,
    FontWeight? fontWeigth,
    onChanged()?,
    double? fontLabel,
  }) {
    return Center(
      child: Container(
        width: largura,
        height: altura,
        padding: confPadding ??
            EdgeInsets.only(top: 5, left: 10, right: 10, bottom: 5),
        child: TextFormField(
          onChanged: (context) {
            if (onChanged != null) onChanged();
          },
          autofocus: false,
          inputFormatters: [mascara],
          enabled: enabled ?? true,
          keyboardType: tipoTexto ?? TextInputType.text,
          controller: nomeController,
          obscureText: campoSenha ?? false,
          style: new TextStyle(
            fontSize: fontSize ?? 20,
            color: Colors.black,
            fontWeight: fontWeigth ?? FontWeight.w700,
          ),
          decoration: new InputDecoration(
            prefixIcon: new Icon(icone),
            labelText: textoCampo,
            labelStyle: TextStyle(
              fontSize: fontLabel ?? 22,
            ),
            border: new OutlineInputBorder(
              borderRadius: new BorderRadius.circular(
                raioBorda ?? 10,
              ),
            ),
          ),
        ),
      ),
    );
  }
  //=======================================================

  textFieldIconButton(
    nomeController,
    textoCampo, {
    double? largura,
    var mascara,
    double? altura,
    confPadding,
    tipoTexto,
    bool? campoSenha,
    icone,
    double? sizeIcon,
    double? raioBorda,
    bool? enabled,
    double? fontSize,
    FontWeight? fontWeigth,
    onChanged,
    Function? onTap,
    onTapIcon()?,
    Color? corTexto,
    Color? backgroundColor,
    double? fontLabel,
    maxLines,
    minLines,
    maxLength,
  }) {
    return Center(
      child: Container(
        width: largura,
        height: altura,
        padding: confPadding ??
            EdgeInsets.only(top: 5, left: 10, right: 10, bottom: 5),
        child: Center(
          child: TextFormField(
            onTap: () {
              if (onTap != null) onTap();
            },
            onChanged: (context) {
              if (onChanged != null) onChanged();
            },
            minLines: minLines ?? 1,
            maxLines: maxLines ?? 1,
            maxLength: maxLength ?? maxLength,
            autofocus: false,
            enabled: enabled ?? true,
            keyboardType: tipoTexto ?? TextInputType.text,
            controller: nomeController,
            obscureText: campoSenha ?? false,
            style: new TextStyle(
              fontSize: fontSize ?? 20,
              color: corTexto ?? Colors.black,
              fontWeight: fontWeigth ?? FontWeight.w700,
            ),
            decoration: InputDecoration(
              prefixIcon: IconButton(
                onPressed: () {
                  onTapIcon!();
                },
                icon: Icon(
                  Icons.calendar_today_outlined,
                ),
              ),
              labelText: textoCampo,
              labelStyle: TextStyle(
                fontSize: fontLabel ?? 20,
              ),
              border: new OutlineInputBorder(
                borderRadius: new BorderRadius.circular(
                  raioBorda ?? 10,
                ),
              ),
            ),
            // decoration: new InputDecoration(
            //   fillColor: backgroundColor,
            //   filled: backgroundColor == null ?  false : true,
            //   prefixIcon: new Icon(
            //     icone,
            //     size: sizeIcon ?? 25,
            //   ),
            //   labelText: textoCampo,
            //   labelStyle: TextStyle(
            //     fontSize: fontLabel ?? 20,
            //   ),
            //   border: new OutlineInputBorder(
            //     borderRadius: new BorderRadius.circular(
            //       raioBorda ?? 10,
            //     ),
            //   ),
            // ),
          ),
        ),
      ),
    );
  }
}
