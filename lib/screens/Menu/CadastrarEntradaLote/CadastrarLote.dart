import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:madecontrol_desenvolvimento/Widget/Botao.dart';
import 'package:madecontrol_desenvolvimento/Widget/Cabecalho.dart';
import 'package:madecontrol_desenvolvimento/Widget/MsgPopup.dart';
import 'package:madecontrol_desenvolvimento/Widget/TextField.dart';
import 'package:madecontrol_desenvolvimento/funcoes/FuncoesParaDatas.dart';
import 'package:madecontrol_desenvolvimento/models/ClassesStaticas.dart';
import 'package:madecontrol_desenvolvimento/models/Models_Usuario.dart';
import 'package:madecontrol_desenvolvimento/models/constantes.dart';
import 'package:madecontrol_desenvolvimento/models/models-lotes.dart';
import 'CadastrarCalculo.dart';

class CadastrarLote extends StatefulWidget {
  @override
  _CadastrarLoteState createState() => _CadastrarLoteState();
}

class _CadastrarLoteState extends State<CadastrarLote> {
  TextEditingController controllerEmpresa = TextEditingController();
  TextEditingController controllerProprietarioEmpresa = TextEditingController();
  bool? iniciarMedicao = false;
  bool? salvarlote = false;
  bool? verificou = false;
  //Valida os campos
  verificarCampos() {
    if (controllerEmpresa.text.isNotEmpty) {
      if (controllerProprietarioEmpresa.text.isNotEmpty) {
        if (iniciarMedicao == true) {
          salvarReg();
        } else if (salvarlote == true) {
          salvarReg();
        }
      } else {
        MsgPopup().msgFeedback(context,
            '\nO campo responsável não foi preenchido!', 'Responsável');
      }
    } else {
      MsgPopup().msgFeedback(
          context, '\nO campo fornecedor não foi preenchido!', 'Fornecedor');
    }
  }

  int? idlote;
  var ultimoId = <ModelsLotes>[];
  double?totalLote = 0;
  double?media = 0;
  var quantidade = 0;

  Future<dynamic> salvarReg() async {
    var corpo = jsonEncode({
      'idusuario': ModelsUsuarios.idDoUsuario,
      'responsavel': controllerProprietarioEmpresa.text,
      'fornecedor': controllerEmpresa.text,
      'resultado': totalLote!.toStringAsFixed(4),
      'quantidade': quantidade,
      'media': media,
      'data_cadastro': DataAtual().pegardataBR() as String,
    });
    var response = await http.post(
      Uri.parse(CadastrarDadosLote + ModelsUsuarios.caminhoBaseUser.toString()),
      headers: {
        "Content-Type": "application/json",
        "authorization": ModelsUsuarios.tokenAuth.toString()
      },
      body: corpo,
    );

    if (response.statusCode == 201) {
      final response = await http.get(
        Uri.parse(
            BuscarUltimoLoteCadastrado + ModelsUsuarios.caminhoBaseUser.toString()),
        headers: {
          "Content-Type": "application/json",
          "authorization": ModelsUsuarios.tokenAuth.toString()
        },
      );
      String? retorno = response.body;
      if (retorno != "[]") {
        // Repara para mostra apenas o valor da chave primária
        String? valorRetorno = retorno
            .substring(retorno.indexOf(':'), retorno.indexOf('}'))
            .replaceAll(':', '');

        // caso haja valor na variável, quer dizer que contém um registro
        if (valorRetorno.length > 0) {
          idlote = int.parse(valorRetorno);
          LotesConfirm.quantidade = 0;
          LotesConfirm.resultado = 0;
        } else if (response.statusCode == 401) {
          Navigator.pushNamed(context, '/login');
        }
      }
      if (salvarlote == true) {
        Navigator.pushNamed(context, '/Home');
      } else if (iniciarMedicao == true) {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CadastrarMedidas(idLote: idlote)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    Size size = mediaQuery.size;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            width: size.width,
            height: size.height,
            color: Colors.green[300],
            child: Column(
              children: [
                Cabecalho().tituloCabecalho(
                  context,
                  'Cadastro de lote',
                  iconeVoltar: true,
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: size.width * 0.02,
                      right: size.width * 0.02,
                      top: size.height * 0.0),
                  child: Container(
                    width: size.width,
                    height: size.height * 0.67,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white),
                    child: Column(
                      children: [
                        CampoText().textField(
                          controllerEmpresa,
                          'Fornecedor:',
                          confPadding:
                              EdgeInsets.only(top: 15, left: 10, right: 10),
                          icone: Icons.business, //train
                        ),
                        CampoText().textField(
                          controllerProprietarioEmpresa,
                          'Responsável:',
                          confPadding:
                              EdgeInsets.only(top: 15, left: 10, right: 10),
                          icone: Icons.perm_contact_calendar,
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: size.height * 0.15),
                          child: Text(
                            'Globalsoft - Soluções',
                            style: TextStyle(fontSize: 30),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.03),
                Botao().botaoAnimacaoLoading(
                  context,
                  txtbutton: 'Salvar lote',
                  onTap: () {
                    salvarlote = true;
                    iniciarMedicao = false;
                    verificarCampos();
                  },
                  comprimento: size.width * 0.6,
                  tamanhoLetra: 27,
                ),
                SizedBox(height: size.height * 0.02),
                Botao().botaoAnimacaoLoading(
                  context,
                  txtbutton: 'Iniciar medição',
                  onTap: () {
                    salvarlote = false;
                    iniciarMedicao = true;
                    verificarCampos();
                  },
                  comprimento: size.width * 0.6,
                  tamanhoLetra: 27,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
