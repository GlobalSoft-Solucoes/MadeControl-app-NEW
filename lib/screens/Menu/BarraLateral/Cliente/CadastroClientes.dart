import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:madecontrol_desenvolvimento/Widget/Botao.dart';
import 'package:madecontrol_desenvolvimento/Widget/Cabecalho.dart';
import 'package:madecontrol_desenvolvimento/Widget/CheckBox.dart';
import 'package:madecontrol_desenvolvimento/Widget/MsgPopup.dart';
import 'package:madecontrol_desenvolvimento/Widget/TextField.dart';
import 'package:madecontrol_desenvolvimento/models/Models_Usuario.dart';
import 'package:madecontrol_desenvolvimento/models/constantes.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';

class CadastroDeClientes extends StatefulWidget {
  @override
  _CadastroDeClientesState createState() => _CadastroDeClientesState();
}

class _CadastroDeClientesState extends State<CadastroDeClientes> {
  TextEditingController controllerCidade = TextEditingController();
  TextEditingController controllerBairro = TextEditingController();
  TextEditingController controllerEndereco = TextEditingController();
  TextEditingController controllerNumEnd = TextEditingController();
  TextEditingController controllerTelefone = TextEditingController();
  TextEditingController controllerNome = TextEditingController();
  MaskedTextController controllerCpf =
      MaskedTextController(mask: '000.000.000-00');
  MaskedTextController controllerCnpj =
      MaskedTextController(mask: '00.000.000/0000-00');
  TextEditingController controllerTipoPessoa =
      TextEditingController(text: "Juridica");
  TextEditingController controllerCodigoCliente = TextEditingController();

  var mascaraCPF = new MaskTextInputFormatter(
      mask: '###.###.###-##', filter: {"#": RegExp(r'[0-9]')});

  var mascaraTelefoneFisica = new MaskTextInputFormatter(
      mask: '(**)*****-****', filter: {"*": RegExp(r'[0-9]')});

  var mascaraTelefoneJuridica = new MaskTextInputFormatter(
      mask: '(**)****-****', filter: {"*": RegExp(r'[0-9]')});

  String? mensagemErro = "";

  bool? checkPFisica = false;
  bool? checkPJuridica = true;
  bool? valorCheckTipoPessoa = true;

  bool? checkDofSim = false;
  bool? checkDofNao = true;
  bool? valorDofSelecionado = false;

  var campoSelecionado = "CNPJ:";

  salvarBanco() async {
    var bodyy = jsonEncode(
      {
        'cidade': controllerCidade.text,
        'bairro': controllerBairro.text,
        'endereco': controllerEndereco.text,
        'num_residencia': controllerNumEnd.text,
        'telefone': controllerTelefone.text,
        'nome': controllerNome.text,
        'cpf': controllerCpf.text,
        'cnpj': controllerCnpj.text,
        'tipo_pessoa': controllerTipoPessoa.text,
        'dof': valorDofSelecionado,
        'codigo_cliente': controllerCodigoCliente.text != null
            ? controllerCodigoCliente.text.toUpperCase()
            : null,
      },
    );
    var state = await http.post(
      Uri.parse(CadastrarCliente + ModelsUsuarios.caminhoBaseUser.toString()),
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
      Navigator.pushNamed(context, '/ListaClientes');
    } else if (state.statusCode == 400) {
      Navigator.pushNamed(context, '/Login');
    }
  }

  // =========== MENSAGEM CASO O USUARIO ESQUECER ALGUM CAMPO VAZIO =============
  _msgErroCadastro() {
    MsgPopup().msgFeedback(
      context,
      mensagemErro,
      'Aviso',
      sizeTitulo: 20,
      fontMsg: 20,
    );
  }

  validarCampos() {
    if (controllerNome.text.isEmpty) {
      mensagemErro = "\n O campo oome não foi preenchido!";
      _msgErroCadastro();
    } else if (checkPJuridica == true && controllerCnpj.text.length < 17) {
      mensagemErro = "\n O CNPJ da Empresa está incorreto!";
      _msgErroCadastro();
    } else if (checkPFisica == true && controllerCpf.text.length < 14) {
      mensagemErro = "\n O CPF do usuário está incorreto!";
      _msgErroCadastro();
    } else if (controllerTelefone.text.isEmpty) {
      mensagemErro = "\n Campo Telefone não preenchido!";
      _msgErroCadastro();
    } else if (controllerCidade.text.isEmpty) {
      mensagemErro = "\n Campo Cidade não preenchido!";
      _msgErroCadastro();
      // } else if (controllerBairro.text.isEmpty) {
      //   mensagemErro = "\n Campo Bairro não preenchido";
      //   _msgErroCadastro();
      // } else if (controllerEndereco.text.isEmpty) {
      //   mensagemErro = "\n Campo Endereço não preenchido";
      //   _msgErroCadastro();
    } else if (controllerNumEnd.text.isEmpty) {
      mensagemErro = "\n Campo Número não preenchido!";
      _msgErroCadastro();
    } else if (valorDofSelecionado == null) {
      mensagemErro = "\n Campo DOF não foi selecionado!";
      _msgErroCadastro();
    } else if (controllerCodigoCliente.text.contains(' ')) {
      mensagemErro =
          "\n Campo Codigo cliente não pode conter espaços em branco!";
      _msgErroCadastro();
    } else {
      salvarBanco();
    }
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
                  'Cadastro de Cliente',
                  iconeVoltar: true,
                  sizeTextTitulo: 0.065,
                  marginBottom: 0.02,
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: size.width * 0.02,
                      right: size.width * 0.02,
                      bottom: size.height * 0.01),
                  child: Container(
                    width: size.width,
                    height: size.height * 0.86,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          //======================================================
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
                                  checkDofNao = true;
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
                                  checkPFisica = valorCheckTipoPessoa;
                                  controllerTipoPessoa.text = "Fisica";
                                  checkPJuridica = false;
                                  controllerCnpj.text = "";
                                  controllerTelefone.text = "";
                                  campoSelecionado = "CPF:";
                                },
                              ),
                            },
                            () => {
                              setState(
                                () {
                                  checkPJuridica = valorCheckTipoPessoa;
                                  controllerTipoPessoa.text = "Juridica";
                                  checkPFisica = false;
                                  controllerCpf.text = "";
                                  controllerTelefone.text = "";
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
                              controllerNumEnd,
                              'Número:',
                              tipoTexto: TextInputType.number,
                              maxLength: 9,
                            ),
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
                          SizedBox(height: size.height * 0.03),
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
