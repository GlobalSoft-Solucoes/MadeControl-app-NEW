import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:madecontrol_desenvolvimento/Statics/Static_SubTipoDespesa.dart';
import 'package:madecontrol_desenvolvimento/Widget/Botao.dart';
import 'package:madecontrol_desenvolvimento/Widget/Cabecalho.dart';
import 'package:madecontrol_desenvolvimento/Widget/CheckBox.dart';
import 'package:madecontrol_desenvolvimento/Widget/MsgPopup.dart';
import 'package:madecontrol_desenvolvimento/Widget/TextField.dart';
import 'package:madecontrol_desenvolvimento/funcoes/FuncoesParaDatas.dart';
import 'package:madecontrol_desenvolvimento/models/Models_Despesa.dart';
import 'package:madecontrol_desenvolvimento/models/Models_Usuario.dart';
import 'package:madecontrol_desenvolvimento/models/constantes.dart';
import 'package:http/http.dart' as http;

class CadastroDespesa extends StatefulWidget {
  @override
  _CadastroDespesaState createState() => _CadastroDespesaState();
}

class _CadastroDespesaState extends State<CadastroDespesa> {
  TextEditingController controllerHora = MaskedTextController(mask: '00:00');
  TextEditingController controllerData =
      MaskedTextController(mask: '00/00/0000');
  TextEditingController controllerDataVencimento =
      MaskedTextController(mask: '00/00/0000');
  MoneyMaskedTextController controllerValorDespesa =
      MoneyMaskedTextController();
  TextEditingController controllerDescricao = TextEditingController();
  TextEditingController controllerObservacoes = TextEditingController();
  TextEditingController controllerNumeroParcelas = TextEditingController();

  // variaveis para validação de data e hora
  var diaDespesa;
  var mesDespesa;
  var anoDespesa;
  var dataDespesa;
  var horaDespesa;
  var minutoDespesa;
  var horarioDespesa;
  bool? despesaNormal = false;
  bool? despesaParcelada = false;
  DateTime currentDate = DateTime.now();

  bool? iniciarMedicao = false;
  bool? salvarlote = false;
  bool? verificou = false;
  int? idTipoDespesaSelecionado;
  List listaTipoDespesa = [];

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

  Future<void> selectDate(BuildContext context) async {
    var datePicked = await DatePicker.showSimpleDatePicker(
      context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime(2050),
      dateFormat: "dd-MMMM-yyyy",
      locale: DateTimePickerLocale.pt_br,
      looping: true,
    );
    if (datePicked != null && datePicked != currentDate) {
      setState(() {
        currentDate = datePicked;
        print(currentDate);
      });
    }
  }

  converterData() {
    var dia;
    var mes;
    var ano;
    var dataBr;
    String? dataConversao = currentDate.toString();

    ano = dataConversao.substring(0, 4);
    mes = dataConversao.substring(5, 7);
    dia = dataConversao.substring(8, 10);
    dataBr = dia + '/' + mes + '/' + ano;

    print(dataBr);
    return dataBr.toString();
  }

