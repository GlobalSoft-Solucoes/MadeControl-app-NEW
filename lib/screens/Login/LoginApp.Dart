import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:madecontrol_desenvolvimento/Statics/Static_ConfigAcesso.dart';
import 'package:madecontrol_desenvolvimento/Statics/Static_Usuario.dart';
import 'package:madecontrol_desenvolvimento/Widget/Botao.dart';
import 'package:madecontrol_desenvolvimento/Widget/MsgPopup.dart';
import 'package:madecontrol_desenvolvimento/Widget/TextField.dart';
import 'package:madecontrol_desenvolvimento/models/Models_Usuario.dart';
import 'package:madecontrol_desenvolvimento/models/constantes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:madecontrol_desenvolvimento/Statics/Static_Empresa.dart';
import 'package:madecontrol_desenvolvimento/Statics/Static_Modulo.dart';

class Login extends StatefulWidget {
  Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerSenha = TextEditingController();
  TextEditingController controllerInfoEmail = TextEditingController();
  TextEditingController controllerCodigoEnviadoEmail = TextEditingController();
  TextEditingController controllerNovaSenha = TextEditingController();
  TextEditingController controllerConfNovaSenha = TextEditingController();
  String? msgAvisoAlterarSenha;
  String? mensagemErro = "";
  var respostajson;
  // ================== ENVIA O E-MAIL PARA RECUPERAÇÃO DE SENHA ==================
  String? emailUsuario = '';
  String? senhaUsuario = '';
  bool? isloading = false;
  var dia;
  var mes;
  var ano;
  var dias;
  var hora;
  var minuto;

// ============ POPUP DISPARADO CASO ALGUM ERRO ACONTEÇA AO TENTAR ALTERAR A SENHA ============

  pegardata() async {
    dia = DateTime.now().day;
    mes = DateTime.now().month;
    ano = DateTime.now().year;
    return dias = '$ano/$mes/$dia';
  }

  logusuario() async {
    var horaFinal = TimeOfDay.now();
    var horas = horaFinal.hour;
    var minuto = horaFinal.minute;
    var horaCorrigida = horas - 3;
    var horafinalCerta = horaCorrigida.toString() + ':' + minuto.toString();
    await pegardata();
    var boddy = jsonEncode(
      {
        'idusuario': ModelsUsuarios.idDoUsuario,
        'mensagem': ' Logou com Sucesso!',
        'data_login': dias,
        'hora_login': horafinalCerta
      },
    );
    print(CadastrarRegistroLogin);
    print(boddy);
    http.Response state = await http.post(
      Uri.parse(CadastrarRegistroLogin +
          ModelsUsuarios.idDoUsuario.toString() +
          '/' +
          ModelsUsuarios.caminhoBaseUser.toString()),
      headers: {
        "Content-Type": "application/json",
        "authorization": ModelsUsuarios.tokenAuth.toString()
      },
      body: boddy,
    );
    if (state.statusCode == 401) {
      print('erro');
      Navigator.pushNamed(context, '/login');
    }
  }

  var dadosUsuario = <ModelsUsuarios>[];

  validarDadosLogin(String? emailLogin, senhaLogin) async {
    var boddy = jsonEncode(
      {
        'email': emailLogin,
        'senha': senhaLogin,
      },
    );

    http.Response state = await http.post(
      Uri.parse(LogarUsuario),
      headers: {"Content-Type": "application/json"},
      body: boddy,
    );

    // setState(
    //   () async{
    if (state.statusCode == 200) {
      logusuario();
      //faz um map para separar os dados do req.body
      Map<String, dynamic> respostajson = jsonDecode(state.body);
      ModelsUsuarios.tokenAuth = 'Bearer ' + (respostajson['token']);
      //armazena a lista result na variavel
      var result = respostajson['result'];
      if (mounted)
        setState(() {
          //faz outro map, no result para poder capturar os dados do usuario
          Iterable lista = result;
          dadosUsuario =
              lista.map((model) => ModelsUsuarios.fromJson(model)).toList();
        });
      //passa o id do usuario para o usuario
      ModelsUsuarios.idDoUsuario = dadosUsuario[0].idUsuario;
      ModelsUsuarios.caminhoBaseUser = dadosUsuario[0].caminho;
      await BuscaDadosUsuarioPorId()
          .capturaDadosUsuariosPorId(ModelsUsuarios.idDoUsuario);
      FieldsAcessoTelas()
          .capturaConfigAcessoTelasUsuario(ModelsUsuarios.idDoUsuario);
      await BuscaDadosEmpresaPorUsuario()
          .capturaDadosEmpresa(ModelsUsuarios.idDoUsuario);
      await FieldsModulo()
          .buscaModelsPorEmpresa(BuscaDadosEmpresaPorUsuario.idEmpresa);
      Navigator.of(context).pop();
      Navigator.of(context).pushNamed('/Home');
      // atualiza os dados da empresa
    } else
      _erroLogin();
    //   },
    // );
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('idusuario', int.parse(ModelsUsuarios.idDoUsuario.toString()));
    prefs.setString('caminho', ModelsUsuarios.caminhoBaseUser.toString());
    prefs.setString('Token', ModelsUsuarios.tokenAuth.toString());
  }

// mensagem de erro ao tentar fazer login com e-mail ou senha incorretos
  _erroLogin() {
    MsgPopup().msgFeedback(
      context,
      'Usuário ou senha estão incorretos. Verifique!',
      '',
      corMsg: Colors.red,
      fontMsg: 20,
    );
  }

