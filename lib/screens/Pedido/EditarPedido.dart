import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:madecontrol_desenvolvimento/Statics/Static_Pedidos.dart';
import 'package:madecontrol_desenvolvimento/Widget/Cabecalho.dart';
import 'package:madecontrol_desenvolvimento/Widget/CheckBox.dart';
import 'package:madecontrol_desenvolvimento/Widget/DropDownButton.dart';
import 'package:madecontrol_desenvolvimento/models/constantes.dart';
import 'package:madecontrol_desenvolvimento/Widget/Botao.dart';
import 'package:madecontrol_desenvolvimento/Widget/MsgPopup.dart';
import 'package:madecontrol_desenvolvimento/Widget/TextField.dart';
import 'package:madecontrol_desenvolvimento/models/ClassesStaticas.dart';
import 'package:madecontrol_desenvolvimento/models/Models_GrupoPedido.dart';
import 'package:madecontrol_desenvolvimento/models/Models_Usuario.dart';
import 'package:http/http.dart' as http;
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:get/get.dart';

class EditarDadosPedido extends StatefulWidget {
  @override
  _EditarDadosPedidoState createState() => _EditarDadosPedidoState();
}

class _EditarDadosPedidoState extends State<EditarDadosPedido> {
  // ================================ VARIÁVEIS UTILIZADAS ==================================
  var ultimogrupocadastrado = <ModelsGrupoPedido>[];
  final navigatorKey = GlobalKey<NavigatorState>();
  TextEditingController controllerLargura =
      TextEditingController(text: FieldsPedido.largura.toString());
  TextEditingController controllerComprimento =
      TextEditingController(text: FieldsPedido.comprimento.toString());
  TextEditingController controllerEspessura =
      TextEditingController(text: FieldsPedido.espessura.toString());
  TextEditingController controllerQuantidade =
      TextEditingController(text: FieldsPedido.quantidade.toString());
  TextEditingController controllerObservacao =
      TextEditingController(text: FieldsPedido.observacoes);
  TextEditingController controllerPrecoUndMedida = MoneyMaskedTextController();
  TextEditingController controllerValorTotal =
      MoneyMaskedTextController(leftSymbol: 'RS: ');
  TextEditingController controllerTotalMetrosMadeira =
      TextEditingController(text: FieldsPedido.qtdMetros.toString());

  var parte01Cadastro = true;
  var parte02Cadastro = false;

  var opcTipoProcesso = FieldsPedido.tipoProcesso;
  bool? processoBruto = FieldsPedido.tipoProcesso != null &&
          FieldsPedido.tipoProcesso!.toUpperCase() == 'BRUTO'
      ? true
      : false;
  bool? processoPersonalizado = FieldsPedido.tipoProcesso != null &&
          FieldsPedido.tipoProcesso!.toUpperCase() == 'PERSONALIZADO'
      ? true
      : false;

  bool? opcPedidoBeneficiado = FieldsPedido.beneficiado;
  bool? beneficiadoSim = FieldsPedido.beneficiado == true ? true : false;
  bool? beneficiadoNao = FieldsPedido.beneficiado == false ? true : false;

  var tipoCalculo = FieldsPedido.tipoCalculo;
  bool? calcQuantidade = FieldsPedido.tipoCalculo == 2 ? true : false;
  bool? calcMetroCubico = FieldsPedido.tipoCalculo == 1 ? true : false;

  bool? pallet = FieldsPedido.idPallet == null ? false : true;
  bool? madeiraProcessada = FieldsPedido.idProduto == null ? false : true;

  List itensLista2 = [];
  int? idCliente;
  List itensListaPallet = [];
  int? idPallet = FieldsPedido.idPallet;
  List itensListaUndMedida = [];
  int? idUnidadeMedida = FieldsPedido.idUnidadeMedida;
  String? nomeUndMedida;
  List itensListaProduto = [];
  int? idProduto = FieldsPedido.idProduto;
  String? nomeProduto;
  List itensListaMadeira = [];
  int? idMadeira = FieldsPedido.idMadeira;
  String? nomeMadeira;
  bool? clienteescolhido = true;
  String? nomePallet;
  var qtdTotalMetros;
  var msgErroCadPallet;

  var mascaraLargura = new MaskTextInputFormatter(
      mask: '##.###.###', filter: {"#": RegExp(r'[0-9]')});
  var mascaraComprimento = new MaskTextInputFormatter(
      mask: '**.***', filter: {"*": RegExp(r'[0-9]')});
  var mascaraEspessura = new MaskTextInputFormatter(mask: '##.###', filter: {
    "#": RegExp(r'[0-9]'),
  });

  // selecionar o tipo da medidas
  Axis direction = Axis.horizontal;

  var selectedRadio;
  var metroscubicos = false;
  var metrosQuadrados = false;
  var metrosCorridos = false;
  var lastro = false;

  int? idGrupoPedidos;
  bool? grupoPedidosCriado = false;

  double? tamanhoWidget01 = FieldsPedido.beneficiado == false ? 0.59 : 0.47;
  double? tamanhoWidget02 = FieldsPedido.beneficiado == false ? 0.78 : 0.78;

//====================================== FUNÇÕES DESENVOLVIDAS ==================================
//
  Future buscarDadosCliente() async {
    final response = await http.get(
        Uri.parse(
            ListarTodosClientes + ModelsUsuarios.caminhoBaseUser.toString()),
        headers: {"authorization": ModelsUsuarios.tokenAuth.toString()});
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      setState(() {
        itensLista2 = jsonData;
      });
    }

