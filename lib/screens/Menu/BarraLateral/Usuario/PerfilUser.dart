import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:madecontrol_desenvolvimento/Statics/Static_Usuario.dart';
import 'package:madecontrol_desenvolvimento/Widget/Botao.dart';
import 'package:madecontrol_desenvolvimento/Widget/Cabecalho.dart';
import 'package:madecontrol_desenvolvimento/Widget/MsgPopup.dart';
import 'package:madecontrol_desenvolvimento/Widget/TextField.dart';
import 'package:madecontrol_desenvolvimento/models/Models_Usuario.dart';
import 'package:madecontrol_desenvolvimento/models/constantes.dart';
import 'package:madecontrol_desenvolvimento/screens/Menu/HomeAplication.dart';
import 'package:http/http.dart' as http;
import 'package:madecontrol_desenvolvimento/screens/Stores/Login_Store.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class PerfilUsuario extends StatefulWidget {
  PerfilUsuario({Key? key}) : super(key: key);

  @override
  _PerfilUsuarioState createState() => _PerfilUsuarioState();
}

bool? checklCodAdm = false;
bool? valorcheck; //= usuario.adm == '1' ? true : false;

class _PerfilUsuarioState extends State<PerfilUsuario> {
  //
  // ========  ATRIBUI DIRETAMENTE PARA O CAMPO TEXTO, OS DADOS CAPTURADOS DO USUÁRIO ===========
  //
  TextEditingController controllerNome =
      TextEditingController(text: BuscaDadosUsuarioPorId.nome);
  TextEditingController controllerCargo =
      TextEditingController(text: BuscaDadosUsuarioPorId.cargoUsuario);
  TextEditingController controllerEmail =
      TextEditingController(text: BuscaDadosUsuarioPorId.email);
  TextEditingController controllerSenha =
      TextEditingController(text: BuscaDadosUsuarioPorId.senha);
  TextEditingController controllerCodigoAdm = TextEditingController();

  String? mensagemErro;
  String? valorRetornoIdEmpresa;
  String? valorRetornoCodAdm;
  String? valorField;
  String? valorAdm;
  String? valorCampoAdmUser = FieldsUsuario.adm;

