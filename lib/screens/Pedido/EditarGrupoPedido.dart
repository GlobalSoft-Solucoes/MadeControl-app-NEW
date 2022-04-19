import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:madecontrol_desenvolvimento/Statics/Static_Cliente.dart';
import 'package:madecontrol_desenvolvimento/Statics/Static_GrupoPedido.dart';
import 'package:madecontrol_desenvolvimento/Widget/Botao.dart';
import 'package:madecontrol_desenvolvimento/Widget/Cabecalho.dart';
import 'package:madecontrol_desenvolvimento/Widget/CheckBox.dart';
import 'package:madecontrol_desenvolvimento/Widget/DropDownButton.dart';
import 'package:madecontrol_desenvolvimento/Widget/MsgPopup.dart';
import 'package:madecontrol_desenvolvimento/Widget/TextField.dart';
import 'package:madecontrol_desenvolvimento/models/ClassesStaticas.dart';
import 'package:madecontrol_desenvolvimento/models/Models_Usuario.dart';
import 'package:http/http.dart' as http;
import 'package:madecontrol_desenvolvimento/models/constantes.dart';

class EditarGrupoPedido extends StatefulWidget {
  final int? idGrupoPedido;
  EditarGrupoPedido({Key? key, @required this.idGrupoPedido}) : super(key: key);
  @override
  _EditarGrupoPedidoState createState() =>
      _EditarGrupoPedidoState(idGrupoPedido: idGrupoPedido);
}

class _EditarGrupoPedidoState extends State<EditarGrupoPedido> {
  _EditarGrupoPedidoState({@required this.idGrupoPedido});
  int? idGrupoPedido;
  List listaClientes = [];
  int? idCliente = FieldsGrupoPedido.idCliente;
  bool? clienteescolhido = true;
  var nomeCliente;
  TextEditingController controllerDataEntrega =
      MaskedTextController(mask: '00/00/0000');
  // TextEditingController(text: FieldsGrupoPedido.dataEntrega);
  DateTime currentDate = DateTime.now();

  var tipoVenda = FieldsGrupoPedido.tipoVenda!.toUpperCase() == 'BALCAO'
      ? 'Balcao'
      : 'Normal';
  bool? vendaBalcao = FieldsGrupoPedido.tipoVenda != null
      ? FieldsGrupoPedido.tipoVenda!.toUpperCase() == 'BALCAO'
          ? true
          : false
      : false;
  bool? vendaNormal = FieldsGrupoPedido.tipoVenda != null
      ? FieldsGrupoPedido.tipoVenda!.toUpperCase() == 'NORMAL'
          ? true
          : false
      : false;

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

  editarGrupoPedido() async {
    var bodyy = jsonEncode(
      {
        'idcliente': idCliente,
        'tipo_venda': tipoVenda,
        'data_entrega': controllerDataEntrega.text != ''
            ? controllerDataEntrega.text.replaceAll('/', '-')
            : null,
      },
    );
    var state = await http.put(
      Uri.parse(EditarumGrupoPedido +
          idGrupoPedido.toString() +
          '/' +
          ModelsUsuarios.caminhoBaseUser.toString()),
      headers: {
        "Content-Type": "application/json",
        "authorization": ModelsUsuarios.tokenAuth.toString()
      },
      body: bodyy,
    );
    print(state.statusCode);
    if (state.statusCode == 200) {
      Navigator.pop(context); //pushNamed(context, '/ListaPedidos');
    } else if (state.statusCode == 401) {
      Navigator.pushNamed(context, '/login');
    }
  }

  Future buscarDadosCliente() async {
    final response = await http.get(
        Uri.parse(ListarTodosClientes + ModelsUsuarios.caminhoBaseUser.toString()),
        headers: {"authorization": ModelsUsuarios.tokenAuth.toString()});
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      setState(() {
        listaClientes = jsonData;
      });
    }

