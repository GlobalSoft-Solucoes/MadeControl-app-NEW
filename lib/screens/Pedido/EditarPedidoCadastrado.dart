import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:madecontrol_desenvolvimento/Statics/Static_Pedidos.dart';
import 'package:madecontrol_desenvolvimento/Widget/Botao.dart';
import 'package:madecontrol_desenvolvimento/Widget/MsgPopup.dart';
import 'package:madecontrol_desenvolvimento/Widget/TextField.dart';
import 'package:madecontrol_desenvolvimento/models/ClassesStaticas.dart';
import 'package:madecontrol_desenvolvimento/models/Models_GrupoPedido.dart';
import 'package:madecontrol_desenvolvimento/models/Models_Usuario.dart';
import 'package:madecontrol_desenvolvimento/models/constantes.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class EditarPedidosCadastrado extends StatefulWidget {
  @override
  _EditarPedidosCadastradoState createState() =>
      _EditarPedidosCadastradoState();
}

class _EditarPedidosCadastradoState extends State<EditarPedidosCadastrado> {
  var ultimogrupocadastrado = <ModelsGrupoPedido>[];
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController controllerProduto =
      TextEditingController(text: FieldsPedido.nomeProduto);
  TextEditingController controllerLargura =
      TextEditingController(text: FieldsPedido.largura.toString());
  TextEditingController controllerComprimento =
      TextEditingController(text: FieldsPedido.comprimento.toString());
  TextEditingController controllerEspessura =
      TextEditingController(text: FieldsPedido.espessura.toString());
  TextEditingController controllerDias = TextEditingController();
  TextEditingController controllerProprietario = TextEditingController();
  TextEditingController controllerQuantidade =
      TextEditingController(text: FieldsPedido.quantidade.toString());
  TextEditingController controllerTipoMadeira =
      TextEditingController(text: FieldsPedido.nomeMadeira);
  TextEditingController controllerObservacao =
      TextEditingController(text: FieldsPedido.observacoes);
  TextEditingController controllerNomePallet = TextEditingController();

  bool? pinus = false;
  bool? eucalipto = false;
  bool? diversos = false;
  int? idPallet;
  var tipoMadeira = '';
  var dia;
  var mes;
  var ano;
  var dias;
  bool? pallet = false;
  bool? madeiraProcessada = false;
  var tipoDeProduto;
  int? idCliente;

  bool? clienteescolhido = true;
  List itensLista1 = [];
  String? nomePallet;
  var mascaraLarguraedicao = new MaskTextInputFormatter(
      mask: '#.#####', filter: {"#": RegExp(r'[0-9]')});
  var mascaraComprimentoedicao = new MaskTextInputFormatter(
      mask: '*.*****', filter: {"*": RegExp(r'[0-9]')});
  var mascaraEspessuraedicao = new MaskTextInputFormatter(
      mask: '#.#####', filter: {"#": RegExp(r'[0-9]')});

