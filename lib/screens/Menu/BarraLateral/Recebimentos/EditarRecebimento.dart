import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:madecontrol_desenvolvimento/Statics/Static_Recebimento.dart';
import 'package:madecontrol_desenvolvimento/Widget/Botao.dart';
import 'package:madecontrol_desenvolvimento/Widget/Cabecalho.dart';
import 'package:madecontrol_desenvolvimento/Widget/MsgPopup.dart';
import 'package:madecontrol_desenvolvimento/Widget/TextField.dart';
import 'package:madecontrol_desenvolvimento/models/Models_Usuario.dart';
import 'package:madecontrol_desenvolvimento/models/constantes.dart';
import 'package:http/http.dart' as http;

class EditarDadosRecebimento extends StatefulWidget {
  @override
  _EditarDadosRecebimentoState createState() => _EditarDadosRecebimentoState();
}

class _EditarDadosRecebimentoState extends State<EditarDadosRecebimento> {
  TextEditingController controllerHora = MaskedTextController(mask: '00:00');
  TextEditingController controllerData =
      MaskedTextController(mask: '00/00/0000');
  MoneyMaskedTextController controllerValorRecebimento =
      MoneyMaskedTextController();
  TextEditingController controllerObservacoes = TextEditingController();

  var tipoPagamento = '';
  bool? pagCartao =
      FieldsRecebimento.tipoPagamento!.toUpperCase().replaceAll('Ã', 'A') ==
              'CARTAO'
          ? true
          : false;
  bool? pagBoleto =
      FieldsRecebimento.tipoPagamento!.toUpperCase() == 'BOLETO' ? true : false;
  bool? pagcheque =
      FieldsRecebimento.tipoPagamento!.toUpperCase() == 'CHEQUE' ? true : false;
  bool? pagAvista =
      FieldsRecebimento.tipoPagamento!.toUpperCase().replaceAll('À', 'A') ==
              'A VISTA'
          ? true
          : false;

  bool? pagDeposito =
      FieldsRecebimento.tipoPagamento!.toUpperCase().replaceAll('Ó', 'O') ==
              'DEPOSITO'
          ? true
          : false;

  // variaveis para validação de data e hora
  var diaDespesa;
  var mesDespesa;
  var anoDespesa;
  var dataDespesa;
  var horaDespesa;
  var minutoDespesa;
  var horarioDespesa;

  int? idClienteSelecionado = FieldsRecebimento.idCliente;
  List listaClientes = [];

  int? idlote;
  // var ultimoId = List<ModelsRecebimento>();
  double?totalLote = 0;
  double?media = 0;
  var quantidade = 0;

