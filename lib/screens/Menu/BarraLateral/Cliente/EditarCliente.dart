import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:madecontrol_desenvolvimento/Statics/Static_Cliente.dart';
import 'package:madecontrol_desenvolvimento/Widget/Botao.dart';
import 'package:madecontrol_desenvolvimento/Widget/Cabecalho.dart';
import 'package:madecontrol_desenvolvimento/Widget/CheckBox.dart';
import 'package:madecontrol_desenvolvimento/Widget/MsgPopup.dart';
import 'package:madecontrol_desenvolvimento/Widget/TextField.dart';
import 'package:madecontrol_desenvolvimento/models/Models_Usuario.dart';
import 'package:madecontrol_desenvolvimento/models/constantes.dart';
import 'package:http/http.dart' as http;
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class EditarDadosCliente extends StatefulWidget {
  @override
  _EditarDadosClienteState createState() => _EditarDadosClienteState();
}

class _EditarDadosClienteState extends State<EditarDadosCliente> {
  TextEditingController controllerCidade =
      TextEditingController(text: BuscaClientePorId.cidade);
  TextEditingController controllerBairro =
      TextEditingController(text: BuscaClientePorId.bairro);
  TextEditingController controllerEndereco =
      TextEditingController(text: BuscaClientePorId.endereco);
  TextEditingController controllerNumEnd =
      TextEditingController(text: BuscaClientePorId.numResidencia.toString());
  TextEditingController controllerTelefone =
      TextEditingController(text: BuscaClientePorId.telefone);
  TextEditingController controllerNome =
      TextEditingController(text: BuscaClientePorId.nomeCliente);
  MaskedTextController controllerCpf =
      MaskedTextController(text: BuscaClientePorId.cpf, mask: '000.000.000-00');
  MaskedTextController controllerCnpj = MaskedTextController(
      text: BuscaClientePorId.cnpj, mask: '00.000.000/0000-00');
  TextEditingController controllerTipoPessoa =
      TextEditingController(text: "Juridica");
  TextEditingController controllerCodigoCliente =
      TextEditingController(text: BuscaClientePorId.codigoCliente);

  var mascaraCPF = new MaskTextInputFormatter(
      mask: '###.###.###-##', filter: {"#": RegExp(r'[0-9]')});

  var mascaraTelefoneFisica = new MaskTextInputFormatter(
      mask: '(**)*****-****', filter: {"*": RegExp(r'[0-9]')});

  var mascaraTelefoneJuridica = new MaskTextInputFormatter(
      mask: '(**)****-****', filter: {"*": RegExp(r'[0-9]')});
  var listaGrupoPedidosProntos = [];
  var listarUsuarios = [];

  // bool? valorcheckPFisica = BuscaClientePorId.cpf.isEmpty ? false : true;
  bool? checkPFisica = BuscaClientePorId.cpf!.isEmpty ? false : true;
  bool? checkPJuridica = BuscaClientePorId.cnpj!.isEmpty ? false : true;
  bool? valorCheckTipoPessoa = true;

  bool? checkDofSim = BuscaClientePorId.dof.value == true ? true : false;
  bool? checkDofNao = BuscaClientePorId.dof.value == false ? true : false;
  bool? selectCheckDof = true;
  var valorDofSelecionado = BuscaClientePorId.dof.value == true ? true : false;

  // para armazenar os valores do cpf e cnpj quando mudar o tipo pessoa
  var ultimoCpf;
  var ultimoCnpj;

  var campoSelecionado = "CPF:";

  // variaveis para validação de data e hora
  var diaEntrega;
  var mesEntrega;
  var anoEntrega;
  var dataEntrega;
  var horaEntrega;
  var minutoEntrega;

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
      Navigator.pushNamed(context, '/Login');
    }
  }

  // =========== MENSAGEM CASO O USUARIO ESQUECER ALGUM CAMPO VAZIO =============
  _msgErroCadastro(mensagemErro) {
    MsgPopup().msgFeedback(
      context,
      mensagemErro,
      'Aviso',
      sizeTitulo: 20,
      fontMsg: 20,
    );
  }