  verificarCampos() {
    DateTime anoAtual = DateTime.now();

    if (controllerData.text.trim().isEmpty) {
      MsgPopup().msgFeedback(
          context, '\nA data não pode ficar vazia!', 'Data inválida');
    } else if (controllerHora.text.trim().isEmpty) {
      MsgPopup().msgFeedback(
          context, '\nA hora não pode ficar vazia!', 'Hora inválida');
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
            context, '\nConfira a data informada!', 'Data inválida');
      } else if (diaDespesa.length < 2 ||
          mesDespesa.length < 2 ||
          anoDespesa.length < 4) {
        MsgPopup().msgFeedback(
            context, '\nConfira a data informada!', 'Data inválida');
      } else if (int.tryParse(diaDespesa)! > 31 ||
              int.tryParse(mesDespesa)! > 12
          // || int.tryParse(anoDespesa) < anoAtual.year
          ) {
        MsgPopup().msgFeedback(
            context, '\nConfira a data informada!', 'Data inválida');
      } else if (despesaNormal == true &&
          (int.tryParse(horaDespesa)! > 24 ||
              int.tryParse(minutoDespesa)! > 59)) {
        MsgPopup().msgFeedback(
            context, '\nConfira a hora informada!', 'Hora inválida');
      }
      //=========================================================================
      // else if (idTipoDespesaSelecionado == null) {
      //   MsgPopup().msgFeedback(context, 'Selecione um tipo de despesa', '');
      // } else if (controllerDescricao.text.isEmpty) {
      //   MsgPopup()
      //       .msgFeedback(context, 'O campo descrição não foi preenchido', '');
      // }
      else if (controllerValorDespesa.text == '0,00') {
        MsgPopup().msgFeedback(context,
            '\nO campo Valor Despesa não foi preenchido!', 'Valor Despesa');
      } else if (despesaParcelada == true &&
          int.parse(controllerNumeroParcelas.text) <= 0) {
        MsgPopup().msgFeedback(
            context,
            '\nO valor do campo Número Parcelas precisa ser '
                'maior que zero',
            'Número Parcelas');
      } else {
        salvarReg();
      }
    }
  }

  int? idlote;
  var ultimoId = <ModelsDespesa>[];
  double? totalLote = 0;
  double? media = 0;
  var quantidade = 0;

  Future<dynamic> salvarReg() async {
    var corpoReq = jsonEncode(
      {
        'idusuario': ModelsUsuarios.idDoUsuario,
        'idsub_tipo_despesa': FieldsSubTipoDespesa.idSubTipoDespesa,
        // 'descricao': controllerDescricao.text,
        'data_despesa': controllerData.text,
        'hora_despesa': controllerHora.text,
        'valor_despesa': controllerValorDespesa.text,
        'observacoes': controllerObservacoes.text,
        'data_vencimento': despesaParcelada == true
            ? controllerDataVencimento.text
            : controllerData.text,
        'num_parcelas': controllerNumeroParcelas.text,
      },
    );
    var response = await http.post(
      Uri.parse(CadastrarDespesa + ModelsUsuarios.caminhoBaseUser.toString()),
      headers: {
        "Content-Type": "application/json",
        "authorization": ModelsUsuarios.tokenAuth.toString()
      },
      body: corpoReq,
    );
    print(response.statusCode);
    print(corpoReq);
    if (response.statusCode == 201) {
      Navigator.pop(context);
    }
  }

