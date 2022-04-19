import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:madecontrol_desenvolvimento/Widget/Cabecalho.dart';
import 'package:madecontrol_desenvolvimento/Widget/DropDownButton.dart';
import 'package:madecontrol_desenvolvimento/Widget/TextField.dart';
import 'package:madecontrol_desenvolvimento/models/constantes.dart';
import 'package:madecontrol_desenvolvimento/Widget/Botao.dart';
import 'package:madecontrol_desenvolvimento/Widget/MsgPopup.dart';
import 'package:madecontrol_desenvolvimento/models/ClassesStaticas.dart';
import 'package:madecontrol_desenvolvimento/funcoes/FuncoesParaDatas.dart';
import 'package:madecontrol_desenvolvimento/models/Models_GrupoPedido.dart';
import 'package:madecontrol_desenvolvimento/models/Models_Usuario.dart';
import 'package:http/http.dart' as http;

class CadVendaAvulso extends StatefulWidget {
  @override
  CadVendaAvulsoState createState() => CadVendaAvulsoState();
}

class CadVendaAvulsoState extends State<CadVendaAvulso> {
  // ================================ VARIÁVEIS UTILIZADAS ==================================
  TextEditingController controllerValorTotal = MoneyMaskedTextController();
  TextEditingController controllerObservacao = TextEditingController();
  TextEditingController controllerQuantidade = TextEditingController();
  var ultimogrupocadastrado = <ModelsGrupoPedido>[];

  var dofCliente;

  List dadosClientes = [];
  int? idCliente;
  List itensListaProduto = [];
  int? idProduto;
  // selecionar o tipo da medidas
  Axis direction = Axis.horizontal;

  var selectedRadio;
  var metroscubicos = false;
  var metrosQuadrados = false;
  var metrosCorridos = false;
  var lastro = false;

  int? idGrupoPedidos;

