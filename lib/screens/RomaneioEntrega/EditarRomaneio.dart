import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:madecontrol_desenvolvimento/Statics/Static_Romaneio.dart';
import 'package:madecontrol_desenvolvimento/Widget/Botao.dart';
import 'package:madecontrol_desenvolvimento/Widget/Cabecalho.dart';
import 'package:madecontrol_desenvolvimento/Widget/MsgPopup.dart';
import 'package:madecontrol_desenvolvimento/Widget/TextField.dart';
import 'package:madecontrol_desenvolvimento/models/Models_Usuario.dart';
import 'package:madecontrol_desenvolvimento/models/constantes.dart';
import 'package:http/http.dart' as http;
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class EditarDadosRomaneio extends StatefulWidget {
  @override
  _EditarDadosRomaneioState createState() => _EditarDadosRomaneioState();
}

class _EditarDadosRomaneioState extends State<EditarDadosRomaneio> {
  TextEditingController controllerData =
      TextEditingController(text: BuscaRomaneioPorId.dataEntrega);
  TextEditingController controllerDestino =
      TextEditingController(text: BuscaRomaneioPorId.destino);
  TextEditingController controllerObs =
      TextEditingController(text: BuscaRomaneioPorId.observacoes);
  TextEditingController controllerHora =
      TextEditingController(text: BuscaRomaneioPorId.horaEntrega);
  //
  var listaGrupoPedidosProntos = [];
  var listarUsuarios = [];

  int? data;
  int? idUsuario = BuscaRomaneioPorId.motorista; //idUsuario;
  int? idGrupoPedidos = BuscaRomaneioPorId.idGrupoPedido;

//BUSCA OS PEDIDOS POR GRUPO
  Future buscarGruposPedidos() async {
    final response = await http.get(
        Uri.parse(
            ListarGruposPedidosProntos + ModelsUsuarios.caminhoBaseUser.toString()),
        headers: {"authorization": ModelsUsuarios.tokenAuth.toString()});
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      setState(() {
        listaGrupoPedidosProntos = jsonData;
      });
    }

    if (response.statusCode == 401) {
      Navigator.pushNamed(context, '/login');
    }
  }

  var mascaradata = new MaskTextInputFormatter(
      mask: '##/##/####', filter: {"#": RegExp(r'[0-9]')});

  var mascaraHora = new MaskTextInputFormatter(
      mask: '##:##', filter: {"#": RegExp(r'[0-9]')});

//BUSCAR USUARIOS DA EMPRESA
  Future buscarUsuario() async {
    final response = await http.get(
        Uri.parse(ListarTodosUsuarios + ModelsUsuarios.caminhoBaseUser.toString()),
        headers: {"authorization": ModelsUsuarios.tokenAuth.toString()});
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      setState(() {
        listarUsuarios = jsonData;
      });
    }
    if (response.statusCode == 401) {
      Navigator.pushNamed(context, '/login');
    }
  }

