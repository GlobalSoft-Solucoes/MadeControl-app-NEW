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

class opcProcessproduto {
  static int? numproduto;
  static String? produto;
}

class SelectProcessoProduto extends StatefulWidget {
  @override
  _SelectProcessoProdutoState createState() => _SelectProcessoProdutoState();
}

class _SelectProcessoProdutoState extends State<SelectProcessoProduto> {
  var iniciarContagem = false;

  var media;
  var duracao;
  int? idProcessoMadeira;
  bool? enabled = false;
  var counter = 0;
  int? tipoTora;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    Size size = mediaQuery.size;
    return SafeArea(
      child: Scaffold(
        // backgroundColor: Colors.white,//(0XFF515667),
        body: Container(
          color: Colors.grey[100]!.withAlpha(300),
          child: Column(
            children: [
              Container(
                alignment: Alignment.bottomLeft,
                padding: EdgeInsets.only(top: size.height * 0.03, left: 10),
                child: Container(
                  color: Colors.black26,
                  width: size.width * 0.13,
                  height: size.height * 0.06,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                    iconSize: 35,
                    color: Colors.black87,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 15, right: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    // ===============================================
                    GestureDetector(
                      onTap: () {
                        opcProcessproduto.numproduto = 1;
                        opcProcessproduto.produto = 'DORMENTE';
                        Navigator.pushNamed(context, '/CadProcessoProduto');
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[400]!.withAlpha(450),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        width: size.width * 0.1,
                        height: size.width * 0.3,
                        margin: EdgeInsets.only(top: size.height * 0.08),
                        child: Container(
                          alignment: Alignment.center,
                          child: const Text(
                            'DORMENTE',
                            style: TextStyle(
                              fontSize: 30,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.03),
                    // ==================================================
                    GestureDetector(
                      onTap: () {
                        opcProcessproduto.numproduto = 2;
                        opcProcessproduto.produto = 'PRANCHA';
                        Navigator.pushNamed(context, '/CadProcessoProduto');
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[400]!.withAlpha(450),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        height: size.width * 0.3,
                        child: Container(
                          alignment: Alignment.center,
                          child: const Text(
                            'PRANCHA',
                            style: TextStyle(
                              fontSize: 30,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // =========================================================
                    SizedBox(height: size.height * 0.03),
                    GestureDetector(
                      onTap: () {
                        opcProcessproduto.numproduto = 3;
                        opcProcessproduto.produto = 'TABUA';
                        Navigator.pushNamed(context, '/CadProcessoProduto');
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[400]!.withAlpha(450),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        height: size.width * 0.3,
                        child: Container(
                          alignment: Alignment.center,
                          child: const Text(
                            'TABUA',
                            style: TextStyle(
                              fontSize: 30,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // =========================================================
                    SizedBox(height: size.height * 0.03),
                    GestureDetector(
                      onTap: () {
                        opcProcessproduto.numproduto = 4;
                        opcProcessproduto.produto = 'PALETE';
                        Navigator.pushNamed(context, '/CadProcessoProduto');
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[400]!.withAlpha(450),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        height: size.width * 0.3,
                        child: Container(
                          alignment: Alignment.center,
                          child: const Text(
                            'PALETE',
                            style:
                                TextStyle(fontSize: 30, color: Colors.black87),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
