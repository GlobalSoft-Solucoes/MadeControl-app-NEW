import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:group_button/group_button.dart';
import 'package:madecontrol_desenvolvimento/Widget/Cabecalho.dart';
import 'package:madecontrol_desenvolvimento/Widget/FieldData.dart';
import 'package:madecontrol_desenvolvimento/Widget/ListFieldsDataBase.dart';
import 'package:madecontrol_desenvolvimento/models/Models_GrupoPedido.dart';
import 'package:http/http.dart' as http;
import 'package:madecontrol_desenvolvimento/models/Models_Usuario.dart';
import 'package:madecontrol_desenvolvimento/models/constantes.dart';
import 'package:madecontrol_desenvolvimento/screens/Menu/BarraLateral/Historico/HistoricoCliente/HistoricoPedidosCliente.dart';

class OpcPesquisa {
  static String? opcSelecionada;
}

class HistoricoGrupoPedidos extends StatefulWidget {
  @override
  _HistoricoGrupoPedidosState createState() => _HistoricoGrupoPedidosState();
}

class _HistoricoGrupoPedidosState extends State<HistoricoGrupoPedidos> {
  TextEditingController controllerDataInicio =
      MaskedTextController(mask: '00/00/0000');
  TextEditingController controllerDataFim =
      MaskedTextController(mask: '00/00/0000');

  var dataInicio = '01-01-2020';
  var dataFim = '01-01-2022';
  var selectedRadio;
  DateTime currentDate = DateTime.now();
  // var primeiraData;
  // var segundaData;

  int? idCliente;
  var dadosListagem = <ModelsGrupoPedido>[];
  RxBool? loading = true.obs;
  Future<dynamic> listarDados() async {
    final response = await http.get(
      Uri.parse(OpcPesquisa.opcSelecionada! +
          ModelsUsuarios.caminhoBaseUser.toString()),
      headers: {"authorization": ModelsUsuarios.tokenAuth.toString()},
    );
    if (response.statusCode == 401) {
      Navigator.pushNamed(context, '/login');
    }
    //IF(MOUNTED) É nescessario para não recarregar a arvore apos retornar das outras listas
    if (mounted) {
      setState(
        () {
          Iterable lista = json.decode(response.body);
          dadosListagem =
              lista.map((model) => ModelsGrupoPedido.fromJson(model)).toList();
        },
      );
    }
    loading!.value = false;
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
    return dataBr;
  }

