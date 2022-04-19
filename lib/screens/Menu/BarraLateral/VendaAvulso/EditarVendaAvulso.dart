import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:madecontrol_desenvolvimento/Statics/Static_GrupoPedido.dart';
import 'package:madecontrol_desenvolvimento/Statics/Static_Pedidos.dart';
import 'package:madecontrol_desenvolvimento/Widget/Botao.dart';
import 'package:madecontrol_desenvolvimento/Widget/Cabecalho.dart';
import 'package:madecontrol_desenvolvimento/Widget/DropDownButton.dart';
import 'package:madecontrol_desenvolvimento/Widget/MsgPopup.dart';
import 'package:madecontrol_desenvolvimento/Widget/TextField.dart';
import 'package:madecontrol_desenvolvimento/models/ClassesStaticas.dart';
import 'package:madecontrol_desenvolvimento/models/Models_Usuario.dart';
import 'package:madecontrol_desenvolvimento/models/constantes.dart';
import 'package:http/http.dart' as http;

class EditarDadosVendaAvulso extends StatefulWidget {
  @override
  _EditarDadosVendaAvulsoState createState() => _EditarDadosVendaAvulsoState();
}

class _EditarDadosVendaAvulsoState extends State<EditarDadosVendaAvulso> {
  TextEditingController controllerValorTotal = MoneyMaskedTextController();
  TextEditingController controllerObservacoes = TextEditingController();
  TextEditingController controllerQuantidade = TextEditingController();

  List listaClientes = [];
  int? idCliente = FieldsGrupoPedido.idCliente;
  List itensListaProduto = [];
  int? idProduto = FieldsPedido.idProduto;

  Future buscarDadosCliente() async {
    final response = await http.get(
        Uri.parse(ListarTodosClientes + ModelsUsuarios.caminhoBaseUser.toString()),
        headers: {"authorization": ModelsUsuarios.tokenAuth.toString()});
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      setState(
        () {
          listaClientes = jsonData;
        },
      );
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
  }

  validarCampos() {
    if (idCliente == null) {
      MsgPopup().msgFeedback(
          context, '\nSelecione um cliente para continuar!', 'Cliente');
    } else if (controllerQuantidade.text.isEmpty) {
      MsgPopup()
          .msgFeedback(context, '\nInsira uma quantidade', ' Tipo da venda');
    } else if (idProduto == null) {
      MsgPopup().msgFeedback(
          context, '\nSelecione um produto para continuar!', 'Cliente');
    } else {
      salvarEdicao();
    }
  }

  Future<dynamic> salvarEdicao() async {
    var corpoReq = jsonEncode(
      {
        'idproduto': idProduto,
        "preco_metro": "0",
        'valor_total': controllerValorTotal.text,
        'quantidade': controllerQuantidade.text,
        'observacoes': controllerObservacoes.text,
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
      body: corpoReq,
    );
    if (state.statusCode == 200) {
      Navigator.pop(context);
    }
  }

//chama a função buscar dados ao iniciar a tela
  @override
  void initState() {
    super.initState();
    this.buscarDadosCliente();
    this.buscarDadosProduto();
    controllerObservacoes.text = FieldsPedido.observacoes!;
    controllerQuantidade.text = FieldsPedido.quantidade.toString();
    controllerValorTotal.text = FieldsPedido.valorTotal!;
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    Size size = mediaQuery.size;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            width: size.width,
            height: size.height,
            color: Colors.green[300],
            child: Column(
              children: [
                Cabecalho().tituloCabecalho(
                  context,
                  'Editar recebimento',
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
                                    items: listaClientes.map(
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
                                  controllerObservacoes,
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
                    validarCampos();
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
