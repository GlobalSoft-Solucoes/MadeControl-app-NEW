import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:http/http.dart' as http;
import 'package:madecontrol_desenvolvimento/Statics/Static_Usuario.dart';
import 'package:madecontrol_desenvolvimento/Widget/Botao.dart';
import 'package:madecontrol_desenvolvimento/Widget/Cabecalho.dart';
import 'package:madecontrol_desenvolvimento/Widget/MsgPopup.dart';
import 'package:madecontrol_desenvolvimento/Widget/TextField.dart';
import 'package:madecontrol_desenvolvimento/models/Models_Usuario.dart';
import 'package:madecontrol_desenvolvimento/models/constantes.dart';
import 'package:madecontrol_desenvolvimento/screens/Stores/Login_Store.dart';

class EditarDadosUsuario extends StatefulWidget {
  EditarDadosUsuario({Key? key}) : super(key: key);
  @override
  _CadastroUsuarioState createState() => _CadastroUsuarioState();
}

class _CadastroUsuarioState extends State<EditarDadosUsuario> {
  TextEditingController controllerSenha =
      TextEditingController(text: BuscaDadosUsuarioPorId.senha);
  TextEditingController controllerConfSenha =
      TextEditingController(text: BuscaDadosUsuarioPorId.senha);
  TextEditingController controllerEmail =
      TextEditingController(text: BuscaDadosUsuarioPorId.email);
  TextEditingController controllerNome =
      TextEditingController(text: BuscaDadosUsuarioPorId.nome);
  String? mensagemErro = "";

  List itensLista = [];
  int? _cargoSelecionado = BuscaDadosUsuarioPorId.idCargo;
  int? idUsuarioSelecionado = BuscaDadosUsuarioPorId.idUsuario;

  LoginStore senha = LoginStore();
  LoginStore confSenha = LoginStore();

// ====== BUSCA A LISTA DE TODOS OS CARGOS CADASTRADOS =======
  Future listarCargos() async {
    final response = await http.get(
      Uri.parse(ListarTodosCargos + ModelsUsuarios.caminhoBaseUser.toString()),
      headers: {"authorization": ModelsUsuarios.tokenAuth.toString()},
    );

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      setState(() {
        itensLista = jsonData;
      });
    }
    if (response.statusCode == 401) Navigator.pushNamed(context, '/login');
  }

  // VALIDAÇÃO DOS CAMPOS PARA O CADASTRO
  validarCampos() {
    // String? nome = controllerNome.text;
    // String? email = controllerEmail.text;
    // var senha = controllerSenha.text;
    // var confSenha = controllerConfSenha.text;

    if (controllerNome.text.isEmpty) {
      mensagemErro = "O nome precisa ter mais que 3 letras";
      erroValidarCampos();
    } else if (controllerEmail.text.isEmpty &&
        controllerEmail.text.contains("@")) {
      mensagemErro = "Preencha o email corretamente";
      erroValidarCampos();
    } else if (controllerSenha.text.isEmpty &&
        controllerSenha.text.length < 6) {
      mensagemErro = "senha incorreta! a senha precisa ter mais que 8 letras";
      erroValidarCampos();
    } else if (controllerConfSenha.text != controllerSenha.text) {
      mensagemErro = "As senhas não coencidem";
      erroValidarCampos();
    } else if (controllerConfSenha.text == controllerSenha.text) {
      mensagemErro = '';
      if (BuscaDadosUsuarioPorId.email != controllerEmail.text) {
        validarEmailRegistrado();
      } else {
        print('Emtrou');
        _editarUsuario();
      }
    }
  }

// VERIFICA SE O E-MAIL ESTÁ DISPONÍVEL PARA SER CADASTRADO
  validarEmailRegistrado() async {
    var email = jsonEncode({
      'email': controllerEmail.text,
    });

    var result = await http.post(
        Uri.parse(VerificaEmailDisponivel.toString() +
            ModelsUsuarios.caminhoBaseUser.toString()),
        headers: {
          "Content-Type": "application/json",
          "authorization": ModelsUsuarios.tokenAuth.toString()
        },
        body: email);
    print(result.statusCode);
    if (result.statusCode == 200) {
      await _editarUsuario();
    } else {
      emailJaEmUso();
    }
    if (result.statusCode == 401) Navigator.pushNamed(context, '/login');
  }

// ======= FAZ O CADASTRO DO USUÁRIO NO BANCO DE DADOS =========
  _editarUsuario() async {
    var boddy = jsonEncode(
      {
        'idempresa': '1',
        'idcargo': _cargoSelecionado,
        'nome': controllerNome.text.trim(),
        'email': controllerEmail.text.trim(),
        'senha': controllerSenha.text.trim(),
      },
    );

    http.Response state = await http.put(
       Uri.parse(EditarUsuario +
          BuscaDadosUsuarioPorId.idUsuario.toString() +
          '/' +
          ModelsUsuarios.caminhoBaseUser.toString()),
      headers: {
        "Content-Type": "application/json",
        "authorization": ModelsUsuarios.tokenAuth.toString()
      },
      body: boddy,
    );

    if (state.statusCode == 200) {
      await editadoSucesso();
      await Navigator.pushNamed(context, '/ListaUsuarios');
    }
    if (state.statusCode == 401) Navigator.pushNamed(context, '/login');
  }

// ====== MENSAGEM DISPARADA CASO O CADASTRO SEJA CONCLUÍDO ========
  editadoSucesso() async {
    await MsgPopup().msgFeedback(
      context,
      'Usuário editado com sucesso!',
      '',
      fontMsg: 20,
      corMsg: Colors.green[600],
    );
    Navigator.of(context).pushNamed('/ListaUsuarios');
    Navigator.of(context).pop(); // fecha a tela de cadastro do usuário
  }