  Future buscarDadosCliente() async {
    final response = await http.get(
        Uri.parse(ListarTodosClientes + ModelsUsuarios.caminhoBaseUser.toString()),
        headers: {"authorization": ModelsUsuarios.tokenAuth.toString()});
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      setState(
        () {
          listaClientes = jsonData;
        },
      );
    }
  }

  //Valida os campos
  verificarCampos() {
    DateTime anoAtual = DateTime.now();

    if (controllerData.text.trim().isEmpty) {
      MsgPopup().msgFeedback(
          context, '\nA data não pode ficar vazia', 'Data inválida');
    } else if (controllerHora.text.trim().isEmpty) {
      MsgPopup().msgFeedback(
          context, '\nA hora não pode ficar vazia', 'Hora inválida');
    } else {
      // Data da despesa
      diaDespesa = controllerData.text.substring(0, 2);
      mesDespesa = controllerData.text.substring(3, 5);
      anoDespesa = controllerData.text.substring(6, 10);
      dataDespesa = anoDespesa + '-' + mesDespesa + '-' + diaDespesa;

      // Hora despesa
      horaDespesa = controllerHora.text.substring(0, 2);
      minutoDespesa = controllerHora.text.substring(3, 5);

      if (controllerData.text.length < 10) {
        MsgPopup().msgFeedback(
            context, '\nConfira a data informada', 'Data inválida');
      } else if (diaDespesa.length < 2 ||
          mesDespesa.length < 2 ||
          anoDespesa.length < 4) {
        MsgPopup().msgFeedback(
            context, '\nConfira a data informada', 'Data inválida');
      } else if (int.tryParse(diaDespesa)! > 31 ||
          int.tryParse(mesDespesa)! > 12 ||
          int.tryParse(anoDespesa)! < anoAtual.year) {
        MsgPopup().msgFeedback(
            context, '\nConfira a data informada', 'Data inválida');
      } else if (int.tryParse(horaDespesa)! > 24 ||
          int.tryParse(minutoDespesa)! > 59) {
        MsgPopup().msgFeedback(
            context, '\nConfira a hora informada', 'Hora inválida');
      }
      //=========================================================================
      else if (idClienteSelecionado == null) {
        MsgPopup().msgFeedback(context, 'Selecione um cliente', 'Cliente');
      } else if (tipoPagamento.isEmpty) {
        MsgPopup().msgFeedback(
            context,
            '\nO campo tipo do pagamento não foi preenchido',
            'Tipo do pagamento');
      } else if (controllerValorRecebimento.text == '0,00') {
        MsgPopup().msgFeedback(
            context,
            'O campo valor recebimento não foi preenchido',
            'Valor recebimento');
      } else {
        salvarEdicao();
      }
    }
  }

  Future<dynamic> salvarEdicao() async {
    var corpoReq = jsonEncode(
      {
        'idcliente': idClienteSelecionado,
        'tipo_pagamento': tipoPagamento,
        'data_recebimento': controllerData.text,
        'hora_recebimento': controllerHora.text,
        'valor_recebido': controllerValorRecebimento.text,
        'observacoes': controllerObservacoes.text,
      },
    );
    http.Response state = await http.put(
      Uri.parse(EditarRecebimento +
          FieldsRecebimento.idRecebimento.toString() +
          '/' +
          ModelsUsuarios.caminhoBaseUser.toString()),
      headers: {
        "Content-Type": "application/json",
        "authorization": ModelsUsuarios.tokenAuth.toString()
      },
      body: corpoReq,
    );
    print(state.statusCode);
    print(corpoReq);
    if (state.statusCode == 201) {
      Navigator.pop(context);
    }
  }

