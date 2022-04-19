import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:http/http.dart' as http;
import 'package:madecontrol_desenvolvimento/Widget/Botao.dart';
import 'package:madecontrol_desenvolvimento/Widget/Cabecalho.dart';
import 'package:madecontrol_desenvolvimento/Widget/MsgPopup.dart';
import 'package:madecontrol_desenvolvimento/Widget/TextField.dart';
import 'package:madecontrol_desenvolvimento/funcoes/FuncoesParaDatas.dart';
import 'package:madecontrol_desenvolvimento/models/Models_Usuario.dart';
import 'package:madecontrol_desenvolvimento/models/constantes.dart';
import 'package:madecontrol_desenvolvimento/screens/Stores/Login_Store.dart';

class CadastroUsuario extends StatefulWidget {
  CadastroUsuario({Key? key}) : super(key: key);
  @override
  _CadastroUsuarioState createState() => _CadastroUsuarioState();
}

class _CadastroUsuarioState extends State<CadastroUsuario> {
  TextEditingController controllerSenha = TextEditingController();
  TextEditingController controllerConfSenha = TextEditingController();
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerNome = TextEditingController();

  LoginStore senha = LoginStore();
  LoginStore confSenha = LoginStore();

  String? mensagemErro = "";

  List itensLista = [];
  int? _cargoSelecionado;
  int? idUsuarioCadastrado;

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
  }

  // VALIDAÇÃO DOS CAMPOS PARA O CADASTRO
  validarCampos() {
    String? nome = controllerNome.text;
    String? email = controllerEmail.text;
    String? senha = controllerSenha.text;
    String? confSenha = controllerConfSenha.text;

    if (nome.isEmpty) {
      mensagemErro = "O nome precisa ter mais que 3 letras";
      erroValidarCampos();
    } else if (email.isEmpty && email.contains("@")) {
      mensagemErro = "Preencha o email corretamente";
      erroValidarCampos();
    } else if (senha.isEmpty && senha.length < 6) {
      mensagemErro = "senha incorreta! a senha precisa ter mais que 8 letras";
      erroValidarCampos();
    } else if (confSenha != senha) {
      mensagemErro = "As senhas não coencidem";
      erroValidarCampos();
    } else if (controllerConfSenha.text == senha) {
      mensagemErro = '';
      validarEmailRegistrado();
    }
  }

// VERIFICA SE O E-MAIL ESTÁ DISPONÍVEL PARA SER CADASTRADO
  validarEmailRegistrado() async {
    var email = jsonEncode({
      'email': controllerEmail.text,
    });

    var result = await http.post(
        Uri.parse(
            VerificaEmailDisponivel + ModelsUsuarios.caminhoBaseUser.toString()),
        headers: {
          "Content-Type": "application/json",
          "authorization": ModelsUsuarios.tokenAuth.toString()
        },
        body: email);
    if (result.statusCode == 200) {
      await _cadastrarUsuario();
      _capturaIdUltimoUsuarioCadastrado();
    } else {
      emailJaEmUso();
    }
  }

  // =========== CAPTURA O ID DO USUARIO ATRAVÉS DO E-MAIL DELE ===============
  _capturaIdUltimoUsuarioCadastrado() async {
    var result = await http.get(
        Uri.parse(
            BuscarUltimoUsuarioCadastrado + ModelsUsuarios.caminhoBaseUser.toString()),
        headers: {
          "authorization": ModelsUsuarios.tokenAuth.toString(),
        });
    // Captura o valor vindo do body da requisição
    String? retorno = result.body;
    // caso o retorno do Body for diferente de vazio("[]"), continua a execução
    if (retorno != "[]") {
      // Repara para mostra apenas o valor da chave primária
      String? valorRetorno = retorno
          .substring(retorno.indexOf(':'), retorno.indexOf('}'))
          .replaceAll(':', '');

      // caso haja valor na variável, quer dizer que contém um registro
      if (valorRetorno.length > 0) {
        idUsuarioCadastrado = int.parse(valorRetorno);
        // carrega os dados do usuário logado
        await _cadastrarAcessoTelas(idUsuarioCadastrado);
      }
    }
  }