// DISPARA MENSAGEM AVISANDO QUE O E-MAIL ESTÁ SENDO USADO POR OUTRO USUÁRIO
  emailJaEmUso() {
    MsgPopup().msgFeedback(
      context,
      'Já existe uma conta de usuário cadastrado com este e-mail. Verifique!',
      '',
      fontMsg: 20,
    );
  }

// ======= MENSAGEM DE ERRO AO CADASTRAR O USUÁRO ========
  erroValidarCampos() {
    MsgPopup().msgFeedback(
      context,
      mensagemErro,
      '',
      fontMsg: 20,
    );
  }

  @override
  void initState() {
    super.initState();
    this.listarCargos();
  }

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
                  'Cadastro de usuário',
                  iconeVoltar: true,
                  sizeTextTitulo: 0.065,
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: size.height * 0.055,
                      right: size.width * 0.01,
                      left: size.width * 0.01),
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        //----------------------------------------------------------------
                        Container(
                          child: Container(
                            child: Row(
                              children: [
                                Container(
                                  width: size.width * 0.86,
                                  padding: EdgeInsets.only(
                                      top: size.width * 0.05,
                                      left: 15,
                                      right: 10,
                                      bottom: 25),
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(24),
                                      border: Border.all(
                                          color: Colors.black, width: 1),
                                    ),
                                    child: DropdownButton(
                                      hint: Text(
                                        'Cargo do usuário',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      value: _cargoSelecionado,
                                      items: itensLista.toList().map(
                                        (categoria) {
                                          return DropdownMenuItem(
                                            value: (categoria['idcargo']),
                                            child: Row(
                                              children: [
                                                Text(
                                                  categoria['idcargo']
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
                                                  categoria['nome'],
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
                                            _cargoSelecionado = value as int;
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                //================ ICONE PARA CADASTRAR NOVO CARGO ==================
                                Container(
                                  padding: EdgeInsets.only(
                                    left: size.height * 0.00,
                                    bottom: 25,
                                    right: 10,
                                    top: size.height * 0.022,
                                  ),
                                  child: Container(
                                    width: 39,
                                    // height: 100,
                                    alignment: Alignment.center,
                                    child: new FloatingActionButton(
                                      backgroundColor: Colors.grey[400],
                                      heroTag: "btn2",
                                      elevation: 10,
                                      child: new IconButton(
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.only(right: 0),
                                        iconSize: 40,
                                        icon: Icon(Icons.add_circle_outline,
                                            color: Colors.white),
                                        onPressed: () async {
                                          setState(
                                            () {},
                                          );
                                          await BuscaDadosUsuarioPorId()
                                              .capturaDadosUsuariosPorId(
                                            idUsuarioSelecionado,
                                          );
                                          Navigator.pushNamed(
                                              context, '/CadastrarCargo');
                                        },
                                      ),
                                      onPressed: () {},
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        //----------------------------------------------------------------
                        CampoText().textField(
                          controllerNome,
                          "Nome completo:",
                          raioBorda: 24,
                          confPadding: EdgeInsets.only(
                            top: 5,
                            left: 15,
                            right: 15,
                          ),
                          icone: Icons.person_add,
                          fontWeigth: FontWeight.w500,
                        ),
                        //-----------------------------------------------------------------
                        CampoText().textField(
                          controllerEmail,
                          "E-mail:",
                          raioBorda: 24,
                          confPadding: EdgeInsets.only(
                            top: 30,
                            left: 15,
                            right: 15,
                          ),
                          icone: Icons.email,
                          fontWeigth: FontWeight.w500,
                        ),
                        //--------------------------------------------------------------
                        new Padding(
                          padding:
                              new EdgeInsets.only(top: 30, left: 15, right: 15),
                          child: Observer(
                            builder: (_) {
                              return new TextFormField(
                                controller: controllerSenha,
                                style: new TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                ),
                                obscureText: senha.senhamostrar!,
                                decoration: new InputDecoration(
                                  labelText: 'Senha',
                                  labelStyle: TextStyle(
                                    fontSize: 22,
                                  ),
                                  suffixIcon: InkWell(
                                    child: senha.senhamostrar!
                                        ? Icon(Icons.visibility)
                                        : Icon(Icons.visibility_off),
                                    onTap: () {
                                      senha.mostrarSenha();
                                    },
                                  ),
                                  prefixIcon: new Icon(Icons.vpn_key),
                                  border: new OutlineInputBorder(
                                    borderRadius: new BorderRadius.circular(
                                      24,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        //--------------------------------------------------------------
                        new Padding(
                          padding: new EdgeInsets.only(
                              top: 30, left: 15, right: 15, bottom: 30),
                          child: Observer(
                            builder: (_) {
                              return new TextFormField(
                                controller: controllerConfSenha,
                                style: new TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                ),
                                obscureText: confSenha.senhamostrar!,
                                decoration: new InputDecoration(
                                  labelText: 'Confirmar senha',
                                  labelStyle: TextStyle(
                                    fontSize: 22,
                                  ),
                                  suffixIcon: InkWell(
                                    child: confSenha.senhamostrar!
                                        ? Icon(Icons.visibility)
                                        : Icon(Icons.visibility_off),
                                    onTap: () {
                                      confSenha.mostrarSenha();
                                    },
                                  ),
                                  prefixIcon: new Icon(Icons.vpn_key),
                                  border: new OutlineInputBorder(
                                    borderRadius: new BorderRadius.circular(
                                      24,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        //--------------------------------------------------------------
                        Padding(
                          padding: EdgeInsets.only(top: size.height * 0.08),
                          child: Botao().botaoPadrao(
                            'Salvar',
                            () async {
                              await validarCampos();
                            },
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