  pegardata() {
    dia = DateTime.now().day;
    mes = DateTime.now().month;
    ano = DateTime.now().year;

    return dias = '$dia/$mes/$ano';
  }

//mensagem de sucesso
  void cadastradoSucesso() {
    MsgPopup().msgFeedback(context, 'Atualizado com sucesso!', 'Cadastrado!');
  }

//atualiza o pedido maidera
  atualizarPedidoMadeira(id) async {
    pegardata();
    var bodyy = jsonEncode(
      {
        'comprimento': double.parse(controllerComprimento.text),
        'largura': double.parse(controllerLargura.text),
        'espessura': double.parse(controllerEspessura.text),
        'quantidade': controllerQuantidade.text,
        'idusuario': ModelsUsuarios.idDoUsuario,
        'tipo_madeira': tipoMadeira,
        'tipo_produto': controllerProduto.text
      },
    );

    var state = await http.put(
     Uri.parse(EditarumPedido +
          id.toString() +
          '/' +
          ModelsUsuarios.caminhoBaseUser.toString()),
      headers: {
        "Content-Type": "application/json",
        "authorization": ModelsUsuarios.tokenAuth.toString()
      },
      body: bodyy,
    );
    if (state.statusCode == 200) {
      ConstantePedidos.cadastraroGrupo = true;
      cadastradoSucesso();
      Navigator.pop(context);
    } else if (state.statusCode == 401) {
      Navigator.pushNamed(context, '/login');
    }
  }

//atualiza  o pedido pallet
  atualizarPedidoPallet(id) async {
    pegardata();
    var bodyy = jsonEncode(
      {
        'quantidade': controllerQuantidade.text,
        'idusuario': ModelsUsuarios.idDoUsuario,
        'tipo_madeira': 'Eucalipto',
        'tipo_produto': 'pallet',
        'idpallet': idPallet
      },
    );

    var state = await http.put(
     Uri.parse(EditarumPedido +
          id.toString() +
          '/' +
          ModelsUsuarios.caminhoBaseUser.toString()),
      headers: {
        "Content-Type": "application/json",
        "authorization": ModelsUsuarios.tokenAuth.toString()
      },
      body: bodyy,
    );

    if (state.statusCode == 200) {
      ConstantePedidos.cadastraroGrupo = true;
      Navigator.pop(context); //pushNamed(context, '/Home');
    } else if (state.statusCode == 401) {
      Navigator.pushNamed(context, '/login');
    }
  }

//valida os campos do pallet
  validarcamposPallet() {
    if (idPallet != null) {
      if (controllerQuantidade.text.isNotEmpty) {
        atualizarPedidoPallet(FieldsPedido.idPedido);
      }
    }
  }

//valida os campos do madeira processada
  validarCamposMadeiraProcessada() {
    if (controllerProduto.text.isNotEmpty) {
      if (controllerQuantidade.text.isNotEmpty) {
        if (controllerTipoMadeira.text.isNotEmpty) {
          if (controllerComprimento.text.isNotEmpty) {
            if (controllerLargura.text.isNotEmpty) {
              if (controllerEspessura.text.isNotEmpty) {
                atualizarPedidoMadeira(FieldsPedido.idPedido);
              } else {
                MsgPopup().msgFeedback(
                    context, 'A espessura não pode ficar vazia', 'espessura!');
              }
            } else {
              MsgPopup().msgFeedback(
                  context, 'A largura não pode ficar vazia', 'largura!');
            }
          } else {
            MsgPopup().msgFeedback(
                context, 'O comprimento não pode ficar vazio', 'comprimento!');
          }
        } else {
          MsgPopup().msgFeedback(context,
              'O tipo da madeira não pode estar em branco', 'Tipo da Madeira!');
        }
      } else {
        MsgPopup().msgFeedback(
            context, 'A quantidade não pode ficar vazia', 'quantidade!');
      }
    } else {
      MsgPopup()
          .msgFeedback(context, 'O produto não foi preenchido', 'Produto!');
    }
  }

//aki vai os widgets do pallet
  categoriaPallet(context) {
    idPallet = FieldsPedido.idPallet;

    MediaQueryData mediaQuery = MediaQuery.of(context);
    Size size = mediaQuery.size;
    if (pallet == true) {
      return Container(
        child: Padding(
          padding: EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.black, width: 1)),
            child: Column(
              children: [
                new Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: new Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    child: Text(
                      'pallet',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.black, width: 1)),
                    child: DropdownButton(
                        hint: Text(
                          'pallet',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        value: idPallet,
                        items: itensLista1.map((categoria) {
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
                                    nomePallet = categoria['nome'],
                                    style: TextStyle(fontSize: 18),
                                  )
                                ],
                              ));
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            idPallet = value as int;
                          });
                        }),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(top: size.height * 0.01),
                    child: CampoText().textField(
                        controllerQuantidade, 'quantidade:',
                        tipoTexto: TextInputType.text)),
                Padding(
                    padding: EdgeInsets.only(top: size.height * 0.01),
                    child: CampoText().textField(
                        controllerObservacao, 'Observacao:',
                        tipoTexto: TextInputType.text)),
                Padding(
                  padding: EdgeInsets.only(top: size.height * 0.01),
                  child: Botao().botaoPadrao(
                    'Salvar',
                    () {
                      validarcamposPallet();
                    },
                  ),
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
  categoriaMadeiraProcessada(context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    Size size = mediaQuery.size;
    if (madeiraProcessada == true) {
      return Container(
          child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: size.height * 0.01),
            child: CampoText().textField(
              controllerProduto,
              'Produto:',
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: size.height * 0.01),
            child: CampoText().textField(controllerQuantidade, 'quantidade:',
                tipoTexto: TextInputType.number),
          ),
          Padding(
            padding: EdgeInsets.only(top: size.height * 0.01),
            child: CampoText().textField(controllerTipoMadeira, 'Madeira:',
                tipoTexto: TextInputType.text),
          ),
          Padding(
            padding: EdgeInsets.only(top: size.height * 0.01),
            child: CampoText().textFieldComMascara(
                controllerLargura, 'largura:',
                tipoTexto: TextInputType.number, mascara: mascaraLarguraedicao),
          ),
          Padding(
            padding: EdgeInsets.only(top: size.height * 0.01),
            child: CampoText().textFieldComMascara(
                controllerComprimento, 'comprimento:',
                tipoTexto: TextInputType.number,
                mascara: mascaraComprimentoedicao),
          ),
          Padding(
              padding: EdgeInsets.only(top: size.height * 0.01),
              child: CampoText().textFieldComMascara(
                  controllerEspessura, 'espessura:',
                  tipoTexto: TextInputType.number,
                  mascara: mascaraEspessuraedicao)),
          Padding(
              padding: EdgeInsets.only(top: size.height * 0.01),
              child: CampoText().textField(controllerObservacao, 'Observacao:',
                  tipoTexto: TextInputType.text)),
          Padding(
            padding: EdgeInsets.only(top: size.height * 0.05),
            child: Botao()
                .botaoPadrao('Salvar', () => validarCamposMadeiraProcessada()),
          ),
        ],
      ));
    } else
      return Container();
  }

//cadastro o grupo de pedido apos o usuario ser escolhido
  editarInformacoes() {
    if (FieldsPedido.idPallet == null) {
      setState(() {
        madeiraProcessada = true;
        pallet = false;
      });
    } else {
      setState(() {
        pallet = true;
        madeiraProcessada = false;
      });
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
        itensLista1 = jsonData;
      });
    }

    if (response.statusCode == 401) {
      Navigator.pushNamed(context, '/login');
    }
  }

//chama a função buscar dados ao iniciar a tela
  @override
  void initState() {
    super.initState();
    this.buscarDadosPallet();
    this.editarInformacoes();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    Size size = mediaQuery.size;
    return Scaffold(
      key: _scaffoldKey,
      body: SingleChildScrollView(
        child: Container(
          height: size.height,
          width: size.width,
          color: Colors.green[200],
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: size.height * 0.02),
                child: Container(
                  width: size.width,
                  height: size.height * 0.10,
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(1),
                        child: IconButton(
                          icon: Icon(Icons.arrow_back),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          iconSize: 35,
                          color: Colors.white,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: size.width * 0.11),
                        child: Text(
                          'Edição de Pedidos',
                          style: TextStyle(
                              fontSize: 30,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
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
                        categoriaMadeiraProcessada(context),
                        categoriaPallet(context)
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
