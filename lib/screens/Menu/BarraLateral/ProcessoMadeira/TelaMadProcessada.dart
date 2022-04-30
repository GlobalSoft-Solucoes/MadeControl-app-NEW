import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:madecontrol_desenvolvimento/Statics/Static_ConfigAcesso.dart';
import 'package:madecontrol_desenvolvimento/Statics/Static_ProcessoMadeira.dart';
import 'package:madecontrol_desenvolvimento/Widget/FieldData.dart';
import 'package:madecontrol_desenvolvimento/Widget/MsgPopup.dart';
import 'package:madecontrol_desenvolvimento/Widget/TextField.dart';
import 'package:madecontrol_desenvolvimento/models/Models_Usuario.dart';

import 'DetalhesPesquisaToras.dart';
import 'ListaProcessoPorTora.dart';
import 'DetalhesPesquisaToras.dart';

class TelaMadProcessada extends StatefulWidget {
  TelaMadProcessada({Key? key}) : super(key: key);

  @override
  TelaMadProcessadaState createState() => TelaMadProcessadaState();
}

class TelaMadProcessadaState extends State<TelaMadProcessada> {
  TextEditingController controllerDataInicio =
      MaskedTextController(mask: '00/00/0000');
  TextEditingController controllerDataFim =
      MaskedTextController(mask: '00/00/0000');
  DateTime currentDate = DateTime.now();
  mensagemErroAcesso() async {
    await MsgPopup().msgFeedback(
      context,
      '\n Você não tem permissão para acessar!',
      'aviso',
      fontMsg: 20,
    );
    await FieldsAcessoTelas()
        .capturaConfigAcessoTelasUsuario(ModelsUsuarios.idDoUsuario);
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

  converterDataParaEua(data) {
    var dia;
    var mes;
    var ano;
    var dataEua;
    String? dataConversao = data.toString();

    dia = dataConversao.substring(0, 2);
    mes = dataConversao.substring(3, 5);
    ano = dataConversao.substring(6, 10);

    dataEua = ano + '-' + mes + '-' + dia;

    print(dataEua);
    return dataEua.toString();
  }

  popupFiltroPesquisaRecebimentos(
    BuildContext context,
    controllerDataInicio,
    controllerDataFim, {
    mensagemTitulo,
    double? bordaPopup,
    double? fontText,
    mascara,
    iconeText,
    double? fontMsg,
    Color? corMsg,
    Color? corBotaoEsq,
    Color? corBotaoDir,
    txtButton,
    textoCampo,
    fonteButton,
    fontWeightButton,
    Function? onTapInicial,
    Function? onTapFinal,
  }) {
    return showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(bordaPopup ?? 10)),
          ),
          title: Text(
            'Pesquisas:',
            textAlign: TextAlign.center,
            style: new TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),
          // ======= email =========
          actions: <Widget>[
            Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.005,
                bottom: MediaQuery.of(context).size.height * 0.005,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.39,
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.01,
                    ),
                    child: CampoText().textFieldIconButton(
                      controllerDataInicio,
                      'Inicial:',
                      tipoTexto: TextInputType.number,
                      fontSize: Get.height * 0.02,
                      fontLabel: Get.height * 0.025,
                      icone: Icons.calendar_today_outlined,
                      confPadding:
                          EdgeInsets.only(top: 5, left: 0, right: 5, bottom: 5),
                      onTapIcon: () {
                        onTapInicial!();
                      },
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.39,
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.01,
                    ),
                    child: CampoText().textFieldIconButton(
                        controllerDataFim, 'Final:',
                        tipoTexto: TextInputType.number,
                        fontSize: Get.height * 0.02,
                        fontLabel: Get.height * 0.025,
                        icone: Icons.calendar_today_outlined,
                        confPadding: EdgeInsets.only(
                            top: 5,
                            left: 5,
                            right: 0,
                            bottom: 5), onTapIcon: () {
                      onTapFinal!();
                    }),
                  ),
                ],
              ),
            ),

            // ================== BOTÃO DE PESQUISA =================
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.03,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.61,
              padding: EdgeInsets.only(
                top: 15,
                bottom: 5,
                right: MediaQuery.of(context).size.width * 0.17,
              ),
              child: FloatingActionButton.extended(
                backgroundColor: Colors.green,
                label: const Text(
                  'Pesquisar',
                  style: TextStyle(fontSize: 23),
                ),
                onPressed: () async {
                  converterDataParaEua(controllerDataInicio.text);
                  Navigator.pop(context);
                  // Navigator.pushNamed(context, '/DetalhesPesquisaTorras');
                  ParametroData.dataFim =
                      converterDataParaEua(controllerDataFim.text);
                  ParametroData.dataInicio =
                      converterDataParaEua(controllerDataInicio.text);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DetalhesTorasPorData()
                        // datainicio:
                        //     converterDataParaEua(controllerDataInicio.text),
                        // datafim:
                        //     converterDataParaEua(controllerDataFim.text)),
                        ),
                  );
                },
              ),
            ),
            // =========== ICONBUTTON PARA LIMPAR OS DADOS ============
            IconButton(
              iconSize: 34,
              icon: const Icon(
                Icons.cleaning_services_outlined,
                color: Colors.red,
              ),
              onPressed: () async {
                setState(() {
                  controllerDataInicio.text = "";
                  controllerDataFim.text = "";
                  Navigator.pop(context);
                });
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    Size size = mediaQuery.size;
    return SafeArea(
      child: Scaffold(
        // backgroundColor: Colors.white,//(0XFF515667),
        body: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                Colors.grey[100]!.withAlpha(300),
                Colors.grey.withAlpha(1100)
              ]),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      alignment: Alignment.bottomLeft,
                      padding:
                          EdgeInsets.only(top: size.height * 0.02, left: 10),
                      child: Container(
                        color: Colors.black26,
                        width: size.width * 0.13,
                        height: size.height * 0.06,
                        child: IconButton(
                          icon: Icon(Icons.arrow_back),
                          onPressed: () => Navigator.pop(context),
                          iconSize: 35,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(width: size.width * 0.7),
                    Container(
                      padding: EdgeInsets.only(right: 10),
                      child: IconButton(
                        icon: Icon(
                          Icons.filter_list,
                          color: Colors.black26,
                        ),
                        onPressed: () async {
                          await popupFiltroPesquisaRecebimentos(
                              context, controllerDataInicio, controllerDataFim,
                              onTapInicial: () async {
                            await selectDate(context);
                            controllerDataInicio.text = converterData();
                          }, onTapFinal: () async {
                            await selectDate(context);
                            controllerDataFim.text = converterData();
                          });
                          setState(() {});
                        },
                        iconSize: size.width * 0.08,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    // ======================= TORA FINA ===========================
                    GestureDetector(
                      onTap: () {
                        FieldsProcessoMadeira.tipoTora = 1;
                        FieldsProcessoMadeira().detalhesProcessoPorTipoTora(1);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ListaProcessoPorTora(),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[400]!.withAlpha(450),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        width: size.width * 0.1,
                        height: size.width * 0.25,
                        margin: EdgeInsets.only(
                            left: 15, right: 15, top: size.height * 0.05),
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            'TORA FINA',
                            style: TextStyle(
                              fontSize: 30,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    // =================== TORA MÉDIA =======================
                    GestureDetector(
                      onTap: () {
                        FieldsProcessoMadeira.tipoTora = 2;
                        FieldsProcessoMadeira().detalhesProcessoPorTipoTora(2);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ListaProcessoPorTora(),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[400]!.withAlpha(450),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        width: size.width * 0.1,
                        height: size.width * 0.25,
                        margin: EdgeInsets.only(
                          left: 15,
                          right: 15,
                        ),
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            'TORA MÉDIA',
                            style: TextStyle(
                              fontSize: 30,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    // =================== TORA DO GROSSA =======================
                    GestureDetector(
                      onTap: () {
                        FieldsProcessoMadeira.tipoTora = 3;
                        FieldsProcessoMadeira().detalhesProcessoPorTipoTora(3);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ListaProcessoPorTora(),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[400]!.withAlpha(450),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        height: size.width * 0.25,
                        margin: EdgeInsets.only(left: 15, right: 15),
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            'TORA GROSSA',
                            style: TextStyle(
                              fontSize: 30,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // =================== TORA DO PÉ =======================
                    SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        FieldsProcessoMadeira.tipoTora = 4;
                        FieldsProcessoMadeira().detalhesProcessoPorTipoTora(4);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ListaProcessoPorTora(),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[400]!.withAlpha(450),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        height: size.width * 0.25,
                        margin: EdgeInsets.only(left: 15, right: 15),
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            'TORA DO PÉ',
                            style: TextStyle(
                              fontSize: 30,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // =================== TORA DO PÉ =======================
                    SizedBox(height: Get.height * 0.1),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                            context, '/ListaHistoricoSerraFita');
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[500],
                          borderRadius: BorderRadius.circular(5),
                        ),
                        height: size.width * 0.25,
                        margin: EdgeInsets.only(left: 15, right: 15),
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            'VER PROCESSO POR USUÁRIO',
                            style: TextStyle(
                              fontSize: 26,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