    if (response.statusCode == 401) {
      Navigator.pushNamed(context, '/login');
    }
  }

  Future buscarDadosUndMedida() async {
    final response = await http.get(
        Uri.parse(
            ListarTodosUndMedida + ModelsUsuarios.caminhoBaseUser.toString()),
        headers: {"authorization": ModelsUsuarios.tokenAuth.toString()});
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      setState(() {
        itensListaUndMedida = jsonData;
      });
    }

    if (response.statusCode == 401) {
      Navigator.pushNamed(context, '/login');
    }
  }

  Future buscarDadosProduto() async {
    final response = await http.get(
        Uri.parse(
            ListarTodosProdutos + ModelsUsuarios.caminhoBaseUser.toString()),
        headers: {"authorization": ModelsUsuarios.tokenAuth.toString()});
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      setState(() {
        itensListaProduto = jsonData;
      });
    }

    if (response.statusCode == 401) {
      Navigator.pushNamed(context, '/login');
    }
  }

  Future buscarDadosPallet() async {
    final response = await http.get(
        Uri.parse(
            ListarTodosOsPallet + ModelsUsuarios.caminhoBaseUser.toString()),
        headers: {"authorization": ModelsUsuarios.tokenAuth.toString()});
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      setState(() {
        itensListaPallet = jsonData;
      });
    }

    if (response.statusCode == 401) {
      Navigator.pushNamed(context, '/login');
    }
  }

  Future buscarDadosMadeira() async {
    final response = await http.get(
        Uri.parse(
            ListarTodasMadeiras + ModelsUsuarios.caminhoBaseUser.toString()),
        headers: {"authorization": ModelsUsuarios.tokenAuth.toString()});
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      setState(() {
        itensListaMadeira = jsonData;
      });
    }

    if (response.statusCode == 401) {
      Navigator.pushNamed(context, '/login');
    }
  }

  clientejaescolhido() {
    if (EdicaoGrupoPedidos.clienteescolhido == false) {
      clienteescolhido = false;
      grupoPedidosCriado = true;
      idCliente = EdicaoGrupoPedidos.idCliente;
      idGrupoPedidos = ConstantePedidos.idGrupoPedidos;
    }
  }

  calculaQtdPorMetroscubicos() {
    var valorTotal;
    var quebraCaracteres;
    var resultQtd;

    setState(() {
      var precoMetroCubido = double.parse(controllerPrecoUndMedida.text
          .replaceAll('.', '')
          .replaceAll(',', '.'));
      var qtdMetrosCubicos = double.tryParse(controllerQuantidade.text);
      var espessura = double.tryParse(controllerEspessura.text); // / 100;
      var largura = double.tryParse(controllerLargura.text); // / 100;
      var comprimento = double.tryParse(controllerComprimento.text);

      resultQtd = (qtdMetrosCubicos! / (espessura! * largura! * comprimento!));

      quebraCaracteres =
          resultQtd.toString().substring(resultQtd.toString().indexOf('.'));

      if (quebraCaracteres.toString().length > 2) {
        qtdTotalMetros = resultQtd.toStringAsFixed(2);
      } else {
        qtdTotalMetros = resultQtd;
      }

      valorTotal = precoMetroCubido * qtdMetrosCubicos;

      controllerTotalMetrosMadeira.text =
          resultQtd.toStringAsFixed(2).toString();

      controllerValorTotal.text = (valorTotal.toStringAsFixed(2)).toString();
    });
  }

  calculaMetroscubicosPorQtd() {
    var valorTotal;
    var metrosCubicos;

    setState(() {
      var precoMetroCubido = double.parse(controllerPrecoUndMedida.text
          .replaceAll('.', '')
          .replaceAll(',', '.'));
      var quantidade = double.tryParse(controllerQuantidade.text);
      var espessura = double.tryParse(controllerEspessura.text); // / 100;
      var largura = double.tryParse(controllerLargura.text); // / 100;
      var comprimento = double.tryParse(controllerComprimento.text);

      metrosCubicos = (quantidade! * (espessura! * largura! * comprimento!));

      if (metrosCubicos.toString().length >= 4) {
        if (metrosCubicos.toString().substring(0, 4) == ".000") {
          qtdTotalMetros = metrosCubicos.toStringAsFixed(2);
        } else if (metrosCubicos.toString().length > 2) {
          qtdTotalMetros = metrosCubicos.toStringAsFixed(3);
        }
      } else {
        qtdTotalMetros = metrosCubicos;
      }

      valorTotal = precoMetroCubido * metrosCubicos;

      controllerTotalMetrosMadeira.text = qtdTotalMetros.toString();

      controllerValorTotal.text = (valorTotal.toStringAsFixed(2)).toString();
    });
  }

  calculaMetrosQuadrados() {
    var valorTotal;
    setState(() {
      var precoMetroQuadrado = double.parse(controllerPrecoUndMedida.text
          .replaceAll('.', '')
          .replaceAll(',', '.'));
      var metrosQuadrados;
      // var espessura = double.tryParse(controllerEspessura.text) / 100;
      var largura = double.tryParse(controllerLargura.text);
      var comprimento = double.tryParse(controllerComprimento.text);

      metrosQuadrados = (largura! * comprimento!);
      qtdTotalMetros = metrosQuadrados.toStringAsFixed(2);

      valorTotal = precoMetroQuadrado * metrosQuadrados;

      controllerTotalMetrosMadeira.text = qtdTotalMetros.toString();

      controllerValorTotal.text = (valorTotal.toStringAsFixed(2)).toString();
    });
  }

  calculoLastro() {
    // CALCULO:
    // QUANTIDADE(UNIDADE) * (ESPESSURA(CENTIMETROS) * LARGURA(METROS) * COMPRIMENTO(METROS))
    var valorTotal;
    var metrosCubicos;
    var precoMetroCubido;

    setState(() {
      precoMetroCubido = double.parse(controllerPrecoUndMedida.text
          .replaceAll('.', '')
          .replaceAll(',', '.'));

      var quantidade = double.tryParse(controllerQuantidade.text);
      var espessura = double.tryParse(controllerEspessura.text); // / 100;
      var largura = double.tryParse(controllerLargura.text);
      var comprimento = double.tryParse(controllerComprimento.text);

      metrosCubicos = (quantidade! * (espessura! * largura! * comprimento!));

      if (metrosCubicos.toString().length >= 4) {
        if (metrosCubicos.toString().substring(0, 4) == ".000") {
          qtdTotalMetros = metrosCubicos.toStringAsFixed(2);
        } else if (metrosCubicos.toString().length > 2) {
          qtdTotalMetros = metrosCubicos.toStringAsFixed(3);
        }
      } else {
        qtdTotalMetros = metrosCubicos;
      }

      valorTotal = precoMetroCubido * metrosCubicos;

      controllerTotalMetrosMadeira.text = qtdTotalMetros.toString();

      controllerValorTotal.text = (valorTotal.toStringAsFixed(2)).toString();
    });
  }

  calculoMetrosCorridos() {
    var valorTotal;
    var metrosCubicos;
    var precoMetroCubido;

    setState(() {
      precoMetroCubido = double.parse(controllerPrecoUndMedida.text
          .replaceAll('.', '')
          .replaceAll(',', '.'));

      var quantidade = double.tryParse(controllerQuantidade.text);

      metrosCubicos = quantidade;

      qtdTotalMetros = metrosCubicos.toStringAsFixed(3);

      if (precoMetroCubido != null)
        valorTotal = precoMetroCubido * metrosCubicos;

      controllerTotalMetrosMadeira.text = qtdTotalMetros.toString();

      controllerValorTotal.text = (valorTotal.toStringAsFixed(2)).toString();
    });
  }

  calculoQtdVesesPreco() {
    var valorTotal;
    var quantidade;
    var precoPorUnd;

    setState(() {
      precoPorUnd = double.parse(controllerPrecoUndMedida.text
          .replaceAll('.', '')
          .replaceAll(',', '.'));

      quantidade = double.tryParse(controllerQuantidade.text);

      valorTotal = precoPorUnd * quantidade;

      controllerValorTotal.text = (valorTotal.toStringAsFixed(2)).toString();
    });
  }

  popupValidaCadPallet(msgErroCadPallet) {
    MsgPopup().msgFeedback(
      context,
      msgErroCadPallet,
      '',
    );
  }