  double?tamanhoWidget01 = 0.12;
  double?tamanhoWidget02 = 0.41;

//====================================== FUNÇÕES DESENVOLVIDAS ==================================
//Busca a lista de clientes
  Future buscarDadosCliente() async {
    final response = await http.get(
        Uri.parse(ListarTodosClientes + ModelsUsuarios.caminhoBaseUser.toString()),
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

  Future buscarDadosProduto() async {
    final response = await http.get(
        Uri.parse(ListarTodosProdutos + ModelsUsuarios.caminhoBaseUser.toString()),
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

  salvarPedido() async {
    // var valorTotal =
    //     controllerValorTotal.text.replaceAll('.', '').replaceAll(',', '.');
    var bodyy = jsonEncode(
      {
        'idusuario': ModelsUsuarios.idDoUsuario,
        'idgrupo_pedido': idGrupoPedidos,
        'idproduto': idProduto,
        'cod_pedido': gerarCodPedido() as String,
        'data_pedido': DataAtual().pegardataBR() as String,
        'hora_pedido': DataAtual().pegarHora() as String,
        "preco_metro": "0",
        'valor_total': controllerValorTotal.text,
        'quantidade': controllerQuantidade.text,
        'observacoes': controllerObservacao.text,
      },
    );
    print(bodyy);

    http.Response state = await http.post(
      Uri.parse(CadastrarUmPedido + ModelsUsuarios.caminhoBaseUser.toString()),
      headers: {
        "Content-Type": "application/json",
        "authorization": ModelsUsuarios.tokenAuth.toString()
      },
      body: bodyy,
    );
    print(bodyy);
    if (state.statusCode == 201) {
      ConstantePedidos.cadastraroGrupo = true;
      Navigator.pop(context);
    } else if (state.statusCode == 401) {
      Navigator.pushNamed(context, '/login');
    }
  }

//cadastro o grupo de pedido apos o usuario ser escolhido
  cadastrarGrupoPedido() async {
    if (ConstantePedidos.cadastraroGrupo == true) {
      if (idCliente != null) {
        var bodyy = jsonEncode(
          {
            'idcliente': idCliente,
            'status_grupo': 'Cadastrado',
            'idusuario': ModelsUsuarios.idDoUsuario,
            'codigo_grupo': gerarCodGrupoPedido(),
            'data_cadastro': DataAtual().pegardataBR() as String,
            'tipo_venda': 'Avulso',
          },
        );
        var state = await http.post(
          Uri.parse(CadastrarGrupoPedido + ModelsUsuarios.caminhoBaseUser.toString()),
          headers: {
            "Content-Type": "application/json",
            "authorization": ModelsUsuarios.tokenAuth.toString()
          },
          body: bodyy,
        );
        print(state.statusCode);
        if (state.statusCode == 201) {
          setState(() {});
          //busca o ultimo grupo cadastrado se der certo a requisição de cadastro
          final response = await http.get(
              Uri.parse(BuscarUltimoGrupoPedidoCadastrado +
                  ModelsUsuarios.caminhoBaseUser.toString()),
              headers: {"authorization": ModelsUsuarios.tokenAuth.toString()});
          print(response);
          String? retorno = response.body;
          // caso o retorno do Body for diferente de vazio("[]"), continua a execução
          if (retorno != "[]") {
            // Repara para mostra apenas o valor da chave primária
            String? valorRetorno = retorno
                .substring(retorno.indexOf(':'), retorno.indexOf('}'))
                .replaceAll(':', '');

            // caso haja valor na variável, quer dizer que contém um registro
            if (valorRetorno.length > 0) {
              idGrupoPedidos = int.parse(valorRetorno);
              salvarPedido();
            } else if (state.statusCode == 401) {
              Navigator.pushNamed(context, '/login');
            }
          }
        }
      }
    } else {
      setState(
        () {},
      );
    }
  }

  validaGrupoPedidos() {
    if (idCliente == null) {
      MsgPopup().msgFeedback(
          context, '\nSelecione um cliente para continuar!', 'Cliente');
    } else if (controllerQuantidade.text.isEmpty) {
      MsgPopup()
          .msgFeedback(context, '\nInsira uma quantidade!', ' Quantidade');
    } else if (idProduto == null) {
      MsgPopup().msgFeedback(
          context, '\nSelecione um produto para continuar!', 'Produto');
    } else {
      cadastrarGrupoPedido();
    }
  }

  @override
  void initState() {
    super.initState();
    this.buscarDadosCliente();
    this.buscarDadosProduto();
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
                  'Venda avulso',
                  iconeVoltar: true,
                  sizeTextTitulo: 0.065,
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: size.height * 0.05,
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
                              left: 5,
                              right: 5,
                              top: size.height * 0.02,
                              bottom: 5),
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
                                SizedBox(height: size.height * 0.01),
                                DropDownButton().dropDownButton(
                                  'Produto:',
                                  DropdownButton(
                                    hint: Text(
                                      'Produto de venda:',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    value: idProduto,
                                    items: itensListaProduto.map(
                                      (categoria) {
                                        return DropdownMenuItem(
                                          value: (categoria['idproduto']),
                                          child: Row(
                                            children: [
                                              Text(
                                                categoria['idproduto']
                                                    .toString(),
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
                                          idProduto = value as int;
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
                                CampoText().textField(
                                  controllerQuantidade,
                                  'Quantidade: ',
                                  confPadding: EdgeInsets.only(
                                      top: size.height * 0.015,
                                      left: 10,
                                      right: 10),
                                  icone: Icons.format_list_numbered,
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.only(top: size.height * 0.015),
                                  child: CampoText().textField(
                                    controllerValorTotal,
                                    'Valor total',
                                    corTexto: Colors.green[600],
                                    icone: Icons.local_atm_outlined,
                                    backgroundColor:
                                        Colors.white.withOpacity(0.9),
                                  ),
                                ),
                                CampoText().textField(
                                  controllerObservacao,
                                  'Observações: ',
                                  confPadding: EdgeInsets.only(
                                      top: size.height * 0.015,
                                      left: 10,
                                      right: 10),
                                  icone: Icons.message_sharp,
                                  minLines: 3,
                                  maxLines: 4,
                                  maxLength: 100,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.05),
                Botao().botaoAnimacaoLoading(
                  context,
                  onTap: () {
                    validaGrupoPedidos();
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