    if (response.statusCode == 401) {
      Navigator.pushNamed(context, '/login');
    }
  }

  validaGrupoPedidos() {
    if (idCliente == null) {
      MsgPopup().msgFeedback(
          context, '\nSelecione um cliente para continuar', 'Cliente');
    } else if (tipoVenda == null) {
      MsgPopup().msgFeedback(
          context, '\nSelecione o tipo da venda', ' Tipo da venda');
    } else {
      editarGrupoPedido();
    }
  }

  @override
  void initState() {
    super.initState();
    this.buscarDadosCliente();
    this.controllerDataEntrega.text = FieldsGrupoPedido.dataEntrega!;
    print(FieldsGrupoPedido.dataEntrega);
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    Size size = mediaQuery.size;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            height: size.height,
            width: size.width,
            color: Colors.green[200],
            child: Column(
              children: [
                Cabecalho().tituloCabecalho(
                  context,
                  'Edição do Grupo',
                  iconeVoltar: true,
                  sizeTextTitulo: 0.065,
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: size.width * 0.02,
                      right: size.width * 0.02,
                      bottom: size.height * 0.02),
                  child: Container(
                    width: size.width,
                    height: size.height * 0.86,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15)),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: 5, right: 5, top: 5, bottom: 5),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                        color: Colors.black, width: 1)),
                                child: Column(
                                  children: [
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
                                        value: idCliente,
                                        items: listaClientes.map(
                                          (categoria) {
                                            return DropdownMenuItem(
                                              value: (categoria['idcliente']),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    categoria['idcliente']
                                                        .toString(),
                                                    style:
                                                        TextStyle(fontSize: 18),
                                                  ),
                                                  Text(
                                                    ' - ',
                                                    style:
                                                        TextStyle(fontSize: 18),
                                                  ),
                                                  Text(
                                                    ConstantePedidos
                                                            .nomeCliente =
                                                        categoria['nome'],
                                                    style:
                                                        TextStyle(fontSize: 18),
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
                                              BuscaClientePorId()
                                                  .capturaDadosCliente(value);
                                            },
                                          );
                                        },
                                      ),
                                      tituloPaddingTop: 0.01,
                                      tituloPaddingBottom: 0.02,
                                      marginTop: 0.01,
                                      backgroundColor:
                                          Colors.white.withOpacity(0.9),
                                    ),
                                    // ==================== TIPO DE VENDA ===================
                                    CheckBox().checkBoxDuasOpcoes(
                                      context,
                                      'Tipo da venda',
                                      'Venda normal',
                                      'Venda de balcão',
                                      vendaNormal,
                                      vendaBalcao,
                                      () => {
                                        setState(
                                          () {
                                            vendaNormal = true;
                                            vendaBalcao = false;
                                            tipoVenda = 'Normal';
                                          },
                                        ),
                                      },
                                      () => {
                                        setState(
                                          () {
                                            vendaBalcao = true;
                                            vendaNormal = false;
                                            tipoVenda = 'Balcao';
                                          },
                                        ),
                                      },
                                      marginBottom: 0.06,
                                      marginTop: 0.045,
                                      backgroundColor:
                                          Colors.white.withOpacity(0.9),
                                    ),
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      margin: EdgeInsets.only(
                                          left: size.width * 0.02),
                                      child: CampoText().textFieldIconButton(
                                        controllerDataEntrega,
                                        'Data Entrega:',
                                        tipoTexto: TextInputType.number,
                                        fontSize: 18,
                                        fontLabel: 18,
                                        icone: Icons.calendar_today_outlined,
                                        confPadding: EdgeInsets.only(
                                            top: 5,
                                            left: 0,
                                            right: 5,
                                            bottom: 5),
                                        onTapIcon: () async {
                                          await selectDate(context);
                                          controllerDataEntrega.text =
                                              converterData(currentDate);
                                          print(controllerDataEntrega.text);
                                        },
                                      ),
                                    ),
                                    SizedBox(height: size.height * 0.05),
                                    Botao().botaoAnimacaoLoading(
                                      context,
                                      onTap: () {
                                        editarGrupoPedido();
                                      },
                                    ),
                                    SizedBox(height: size.height * 0.02),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
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
