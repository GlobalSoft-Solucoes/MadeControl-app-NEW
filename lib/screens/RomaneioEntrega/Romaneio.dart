import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:madecontrol_desenvolvimento/Widget/Botao.dart';
import 'package:madecontrol_desenvolvimento/Widget/Cabecalho.dart';
import 'package:madecontrol_desenvolvimento/Widget/MsgPopup.dart';
import 'package:madecontrol_desenvolvimento/Widget/TextField.dart';
import 'package:madecontrol_desenvolvimento/funcoes/FuncoesParaDatas.dart';
import 'package:madecontrol_desenvolvimento/models/Models_Usuario.dart';
import 'package:madecontrol_desenvolvimento/models/constantes.dart';
import 'package:http/http.dart' as http;
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:madecontrol_desenvolvimento/Statics/Static_Cliente.dart';

class Romaneio extends StatefulWidget {
  @override
  _RomaneioState createState() => _RomaneioState();
}

class _RomaneioState extends State<Romaneio> {
  TextEditingController controllerDestino = TextEditingController();
  TextEditingController controllerObs = TextEditingController();
  TextEditingController controllerHora = TextEditingController();
  // TextEditingController controllerData = TextEditingController();
  TextEditingController controllerData =
      MaskedTextController(mask: '00/00/0000');
  var itensLista = [];
  var itensLista2 = [];
  int? data;
  int? idUsuarioMotorista;
  int? idGrupoPedidos;

// variaveis para validação de data e hora
  var diaEntrega;
  var mesEntrega;
  var anoEntrega;
  var dataEntrega;
  var horaEntrega;
  var minutoEntrega;
  var horarioEntrega;

//BUSCA OS PEDIDOS POR GRUPO
  Future buscarGruposPedidos() async {
    final response = await http.get(
        Uri.parse(
            ListarGruposPedidosProntos + ModelsUsuarios.caminhoBaseUser.toString()),
        headers: {"authorization": ModelsUsuarios.tokenAuth.toString()});
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      setState(() {
        itensLista = jsonData;
      });
    }

    if (response.statusCode == 401) {
      Navigator.pushNamed(context, '/login');
    }
  }

  var mascaradata = new MaskTextInputFormatter(
    mask: '##/##/####',
    filter: {
      "#": RegExp(r'[0-9]'),
    },
  );

  var mascaraHora = new MaskTextInputFormatter(
    mask: '##:##',
    filter: {
      "#": RegExp(r'[0-9]'),
    },
  );