//ALTERA O STATUS PARA ENTREGUE!
  alterarstatuEntregue() async {
    var response = await http.put(
      Uri.parse(AlteraStatusGrupoPedidoParaEntregue +
          idGrupoPedidos.toString() +
          '/' +
          ModelsUsuarios.caminhoBaseUser.toString()),
      headers: {"authorization": ModelsUsuarios.tokenAuth.toString()},
    );
    if (response.statusCode == 401) {
      Navigator.pushNamed(context, '/login');
    }
  }

  validarRomaneio() {
    if (idGrupoPedidos! > 0) {
      if (idUsuario! > 0) {
        if (controllerData.text.isNotEmpty) {
          if (controllerDestino.text.isNotEmpty) {
            // alterarstatuEntregue();
            salvarBanco();
          } else {
            MsgPopup()
                .msgFeedback(context, 'destino não pode ficar vazio', 'Erro');
          }
        } else {
          MsgPopup()
              .msgFeedback(context, 'A Data não pode ficar vazia', 'Erro');
        }
      } else {
        MsgPopup().msgFeedback(
            context, 'Verifique sua conexao com a internet', 'Erro');
      }
    } else {
      MsgPopup()
          .msgFeedback(context, 'Verifique sua conexao com a internet', 'Erro');
    }
  }

  salvarBanco() async {
    var bodyy = jsonEncode(
      {
        'idusuario': ModelsUsuarios.idDoUsuario,
        'motorista': idUsuario,
        'data_entrega': controllerData.text.replaceAll('/', '-'),
        'hora_entrega': controllerHora.text,
        'destino': controllerDestino.text,
        'idgrupo_pedido': idGrupoPedidos,
        'observacoes': controllerObs.text,
      },
    );

     var state = await http.put(
     Uri.parse( EditarRomaneio +
          BuscaRomaneioPorId.idRomaneio.toString() +
          '/' +
          ModelsUsuarios.caminhoBaseUser.toString()),
      headers: {
        "Content-Type": "application/json",
        "authorization": ModelsUsuarios.tokenAuth.toString()
      },
      body: bodyy,
    );

    if (state.statusCode == 201) {
      Navigator.pop(context);
    } else if (state.statusCode == 401) {
      Navigator.pushNamed(context, '/login');
    }
  }

  @override
  void initState() {
    super.initState();
    this.buscarGruposPedidos();
    this.buscarUsuario();
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
                  'Edição do Romaneio',
                  iconeVoltar: true,
                  sizeTextTitulo: 0.065,
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: size.height * 0.01,
                      right: size.width * 0.02,
                      left: size.width * 0.02),
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        Container(
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: 5,
                              right: 5,
                              top: size.height * 0.02,
                              bottom: 15,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                      color: Colors.black, width: 1)),
                              child: Column(
                                children: [
                                  new Container(
                                    padding: EdgeInsets.only(
                                      top: 10,
                                      bottom: 15,
                                      left: 8,
                                      // right: size.width * 0.55,
                                    ),
                                    child: new Container(
                                      alignment: Alignment.topLeft,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        'Código do pedido:  ' +
                                            BuscaRomaneioPorId.codigoGrupo
                                                .toString(),
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.topLeft,
                                    padding: EdgeInsets.only(
                                      bottom: 10,
                                      left: 8,
                                      // right: size.width * 0.725,
                                    ),
                                    child: Container(
                                      alignment: Alignment.topLeft,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        'Cliente:  ' +
                                            BuscaRomaneioPorId.nomeCliente!,
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
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
                                  new Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: new Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Text(
                                        'motorista',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                              color: Colors.black, width: 1)),
                                      child: DropdownButton(
                                        hint: Text(
                                          'motorista',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        value: idUsuario,
                                        items: listarUsuarios.map((categoria) {
                                          return DropdownMenuItem(
                                              value: (categoria['idusuario']),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    categoria['idusuario']
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
                                                    categoria['nome']
                                                        .toString(),
                                                    style:
                                                        TextStyle(fontSize: 18),
                                                  )
                                                ],
                                              ));
                                        }).toList(),
                                        onChanged: (value) {
                                          setState(
                                            () {
                                              idUsuario = value as int;
                                            },
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
                        Container(
                          padding: EdgeInsets.only(top: size.height * 0.02),
                          child: Row(
                            children: [
                              Container(
                                alignment: Alignment.topLeft,
                                width: size.width * 0.48,
                                padding: EdgeInsets.only(
                                  top: size.height * 0.01,
                                  right: size.width * 0.0,
                                ),
                                child: CampoText().textFieldComMascara(
                                  controllerData,
                                  'Data Entrega:',
                                  tipoTexto: TextInputType.text,
                                  mascara: mascaradata,
                                ),
                              ),
                              Container(
                                //  alignment: Alignment.topRight,
                                width: size.width * 0.48,
                                padding: EdgeInsets.only(
                                  top: size.height * 0.01,
                                  left: size.width * 0.0,
                                ),
                                child: CampoText().textFieldComMascara(
                                  controllerHora,
                                  'Hora Entrega:',
                                  tipoTexto: TextInputType.text,
                                  mascara: mascaraHora,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: size.height * 0.01),
                          child: CampoText().textField(
                            controllerDestino,
                            'destino:',
                            tipoTexto: TextInputType.text,
                            fontWeigth: FontWeight.w500,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: size.height * 0.01),
                          child: CampoText().textField(
                            controllerObs,
                            'OBS:',
                            tipoTexto: TextInputType.text,
                            fontWeigth: FontWeight.w500,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: size.height * 0.04),
                          child: Botao().botaoPadrao(
                            'Salvar',
                            () => validarRomaneio(),
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