  LoginStore loginStore = LoginStore();

// ============= VERIFICA SE HOUVE ALTERAÇÕES NO CADASTRO DO USUARIO ==============
  _verificaSeHouveAlteracoes() {
    if (controllerNome.text != BuscaDadosUsuarioPorId.nome ||
        controllerEmail.text != BuscaDadosUsuarioPorId.email ||
        controllerSenha.text != BuscaDadosUsuarioPorId.senha) {
      _confirmarAlteracoes();
    } else {
      Navigator.pop(context);
    }
  }

// ==== caso o usuario desmarcar o ckeck, confirmar a alterações e clicar em cancelar as alterações,
// marca novamente o checkbox. =======
  _marcaDesmarcaCheckBox() {
    if (FieldsUsuario.adm == '1' && checklCodAdm == false) {
      valorcheck = true;
      checklCodAdm = valorcheck;
    } else {
      valorcheck = false;
      checklCodAdm = valorcheck;
    }
  }

// ======== POPUP DE CONFIRMAÇÃO PARA ALTERAÇÃO DAS INFORMAÇÕES DO USUÁRIO =========
  _confirmarAlteracoes() {
    MsgPopup().msgComDoisBotoes(
      context,
      'Deseja salvar as alterações feitas?',
      'Não',
      'Sim',
      () async {
        await _marcaDesmarcaCheckBox();
        Navigator.pop(context);
         Navigator.pop(context);
      },
      () async {
        await editarDadosUsuario();
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) {
              return Home();
            },
          ),
        );
      },
      corBotaoEsq: Color(0XFFF4485C),
      corBotaoDir: Color(0XFF0099FF),
      sairAoPressionar: true,
    );
  }

  //======== Salva os dados editados no banco de dados =========
  Future<dynamic> editarDadosUsuario() async {
    var bodyy = jsonEncode(
      {
        "nome": controllerNome.text,
        "email": controllerEmail.text,
        "senha": controllerSenha.text,
      },
    );

    var response = await http.put(
     Uri.parse(EditarUsuario +
          ModelsUsuarios.idDoUsuario.toString() +
          '/' +
          ModelsUsuarios.caminhoBaseUser.toString()),
      headers: {
        "Content-Type": "application/json",
        "authorization": ModelsUsuarios.tokenAuth.toString()
      },
      body: bodyy,
    );
    print(bodyy);
    print(response.statusCode);
    print(BuscaDadosUsuarioPorId.idUsuario);
    print(ModelsUsuarios.idDoUsuario);
    // atualiza a lista com os dados alterados do usuário logado
    await BuscaDadosUsuarioPorId()
        .capturaDadosUsuariosPorId(ModelsUsuarios.idDoUsuario);
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
            alignment: Alignment.topCenter,
            color: Colors.green[200],
            child: Column(
              children: [
                Cabecalho().tituloCabecalho(
                  context,
                  'Perfil do usuário',
                  iconeVoltar: true,
                  sizeTextTitulo: 0.065,
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: size.height * 0.04,
                    left: size.height * 0.01,
                    right: size.height * 0.01,
                  ),
                  child: Container(
                    width: size.width,
                    height: size.height * 0.73,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    // child: SingleChildScrollView(
                    child: Column(
                      children: [
                        //=================== NOME DO USUÁRIO ======================
                        Container(
                          child: Text(
                            'Nome do usuário:',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          padding: EdgeInsets.only(
                              right: size.width * 0.58,
                              top: size.height * 0.04),
                        ),
                        CampoText().textField(
                          controllerNome,
                          '',
                          icone: Icons.person,
                          confPadding: EdgeInsets.only(
                              top: 10, left: 10, right: 10, bottom: 30),
                        ),

                        // ================== CARGO DO USUÁRIO =====================
                        Container(
                          child: Text(
                            'cargo do usuário na empresa:',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          padding: EdgeInsets.only(right: size.width * 0.37),
                        ),
                        CampoText().textField(
                          controllerCargo,
                          '',
                          icone: Icons.account_box,
                          tipoTexto: TextInputType.emailAddress,
                          confPadding: EdgeInsets.only(
                              top: 10, left: 10, right: 10, bottom: 30),
                          enabled: false,
                        ),

                        // ================== E-MAIL DO USUÁRIO =====================
                        Container(
                          child: Text(
                            'E-mail do usuário:',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          padding: EdgeInsets.only(right: size.width * 0.58),
                        ),
                        CampoText().textField(
                          controllerEmail,
                          '',
                          icone: Icons.email,
                          tipoTexto: TextInputType.emailAddress,
                          confPadding: EdgeInsets.only(
                              top: 10, left: 10, right: 10, bottom: 30),
                        ),

                        // =================== SENHA DO USUÁRIO ====================
                        Container(
                          child: Text(
                            'senha do usuário',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          padding: EdgeInsets.only(right: size.width * 0.58),
                        ),
                        new Padding(
                          padding: new EdgeInsets.only(
                              top: 10,
                              left: 10,
                              right: 10,
                              bottom: size.height * 0.09),
                          child: Observer(builder: (_) {
                            return new TextFormField(
                              controller: controllerSenha,
                              style: new TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                              ),
                              obscureText: loginStore.senhamostrar!,
                              decoration: new InputDecoration(
                                suffixIcon: InkWell(
                                  child: loginStore.senhamostrar!
                                      ? Icon(Icons.visibility)
                                      : Icon(Icons.visibility_off),
                                  onTap: () {
                                    loginStore.mostrarSenha();
                                  },
                                ),
                                prefixIcon: new Icon(Icons.vpn_key),
                                border: new OutlineInputBorder(
                                  borderRadius: new BorderRadius.circular(
                                    12,
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                        //==================================================
                        Botao().botaoPadrao(
                          'Confirmar',
                          () async {
                            await _verificaSeHouveAlteracoes();
                            setState(
                              () {
                                // Atualiza os dados do usuario no arquivo static onde eles são pegos
                                BuscaDadosUsuarioPorId()
                                    .capturaDadosUsuariosPorId(
                                  ModelsUsuarios.idDoUsuario,
                                );
                              },
                            );
                          },
                        )
                        //==============================================
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