//valida os campos do pallet
  validarcamposPallet() {
    if (idPallet == null) {
      popupValidaCadPallet('Escolha um tipo de pallet para o cadastro!');
    } else if (controllerQuantidade.text.isEmpty) {
      popupValidaCadPallet('É preciso inserir uma quantidade!');
    } else if (controllerPrecoUndMedida.text.isEmpty) {
      popupValidaCadPallet('Insira o preço unitário por pallet!');
    } else if (idMadeira == null) {
      MsgPopup().msgFeedback(
          context, '\nO Tipo da madeira precisa ser preenchido!', '');
    } else {
      submitForm();
    }
  }

  //valida os campos do madeira processada
  validarCamposMadeiraProcessada() {
    if (idMadeira == null) {
      MsgPopup().msgFeedback(context,
          '\nO Tipo da madeira não pode ficar vazio', 'Tipo da madeira!');
    } else if (controllerPrecoUndMedida.text == '0,00') {
      MsgPopup().msgFeedback(context,
          '\nO preço por metro cúbico não foi preenchido', 'Preço cúbico!');
    } else if (idProduto == null) {
      MsgPopup()
          .msgFeedback(context, '\nO produto não foi preenchido', 'Produto!');
    } else if (idUnidadeMedida != 2 && controllerQuantidade.text.isEmpty) {
      MsgPopup().msgFeedback(
          context, '\nA quantidade não pode ficar vazia', 'quantidade!');
    } else if ((idUnidadeMedida != 3) && controllerComprimento.text.isEmpty) {
      MsgPopup().msgFeedback(context,
          '\nO comprimento da madeira precisa ser selecionado', 'Comprimento!');
    } else if (idUnidadeMedida != 3 && controllerLargura.text.isEmpty) {
      MsgPopup()
          .msgFeedback(context, '\nA largura não pode ficar vazia', 'largura!');
    } else if ((idUnidadeMedida != 2 && idUnidadeMedida != 3) &&
        controllerEspessura.text.isEmpty) {
      MsgPopup().msgFeedback(
          context, '\nA espessura não pode ficar vazia', 'espessura!');
    } else {
      submitForm();
    }
  }

  confereCamposParte01Cadastro(context) {
    if (beneficiadoNao == false && beneficiadoSim == false) {
      MsgPopup().msgFeedback(
          context,
          '\n É preciso escolher uma opção do pedido beneficiado!',
          'Pedido beneficiado?');
    } else if (idMadeira == null) {
      MsgPopup().msgFeedback(context,
          '\nO Tipo da madeira não pode ficar vazio!', 'Tipo da madeira');
    } else if (idUnidadeMedida == null && opcPedidoBeneficiado == false) {
      MsgPopup().msgFeedback(
          context, '\n Escolha uma unidade de medida!', 'Unidade de medida');
    } else if (idProduto == null) {
      MsgPopup()
          .msgFeedback(context, '\nO produto não foi preenchido!', 'Produto');
    } else {
      setState(() {
        parte02Cadastro = true;
        parte01Cadastro = false;
      });
    }
  }

