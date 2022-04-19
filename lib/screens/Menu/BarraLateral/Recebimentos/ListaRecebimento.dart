import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:madecontrol_desenvolvimento/Statics/Static_Recebimento.dart';
import 'package:madecontrol_desenvolvimento/Widget/Botao.dart';
import 'package:madecontrol_desenvolvimento/Widget/Cabecalho.dart';
import 'package:madecontrol_desenvolvimento/Widget/DropDownButton.dart';
import 'package:madecontrol_desenvolvimento/Widget/FieldData.dart';
import 'package:madecontrol_desenvolvimento/Widget/ListFieldsDataBase.dart';
import 'package:madecontrol_desenvolvimento/Widget/MsgPopup.dart';
import 'package:madecontrol_desenvolvimento/Widget/TextField.dart';
import 'package:madecontrol_desenvolvimento/models/Models_Recebimento.dart';
import 'package:madecontrol_desenvolvimento/models/Models_Usuario.dart';
import 'package:madecontrol_desenvolvimento/models/constantes.dart';
import 'package:http/http.dart' as http;
import 'DetalhesRecebimento.dart';

class OpcPesquisaDatas {
  static String? opcSelecionada;
}

class ListarRecebimentos extends StatefulWidget {
  @override
  _ListarRecebimentosState createState() => _ListarRecebimentosState();
}

class _ListarRecebimentosState extends State<ListarRecebimentos> {
  TextEditingController controllerDataInicio =
      MaskedTextController(mask: '00/00/0000');
  TextEditingController controllerDataFim =
      MaskedTextController(mask: '00/00/0000');
  var dadosListagem = <ModelsRecebimento>[];
  DateTime currentDate = DateTime.now();
  RxBool? loading = true.obs;
  List dadosClientes = [];
  int? idCliente;

  Future<dynamic> listarDados() async {
    final response = await http.get(
      Uri.parse(OpcPesquisaDatas.opcSelecionada! +
          ModelsUsuarios.caminhoBaseUser.toString()),
      headers: {"authorization": ModelsUsuarios.tokenAuth.toString()},
    );
    if (response.statusCode == 401) {
      Navigator.pushNamed(context, '/login');
    }
    //IF(MOUNTED) É nescessario para não recarregar a arvore apos retornar das outras listas
    // if (dadosListagem.isNotEmpty) {
    if (mounted) {
      setState(
        () {
          Iterable lista = json.decode(response.body);
          dadosListagem =
              lista.map((model) => ModelsRecebimento.fromJson(model)).toList();
        },
      );
    }
    loading!.value = false;
    // }
  }

  Future buscarDadosCliente() async {
    final response = await http.get(
        Uri.parse(
            ListarTodosClientes + ModelsUsuarios.caminhoBaseUser.toString()),
        headers: {"authorization": ModelsUsuarios.tokenAuth.toString()});
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      setState(() {
        dadosClientes = jsonData;
      });
    }

    if (response.statusCode == 401) {
      Navigator.pushNamed(context, '/login');
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

  mostrarSpeedDial() {
    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: IconThemeData(size: 30),
      child: Icon(Icons.add),
      visible: true,
      curve: Curves.bounceIn,
      overlayColor: Colors.white,
      overlayOpacity: 0.6,
      // onOpen: () => print('OPENING DIAL'),
      // onClose: () => print('DIAL CLOSED'),
      tooltip: 'Speed Dial',
      heroTag: 'speed-dial-hero-tag',
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 8.0,
      shape: CircleBorder(),
      children: [
        SpeedDialChild(
          child: Icon(Icons.add, size: 30),
          backgroundColor: Colors.blue,
          label: 'Cadastrar recebimento',
          labelStyle: TextStyle(fontSize: 20),
          onTap: () => {Navigator.pushNamed(context, '/CadastroRecebimento')},
        ),
      ],
    );
  }

  msgConfirmacaoDeletarRecebimento(idRecebimento) {
    MsgPopup().msgComDoisBotoes(
      context,
      'Você deseja excluir este recebimento?',
      'Não',
      'Sim',
      () => Navigator.pop(context),
      () {
        excluiRecebimento(idRecebimento);
      },
    );
  }