//BUSCAR USUARIOS DA EMPRESA
  Future buscarUsuario() async {
    final response = await http.get(
        Uri.parse(ListarTodosUsuarios + ModelsUsuarios.caminhoBaseUser.toString()),
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

//ALTERA O STATUS PARA ENTREGUE!
  alterarstatuEntregue() async {
    var response = await http.put(
     Uri.parse( AlteraStatusGrupoPedidoParaEntregue +
          Cliente.idGrupoPedido.toString() +
          '/' +
          ModelsUsuarios.caminhoBaseUser.toString()),
      headers: {
        "Content-Type": "application/json",
        "authorization": ModelsUsuarios.tokenAuth.toString()
      },
    );
    print(response.statusCode);
    if (response.statusCode == 401) {
      Navigator.pushNamed(context, '/login');
    }
  }

//VALIDA OS CAMPOS
  validarRomaneio() {
    DateTime anoAtual = DateTime.now();

    // Data da entrega
    diaEntrega = controllerData.text.substring(0, 2);
    mesEntrega = controllerData.text.substring(3, 5);
    anoEntrega = controllerData.text.substring(6, 10);
    dataEntrega = anoEntrega + '-' + mesEntrega + '-' + diaEntrega;

    // Hora entrega
    horaEntrega = controllerHora.text.substring(0, 2);
    minutoEntrega = controllerHora.text.substring(3, 5);

    if (controllerData.text.trim().isEmpty) {
      MsgPopup().msgFeedback(
          context, '\nA data não pode ficar vazia', 'Data inválida');
    } else if (controllerData.text.length < 10) {
      MsgPopup()
          .msgFeedback(context, '\nConfira a data informada', 'Data inválida');
    } else if (diaEntrega.length < 2 ||
        mesEntrega.length < 2 ||
        anoEntrega.length < 4) {
      MsgPopup()
          .msgFeedback(context, '\nConfira a data informada', 'Data inválida');
    } else if (int.tryParse(diaEntrega)! > 31 ||
        int.tryParse(mesEntrega)! > 12 )
        // ||int.tryParse(anoEntrega) < anoAtual.year) 
        {
      MsgPopup()
          .msgFeedback(context, '\nConfira a data informada', 'Data inválida');
    } else if (controllerHora.text.trim().isEmpty) {
      MsgPopup().msgFeedback(
          context, '\nA hora não pode ficar vazia', 'Hora inválida');
    } else if (int.tryParse(horaEntrega)! > 24 ||
        int.tryParse(minutoEntrega)! > 59) {
      MsgPopup()
          .msgFeedback(context, '\nConfira a hora informada', 'Hora inválida');
    } else if (controllerDestino.text.isEmpty) {
      MsgPopup().msgFeedback(context, 'o destino não pode ficar vazio', '');
    } else if (idUsuarioMotorista == null) {
      MsgPopup().msgFeedback(context, 'É preciso escolher um motorista', '');
    } else {
      alterarstatuEntregue();
      salvarBanco();
    }
  }

  salvarBanco() async {
    var bodyy = jsonEncode(
      {
        'idusuario': ModelsUsuarios.idDoUsuario,
        'motorista': idUsuarioMotorista,
        'data_entrega': dataEntrega,
        'hora_entrega': controllerHora.text,
        'destino': controllerDestino.text,
        'idgrupo_pedido': Cliente.idGrupoPedido,
        'observacoes': controllerObs.text,
        'status': 'Cadastrado',
      },
    );
    var state = await http.post(
      Uri.parse(CadastrarRomaneio + ModelsUsuarios.caminhoBaseUser.toString()),
      headers: {
        "Content-Type": "application/json",
        "authorization": ModelsUsuarios.tokenAuth.toString()
      },
      body: bodyy,
    );
     print(state.statusCode);
     print(bodyy);
    if (state.statusCode == 201) {
      Navigator.pushNamed(context, '/Home');
    } else if (state.statusCode == 401) {
      Navigator.pushNamed(context, '/login');
    }
  }

  @override
  void initState() {
    super.initState();
    this.buscarGruposPedidos();
    this.buscarUsuario();
    controllerData.text = DataAtual().pegardataBR().toString().replaceAll('-', '/');
    controllerHora.text = DataAtual().pegarHora().toString();
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
                  'Romaneio',
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
                                            Cliente.codigoGrupo.toString(),
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
                                        'cliente:  ' +
                                            Cliente.nomeCliente.toString(),
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
                                left: 5, right: 5, top: size.height * 0.02),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border:
                                    Border.all(color: Colors.black, width: 1),
                              ),
                              child: Column(
                                children: [
                                  new Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: new Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Text(
                                        'Motorista',
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
                                          'Motorista',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        value: idUsuarioMotorista,
                                        items: itensLista2.map(
                                          (categoria) {
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
                                              ),
                                            );
                                          },
                                        ).toList(),
                                        onChanged: (value) {
                                          setState(
                                            () {
                                              idUsuarioMotorista = value as int;
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
                                    controllerData, 'Data entrega:',
                                    tipoTexto: TextInputType.number,
                                    mascara: mascaradata,
                                    fontLabel: size.width * 0.04),
                              ),
                              Container(
                                //  alignment: Alignment.topRight,
                                width: size.width * 0.48,
                                padding: EdgeInsets.only(
                                  top: size.height * 0.01,
                                  left: size.width * 0.0,
                                ),
                                child: CampoText().textFieldComMascara(
                                    controllerHora, 'Hora entrega:',
                                    tipoTexto: TextInputType.number,
                                    mascara: mascaraHora,
                                    fontLabel: size.width * 0.04),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: size.height * 0.02),
                          child: CampoText().textField(
                            controllerDestino,
                            'Destino:',
                            tipoTexto: TextInputType.text,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: size.height * 0.02),
                          child: CampoText().textField(
                            controllerObs,
                            'OBS:',
                            tipoTexto: TextInputType.text,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: size.height * 0.04),
                          child: Botao().botaoPadrao(
                            'Salvar',
                            () => validarRomaneio()
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