// ================================== CADASTROS DE REGISTROS ====================================
  salvarPedidoMadeira(BuildContext context) async {
    // var valorTotal = controllerValorTotal.text.replaceAll('RS: ', ' ');
    var bodyy = jsonEncode(
      {
        'idgrupo_pedido': idGrupoPedidos,
        'idproduto': idProduto,
        'idunidade_medida': idUnidadeMedida,
        'idmadeira': idMadeira,
        "idpallet": null,
        'comprimento': controllerComprimento.text == 'null' ||
                controllerEspessura.text == ''
            ? null
            : double.parse(controllerComprimento.text),
        'largura':
            controllerLargura.text == 'null' || controllerEspessura.text == ''
                ? null
                : double.parse(controllerLargura.text),
        'espessura':
            controllerEspessura.text == 'null' || controllerEspessura.text == ''
                ? null
                : double.parse(controllerEspessura.text),
        'quantidade': opcPedidoBeneficiado == false && calcMetroCubico == true
            ? qtdTotalMetros
            : calcMetroCubico == false && controllerQuantidade.text != ''
                ? double.parse(controllerQuantidade.text)
                : null,
        'preco_metro': controllerPrecoUndMedida.text, //precoMetroCubido,
        'valor_total':
            controllerValorTotal.text.replaceAll('RS: ', ''), // valorTotal,
        'qtd_metros': opcPedidoBeneficiado == false && calcMetroCubico == true
            ? double.parse(controllerQuantidade.text)
            : qtdTotalMetros != 'null' || qtdTotalMetros != ''
                ? qtdTotalMetros
                : null,
        'observacoes': controllerObservacao.text,
        'tipo_calculo': tipoCalculo,
        'tipo_processo': opcTipoProcesso,
        'beneficiado': opcPedidoBeneficiado,
      },
    );

    var state = await http.put(
     Uri.parse(EditarumPedido +
          FieldsPedido.idPedido.toString() +
          '/' +
          ModelsUsuarios.caminhoBaseUser.toString()),
      headers: {
        "Content-Type": "application/json",
        "authorization": ModelsUsuarios.tokenAuth.toString()
      },
      body: bodyy,
    );
    print(bodyy);
    if (state.statusCode == 201) {
      // Get.to(GrupoPedidosCadastrados());
      Get.back();
    } else if (state.statusCode == 401) {
      Navigator.pushNamed(context, '/login');
    }
  }

  submitForm() {
    if (madeiraProcessada == true) {
      salvarPedidoMadeira(context);
      Navigator.pop(context);
    } else if (pallet == true) {
      salvarPedidoPallet();
    }
  }

  salvarPedidoPallet() async {
    // pegardata();
    var bodyy = jsonEncode(
      {
        'idusuario': ModelsUsuarios.idDoUsuario,
        'idgrupo_pedido': idGrupoPedidos,
        "idpallet": idPallet,
        "idmadeira": idMadeira,
        "quantidade": double.parse(controllerQuantidade.text),
        "preco_metro": controllerPrecoUndMedida.text,
        "valor_total": controllerValorTotal.text,
        "observacoes": controllerObservacao.text,
        'idproduto': null,
        'idunidade_medida': null,
        'comprimento': null,
        'largura': null,
        'espessura': null,
        'qtd_metros': null,
        'tipo_calculo': null,
        'tipo_processo': null,
        'beneficiado': null,
      },
    );

    http.Response state = await http.put(
      Uri.parse(EditarumPedido +
          FieldsPedido.idPedido.toString() +
          '/' +
          ModelsUsuarios.caminhoBaseUser.toString()),
      headers: {
        "Content-Type": "application/json",
        "authorization": ModelsUsuarios.tokenAuth.toString()
      },
      body: bodyy,
    );

    print(state.statusCode);

    if (state.statusCode == 201) {
      ConstantePedidos.cadastraroGrupo = true;
      Get.back();
    } else if (state.statusCode == 401) {
      Navigator.pushNamed(context, '/login');
    }
  }