  //restaura o grupo
  Future<dynamic> excluiRecebimento(idRecebimento) async {
    var response = await http.delete(
      Uri.parse(ExcluirRecebimento +
          idRecebimento.toString() +
          '/' +
          ModelsUsuarios.caminhoBaseUser.toString()),
      headers: {
        "Content-Type": "application/json",
        "authorization": ModelsUsuarios.tokenAuth.toString()
      },
    );
    if (response.statusCode == 401) {
      Navigator.pushNamed(context, '/login');
    } else if (response.statusCode == 200) {
      Navigator.pop(context);
    }
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
                      fontSize: 18,
                      fontLabel: 18,
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
                        fontSize: 18,
                        fontLabel: 18,
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
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            DropDownButton().dropDownButton(
              'Cliente',
              DropdownButton(
                hint: Text(
                  'Cliente',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                // isExpanded: true,
                value: idCliente,
                items: dadosClientes.map(
                  (categoria) {
                    return DropdownMenuItem(
                      value: (categoria['idcliente']),
                      child: Row(
                        children: [
                          Text(
                            categoria['idcliente'].toString(),
                            style: TextStyle(fontSize: 18),
                          ),
                          Text(
                            ' - ',
                            style: TextStyle(fontSize: 18),
                          ),
                          Text(
                            categoria['nome'],
                            style: TextStyle(fontSize: 18),
                          )
                        ],
                      ),
                    );
                  },
                ).toList(),
                onChanged: (value) {
                  setState(
                    () {
                      idCliente = value as int;
                      Navigator.pop(context);
                      popupFiltroPesquisaRecebimentos(
                        context,
                        controllerDataInicio,
                        controllerDataFim,
                        onTapInicial: () async {
                          await selectDate(context);
                        },
                        onTapFinal: () async {
                          await selectDate(context);
                        },
                      );
                    },
                  );
                },
              ),
              tituloPaddingTop: 0.01,
              tituloPaddingBottom: 0.02,
              marginTop: 0.01,
              backgroundColor: Colors.white.withOpacity(0.9),
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
              child: new FloatingActionButton.extended(
                backgroundColor: Colors.green,
                label: Text(
                  'Pesquisar',
                  style: new TextStyle(fontSize: 23),
                ),
                onPressed: () async {
                  OpcPesquisaDatas.opcSelecionada = idCliente == null
                      ? ListarRecebimentosPorData +
                          controllerDataInicio.text.replaceAll('/', '-') +
                          '/' +
                          controllerDataFim.text.replaceAll('/', '-') +
                          '/'
                      : controllerDataInicio.text.isEmpty
                          ? BuscarRecebimentoPorIdCliente +
                              idCliente.toString() +
                              '/'
                          : BuscarRecebimentoPorClienteEData +
                              controllerDataInicio.text.replaceAll('/', '-') +
                              '/' +
                              controllerDataFim.text.replaceAll('/', '-') +
                              '/' +
                              idCliente.toString() +
                              '/';
                  await FieldData().validarDataSelecionada(
                      controllerDataInicio, controllerDataFim);
                  Navigator.pop(context);
                },
              ),
            ),
            // =========== ICONBUTTON PARA LIMPAR OS DADOS ============
            Container(
              child: IconButton(
                iconSize: 34,
                icon: Icon(
                  Icons.cleaning_services_outlined,
                  color: Colors.red,
                ),
                onPressed: () async {
                  setState(() {
                    if (idCliente != null) {
                      idCliente = null;
                    }
                    if (controllerDataInicio.text != "" ||
                        controllerDataFim.text != "") {
                      controllerDataInicio.text = "";
                      controllerDataFim.text = "";
                      controllerDataInicio.text = isBlank;
                      controllerDataFim.text = isBlank;
                    }
                    Navigator.pop(context);
                    // await popupFiltroPesquisaRecebimentos(
                    //   context,
                    //   controllerDataInicio,
                    //   controllerDataFim,
                    //   onTapInicial: () async {
                    //     await selectDate(context);
                    //   },
                    //   onTapFinal: () async {
                    //     await selectDate(context);
                    //   },
                    // );
                  });
                },
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    this.buscarDadosCliente();
    FiltroDatasPesquisa.dataInicial = '1999-01-01';
    FiltroDatasPesquisa.dataFinal = '2100-01-01';
    OpcPesquisaDatas.opcSelecionada = ListarRecebimentosPorData +
        FiltroDatasPesquisa.dataInicial! +
        '/' +
        FiltroDatasPesquisa.dataFinal! +
        '/';
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    Size size = mediaQuery.size;
    return SafeArea(
      child: Scaffold(
        floatingActionButton: mostrarSpeedDial(),
        body: SingleChildScrollView(
          child: Container(
            color: Colors.green[200],
            height: size.height,
            width: size.width,
            child: Column(
              children: [
                Container(
                  width: size.width,
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                      SizedBox(width: size.width * 0.16),
                      Container(
                        alignment: Alignment.center,
                        child: Cabecalho().tituloCabecalho(
                          context,
                          'Recebimentos',
                          marginBottom: 0,
                        ),
                      ),
                      SizedBox(width: size.width * 0.16),
                      Container(
                        padding: EdgeInsets.only(right: 10),
                        child: IconButton(
                          icon: Icon(
                            Icons.filter_list,
                            color: Colors.white,
                          ),
                          onPressed: () async {
                            await popupFiltroPesquisaRecebimentos(
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
                              OpcPesquisaDatas.opcSelecionada =
                                  idCliente == null
                                      ? ListarRecebimentosPorData +
                                          FiltroDatasPesquisa.dataInicial! +
                                          '/' +
                                          FiltroDatasPesquisa.dataFinal! +
                                          '/'
                                      : controllerDataInicio.text.isEmpty
                                          ? BuscarRecebimentoPorIdCliente +
                                              idCliente.toString() +
                                              '/'
                                          : BuscarRecebimentoPorClienteEData +
                                              controllerDataInicio.text
                                                  .replaceAll('/', '-') +
                                              '/' +
                                              controllerDataFim.text
                                                  .replaceAll('/', '-') +
                                              '/' +
                                              idCliente.toString() +
                                              '/';
                              loading!.value = true;
                            });
                          },
                          iconSize: size.width * 0.08,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: size.width * 0.02,
                    right: size.width * 0.02,
                    top: size.height * 0.01,
                    bottom: size.height * 0.02,
                  ),
                  child: Container(
                    padding: const EdgeInsets.only(
                      bottom: 5,
                      top: 5,
                    ),
                    width: size.width,
                    height: size.height * 0.83,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white.withOpacity(0.8),
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
                                        top: size.width * 0.008,
                                        bottom: size.width * 0.008,
                                      ),
                                      child: Container(
                                        child: Slidable(
                                          key: const ValueKey(0),
                                          startActionPane: ActionPane(
                                            motion: const ScrollMotion(),
                                            children: [
                                              SlidableAction(
                                                label: 'Editar',
                                                backgroundColor: Colors.white,
                                                icon: Icons.edit_outlined,
                                                onPressed: (BuildContext
                                                    context) async {
                                                  await FieldsRecebimento()
                                                      .capturaDadosRecebimento(
                                                          dadosListagem[index]
                                                              .idrecebimento);
                                                  Navigator.pushNamed(context,
                                                      '/EditarRecebimento');
                                                },
                                              ),
                                              SlidableAction(
                                                label: 'Excluir',
                                                backgroundColor: Colors.red,
                                                icon: Icons.delete_forever,
                                                onPressed: (BuildContext
                                                        context) =>
                                                    msgConfirmacaoDeletarRecebimento(
                                                        dadosListagem[index]
                                                            .idrecebimento),
                                              ),
                                            ],
                                          ),
                                          child: GestureDetector(
                                            onTap: () {
                                              PermissaoExcluir
                                                  .permissao!.value = true;
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      DetalhesRecebimento(
                                                    idRecebimento:
                                                        dadosListagem[index]
                                                            .idrecebimento,
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              height: size.height * 0.157,
                                              width: size.width,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  5,
                                                ),
                                                color: Colors.grey[400],
                                              ),
                                              child: Container(
                                                alignment: Alignment.center,
                                                child: SingleChildScrollView(
                                                  child: Container(
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
                                                                      .nomeCliente),
                                                          SizedBox(height: 3),
                                                          FieldsDatabase()
                                                              .listaDadosBanco(
                                                                  'Tipo pagamento: ',
                                                                  dadosListagem[
                                                                          index]
                                                                      .tipoPagamento),
                                                          SizedBox(height: 3),
                                                          FieldsDatabase()
                                                              .listaDadosBanco(
                                                                  'Data cadastro: ',
                                                                  dadosListagem[
                                                                          index]
                                                                      .dataCadastro),
                                                          SizedBox(height: 3),
                                                          FieldsDatabase()
                                                              .listaDadosBanco(
                                                                  'Valor: ',
                                                                  dadosListagem[
                                                                          index]
                                                                      .valorRecebido),
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