  @override
  void initState() {
    super.initState();
    OpcPesquisa.opcSelecionada = ListaGruposPorOpcPesquisaAno;
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    Size size = mediaQuery.size;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            color: Colors.green[200],
            height: size.height,
            width: size.width,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: size.width,
                    alignment: Alignment.center,
                    child: Row(
                      children: [
                        Container(
                          child: IconButton(
                            icon: Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            iconSize: 33,
                          ),
                        ),
                        SizedBox(width: size.width * 0.08),
                        Container(
                          child: Cabecalho().tituloCabecalho(
                            context,
                            'Pedidos cadastrados',
                            marginBottom: 0,
                          ),
                        ),
                        SizedBox(width: size.width * 0.08),
                        Container(
                          padding: EdgeInsets.only(right: 10),
                          child: IconButton(
                            icon: Icon(
                              Icons.filter_list,
                              color: Colors.white,
                            ),
                            onPressed: () async {
                              await FieldData().popupPesquisaDatas(
                                  context,
                                  controllerDataInicio,
                                  controllerDataFim, onTapInicial: () async {
                                await selectDate(context);
                                controllerDataInicio.text = converterData();
                              }, onTapFinal: () async {
                                await selectDate(context);
                                controllerDataFim.text = converterData();
                              });
                              setState(() {
                                OpcPesquisa.opcSelecionada =
                                    ListaGruposPorDataPesquisa +
                                        FiltroDatasPesquisa.dataInicial! +
                                        '/' +
                                        FiltroDatasPesquisa.dataFinal! +
                                        '/';
                                // selectedRadio = 0;
                                loading!.value = true;
                              });
                            },
                            iconSize: size.width * 0.08,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 100,
                    padding: EdgeInsets.only(
                      left: size.width * 0.025,
                      top: size.height * 0.012,
                      bottom: size.height * 0.005,
                      right: size.width * 0.025,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.grey[200],
                            ),
                            height: size.height * 0.09,
                            padding: const EdgeInsets.all(5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Flexible(
                                  child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Center(
                                          child: GroupButton(
                                            spacing: 15,
                                            direction: Axis.horizontal,
                                            onSelected:
                                                (index, isSelected) async {
                                              print(
                                                  '$index button is selected');
                                              if (index == 0) {
                                                loading!.value = true;
                                                OpcPesquisa.opcSelecionada =
                                                    ListaGruposPorOpcPesquisaDia;
                                              } else if (index == 1) {
                                                loading!.value = true;
                                                OpcPesquisa.opcSelecionada =
                                                    ListaGruposPorOpcPesquisaSemana;
                                              } else if (index == 2) {
                                                loading!.value = true;
                                                OpcPesquisa.opcSelecionada =
                                                    ListaGruposPorOpcPesquisaMes;
                                              } else if (index == 3) {
                                                loading!.value = true;
                                                OpcPesquisa.opcSelecionada =
                                                    ListaGruposPorOpcPesquisaAno;
                                              } else if (index == 4) {
                                                loading!.value = true;
                                                OpcPesquisa.opcSelecionada =
                                                    ListaGruposPorOpcPesquisaTodos;
                                              }
                                            },
                                            buttons: [
                                              "Dia",
                                              "Semana",
                                              "Mês",
                                              "Ano",
                                              "Todo",
                                            ],
                                            // selectedButtons: ["Semana"],
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
                      ],
                    ),
                  ),
                  SizedBox(width: size.height * 0.3),
                  Padding(
                    padding: EdgeInsets.only(
                        left: size.width * 0.02,
                        right: size.width * 0.02,
                        bottom: size.height * 0.02),
                    child: Container(
                      padding: EdgeInsets.only(
                        top: 5,
                        bottom: 5,
                      ),
                      width: size.width,
                      height: size.height * 0.72,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      child: FutureBuilder(
                        future: listarDados(),
                        builder: (BuildContext context, snapshot) {
                          return Obx(
                            () => loading!.value == true
                                ? Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : ListView.builder(
                                    itemCount: dadosListagem.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: EdgeInsets.only(
                                          left: size.width * 0.015,
                                          right: size.width * 0.015,
                                          top: size.width * 0.015,
                                          bottom: size.width * 0.01,
                                        ),
                                        child: Container(
                                          child: Slidable(
                                            key: const ValueKey(0),
                                            startActionPane: ActionPane(
                                              motion: const ScrollMotion(),
                                              children: [],
                                            ),
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        HistoricoPedidosCliente(
                                                      idGrupoPedido:
                                                          dadosListagem[index]
                                                              .idGrupoPedido,
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Container(
                                                alignment: Alignment.center,
                                                height: size.height * 0.14,
                                                width: size.width,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    5,
                                                  ),
                                                  color: Color(0XFFD1D6DC),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 0, right: 10),
                                                  child: SingleChildScrollView(
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color:
                                                            Color(0XFFD1D6DC),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                          15,
                                                        ),
                                                      ),
                                                      child: ListTile(
                                                        title: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            FieldsDatabase()
                                                                .listaDadosBanco(
                                                              'Cliente: ',
                                                              dadosListagem[
                                                                      index]
                                                                  .nomeCliente,
                                                            ),
                                                            SizedBox(height: 3),
                                                            Row(
                                                              children: [
                                                                FieldsDatabase()
                                                                    .listaDadosBanco(
                                                                  'Data: ',
                                                                  dadosListagem[
                                                                          index]
                                                                      .dataCadastro!
                                                                      .substring(
                                                                          0,
                                                                          10),
                                                                ),
                                                                FieldsDatabase()
                                                                    .listaDadosBanco(
                                                                  '  -  Hora: ',
                                                                  dadosListagem[
                                                                          index]
                                                                      .horaCadastro,
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(height: 3),
                                                            FieldsDatabase()
                                                                .listaDadosBanco(
                                                              'Status pedido: ',
                                                              dadosListagem[
                                                                      index]
                                                                  .status
                                                                  .toString(),
                                                            ),
                                                            SizedBox(height: 3),
                                                            FieldsDatabase()
                                                                .listaDadosBanco(
                                                              'Valor faturado: ',
                                                              dadosListagem[
                                                                      index]
                                                                  .faturamentoGrupo,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
