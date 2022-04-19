import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:intl/intl.dart';
import 'package:madecontrol_desenvolvimento/Widget/Cabecalho.dart';
import 'package:madecontrol_desenvolvimento/Widget/CheckBox.dart';
import 'package:madecontrol_desenvolvimento/Widget/DropDownButton.dart';
import 'package:madecontrol_desenvolvimento/models/constantes.dart';
import 'package:madecontrol_desenvolvimento/Widget/Botao.dart';
import 'package:madecontrol_desenvolvimento/Widget/MsgPopup.dart';
import 'package:madecontrol_desenvolvimento/Widget/TextField.dart';
import 'package:madecontrol_desenvolvimento/models/ClassesStaticas.dart';
import 'package:madecontrol_desenvolvimento/funcoes/FuncoesParaDatas.dart';
import 'package:madecontrol_desenvolvimento/models/Models_GrupoPedido.dart';
import 'package:madecontrol_desenvolvimento/models/Models_Usuario.dart';
import 'package:http/http.dart' as http;
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class CadastrarPedido extends StatefulWidget {
  @override
  CadastrarPedidoState createState() => CadastrarPedidoState();
}

class CadastrarPedidoState extends State<CadastrarPedido> {
  // ================================ VARIÁVEIS UTILIZADAS ==================================
  var ultimogrupocadastrado = <ModelsGrupoPedido>[];
  TextEditingController controllerLargura = TextEditingController();
  TextEditingController controllerComprimento = TextEditingController();
  TextEditingController controllerEspessura = TextEditingController();
  TextEditingController controllerQuantidade = TextEditingController();
  TextEditingController controllerNomePallet = TextEditingController();
  TextEditingController controllerPrecoUndMedida = MoneyMaskedTextController();
  TextEditingController controllerObservacao = TextEditingController();
  TextEditingController controllerValorTotal =
      MoneyMaskedTextController(leftSymbol: 'RS: ');
  TextEditingController controllerTotalMetrosMadeira = TextEditingController();
  NumberFormat formatter = NumberFormat.simpleCurrency();

  var parte01Cadastro = true;
  var parte02Cadastro = false;

  var opcTipoProcesso;
  bool? processoBruto = false;
  bool? processoPersonalizado = false;

  bool? opcPedidoBeneficiado = false;
  bool? beneficiadoSim = false;
  bool? beneficiadoNao = true;

  var dofCliente;

  var tipoVenda;
  bool? vendaBalcao = false;
  bool? vendaNormal = false;

  var tipoCalculo;
  bool? calcQuantidade = true;
  bool? calcMetroCubico = false;

  var dia;
  var mes;
  var ano;
  var tipoDeProduto;
  bool? pallet = false;
  bool? madeiraProcessada = false;

  List itensLista2 = [];
  int? idCliente;
  List itensListaPallet = [];
  int? idPallet;
  List itensListaUndMedida = [];
  int? idUnidadeMedida;
  String? nomeUndMedida;
  List itensListaProduto = [];
  int? idProduto;
  String? nomeProduto;
  List itensListaMadeira = [];
  int? idMadeira;
  String? nomeMadeira;
  bool? clienteescolhido = true;
  String? nomePallet;
  var qtdTotalMetros;
  var msgErroCadPallet;
  bool? isloadingPallet = false;
  bool? isloadingMadeiraProcessada = false;
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

  int? idGrupoPedidos = ConstantePedidos.idGrupoPedidos;

  double? tamanhoWidget01 = 0.12;
  double? tamanhoWidget02 = 0.41;

//====================================== FUNÇÕES DESENVOLVIDAS ==================================
//Busca a lista de clientes
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