// ====================================== COMPONENTIZAÇÃO DA TELA ======================================
  categoriaPallet(context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    Size size = mediaQuery.size;
    if (pallet == true) {
      return Container(
        child: Padding(
          padding: EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
          child: Container(
            decoration: BoxDecoration(
                // color: Colors.white,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.black, width: 1)),
            child: Column(
              children: [
                DropDownButton().dropDownButton(
                  'Opções de pallet:',
                  DropdownButton(
                    hint: Text(
                      'Pallet:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    value: idPallet,
                    items: itensListaPallet.map(
                      (categoria) {
                        return DropdownMenuItem(
                          value: (categoria['idpallet']),
                          child: Row(
                            children: [
                              Text(
                                categoria['idpallet'].toString(),
                                style: TextStyle(fontSize: 18),
                              ),
                              Text(
                                ' - ',
                                style: TextStyle(fontSize: 18),
                              ),
                              Text(
                                nomePallet = categoria['nome'].toString(),
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
                          idPallet = value as int;
                        },
                      );
                    },
                  ),
                  marginTop: 0.035,
                  backgroundColor: Colors.white.withOpacity(0.9),
                ),
                //--------------------------------------------------------
                DropDownButton().dropDownButton(
                  'Tipo de madeira',
                  DropdownButton(
                    hint: Text(
                      'Madeira:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    value: idMadeira,
                    items: itensListaMadeira.map(
                      (categoria) {
                        return DropdownMenuItem(
                          value: (categoria['idmadeira']),
                          child: Row(
                            children: [
                              Text(
                                categoria['idmadeira'].toString(),
                                style: TextStyle(fontSize: 18),
                              ),
                              Text(
                                ' - ',
                                style: TextStyle(fontSize: 18),
                              ),
                              Text(
                                nomeMadeira = categoria['nome'].toString(),
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
                          idMadeira = value as int;
                        },
                      );
                    },
                  ),
                  marginTop: 0.025,
                  backgroundColor: Colors.white.withOpacity(0.9),
                ),
                //--------------------------------------------------------
                Padding(
                  padding: EdgeInsets.only(top: size.height * 0.01),
                  child: CampoText().textField(
                    controllerQuantidade,
                    'Quantidade:',
                    tipoTexto: TextInputType.number,
                    backgroundColor: Colors.white.withOpacity(0.9),
                    icone: Icons.format_list_numbered_outlined,
                    onChanged: () {
                      calculoQtdVesesPreco();
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: size.height * 0.001),
                  child: CampoText().textField(
                    controllerPrecoUndMedida,
                    'Preço por pallet: ',
                    tipoTexto: TextInputType.number,
                    onChanged: () {
                      calculoQtdVesesPreco();
                    },
                    // corTexto: Colors.green[600],
                    icone: Icons.local_atm_outlined,
                    backgroundColor: Colors.white.withOpacity(0.9),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: size.height * 0.001),
                  child: CampoText().textField(
                    controllerValorTotal,
                    'Valor total',
                    tipoTexto: TextInputType.text,
                    enabled: false,
                    corTexto: Colors.green[600],
                    icone: Icons.attach_money,
                    backgroundColor: Colors.white.withOpacity(0.9),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: size.height * 0.01),
                  child: CampoText().textField(
                    controllerObservacao,
                    'Observações:',
                    tipoTexto: TextInputType.text,
                    backgroundColor: Colors.white.withOpacity(0.9),
                    icone: Icons.message_sharp,
                    minLines: 3,
                    maxLines: 4,
                    maxLength: 100,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: size.height * 0.02),
                  child: Botao().botaoPadrao('Salvar', () async {
                    opcPedidoBeneficiado = null;
                    tipoCalculo = null;
                    opcTipoProcesso = null;
                    qtdTotalMetros = null;
                    controllerEspessura.text = '';
                    controllerLargura.text = '';
                    controllerComprimento.text = '';
                    idUnidadeMedida = null;
                    idProduto = null;
                    await validarcamposPallet();
                  }, comprimento: size.width * 0.5),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return Container();
    }
  }

//mostra os widgets caso a madeira processada for escolhida
  escolhasMadeiraProcessada(context) {
    if (madeiraProcessada == true) {
      return SingleChildScrollView(
        child: Column(
          children: [
            CheckBox().checkBoxDuasOpcoes(
              context,
              'Pedido beneficiado?',
              'Não',
              'Sim',
              beneficiadoNao,
              beneficiadoSim,
              () => {
                setState(
                  () {
                    tamanhoWidget01 = 0.59;
                    tamanhoWidget02 = 0.78;
                    beneficiadoNao = true;
                    beneficiadoSim = false;
                    opcPedidoBeneficiado = false;
                    processoPersonalizado = false;
                    processoBruto = false;
                    opcTipoProcesso = null;
                  },
                ),
              },
              () => {
                setState(
                  () {
                    tamanhoWidget01 = 0.47;
                    tamanhoWidget02 = 0.78;
                    beneficiadoSim = true;
                    beneficiadoNao = false;
                    opcPedidoBeneficiado = true;
                    idUnidadeMedida = null;
                    controllerTotalMetrosMadeira.text = '';
                    qtdTotalMetros = null;
                  },
                ),
              },
              marginLeft: 0.013,
              marginTop: 0.025,
              distanciaTituloDosChecks: 0.005,
              backgroundColor: Colors.white.withOpacity(0.9),
            ),
            DropDownButton().dropDownButton(
              'Tipo de madeira',
              DropdownButton(
                hint: Text(
                  'Madeira:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                value: idMadeira,
                items: itensListaMadeira.map(
                  (categoria) {
                    return DropdownMenuItem(
                      value: (categoria['idmadeira']),
                      child: Row(
                        children: [
                          Text(
                            categoria['idmadeira'].toString(),
                            style: TextStyle(fontSize: 18),
                          ),
                          Text(
                            ' - ',
                            style: TextStyle(fontSize: 18),
                          ),
                          Text(
                            nomeMadeira = categoria['nome'].toString(),
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
                      idMadeira = value as int;
                    },
                  );
                },
              ),
              marginTop: 0.025,
              backgroundColor: Colors.white.withOpacity(0.9),
            ),
            //-------------------------------------------------------
            DropDownButton().dropDownButton(
              'Produto',
              DropdownButton(
                hint: Text(
                  'Produto de venda:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                value: idProduto,
                items: itensListaProduto.map(
                  (categoria) {
                    return DropdownMenuItem(
                      value: (categoria['idproduto']),
                      child: Row(
                        children: [
                          Text(
                            categoria['idproduto'].toString(),
                            style: TextStyle(fontSize: 18),
                          ),
                          Text(
                            ' - ',
                            style: TextStyle(fontSize: 18),
                          ),
                          Text(
                            nomeUndMedida = categoria['nome'].toString(),
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
                      idProduto = value as int;
                    },
                  );
                },
              ),
              marginTop: 0.025,
              backgroundColor: Colors.white.withOpacity(0.9),
            ),
            //-------------------------------------------------------
            if (opcPedidoBeneficiado == false)
              DropDownButton().dropDownButton(
                'Unidade de medida',
                DropdownButton(
                  hint: Text(
                    'Unidade de medida:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  value: idUnidadeMedida,
                  items: itensListaUndMedida.map(
                    (categoria) {
                      return DropdownMenuItem(
                        value: (categoria['idunidade_medida']),
                        child: Row(
                          children: [
                            Text(
                              categoria['idunidade_medida'].toString(),
                              style: TextStyle(fontSize: 18),
                            ),
                            Text(
                              ' - ',
                              style: TextStyle(fontSize: 18),
                            ),
                            Text(
                              nomeUndMedida = categoria['nome'].toString(),
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
                        idUnidadeMedida = value as int;
                        controllerQuantidade.text = '';
                        controllerLargura.text = '';
                        controllerEspessura.text = '';
                        controllerPrecoUndMedida.text = '';
                        controllerValorTotal.text = '';
                        controllerComprimento.text = '';
                        controllerTotalMetrosMadeira.text = '';
                        calcQuantidade = false;
                        calcMetroCubico = false;
                        tipoCalculo = null;
                        if (idUnidadeMedida == 3) {
                          tamanhoWidget02 = 0.45;
                        } else if (idUnidadeMedida == 2) {
                          tamanhoWidget02 = 0.62;
                        } else {
                          tamanhoWidget02 = 0.78;
                        }
                      },
                    );
                  },
                ),
                marginTop: 0.025,
                backgroundColor: Colors.white.withOpacity(0.9),
              ),
          ],
        ),
      );
    } else
      return Container();
  }

  categoriaMadeiraProcessada(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    Size size = mediaQuery.size;
    if (madeiraProcessada == true && opcPedidoBeneficiado == false) {
      return Container(
        child: Column(
          children: [
            if (idUnidadeMedida == 1)
              CheckBox().checkBoxDuasOpcoes(
                context,
                'Pedido por:',
                'Metros cúbicos',
                'Quantidade',
                calcMetroCubico,
                calcQuantidade,
                () {
                  setState(() {
                    calcMetroCubico = true;
                    calcQuantidade = false;
                    tipoCalculo = 1;
                    if (controllerQuantidade.text.isNotEmpty &&
                        controllerEspessura.text.isNotEmpty &&
                        controllerLargura.text.isNotEmpty &&
                        controllerComprimento.text.isNotEmpty &&
                        controllerPrecoUndMedida.text.isNotEmpty) {
                      calculaQtdPorMetroscubicos();
                    }
                  });
                },
                () {
                  setState(() {
                    calcQuantidade = true;
                    calcMetroCubico = false;
                    tipoCalculo = 2;
                    if (controllerQuantidade.text.isNotEmpty &&
                        controllerEspessura.text.isNotEmpty &&
                        controllerLargura.text.isNotEmpty &&
                        controllerComprimento.text.isNotEmpty &&
                        controllerPrecoUndMedida.text.isNotEmpty) {
                      calculaMetroscubicosPorQtd();
                    }
                  });
                },
                distanciaTituloDosChecks: 0.00,
                marginTop: 0.01,
                marginBottom: 0.015,
                backgroundColor: Colors.white.withOpacity(0.9),
              ),
            if (idUnidadeMedida == 4 ||
                idUnidadeMedida == 3 ||
                idUnidadeMedida == 1)
              Padding(
                padding: EdgeInsets.only(top: size.height * 0.001),
                child: CampoText().textField(
                  controllerQuantidade,
                  idUnidadeMedida == 3
                      ? 'Metros corridos'
                      : calcMetroCubico == true
                          ? 'Metros cúbicos'
                          : 'Quantidade:',
                  tipoTexto: TextInputType.number,
                  onChanged: () {
                    idUnidadeMedida == 4
                        ? calculoLastro()
                        : idUnidadeMedida == 3
                            ? calculoMetrosCorridos()
                            : calcMetroCubico == true
                                ? calculaQtdPorMetroscubicos()
                                : calcQuantidade == true
                                    ? calculaMetroscubicosPorQtd()
                                    : null;
                  },
                  icone: Icons.arrow_right_alt,
                  backgroundColor: Colors.white.withOpacity(0.9),
                ),
              ),
            if (idUnidadeMedida != 3 && idUnidadeMedida != 2)
              Padding(
                padding: EdgeInsets.only(top: size.height * 0.001),
                child: CampoText().textField(
                  controllerEspessura,
                  'Espessura',
                  tipoTexto: TextInputType.number,
                  onChanged: () {
                    idUnidadeMedida == 4
                        ? calculoLastro()
                        : idUnidadeMedida == 3
                            ? calculoMetrosCorridos()
                            : idUnidadeMedida == 2
                                ? calculaMetrosQuadrados()
                                : calcMetroCubico == true
                                    ? calculaQtdPorMetroscubicos()
                                    : calcQuantidade == true
                                        ? calculaMetroscubicosPorQtd()
                                        : null;
                  },
                  icone: Icons.arrow_upward,
                  backgroundColor: Colors.white.withOpacity(0.9),
                ),
              ),
            if (idUnidadeMedida != 3)
              Padding(
                padding: EdgeInsets.only(top: size.height * 0.001),
                child: CampoText().textField(
                  controllerLargura,
                  idUnidadeMedida == 2 ? 'Altura' : 'Largura:',
                  tipoTexto: TextInputType.number,
                  onChanged: () {
                    idUnidadeMedida == 4
                        ? calculoLastro()
                        : idUnidadeMedida == 3
                            ? calculoMetrosCorridos()
                            : idUnidadeMedida == 2
                                ? calculaMetrosQuadrados()
                                : calcMetroCubico == true
                                    ? calculaQtdPorMetroscubicos()
                                    : calcQuantidade == true
                                        ? calculaMetroscubicosPorQtd()
                                        : null;
                  },
                  icone: Icons.aspect_ratio_sharp,
                  backgroundColor: Colors.white.withOpacity(0.9),
                ),
              ),
            if (idUnidadeMedida != 3)
              Padding(
                padding: EdgeInsets.only(top: size.height * 0.001),
                child: CampoText().textField(
                  controllerComprimento,
                  'Comprimento',
                  tipoTexto: TextInputType.number,
                  onChanged: () {
                    idUnidadeMedida == 4
                        ? calculoLastro()
                        : idUnidadeMedida == 2
                            ? calculaMetrosQuadrados()
                            : calcMetroCubico == true
                                ? calculaQtdPorMetroscubicos()
                                : calcQuantidade == true
                                    ? calculaMetroscubicosPorQtd()
                                    : null;
                  },
                  icone: Icons.arrow_right_alt,
                  backgroundColor: Colors.white.withOpacity(0.9),
                ),
              ),
            Padding(
              padding: EdgeInsets.only(top: size.height * 0.001),
              child: CampoText().textField(
                controllerPrecoUndMedida,
                idUnidadeMedida == 4
                    ? 'Preço por metro cúbico'
                    : idUnidadeMedida == 3
                        ? 'Preço por metro corrido'
                        : idUnidadeMedida == 2
                            ? 'Preço por metro quadrado'
                            : idUnidadeMedida == 1
                                ? 'Preço por metro cúbico'
                                : 'Preço por metro',
                tipoTexto: TextInputType.number,
                onChanged: () {
                  idUnidadeMedida == 4
                      ? calculoLastro()
                      : idUnidadeMedida == 3
                          ? calculoMetrosCorridos()
                          : idUnidadeMedida == 2
                              ? calculaMetrosQuadrados()
                              : calcMetroCubico == true
                                  ? calculaQtdPorMetroscubicos()
                                  : calcQuantidade == true
                                      ? calculaMetroscubicosPorQtd()
                                      : null;
                },
                corTexto: Colors.green[600],
                icone: Icons.local_atm_outlined,
                backgroundColor: Colors.white.withOpacity(0.9),
              ),
            ),
            if (idUnidadeMedida == 1 ||
                idUnidadeMedida == 2 ||
                idUnidadeMedida == 4)
              Padding(
                padding: EdgeInsets.only(top: size.height * 0.001),
                child: CampoText().textField(
                  controllerTotalMetrosMadeira,
                  idUnidadeMedida == 4
                      ? 'Metros cúbicos'
                      : idUnidadeMedida == 2
                          ? 'Metros quadrados'
                          : calcQuantidade == true
                              ? 'Metros cúbicos'
                              : calcMetroCubico == true
                                  ? 'Quantidade de peças'
                                  : 'Quantidade de metros',
                  tipoTexto: TextInputType.text,
                  enabled: false,
                  corTexto: Colors.green[600],
                  icone: Icons.app_registration,
                  backgroundColor: Colors.white.withOpacity(0.9),
                ),
              ),
            Padding(
              padding: EdgeInsets.only(top: size.height * 0.001),
              child: CampoText().textField(
                controllerValorTotal,
                'Valor total',
                tipoTexto: TextInputType.text,
                enabled: false,
                corTexto: Colors.green[600],
                icone: Icons.attach_money,
                backgroundColor: Colors.white.withOpacity(0.9),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: size.height * 0.001),
              child: CampoText().textField(
                controllerObservacao,
                'Observações',
                tipoTexto: TextInputType.text,
                icone: Icons.comment,
                backgroundColor: Colors.white.withOpacity(0.9),
              ),
            ),
            SizedBox(height: 20),
            Botao().botaoAnimacaoLoading(
              context,
              onTap: () {
                validarCamposMadeiraProcessada();
              },
            ),
            SizedBox(height: 5),
          ],
        ),
      );
    } else
      return Container();
  }

  pedidoBeneficiado(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    Size size = mediaQuery.size;
    if (madeiraProcessada == true && opcPedidoBeneficiado == true) {
      return Container(
        child: Column(
          children: [
            CheckBox().checkBoxDuasOpcoes(
              context,
              'Tipo do processo:',
              'Bruto',
              'Personalizado',
              processoBruto,
              processoPersonalizado,
              () => {
                setState(
                  () {
                    processoBruto = true;
                    processoPersonalizado = false;
                    opcTipoProcesso = 'Bruto';
                  },
                ),
              },
              () => {
                setState(
                  () {
                    processoPersonalizado = true;
                    processoBruto = false;
                    opcTipoProcesso = 'Personalizado';
                  },
                ),
              },
              marginLeft: 0.02,
              distanciaTituloDosChecks: 0.005,
              backgroundColor: Colors.white.withOpacity(0.9),
            ),
            Padding(
              padding: EdgeInsets.only(top: size.height * 0.005),
              child: CampoText().textField(
                controllerQuantidade,
                'Quantidade:',
                tipoTexto: TextInputType.number,
                onChanged: () {
                  calculoQtdVesesPreco();
                },
                icone: Icons.arrow_right_alt,
                backgroundColor: Colors.white.withOpacity(0.9),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: size.height * 0.003),
              child: CampoText().textField(
                controllerEspessura,
                'Espessura:',
                tipoTexto: TextInputType.number,
                onChanged: () {
                  calculoQtdVesesPreco();
                },
                icone: Icons.arrow_upward,
                backgroundColor: Colors.white.withOpacity(0.9),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: size.height * 0.003),
              child: CampoText().textField(
                controllerLargura,
                idUnidadeMedida == 2 ? 'Altura:' : 'Largura:',
                tipoTexto: TextInputType.number,
                onChanged: () {
                  calculoQtdVesesPreco();
                },
                icone: Icons.aspect_ratio_sharp,
                backgroundColor: Colors.white.withOpacity(0.9),
              ),
            ),
            if (idUnidadeMedida != 3)
              Padding(
                padding: EdgeInsets.only(top: size.height * 0.003),
                child: CampoText().textField(
                  controllerComprimento,
                  'Comprimento:',
                  tipoTexto: TextInputType.number,
                  onChanged: () {
                    calculoQtdVesesPreco();
                  },
                  icone: Icons.arrow_right_alt,
                  backgroundColor: Colors.white.withOpacity(0.9),
                ),
              ),
            Padding(
              padding: EdgeInsets.only(top: size.height * 0.003),
              child: CampoText().textField(
                controllerPrecoUndMedida,
                'Preço por quantidade:',
                tipoTexto: TextInputType.number,
                onChanged: () {
                  calculoQtdVesesPreco();
                },
                corTexto: Colors.green[600],
                icone: Icons.local_atm_outlined,
                backgroundColor: Colors.white.withOpacity(0.9),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: size.height * 0.003),
              child: CampoText().textField(
                controllerValorTotal,
                'Valor total:',
                tipoTexto: TextInputType.text,
                enabled: false,
                corTexto: Colors.green[600],
                icone: Icons.attach_money,
                backgroundColor: Colors.white.withOpacity(0.9),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: size.height * 0.003),
              child: CampoText().textField(
                controllerObservacao,
                'Observações',
                tipoTexto: TextInputType.text,
                icone: Icons.comment,
                backgroundColor: Colors.white.withOpacity(0.9),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: size.height * 0.01),
              child: Botao().botaoPadrao(
                'Salvar',
                () => {
                  validarCamposMadeiraProcessada(),
                },
              ),
            ),
          ],
        ),
      );
    } else
      return Container();
  }

  escolherProduto(context) {
    if (grupoPedidosCriado == true) {
      return CheckBox().checkBoxDuasOpcoes(
        context,
        'Tipo de Produto',
        'Pallet',
        'Madeira Processada',
        pallet,
        madeiraProcessada,
        () => {
          setState(
            () {
              madeiraProcessada = false;
              pallet = true;
              // tamanhoWidget01 = 0.11;
              // tamanhoWidget02 = 0.40;
              controllerQuantidade.text = '';
              controllerPrecoUndMedida.text = '';
              controllerValorTotal.text = '';
            },
          ),
        },
        () => {
          setState(
            () {
              madeiraProcessada = true;
              pallet = false;
              idPallet = null;
              beneficiadoSim = false;
              beneficiadoNao = false;
              // tamanhoWidget01 = 0.59;
              controllerQuantidade.text = '';
              controllerPrecoUndMedida.text = '';
              controllerValorTotal.text = '';
            },
          ),
        },
        marginBottom: 0.0,
        marginLeft: 0.013,
        marginTop: 0.02,
        distanciaTituloDosChecks: 0.005,
        backgroundColor: Colors.white.withOpacity(0.9),
      );
    } else {
      return Container();
    }
  }

//chama a função buscar dados ao iniciar a tela
  @override
  void initState() {
    super.initState();
    this.buscarDadosCliente();
    this.buscarDadosPallet();
    this.clientejaescolhido();
    this.buscarDadosUndMedida();
    this.buscarDadosProduto();
    this.buscarDadosMadeira();
    controllerPrecoUndMedida.text = FieldsPedido.precoMetro.toString();
    controllerValorTotal.text = FieldsPedido.valorTotal.toString();
    controllerTotalMetrosMadeira.text = FieldsPedido.tipoCalculo == 1
        ? FieldsPedido.quantidade.toString()
        : FieldsPedido.qtdMetros.toString();
    controllerEspessura.text = FieldsPedido.espessura.toString();
    controllerQuantidade.text = FieldsPedido.tipoCalculo == 1
        ? FieldsPedido.qtdMetros.toString()
        : FieldsPedido.quantidade.toString();
    controllerLargura.text = FieldsPedido.largura.toString();
    controllerComprimento.text = FieldsPedido.comprimento.toString();
    qtdTotalMetros = controllerTotalMetrosMadeira.text;
  }

  @override
  Widget build(BuildContext context) {
    // navigatorKey: navigatorKey,
    MediaQueryData mediaQuery = MediaQuery.of(context);
    Size size = mediaQuery.size;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            height: size.height,
            width: size.width,
            color: Colors.green[200],
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Cabecalho().tituloCabecalho(
                    context,
                    'Edição do Pedido',
                    iconeVoltar: parte01Cadastro == true ? true : false,
                    sizeTextTitulo: 0.065,
                    marginBottom: 0.015,
                  ),
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        if (parte01Cadastro == true)
                          Padding(
                            padding: EdgeInsets.only(
                              left: size.width * 0.02,
                              right: size.width * 0.02,
                              bottom: size.height * 0.01,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                escolherProduto(context),
                                escolhasMadeiraProcessada(context),
                              ],
                            ),
                          ),
                        if (madeiraProcessada == true &&
                            parte02Cadastro == false)
                          SizedBox(height: size.height * 0.05),
                        if (madeiraProcessada == true &&
                            parte02Cadastro == false)
                          GestureDetector(
                            onTap: () {
                              confereCamposParte01Cadastro(context);
                            },
                            child: Container(
                              width: 100,
                              height: 50,
                              child: Center(
                                child: Icon(
                                  Icons.arrow_forward_outlined,
                                  size: 45,
                                ),
                              ),
                              decoration: BoxDecoration(
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                      color: Colors.black.withOpacity(0.5),
                                      offset: Offset(3.0, 5.0),
                                      blurRadius: 7)
                                ],
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.transparent,
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                        if (parte02Cadastro == true || pallet == true)
                          Container(
                            padding: EdgeInsets.only(
                              left: size.width * 0.02,
                              right: size.width * 0.02,
                              top: idUnidadeMedida == 2
                                  ? size.height * 0.07
                                  : idUnidadeMedida == 3
                                      ? size.height * 0.15
                                      : 0,
                            ),
                            alignment: Alignment.bottomCenter,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                categoriaPallet(context),
                                categoriaMadeiraProcessada(context),
                                pedidoBeneficiado(context),
                              ],
                            ),
                          ),
                        SizedBox(height: size.height * 0.015),
                        if (parte02Cadastro == true)
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                parte02Cadastro = false;
                                parte01Cadastro = true;
                              });
                            },
                            child: Container(
                              width: 100,
                              height: 50,
                              child: Center(
                                child: Icon(
                                  Icons.arrow_back_rounded,
                                  size: 45,
                                ),
                              ),
                              decoration: BoxDecoration(
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                      color: Colors.black.withOpacity(0.5),
                                      offset: Offset(3.0, 5.0),
                                      blurRadius: 7)
                                ],
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.transparent,
                                  width: 2,
                                ),
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
        ),
      ),
    );
  }
}