//chama a função buscar dados ao iniciar a tela
  @override
  void initState() {
    super.initState();
    this.buscarDadosTipoDespesa();
    controllerData.text =
        DataAtual().pegardataBR().toString().replaceAll('-', '/');
    controllerDataVencimento.text =
        DataAtual().pegardataBR().toString().replaceAll('-', '/');
    controllerHora.text = DataAtual().pegarHora().toString();
    controllerNumeroParcelas.text = '0';
  }

  escolherTipoDespesa(context) {
    return CheckBox().checkBoxDuasOpcoes(
      context,
      'Tipo da Despesa',
      'Despesa Normal',
      'Despesa Parcelada',
      despesaNormal,
      despesaParcelada,
      () async {
        setState(
          () {
            despesaNormal = true;
            despesaParcelada = false;
            controllerNumeroParcelas.text = '1';
          },
        );
      },
      () async {
        setState(
          () {
            despesaParcelada = true;
            despesaNormal = false;
          },
        );
      },
      marginBottom: 0.0,
      marginLeft: 0.013,
      marginTop: 0.02,
      distanciaTituloDosChecks: 0.005,
      backgroundColor: Colors.white.withOpacity(0.9),
    );
  }

  opcDespesaNormal() {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    Size size = mediaQuery.size;
    return Column(
      children: [
        CampoText().textField(
          controllerValorDespesa,
          'Valor da despesa:',
          confPadding:
              EdgeInsets.only(top: size.height * 0.08, left: 10, right: 10),
          icone: Icons.monetization_on,
        ),
        Container(
          padding: EdgeInsets.only(top: size.height * 0.04),
          child: Row(
            children: [
              Container(
                alignment: Alignment.topLeft,
                width: size.width * 0.48,
                child: CampoText().textFieldIconButton(
                  controllerData,
                  'Data:',
                  tipoTexto: TextInputType.text,
                  icone: Icons.date_range_outlined,
                  fontLabel: Get.width * 0.05,
                  onTapIcon: () async {
                    await selectDate(context);
                    controllerData.text = converterData();
                  },
                ),
              ),
              Container(
                width: size.width * 0.48,
                child: CampoText().textField(
                  controllerHora,
                  'Hora:',
                  tipoTexto: TextInputType.text,
                  icone: Icons.timelapse_sharp,
                  fontLabel: Get.width * 0.05,
                ),
              ),
            ],
          ),
        ),
        CampoText().textField(
          controllerObservacoes,
          'Observações: ',
          confPadding:
              EdgeInsets.only(top: size.height * 0.04, left: 10, right: 10),
          icone: Icons.message_sharp,
          minLines: 3,
          maxLines: 4,
          maxLength: 100,
        ),
      ],
    );
  }

  opcDespesaParcelada() {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    Size size = mediaQuery.size;
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(top: size.height * 0.04),
          child: Row(
            children: [
              Container(
                alignment: Alignment.topLeft,
                width: size.width * 0.48,
                child: CampoText().textField(
                  controllerNumeroParcelas,
                  'Num Parcelas:',
                  tipoTexto: TextInputType.text,
                  icone: Icons.numbers_rounded,
                  fontLabel: Get.width * 0.05,
                ),
              ),
              Container(
                width: size.width * 0.48,
                child: CampoText().textField(
                  controllerValorDespesa,
                  'Valor Despesa:',
                  tipoTexto: TextInputType.text,
                  icone: Icons.monetization_on,
                  fontLabel: Get.width * 0.05,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: size.height * 0.04),
          child: Row(
            children: [
              Container(
                alignment: Alignment.topLeft,
                width: size.width * 0.48,
                child: CampoText().textFieldIconButton(
                  controllerData,
                  'Data cadastro:',
                  tipoTexto: TextInputType.text,
                  icone: Icons.date_range_outlined,
                  fontLabel: Get.width * 0.05,
                  onTapIcon: () async {
                    await selectDate(context);
                    controllerData.text = converterData();
                  },
                ),
              ),
              Container(
                width: size.width * 0.48,
                child: CampoText().textFieldIconButton(
                  controllerDataVencimento,
                  'Vencimento:',
                  tipoTexto: TextInputType.text,
                  icone: Icons.date_range_outlined,
                  fontLabel: Get.width * 0.05,
                  onTapIcon: () async {
                    await selectDate(context);
                    controllerDataVencimento.text = converterData();
                  },
                ),
              ),
            ],
          ),
        ),
        CampoText().textField(
          controllerObservacoes,
          'Observações: ',
          confPadding:
              EdgeInsets.only(top: size.height * 0.04, left: 10, right: 10),
          icone: Icons.message_sharp,
          minLines: 3,
          maxLines: 4,
          maxLength: 100,
        ),
      ],
    );
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
            color: Colors.green[200],
            child: Column(
              children: [
                Cabecalho().tituloCabecalho(context, 'Cadastro de despesa',
                    iconeVoltar: true,
                    // sizeTextTitulo: 0.065,
                    marginTop: 0.02),
                SizedBox(height: size.height * 0.04),
                Padding(
                  padding: EdgeInsets.only(
                    left: size.width * 0.02,
                    right: size.width * 0.02,
                  ),
                  child: Container(
                    width: size.width,
                    height: size.height * 0.60,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: Get.height * 0.02),
                          escolherTipoDespesa(context),
                          if (despesaNormal == true) opcDespesaNormal(),
                          if (despesaParcelada == true) opcDespesaParcelada(),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.05),
                Botao().botaoAnimacaoLoading(
                  context,
                  onTap: () {
                    salvarlote = true;
                    iniciarMedicao = false;
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