  _validarCampos() {
    String? email = controllerEmail.text;
    String? senha = controllerSenha.text;

    if (email.isNotEmpty && email.contains("@")) {
      if (senha.isNotEmpty) {
        if (senha.isNotEmpty) {
          setState(
            () {
              mensagemErro = "";
              validarDadosLogin(email, senha);
            },
          );
        }
      } else {
        setState(
          () {
            _erroLogin();
          },
        );
      }
    } else {
      setState(
        () async {
          await _erroLogin();
        },
      );
    }
  }

  mostrarSpeedDial() {
    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: IconThemeData(size: 30),
      child: Icon(Icons.add),
      visible: true,
      curve: Curves.bounceIn,
      overlayColor: Colors.blue[50],
      overlayOpacity: 0.6,
      tooltip: 'Speed Dial',
      heroTag: 'speed-dial-hero-tag',
      backgroundColor: Colors.black45,
      foregroundColor: Colors.white,
      elevation: 8.0,
      shape: CircleBorder(),
      children: [
        SpeedDialChild(
          child: Icon(Icons.add, size: 35),
          backgroundColor: Colors.orange,
          label: 'Acompanhar pedido',
          labelStyle: TextStyle(fontSize: 20),
          onTap: () => {
             Navigator.pushNamed(context, '/AcompanharPedido'),
            // Navigator.pushNamed(context, '/AcompanharPedido'),
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    Size size = mediaQuery.size;
    return new SafeArea(
      child: Scaffold(
        // floatingActionButton: mostrarSpeedDial(),
        backgroundColor: Colors.green[300],
        body: new Form(
          child: new Stack(
            children: <Widget>[
              new Positioned(
                child: new SingleChildScrollView(
                  child: new Container(
                    height: size.height * 1,
                    width: size.width * 1,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/login06.jpg"),
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        //----------------------Usuário--------------------//
                        new Padding(
                          padding: new EdgeInsets.only(
                            left: 15,
                            right: 15,
                          ),
                          child: new TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            controller: controllerEmail,
                            style: new TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                            ),
                            decoration: new InputDecoration(
                                fillColor: Colors.white.withOpacity(0.5),
                                filled: true,
                                prefixIcon: new Icon(Icons.email),
                                labelText: 'E-mail:',
                                labelStyle: new TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w500,
                                ),
                                border: new OutlineInputBorder(
                                  borderRadius: new BorderRadius.circular(
                                    20,
                                  ),
                                ),
                                helperText: "seuemail@seuprovedor.com.br"),
                          ),
                        ),
                        //---------------------senha---------------------//
                        CampoText().textField(
                          controllerSenha,
                          "Senha:",
                          raioBorda: 20,
                          confPadding:
                              EdgeInsets.only(left: 15, right: 15, top: 25),
                          icone: Icons.vpn_key,
                          fontWeigth: FontWeight.w700,
                          campoSenha: true,
                          fontLabel: 22,
                          backgroundColor: Colors.white.withOpacity(0.5),
                        ),
                        //--------------------Botão Conectar----------------------//
                        SizedBox(height: size.height * 0.08),
                        Botao().botaoAnimacaoLoading(
                          context,
                          onTap: () {
                            _validarCampos();
                          },
                          txtbutton: 'Conectar',
                          corFonte: Colors.black87,
                          comprimento: size.width * 0.7,
                          borderRadius: 20,
                          tamanhoLetra: 26,
                          animacao: SpinKitFadingCircle(
                            color: Colors.red,
                            size: 35,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // ========================== NOME DO PROJETO ==========================
              new Container(
                alignment: Alignment.topCenter,
                padding: EdgeInsets.only(
                  top: size.height * 0.05,
                ),
                child: Text(
                  'MADECONTROL',
                  style: TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.w400,
                    // fontFamily: 'Raleway',
                  ),
                ),
              ),
              Container(
                //==================== NOME DA EMRPESA ========================
                padding: EdgeInsets.only(
                  top: size.height * 0.85,
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.only(right: size.width * 0.0),
                        child: Text(
                          'GlobalSoft',
                          style: TextStyle(
                              fontSize: 21, fontWeight: FontWeight.w600),
                        ),
                      ),
                      Text(
                        'Soluções Tecnologicas',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
