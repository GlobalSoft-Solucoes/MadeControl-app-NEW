import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:madecontrol_desenvolvimento/Widget/Botao.dart';
import 'package:madecontrol_desenvolvimento/Widget/Cabecalho.dart';
import 'package:madecontrol_desenvolvimento/Widget/MsgPopup.dart';
import 'package:madecontrol_desenvolvimento/Widget/TextField.dart';
import 'package:madecontrol_desenvolvimento/models/Models_Usuario.dart';
import 'package:madecontrol_desenvolvimento/models/constantes.dart';
import 'package:http/http.dart' as http;
import 'package:madecontrol_desenvolvimento/Statics/Static_Despesa.dart';

class EditarDadosDespesa extends StatefulWidget {
  @override
  _EditarDadosDespesaState createState() => _EditarDadosDespesaState();
}

class _EditarDadosDespesaState extends State<EditarDadosDespesa> {
  TextEditingController controllerHora = MaskedTextController(mask: '00:00');
  TextEditingController controllerData =
      MaskedTextController(mask: '00/00/0000');
  TextEditingController controllerObservacoes =
      TextEditingController(text: EditarDadosDaDespesa.observacoes);
  TextEditingController controllerDescricao =
      TextEditingController(text: EditarDadosDaDespesa.descricao);
  TextEditingController controllerValorDespesa = MoneyMaskedTextController();
  //
  int? idTipoDespesaCadastrado = EditarDadosDaDespesa.idtipoDespesa;
  int? idTipoDespesaSelecionado;
  List listaTipoDespesa = [];

  // variaveis para validação de data e hora
  var diaDespesa;
  var mesDespesa;
  var anoDespesa;
  var dataDespesa;
  var horaDespesa;
  var minutoDespesa;
  var horarioDespesa;

  Future buscarDadosTipoDespesa() async {
    final response = await http.get(
        Uri.parse(
            ListarTodosTipoDespesa + ModelsUsuarios.caminhoBaseUser.toString()),
        headers: {"authorization": ModelsUsuarios.tokenAuth.toString()});
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      setState(
        () {
          listaTipoDespesa = jsonData;
        },
      );
    }
  }

//VALIDA OS CAMPOS
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
      else if (idTipoDespesaCadastrado == null) {
        MsgPopup().msgFeedback(context, 'Selecione um tipo de despesa', '');
      } else if (controllerDescricao.text.isEmpty) {
        MsgPopup()
            .msgFeedback(context, 'O campo descrição não foi preenchido', '');
      } else if (controllerValorDespesa.text == '0,00') {
        MsgPopup().msgFeedback(
            context, 'O campo valor despesa não foi preenchido', '');
      } else {
        salvarRegistro();
      }
    }
  }

  salvarRegistro() async {
    var corpoReq = jsonEncode(
      {
        'idusuario': ModelsUsuarios.idDoUsuario,
        'idtipo_despesa': idTipoDespesaSelecionado == null
            ? idTipoDespesaCadastrado
            : idTipoDespesaSelecionado,
        'descricao': controllerDescricao.text,
        'data_despesa': controllerData.text,
        'hora_despesa': controllerHora.text,
        'valor_despesa': controllerValorDespesa.text,
        'observacoes': controllerObservacoes.text,
      },
    );
    http.Response state = await http.put(
      Uri.parse(EditarDespesa +
          EditarDadosDaDespesa.iddespesa.toString() +
          '/' +
          ModelsUsuarios.caminhoBaseUser.toString()),
      headers: {
        "Content-Type": "application/json",
        "authorization": ModelsUsuarios.tokenAuth.toString()
      },
      body: corpoReq,
    );
    print(corpoReq);

    if (state.statusCode == 201) {
      Navigator.pop(context);
    } else if (state.statusCode == 401) {
      Navigator.pushNamed(context, '/login');
    }
  }

  @override
  void initState() {
    super.initState();
    this.buscarDadosTipoDespesa();
    controllerValorDespesa.text = EditarDadosDaDespesa.valorDespesa.toString();
    controllerData.text = EditarDadosDaDespesa.dataDespesa.toString();
    controllerHora.text = EditarDadosDaDespesa.horaDespesa.toString();
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
                  'Editar despesa',
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
                    height: size.height * 0.70,
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
                                  'Tipo da despesa',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                value: idTipoDespesaCadastrado,
                                items: listaTipoDespesa.map(
                                  (tipoDespesa) {
                                    return DropdownMenuItem(
                                      value: (tipoDespesa['idtipo_despesa']),
                                      child: RichText(
                                        text: TextSpan(
                                          text: tipoDespesa['idtipo_despesa']
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
                                              text: tipoDespesa['nome']
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
                                      idTipoDespesaSelecionado = value as int;
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                          CampoText().textField(
                            controllerDescricao,
                            'Descrição:',
                            confPadding: EdgeInsets.only(
                                top: size.height * 0.04, left: 10, right: 10),
                            icone: Icons.description,
                          ),
                          CampoText().textField(
                            controllerValorDespesa,
                            'Valor da despesa:',
                            confPadding: EdgeInsets.only(
                                top: size.height * 0.04, left: 10, right: 10),
                            icone: Icons.monetization_on,
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
                Padding(padding: EdgeInsets.only(top: size.height * 0.05)),
                Botao().botaoAnimacaoLoading(
                  context,
                  txtbutton: 'Salvar despesa',
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