// ======= FAZ O CADASTRO DO USUÁRIO NO BANCO DE DADOS =========
  _cadastrarUsuario() async {
    var boddy = jsonEncode(
      {
        'idempresa': '1',
        'idcargo': _cargoSelecionado,
        'nome': controllerNome.text.trim(),
        'email': controllerEmail.text.trim(),
        'senha': controllerSenha.text.trim(),
        'adm': 'Nao',
        'data_cadastro': DataAtual().pegardataBR() as String,
        'caminho': ModelsUsuarios.caminhoBaseUser.toString(),
      },
    );
    var result = await http.post(
        Uri.parse(CadastrarUsuario + ModelsUsuarios.caminhoBaseUser.toString()),
        headers: {
          "Content-Type": "application/json",
          "authorization": ModelsUsuarios.tokenAuth.toString()
        },
        body: boddy);
    if (result.statusCode == 201) msgCadSucesso();
  }

// ===== FAZ O CADASTRO DAS CONFIGURACOES DE ACESSO DAS TELAS PARA O USUÁRIO CADASTRADO =========
  _cadastrarAcessoTelas(idUsuario) async {
    var boddy = jsonEncode(
      {
        'idusuario': idUsuarioCadastrado,
        'cad_usuario': false,
        'cad_cargo': false,
        'cad_lote': false,
        'cad_pedido': false,
        'cad_produto': false,
        'cad_madeira': false,
        'cad_pallet': false,
        'cad_romaneio': false,
        'processo_madeira': false,
        'historico_pedidos': false,
        'historico_romaneios': false,
        'lista_clientes': false,
        'lixeira_grupopedidos': false,
        'pedidos_cadastrados': false,
        'pedidos_producao': false,
        'pedidos_prontos': false,
        'financeiro': false,
        'lista_despesas': false,
        'lista_recebimentos': false,
        'estatisticas': false,
        'venda_avulso': false,
      },
    );
    var result = await http.post(
        Uri.parse(CadastrarAcessoTelas + ModelsUsuarios.caminhoBaseUser.toString()),
        headers: {
          "Content-Type": "application/json",
          "authorization": ModelsUsuarios.tokenAuth.toString()
        },
        body: boddy);
    if (result.statusCode == 201){}
    print(boddy);
  }

// ====== MENSAGEM DISPARADA CASO O CADASTRO SEJA CONCLUÍDO ========
  msgCadSucesso() async {
    await MsgPopup().msgFeedback(
      context,
      'Usuário cadastrado com sucesso!',
      '',
      fontMsg: 20,
      corMsg: Colors.green[600],
    );
    Navigator.of(context).pop(); // fecha a tela de cadastro do usuário
  }

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
                      top: size.height * 0.07,
                      right: size.width * 0.02,
                      left: size.width * 0.02),
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        //----------------------------------------------------------------
                        Container(
                          // width: 100,
                          padding: EdgeInsets.only(
                              top: size.height * 0.04,
                              left: 15,
                              right: 15,
                              bottom: 25),
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40),
                                border:
                                    Border.all(color: Colors.black, width: 1)),
                            child: DropdownButton(
                              hint: Text(
                                'Cargo do usuário',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                              value: _cargoSelecionado,
                              items: itensLista.map(
                                (categoria) {
                                  return DropdownMenuItem(
                                    value: (categoria['idcargo']),
                                    child: Row(
                                      children: [
                                        Text(
                                          categoria['idcargo'].toString(),
                                          style: TextStyle(fontSize: 18),
                                        ),
                                        Text(
                                          ' - ',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                        Text(
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
                                    _cargoSelecionado = value as int;
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                        //----------------------------------------------------------------
                        CampoText().textField(
                          controllerNome,
                          "Nome:",
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

                        Padding(
                          padding: EdgeInsets.only(top: size.height * 0.03),
                          child: Botao().botaoAnimacaoLoading(
                            context,
                            onTap: () {
                              validarCampos();
                            },
                          ),
                        ),
                        SizedBox(height: size.height * 0.02)
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