//chama a função buscar dados ao iniciar a tela
  @override
  void initState() {
    super.initState();
    this.buscarDadosCliente();
    controllerHora.text = FieldsRecebimento.horaRecebimento!;
    controllerData.text = FieldsRecebimento.dataRecebimento!;
    controllerValorRecebimento.text = FieldsRecebimento.valorRecebido!;
    controllerObservacoes.text = FieldsRecebimento.observacoes!;

    pagCartao == true ? tipoPagamento = 'Cartão' : '';
    pagAvista == true ? tipoPagamento = 'À vista' : '';
    pagcheque == true ? tipoPagamento = 'Cheque' : '';
    pagBoleto == true ? tipoPagamento = 'Boleto' : '';
    pagDeposito == true ? tipoPagamento = 'Depósito' : '';
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
                  'Editar recebimento',
                  iconeVoltar: true,
                  sizeTextTitulo: 0.065,
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: size.width * 0.02,
                    right: size.width * 0.02,
                  ),
                  child: Container(
                    width: size.width,
                    height: size.height * 0.75,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              top: size.height * 0.04,
                              left: 5,
                              right: 5,
                            ),
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: Colors.black, width: 1)),
                              child: DropdownButton(
                                hint: Text(
                                  'Cliente: ',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                value: idClienteSelecionado,
                                items: listaClientes.map(
                                  (dadosCliente) {
                                    return DropdownMenuItem(
                                      value: (dadosCliente['idcliente']),
                                      child: RichText(
                                        text: TextSpan(
                                          text: dadosCliente['idcliente']
                                              .toString(),
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.blue[800],
                                          ),
                                          children: <TextSpan>[
                                            TextSpan(
                                              text: ' - ',
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.blue[800],
                                              ),
                                            ),
                                            TextSpan(
                                              text: dadosCliente['nome']
                                                  .toString(),
                                              style: TextStyle(
                                                fontSize: 18.5,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ).toList(),
                                onChanged: (value) {
                                  setState(
                                    () {
                                      idClienteSelecionado = value as int;
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(
                                left: 5,
                                right: 5,
                                top: MediaQuery.of(context).size.height * 0.04),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.black),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    'Tipo do pagamento:',
                                    style: TextStyle(
                                      fontSize: 21,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: CheckboxListTile(
                                                title: Text(
                                                  'À vista',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 20),
                                                ),
                                                key: Key('check1'),
                                                value: pagAvista,
                                                onChanged: (bool? valor) {
                                                  setState(
                                                    () {
                                                      pagAvista = true;
                                                      pagCartao = false;
                                                      pagBoleto = false;
                                                      pagcheque = false;
                                                      pagDeposito = false;
                                                      tipoPagamento = 'À vista';
                                                    },
                                                  );
                                                },
                                              ),
                                            ),
                                            SizedBox(width: size.width * 0.1),
                                            Expanded(
                                              child: CheckboxListTile(
                                                  title: Text(
                                                    'Cartão',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontSize: 20),
                                                  ),
                                                  key: Key('check2'),
                                                  value: pagCartao,
                                                  onChanged: (bool? valor) {
                                                    setState(() {
                                                      pagCartao = true;
                                                      pagAvista = false;
                                                      pagBoleto = false;
                                                      pagcheque = false;
                                                      pagDeposito = false;
                                                      tipoPagamento = 'Cartão';
                                                    });
                                                  }),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: CheckboxListTile(
                                                title: Text(
                                                  'Boleto',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 20),
                                                ),
                                                key: Key('check3'),
                                                value: pagBoleto,
                                                onChanged: (bool? valor) {
                                                  setState(
                                                    () {
                                                      pagBoleto = true;
                                                      pagAvista = false;
                                                      pagCartao = false;
                                                      pagcheque = false;
                                                      pagDeposito = false;
                                                      tipoPagamento = 'Boleto';
                                                    },
                                                  );
                                                },
                                              ),
                                            ),
                                            SizedBox(width: size.width * 0.1),
                                            Expanded(
                                              child: CheckboxListTile(
                                                title: Text(
                                                  'Cheque',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 20),
                                                ),
                                                key: Key('check4'),
                                                value: pagcheque,
                                                onChanged: (bool? valor) {
                                                  setState(() {
                                                    pagcheque = true;
                                                    pagCartao = false;
                                                    pagAvista = false;
                                                    pagBoleto = false;
                                                    pagDeposito = false;
                                                    tipoPagamento = 'Cheque';
                                                  });
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: CheckboxListTile(
                                                title: Text(
                                                  'Depósito',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 20),
                                                ),
                                                key: Key('check3'),
                                                value: pagDeposito,
                                                onChanged: (bool? valor) {
                                                  setState(
                                                    () {
                                                      pagDeposito = true;
                                                      pagBoleto = false;
                                                      pagAvista = false;
                                                      pagCartao = false;
                                                      pagcheque = false;
                                                      tipoPagamento =
                                                          'Depósito';
                                                    },
                                                  );
                                                },
                                              ),
                                            ),
                                            SizedBox(width: size.width * 0.514),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          CampoText().textField(
                            controllerValorRecebimento,
                            'Valor da despesa:',
                            confPadding: EdgeInsets.only(
                                top: size.height * 0.04, left: 10, right: 10),
                            icone: Icons.monetization_on,
                            tipoTexto: TextInputType.number,
                          ),
                          Container(
                            padding: EdgeInsets.only(top: size.height * 0.04),
                            child: Row(
                              children: [
                                Container(
                                  alignment: Alignment.topLeft,
                                  width: size.width * 0.48,
                                  child: CampoText().textField(
                                    controllerData,
                                    'Data:',
                                    tipoTexto: TextInputType.text,
                                    icone: Icons.date_range_outlined,
                                    fontLabel: 19,
                                  ),
                                ),
                                Container(
                                  width: size.width * 0.48,
                                  child: CampoText().textField(
                                    controllerHora,
                                    'Hora:',
                                    tipoTexto: TextInputType.text,
                                    icone: Icons.timelapse_sharp,
                                    fontLabel: 19,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          CampoText().textField(
                            controllerObservacoes,
                            'Observações: ',
                            confPadding: EdgeInsets.only(
                                top: size.height * 0.03, left: 10, right: 10),
                            icone: Icons.message_sharp,
                            minLines: 3,
                            maxLines: 4,
                            maxLength: 100,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.03),
                Botao().botaoAnimacaoLoading(
                  context,
                  onTap: () {
                    verificarCampos();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