// ============= VALIDAÇÃO DOS DADOS INFORMADOS ===============
  validarCampos() {
    if (checkPJuridica == true && controllerCnpj.text.length < 17) {
      _msgErroCadastro("\n O CNPJ da Empresa está incorreto");
    } else if (checkPFisica == true && controllerCpf.text.length < 14) {
      _msgErroCadastro("\n O CPF do usuário está incorreto");
    } else if (controllerNome.text.isEmpty) {
      _msgErroCadastro("\n Campo Nome não preenchido");
    } else if (controllerTelefone.text.isEmpty) {
      _msgErroCadastro("\n Campo Telefone não preenchido");
    } else if (controllerCidade.text.isEmpty) {
      _msgErroCadastro("\n Campo Cidade não preenchido");
      // } else if (controllerBairro.text.isEmpty) {
      //   _msgErroCadastro("\n Campo Bairro não preenchido");
      // } else if (controllerEndereco.text.isEmpty) {
      //   _msgErroCadastro("\n Campo Endereço não preenchido");
    } else if (controllerNumEnd.text.isEmpty) {
      _msgErroCadastro("\n Campo Número não preenchido");
    } else if (checkDofNao == false && checkDofSim == false) {
      _msgErroCadastro("\n Campo DOF não foi selecionado");
    } else {
      salvarEdicaoDados();
    }
  }

  salvarEdicaoDados() async {
    var bodyy = jsonEncode(
      {
        'cidade': controllerCidade.text,
        'bairro': controllerBairro.text,
        'endereco': controllerEndereco.text,
        'num_residencia': controllerNumEnd.text,
        'telefone': controllerTelefone.text,
        'nome': controllerNome.text,
        'cpf': checkPFisica == true ? controllerCpf.text : '',
        'cnpj': checkPJuridica == true ? controllerCnpj.text : '',
        'tipo_pessoa': controllerTipoPessoa.text,
        'dof': valorDofSelecionado,
        'codigo_cliente': controllerCodigoCliente.text != null
            ? controllerCodigoCliente.text.toUpperCase()
            : null!,
      },
    );
    var state = await http.put(
      Uri.parse(EditarCliente +
          BuscaClientePorId.idCliente.toString() +
          '/' +
          ModelsUsuarios.caminhoBaseUser.toString()),
      headers: {
        "Content-Type": "application/json",
        "authorization": ModelsUsuarios.tokenAuth.toString()
      },
      body: bodyy,
    );

    if (state.statusCode == 200) {
      Navigator.pop(context);
    } else if (state.statusCode == 401) {
      Navigator.pushNamed(context, '/Login');
    }
  }

  void initState() {
    super.initState();
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
                  'Edição do cliente',
                  iconeVoltar: true,
                  sizeTextTitulo: 0.065,
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: size.width * 0.02,
                      right: size.width * 0.02,
                      bottom: size.height * 0.0),
                  child: Container(
                    width: size.width,
                    height: size.height * 0.83,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15)),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          //====================== CHECK BOX ========================
                          CheckBox().checkBoxDuasOpcoes(
                            context,
                            'Cliente possui DOF?',
                            'Não',
                            'Sim',
                            checkDofNao,
                            checkDofSim,
                            () => {
                              setState(
                                () {
                                  checkDofNao = selectCheckDof;
                                  checkDofSim = false;
                                  valorDofSelecionado = false;
                                },
                              ),
                            },
                            () => {
                              setState(
                                () {
                                  checkDofNao = false;
                                  checkDofSim = true;
                                  valorDofSelecionado = true;
                                },
                              ),
                            },
                            marginBottom: 0.04,
                            marginTop: 0.03,
                          ),
                          // =================== CHECK BOX ========================
                          CheckBox().checkBoxDuasOpcoes(
                            context,
                            'Tipo pessoa:',
                            'Pessoa Física',
                            'Pessoa Jurídica',
                            checkPFisica,
                            checkPJuridica,
                            () => {
                              setState(
                                () {
                                  controllerCpf.text = ultimoCpf;
                                  ultimoCnpj = controllerCnpj.text;
                                  checkPFisica = valorCheckTipoPessoa;
                                  controllerTipoPessoa.text = "Fisica";
                                  checkPJuridica = false;
                                  controllerCnpj.text = "";
                                  campoSelecionado = "CPF:";
                                },
                              ),
                            },
                            () => {
                              setState(
                                () {
                                  ultimoCpf = controllerCpf.text;
                                  controllerCnpj.text = ultimoCnpj;
                                  checkPJuridica = valorCheckTipoPessoa;
                                  controllerTipoPessoa.text = "Juridica";
                                  checkPFisica = false;
                                  controllerCpf.text = "";
                                  campoSelecionado = "CNPJ:";
                                },
                              ),
                            },
                            marginBottom: 0.015,
                          ),
                          //======================================================
                          Padding(
                            padding: EdgeInsets.only(top: size.height * 0.01),
                            child: CampoText().textField(
                              controllerNome,
                              'Nome:',
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: size.height * 0.01),
                            child: CampoText().textField(
                              checkPFisica == true
                                  ? controllerCpf
                                  : controllerCnpj,
                              campoSelecionado,
                              // raioBorda: 20,
                              // icone: Icons.vpn_key,
                              tipoTexto: TextInputType.number,
                            ),
                          ),

                          Padding(
                            padding: EdgeInsets.only(top: size.height * 0.01),
                            child: CampoText().textFieldComMascara(
                              controllerTelefone,
                              'Telefone:',
                              mascara: checkPFisica == true
                                  ? mascaraTelefoneFisica
                                  : mascaraTelefoneJuridica,
                              tipoTexto: TextInputType.number,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: size.height * 0.01),
                            child: CampoText().textField(
                              controllerCidade,
                              'Cidade:',
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: size.height * 0.01),
                            child: CampoText().textField(
                              controllerBairro,
                              'Bairro:',
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: size.height * 0.01),
                            child: CampoText().textField(
                              controllerEndereco,
                              'Endereco:',
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: size.height * 0.01),
                            child: CampoText().textField(
                                controllerNumEnd, 'Número:',
                                tipoTexto: TextInputType.number),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: size.height * 0.0),
                            child: CampoText().textField(
                              controllerCodigoCliente,
                              'Código do cliente:',
                              maxLength: 50,
                            ),
                          ),
                          SizedBox(height: size.height * 0.03),
                          Botao().botaoAnimacaoLoading(
                            context,
                            onTap: () {
                              validarCampos();
                            },
                          ),
                          SizedBox(height: size.height * 0.02),
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
