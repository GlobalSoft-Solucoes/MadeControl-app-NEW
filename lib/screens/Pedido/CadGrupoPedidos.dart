import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/date_picker.dart';
import 'package:flutter_holo_date_picker/i18n/date_picker_i18n.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:madecontrol_desenvolvimento/Statics/Static_Cliente.dart';
import 'package:madecontrol_desenvolvimento/Widget/Cabecalho.dart';
import 'package:madecontrol_desenvolvimento/Widget/CheckBox.dart';
import 'package:madecontrol_desenvolvimento/Widget/DropDownButton.dart';
import 'package:madecontrol_desenvolvimento/Widget/ListFieldsDataBase.dart';
import 'package:madecontrol_desenvolvimento/Widget/TextField.dart';
import 'package:madecontrol_desenvolvimento/models/constantes.dart';
import 'package:madecontrol_desenvolvimento/Widget/Botao.dart';
import 'package:madecontrol_desenvolvimento/Widget/MsgPopup.dart';
import 'package:madecontrol_desenvolvimento/models/ClassesStaticas.dart';
import 'package:madecontrol_desenvolvimento/funcoes/FuncoesParaDatas.dart';
import 'package:madecontrol_desenvolvimento/models/Models_GrupoPedido.dart';
import 'package:madecontrol_desenvolvimento/models/Models_Usuario.dart';
import 'package:http/http.dart' as http;

class CadGrupoPedido extends StatefulWidget {
  @override
  CadGrupoPedidoState createState() => CadGrupoPedidoState();
}

class CadGrupoPedidoState extends State<CadGrupoPedido> {
  // ================================ VARIÁVEIS UTILIZADAS ==================================
  var ultimogrupocadastrado = <ModelsGrupoPedido>[];

  var dofCliente;

  var tipoVenda;
  bool? vendaBalcao = false;
  bool? vendaNormal = false;

  List dadosClientes = [];
  int? idCliente;
  int? idClienteSelecionado;

  // selecionar o tipo da medidas
  Axis direction = Axis.horizontal;

  var selectedRadio;
  var metroscubicos = false;
  var metrosQuadrados = false;
  var metrosCorridos = false;
  var lastro = false;

  int? idGrupoPedidos;
  bool? grupoPedidosCriado = false;

  double? tamanhoWidget01 = 0.12;
  double? tamanhoWidget02 = 0.41;

  TextEditingController controllerDataEntrega =
      MaskedTextController(mask: '00/00/0000');
  DateTime currentDate = DateTime.now();

//====================================== FUNÇÕES DESENVOLVIDAS ==================================

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

  gerarCodGrupoPedido() {
    var _random = Random.secure();
    var random = List<int>.generate(4, (i) => _random.nextInt(256));
    var verificador = base64Url.encode(random);
    verificador = verificador
        .replaceAll('+', '')
        .replaceAll('-', '')
        .replaceAll('/', '')
        .replaceAll('', '')
        .replaceAll('=', '')
        .replaceAll(' ', '');

    return verificador.trim().toUpperCase();
  }

// ================================== CADASTROS DE REGISTROS ====================================

//cadastro o grupo de pedido apos o usuario ser escolhido
  cadastrarGrupoPedido() async {
    // if (ConstantePedidos.cadastraroGrupo == true) {
    var bodyy = jsonEncode(
      {
        'idcliente': idCliente,
        'status_grupo': 'Cadastrado',
        'idusuario': ModelsUsuarios.idDoUsuario,
        'codigo_grupo': gerarCodGrupoPedido(),
        'data_cadastro': DataAtual().pegardataBR() as String,
        'tipo_venda': tipoVenda,
        'data_entrega': controllerDataEntrega.text != ''
            ? controllerDataEntrega.text //.replaceAll('/', '-')
            : null,
      },
    );
    print(bodyy);
    var state = await http.post(
      Uri.parse(
          CadastrarGrupoPedido + ModelsUsuarios.caminhoBaseUser.toString()),
      headers: {
        "Content-Type": "application/json",
        "authorization": ModelsUsuarios.tokenAuth.toString()
      },
      body: bodyy,
    );
    print(bodyy);
    print(state.statusCode);
    if (state.statusCode == 201) {
      Navigator.pop(context);
    }
  }

  //    else {
  //     setState(
  //       () {},
  //     );
  //   }
  // }
  validaGrupoPedidos() {
    if (idCliente == null) {
      MsgPopup().msgFeedback(
          context, '\nSelecione um cliente para continuar', 'Cliente');
    } else if (tipoVenda == null) {
      MsgPopup().msgFeedback(
          context, '\nSelecione o tipo da venda', ' Tipo da venda');
    } else {
      cadastrarGrupoPedido();
    }
  }

  @override
  void initState() {
    super.initState();
    this.buscarDadosCliente();
    BuscaClientePorId.dof.value = false;
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
            width: size.width,
            height: size.height,
            child: Column(
              children: [
                Cabecalho().tituloCabecalho(
                  context,
                  'Grupo de pedidos',
                  iconeVoltar: true,
                  sizeTextTitulo: 0.065,
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: size.height * 0.01,
                      right: size.width * 0.02,
                      left: size.width * 0.02),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5)),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              left: 5, right: 5, top: 5, bottom: 5),
                          child: SingleChildScrollView(
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
                                    items: dadosClientes.map(
                                      (categoria) {
                                        return DropdownMenuItem(
                                          value: (categoria['idcliente']),
                                          child: Row(
                                            children: [
                                              Text(
                                                categoria['idcliente']
                                                    .toString(),
                                                style: TextStyle(fontSize: 18),
                                              ),
                                              Text(
                                                ' - ',
                                                style: TextStyle(fontSize: 18),
                                              ),
                                              Text(
                                                ConstantePedidos.nomeCliente =
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
                                Container(
                                  alignment: Alignment.centerLeft,
                                  margin: EdgeInsets.only(
                                      left: size.width * 0.02,
                                      top: size.height * 0.02),
                                  child: ValueListenableBuilder(
                                    valueListenable: BuscaClientePorId.dof,
                                    builder: (context, value, _) {
                                      return FieldsDatabase().listaDadosBanco(
                                        'Cliente possui DOF?  ',
                                        BuscaClientePorId.dof.value
                                            .toString()
                                            .replaceAll('null', '')
                                            .replaceAll('false', 'Não')
                                            .replaceAll('true', 'Sim'),
                                        corCampoBanco: Colors.black,
                                      );
                                    },
                                  ),
                                ),
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
                                  margin:
                                      EdgeInsets.only(left: size.width * 0.02),
                                  child: CampoText().textFieldIconButton(
                                    controllerDataEntrega,
                                    'Data Entrega:',
                                    tipoTexto: TextInputType.number,
                                    fontSize: 18,
                                    fontLabel: 18,
                                    icone: Icons.calendar_today_outlined,
                                    confPadding: EdgeInsets.only(
                                        top: 5, left: 0, right: 5, bottom: 5),
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
                                    validaGrupoPedidos();
                                  },
                                ),
                                SizedBox(height: 7),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
