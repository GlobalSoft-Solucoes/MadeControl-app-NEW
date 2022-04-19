import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_holo_date_picker/date_picker.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:madecontrol_desenvolvimento/Statics/Static_Despesa.dart';
import 'package:madecontrol_desenvolvimento/Widget/FieldData.dart';
import 'package:madecontrol_desenvolvimento/Statics/Static_Financeiro.dart';
import 'package:madecontrol_desenvolvimento/Statics/Static_Pedidos.dart';

class FirstCard extends StatefulWidget {
  @override
  _FristCardState createState() => _FristCardState();

  static String? dataInicial = '1999-01-01';
  static String? dataFinal = '2100-01-01';
}

class _FristCardState extends State<FirstCard> {
  TextEditingController controllerDataInicio =
      MaskedTextController(mask: '00/00/0000');
  TextEditingController controllerDataFim =
      MaskedTextController(mask: '00/00/0000');
  DateTime currentDate = DateTime.now();

  Axis direction = Axis.horizontal;

  var selectedRadio;

  setSelectedRadio(int? val) {
    setState(
      () {
        selectedRadio = val;
        if (selectedRadio == 1) {
          BuscaValoresFinanceiroPorData.saldoEmCaixa.value =
              BuscaValoresFinanceiroPorData.saldoSemana.value;
        } else if (selectedRadio == 2) {
          BuscaValoresFinanceiroPorData.saldoEmCaixa.value =
              BuscaValoresFinanceiroPorData.saldoMes.value;
        } else if (selectedRadio == 3) {
          BuscaValoresFinanceiroPorData.saldoEmCaixa.value =
              BuscaValoresFinanceiroPorData.saldoAno.value;
        } else if (selectedRadio == 4) {
          BuscaValoresFinanceiroPorData.saldoEmCaixa.value =
              BuscaValoresFinanceiroPorData.saldoHistorico.value;
        }
      },
    );
  }

selectDate(BuildContext context) async {
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
  void initState() {
    super.initState();
    selectedRadio = 0;
    BuscaValoresFinanceiroPorData().buscaSaldoPorOpcPesquisa();
    FieldsPedido().capturaDadosPedidosPorData(
      FiltroDatasPesquisa.dataInicial,
      FiltroDatasPesquisa.dataFinal,
    );
    BuscaDespesasPorData().capturaDadosDespesa(
      FiltroDatasPesquisa.dataInicial,
      FiltroDatasPesquisa.dataFinal,
    );
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
                              children: <Widget>[
                                Icon(
                                  Icons.money,
                                  color: Colors.white,
                                  size: 28,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  ' Saldo em caixa',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: size.width * 0.25, right: 0),
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
                                        selectedRadio = 0;
                                        BuscaValoresFinanceiroPorData()
                                            .capturaDadosFinanceiro(
                                          FiltroDatasPesquisa.dataInicial,
                                          FiltroDatasPesquisa.dataFinal,
                                        );
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(
                                left: 20, top: 20, bottom: 20),
                            child: SizedBox(
                              width: double.infinity,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                   ValueListenableBuilder(
                                    valueListenable:
                                        BuscaValoresFinanceiroPorData
                                            .saldoEmCaixa,
                                    builder: (context, value, _) {
                                      return Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                              text:
                                                  BuscaValoresFinanceiroPorData
                                                      .saldoEmCaixa.value,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          color: BuscaValoresFinanceiroPorData
                                                  .saldoEmCaixa.value
                                                  .contains('-')
                                              ? Colors.red[300]
                                              : Colors.green,
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      );
                                    })
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
                                flex: 3,
                                child: Container(
                                  color: Colors.orange,
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  color: Colors.blue,
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Container(
                                  color: Colors.green,
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
            Expanded(
              // flex: 1,
              child: Container(
                color: Colors.grey[200],
                height: 200,
                child: Container(
                  height: 200,
                  padding: const EdgeInsets.all(5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Flexible(
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            Row(
                              children: <Widget>[
                                Radio(
                                  value: 1,
                                  groupValue: selectedRadio,
                                  activeColor: Colors.green,
                                  onChanged: (val) {
                                    setSelectedRadio(val as int);
                                  },
                                ),
                                Text(
                                  'Semana',
                                  style: TextStyle(fontSize: 20),
                                )
                              ],
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Row(
                              children: <Widget>[
                                Radio(
                                  value: 2,
                                  groupValue: selectedRadio,
                                  activeColor: Colors.green,
                                  onChanged: (val) {
                                    setSelectedRadio(val as int);
                                  },
                                ),
                                Text(
                                  'Mês',
                                  style: TextStyle(fontSize: 20),
                                )
                              ],
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Row(
                              children: <Widget>[
                                Radio(
                                  value: 3,
                                  groupValue: selectedRadio,
                                  activeColor: Colors.green,
                                  onChanged: (val) {
                                    setSelectedRadio(val as int);
                                  },
                                ),
                                Text(
                                  'Ano',
                                  style: TextStyle(fontSize: 20),
                                )
                              ],
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Row(
                              children: <Widget>[
                                Radio(
                                  value: 4,
                                  groupValue: selectedRadio,
                                  activeColor: Colors.green,
                                  onChanged: (val) {
                                    setSelectedRadio(val as int);
                                  },
                                ),
                                Text(
                                  'Todo histórico',
                                  style: TextStyle(fontSize: 20),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Icon(
                      //   Icons.chevron_right,
                      //   color: Colors.grey[400],
                      //   size: 18,
                      // ),
                    ],
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