  calculaQtdPorMetroscubicos() {
    var valorTotal;
    var quebraCaracteres;
    var resultQtd;
    var precoMetroCubido;
    setState(() {
      if (controllerPrecoUndMedida.text.length <= 6) {
        precoMetroCubido =
            double.tryParse(controllerPrecoUndMedida.text.replaceAll(',', '.'));
      } else {
        precoMetroCubido = double.tryParse(controllerPrecoUndMedida.text
            .replaceAll('.', '')
            .replaceAll(',', '.'));
      }

      var qtdMetrosCubicos = double.tryParse(controllerQuantidade.text);
      var espessura = double.tryParse(controllerEspessura.text); // / 100;
      var largura = double.tryParse(controllerLargura.text); // / 100;
      var comprimento = double.tryParse(controllerComprimento.text);

      resultQtd = (qtdMetrosCubicos! / (espessura! * largura! * comprimento!));

      quebraCaracteres =
          resultQtd.toString().substring(resultQtd.toString().indexOf('.'));

      if (quebraCaracteres.toString().length > 2) {
        qtdTotalMetros = resultQtd.toStringAsFixed(3);
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
    var precoMetroCubido;

    setState(() {
      if (controllerPrecoUndMedida.text.length <= 6) {
        precoMetroCubido =
            double.tryParse(controllerPrecoUndMedida.text.replaceAll(',', '.'));
      } else {
        precoMetroCubido = double.tryParse(controllerPrecoUndMedida.text
            .replaceAll('.', '')
            .replaceAll(',', '.'));
      }

      var quantidade = double.tryParse(controllerQuantidade.text);
      var espessura = double.tryParse(controllerEspessura.text); // / 100;
      var largura = double.tryParse(controllerLargura.text); // / 100;
      var comprimento = double.tryParse(controllerComprimento.text);

        //    if (comprimento != null &&
        //   largura != null &&
        //   espessura != null &&
        //   quantidade != null &&
        //   precoMetroCubido != null) {
        // metrosCubicos = (quantidade * (espessura * largura * comprimento));
        // }


      metrosCubicos = (quantidade! * (espessura! * largura! * comprimento!));

      if (metrosCubicos.toString().length >= 4) {
        if (metrosCubicos.toString().substring(0, 4) == ".000") {
          qtdTotalMetros = metrosCubicos.toStringAsFixed(3);
        } else if (metrosCubicos.toString().length > 2) {
          qtdTotalMetros = metrosCubicos.toStringAsFixed(4);
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
    var precoMetroQuadrado;
    setState(() {
      if (controllerPrecoUndMedida.text.length <= 6) {
        precoMetroQuadrado =
            double.tryParse(controllerPrecoUndMedida.text.replaceAll(',', '.'));
      } else {
        precoMetroQuadrado = double.tryParse(controllerPrecoUndMedida.text
            .replaceAll('.', '')
            .replaceAll(',', '.'));
      }

      var metrosQuadrados;
      var largura = double.tryParse(controllerLargura.text);
      var comprimento = double.tryParse(controllerComprimento.text);
      if (largura != null &&
          comprimento != null &&
          precoMetroQuadrado != null) {
        metrosQuadrados = (largura * comprimento);
        qtdTotalMetros = metrosQuadrados.toStringAsFixed(3);

        valorTotal = precoMetroQuadrado * metrosQuadrados;

        controllerTotalMetrosMadeira.text = qtdTotalMetros.toString();

        controllerValorTotal.text = (valorTotal.toStringAsFixed(2)).toString();
      }
    });
  }

  calculoLastro() {
    // CALCULO:
    // QUANTIDADE(UNIDADE) * (ESPESSURA(CENTIMETROS) * LARGURA(METROS) * COMPRIMENTO(METROS))
    var valorTotal;
    var metrosCubicos;
    var precoMetroCubido;

    setState(() {
      if (controllerPrecoUndMedida.text.length <= 6) {
        precoMetroCubido =
            double.tryParse(controllerPrecoUndMedida.text.replaceAll(',', '.'));
      } else {
        precoMetroCubido = double.tryParse(controllerPrecoUndMedida.text
            .replaceAll('.', '')
            .replaceAll(',', '.'));
      }

      double? quantidade = double.tryParse(controllerQuantidade.text);
      double? espessura = double.tryParse(controllerEspessura.text);
      double? largura = double.tryParse(controllerLargura.text);
      double? comprimento = double.tryParse(controllerComprimento.text);
      // if (largura == null) {
      // largura =0;
      if (comprimento != null &&
          largura != null &&
          espessura != null &&
          quantidade != null &&
          precoMetroCubido != null) {
        metrosCubicos = (quantidade * (espessura * largura * comprimento));
        if (metrosCubicos.toString().length >= 4) {
          if (metrosCubicos.toString().substring(0, 4) == ".000") {
            qtdTotalMetros = metrosCubicos.toStringAsFixed(3);
          } else if (metrosCubicos.toString().length > 2) {
            qtdTotalMetros = metrosCubicos.toStringAsFixed(4);
          }
        } else {
          qtdTotalMetros = metrosCubicos;
        }

        valorTotal = precoMetroCubido * metrosCubicos;

        controllerTotalMetrosMadeira.text = qtdTotalMetros.toString();

        controllerValorTotal.text = (valorTotal.toStringAsFixed(2)).toString();
      }

      // }
    });
  }

  calculoMetrosCorridos() {
    var valorTotal;
    var metrosCubicos;
    var precoMetroCubido;

    setState(() {
      if (controllerPrecoUndMedida.text.length <= 6) {
        precoMetroCubido =
            double.tryParse(controllerPrecoUndMedida.text.replaceAll(',', '.'));
      } else {
        precoMetroCubido = double.tryParse(controllerPrecoUndMedida.text
            .replaceAll('.', '')
            .replaceAll(',', '.'));
      }

      var quantidade = double.tryParse(controllerQuantidade.text);
      if (quantidade != null && precoMetroCubido != null) {
        metrosCubicos = quantidade;

        qtdTotalMetros = metrosCubicos.toStringAsFixed(3);

        if (precoMetroCubido != null && metrosCubicos != null) {
          valorTotal = precoMetroCubido * metrosCubicos;

          controllerTotalMetrosMadeira.text = qtdTotalMetros.toString();

          controllerValorTotal.text =
              (valorTotal.toStringAsFixed(2)).toString();
        }
      }
    });
  }

  calculoQtdVesesPreco() {
    var valorTotal;
    var quantidade;
    var precoPorUnd;

    setState(() {
      if (controllerPrecoUndMedida.text.length <= 6) {
        precoPorUnd =
            double.tryParse(controllerPrecoUndMedida.text.replaceAll(',', '.'));
      } else {
        precoPorUnd = double.tryParse(controllerPrecoUndMedida.text
            .replaceAll('.', '')
            .replaceAll(',', '.'));
      }
      quantidade = double.tryParse(controllerQuantidade.text);
      if (quantidade != null && precoPorUnd != null) {
        valorTotal = precoPorUnd! * quantidade!;
        print(precoPorUnd);
        print(valorTotal);

        controllerValorTotal.text = (valorTotal.toStringAsFixed(2))
            .toString(); //formatter.format(valorTotal);
      }
    });
  }

  gerarCodPedido() {
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
          '\nO Tipo da madeira não pode ficar vazio.', 'Tipo da madeira!');
    } else if (controllerPrecoUndMedida.text == '0,00') {
      MsgPopup().msgFeedback(context,
          '\nO preço por metro cúbico não foi preenchido.', 'Preço cúbico!');
    } else if (idProduto == null) {
      MsgPopup()
          .msgFeedback(context, '\nO produto não foi preenchido.', 'Produto!');
    } else if (idUnidadeMedida != 2 && controllerQuantidade.text.isEmpty) {
      MsgPopup().msgFeedback(
          context, '\nA quantidade não pode ficar vazia.', 'Quantidade!');
    } else if ((idUnidadeMedida != 2 && idUnidadeMedida != 3) &&
        controllerEspessura.text.isEmpty) {
      MsgPopup().msgFeedback(
          context, '\nA espessura não pode ficar vazia.', 'Espessura!');
    } else if (idUnidadeMedida != 3 && controllerLargura.text.isEmpty) {
      if (idUnidadeMedida == 2 && controllerLargura.text.isEmpty) {
        MsgPopup().msgFeedback(
            context, '\nA altura não pode ficar vazia.', 'Altura!');
      } else {
        MsgPopup().msgFeedback(
            context, '\nA largura não pode ficar vazia.', 'Largura!');
      }
    } else if ((idUnidadeMedida != 3) && controllerComprimento.text.isEmpty) {
      MsgPopup().msgFeedback(
          context,
          '\nO comprimento da madeira precisa ser selecionado.',
          'Comprimento!');
    } else {
      submitForm();
    }
  }

  confereCamposParte01Cadastro() {
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

  salvarPedidoMadeira() async {
    // var teste = qtdTotalMetros.toStringAsFixed(3).toString();
    // print(teste);
    // var valorTotal = controllerValorTotal.text.replaceAll('RS: ', '');
    var bodyy = jsonEncode(
      {
        'idusuario': ModelsUsuarios.idDoUsuario,
        'idgrupo_pedido': idGrupoPedidos,
        'idproduto': idProduto,
        'idunidade_medida': idUnidadeMedida,
        'idmadeira': idMadeira,
        'cod_pedido': gerarCodPedido() as String,
        'comprimento': controllerComprimento.text == ''
            ? null
            : double.parse(controllerComprimento.text),
        'largura': controllerLargura.text == ''
            ? null
            : double.parse(controllerLargura.text),
        'espessura': controllerEspessura.text == ''
            ? null
            : double.parse(controllerEspessura.text),
        'quantidade': opcPedidoBeneficiado == false && calcMetroCubico == true
            ? qtdTotalMetros
            : calcMetroCubico == false && controllerQuantidade.text != ''
                ? double.parse(controllerQuantidade.text)
                : null,
        'data_pedido': DataAtual().pegardataBR() as String,
        'hora_pedido': DataAtual().pegarHora() as String,
        'preco_metro': controllerPrecoUndMedida.text.length <= 6
            ? controllerPrecoUndMedida.text.replaceAll('.', ',')
            : controllerPrecoUndMedida.text,
        'valor_total': controllerValorTotal.text
            .replaceAll('RS: ', '')
            .replaceAll('.', ','), // valorTotal,
        'qtd_metros': opcPedidoBeneficiado == false && calcMetroCubico == true
            ? double.parse(controllerQuantidade.text)
            : qtdTotalMetros,
        'observacoes': controllerObservacao.text,
        'tipo_calculo': tipoCalculo,
        'tipo_processo': opcTipoProcesso,
        'beneficiado': opcPedidoBeneficiado,
      },
    );
    http.Response state = await http.post(
      Uri.parse(CadastrarUmPedido + ModelsUsuarios.caminhoBaseUser.toString()),
      headers: {
        "Content-Type": "application/json",
        "authorization": ModelsUsuarios.tokenAuth.toString()
      },
      body: bodyy,
    );
    print(bodyy);
    print(state.statusCode);
    if (state.statusCode == 201) {
      ConstantePedidos.cadastraroGrupo = true;
      Navigator.pop(context);
    } else if (state.statusCode == 401) {
      Navigator.pushNamed(context, '/login');
    }
  }

  submitForm() {
    if (nomePallet != null) controllerNomePallet.text = nomePallet!;

    if (madeiraProcessada == true) {
      salvarPedidoMadeira();
      // Navigator.pop(context);
    } else if (pallet == true) {
      salvarPedidoPallet(context);
    }
    // showSnackbar("Submitting Feedback");
  }

  // showSnackbar(String? message) {
  //   final snackBar = SnackBar(
  //     content: Text(message),
  //     backgroundColor: Colors.blueAccent[200],
  //   );
  //   _scaffoldKey.currentState.showSnackBar(snackBar);
  // }

  salvarPedidoPallet(BuildContext context) async {
    // var valorTotal = controllerValorTotal.text.replaceAll('RS: ', '');
    var bodyy = jsonEncode(
      {
        "idusuario": ModelsUsuarios.idDoUsuario,
        "idgrupo_pedido": idGrupoPedidos,
        "idpallet": idPallet,
        "idmadeira": idMadeira,
        "cod_pedido": gerarCodPedido() as String,
        "data_pedido": DataAtual().pegardataBR() as String,
        "hora_pedido": DataAtual().pegarHora() as String,
        "quantidade": double.parse(controllerQuantidade.text),
        "preco_metro": controllerPrecoUndMedida.text.length <= 6
            ? controllerPrecoUndMedida.text.replaceAll('.', ',')
            : controllerPrecoUndMedida.text,
        "valor_total": controllerValorTotal.text.replaceAll('.', ','),
        "observacoes": controllerObservacao.text,
      },
    );
    print(bodyy);
    var state = await http.post(
      Uri.parse(CadastrarUmPedido + ModelsUsuarios.caminhoBaseUser.toString()),
      headers: {
        "Content-Type": "application/json",
        "authorization": ModelsUsuarios.tokenAuth.toString()
      },
      body: bodyy,
    );

    print(state.statusCode);
    if (state.statusCode == 201) {
      ConstantePedidos.cadastraroGrupo = true;
      Navigator.pop(context);
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
                        setState(() {
                          nomePallet = categoria['nome'].toString();
                        });
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
                                categoria['nome'].toString(),
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
                SizedBox(height: MediaQuery.of(context).size.height * 0.008),
                Botao().botaoAnimacaoLoading(context, onTap: () {
                  validarcamposPallet();
                }, colorButton: Colors.grey[200]),
                SizedBox(height: MediaQuery.of(context).size.height * 0.015),
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
                  },
                ),
              },
              marginLeft: 0.013,
              marginTop: 0.025,
              distanciaTituloDosChecks: 0.005,
              backgroundColor: Colors.white.withOpacity(0.9),
            ),
            //-------------------------------------------------------
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
                        controllerQuantidade.text.isEmpty;
                        controllerLargura.text.isEmpty;
                        controllerEspessura.text.isEmpty;
                        controllerPrecoUndMedida.text.isEmpty;
                        controllerValorTotal.text.isEmpty;
                        controllerComprimento.text.isEmpty;
                        controllerTotalMetrosMadeira.text.isEmpty;
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

  categoriaMadeiraProcessada(context) {
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

  pedidoBeneficiado(context) {
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
                  comprimento: 250),
            ),
          ],
        ),
      );
    } else
      return Container();
  }

  //----- Aqui vc escolhe entre os pallets ou madeira processada-----
  escolherProduto(context) {
    return CheckBox().checkBoxDuasOpcoes(
      context,
      'Tipo de Produto',
      'Pallet',
      'Madeira Processada',
      pallet,
      madeiraProcessada,
      () async {
        setState(
          () {
            madeiraProcessada = false;
            pallet = true;
            controllerQuantidade = new TextEditingController();
            controllerPrecoUndMedida = new TextEditingController();
            controllerValorTotal = new TextEditingController();

            // controllerValorTotal.text = "";
            idUnidadeMedida = null;
          },
        );
      },
      () async {
        setState(
          () {
            madeiraProcessada = true;
            pallet = false;
            idPallet = null;
            beneficiadoSim = false;
            beneficiadoNao = true;
            controllerQuantidade = new TextEditingController();
            controllerPrecoUndMedida = new TextEditingController();
            controllerValorTotal = new TextEditingController();
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

//chama a função buscar dados ao iniciar a tela
  @override
  void initState() {
    super.initState();
    this.buscarDadosCliente();
    this.buscarDadosPallet();
    this.buscarDadosUndMedida();
    this.buscarDadosProduto();
    this.buscarDadosMadeira();
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
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Cabecalho().tituloCabecalho(
                    context,
                    'Cadastro de pedido',
                    iconeVoltar: parte01Cadastro == true ? true : false,
                    sizeTextTitulo: 0.065,
                    marginBottom: 0.015,
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          if (parte01Cadastro == true)
                            Container(
                              padding: EdgeInsets.only(
                                left: size.width * 0.025,
                                right: size.width * 0.025,
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
                                confereCamposParte01Cadastro();
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
                                // bottom: size.height * 0.01
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
                          SizedBox(height: size.height * 0.02),
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
