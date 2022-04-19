import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:madecontrol_desenvolvimento/Statics/Static_Despesa.dart';
import 'package:madecontrol_desenvolvimento/Widget/FieldData.dart';

class ThirdCard extends StatefulWidget {
  @override
  _ThirdCardState createState() => _ThirdCardState();

  static String? dataInicial = '1999-01-01';
  static String? dataFinal = '2100-01-01';
}

class _ThirdCardState extends State<ThirdCard> {
  TextEditingController controllerDataInicio =
      MaskedTextController(mask: '00/00/0000');
  TextEditingController controllerDataFim =
      MaskedTextController(mask: '00/00/0000');
  bool? _showSaldo = false;
  DateTime currentDate = DateTime.now();

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

  converterData(dataConvert) {
    var dia;
    var mes;
    var ano;
    var dataBr;
    String? dataConversao = dataConvert.toString();

    ano = dataConversao.substring(0, 4);
    mes = dataConversao.substring(5, 7);
    dia = dataConversao.substring(8, 10);
    dataBr = dia + '/' + mes + '/' + ano;

    print(dataBr);
    return dataBr;
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    Size size = mediaQuery.size;
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Container(
        color: Colors.blueGrey[500],
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Container(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Text(
                                      '--',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Icon(
                                      Icons.request_page,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      ' Despesas',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _showSaldo = !_showSaldo!;
                                    });
                                  },
                                  child: SvgPicture.asset(
                                      !_showSaldo!
                                          ? 'assets/icons/eye-off-outline.svg'
                                          : 'assets/icons/eye-outline.svg',
                                      color: Colors.white,
                                      semanticsLabel: 'eye'),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: size.width * 0.2, right: 4),
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.filter_list,
                                      color: Colors.white,
                                      size: 34,
                                    ),
                                    onPressed: () async {
                                      await FieldData().popupPesquisaDatas(
                                          context,
                                          controllerDataInicio,
                                          controllerDataFim,
                                          onTapInicial: () async {
                                        await selectDate(context);
                                        controllerDataInicio.text =
                                            converterData(currentDate);
                                      }, onTapFinal: () async {
                                        await selectDate(context);
                                        controllerDataFim.text =
                                            converterData(currentDate);
                                      });
                                      setState(() {
                                        BuscaDespesasPorData()
                                            .capturaDadosDespesa(
                                          FiltroDatasPesquisa.dataInicial,
                                          FiltroDatasPesquisa.dataFinal,
                                        );
                                      });
                                      ThirdCard.dataInicial =
                                          FiltroDatasPesquisa.dataInicial;
                                      ThirdCard.dataFinal =
                                          FiltroDatasPesquisa.dataFinal;
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20, top: 20, bottom: 20),
                            child: SizedBox(
                              width: double.infinity,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                   ValueListenableBuilder(
                                   valueListenable: BuscaDespesasPorData
                                      .atualizaValorTotalDespesas,
                                   builder: (context, value, _){
                                      return Text.rich(
                                      TextSpan(
                                        text:
                                            (BuscaDespesasPorData.atualizaValorTotalDespesas.value),
                                      ),
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        color: Colors.deepOrange[400],
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    );
                                   }
                                 )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.05,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 12, bottom: 12, left: 10, right: 15),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Container(
                          child: Column(
                            children: <Widget>[
                              Expanded(
                                flex: 2,
                                child: Container(
                                  color: Colors.orange[500],
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Container(
                                  color: Colors.orange[700],
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Container(
                                  color: Colors.orange[500],
                                ),
                              ),
                            ],
                          ),
                          width: 7,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/RelatorioDespesas');
                },
                child: Container(
                  color: Colors.grey[200],
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Icon(
                          Icons.call_missed_outgoing_sharp,
                          color: Colors.grey,
                          size: 28,
                        ),
                        Flexible(
                          child: Text(
                            'Ver relações das despesas',
                            style: TextStyle(color: Colors.black, fontSize: 19),
                          ),
                        ),
                        Icon(
                          Icons.chevron_right,
                          color: Colors.grey[700],
                          size: 25,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
