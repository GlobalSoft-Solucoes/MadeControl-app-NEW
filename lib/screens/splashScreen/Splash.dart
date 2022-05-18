import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:madecontrol_desenvolvimento/Statics/Static_ConfigAcesso.dart';
import 'package:madecontrol_desenvolvimento/Statics/Static_Empresa.dart';
import 'package:madecontrol_desenvolvimento/Statics/Static_Modulo.dart';
import 'package:madecontrol_desenvolvimento/Statics/Static_Usuario.dart';
import 'package:madecontrol_desenvolvimento/models/Models_Usuario.dart';
import 'package:madecontrol_desenvolvimento/models/constantes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:madecontrol_desenvolvimento/screens/Login/LoginApp.Dart';
import 'package:madecontrol_desenvolvimento/screens/Menu/HomeAplication.Dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  bool? login = true;
  bool? home = false;
  logarUsuario() async {
    bool? validou = false;
    var dadosUsuario = <ModelsUsuarios>[];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getInt('idusuario');
    var caminhoBase = prefs.getString('caminho');
    var token = prefs.getString('Token');

    final response = await http.get(
      Uri.parse(
          // VerificaUsuarioLogado + id.toString()),
          VerificaUsuarioLogado + id.toString() + '/' + caminhoBase.toString()),
      headers: {
        "Content-Type": "application/json",
        "authorization": token.toString()
      },
    );

    if (response.statusCode == 200) {
      validou = true;
      Iterable lista = json.decode(response.body);
      dadosUsuario =
          lista.map((model) => ModelsUsuarios.fromJson(model)).toList();
    }
    if (validou == true) {
      setState(() {
        home = true;
        login = false;
      });
      var idempresa = dadosUsuario[0].idEmpresa;
      logusuario();
      ModelsUsuarios.tokenAuth = token;
      ModelsUsuarios.idDoUsuario = dadosUsuario[0].idUsuario;
      ModelsUsuarios.caminhoBaseUser = dadosUsuario[0].caminho;

      await BuscaDadosUsuarioPorId()
          .capturaDadosUsuariosPorId(ModelsUsuarios.idDoUsuario);
      FieldsAcessoTelas()
          .capturaConfigAcessoTelasUsuario(ModelsUsuarios.idDoUsuario);
      BuscaDadosEmpresaPorUsuario()
          .capturaDadosEmpresa(ModelsUsuarios.idDoUsuario);
      await FieldsModulo().buscaModelsPorEmpresa(idempresa as int);
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
      Future.delayed(Duration(seconds: 5)).then((_) async {
        if (login == true) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Login()));
        }
        if (home == true) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Home()));
        }
      });
    }
    if (validou == false)
      setState(() {
        home = false;
        login = true;
      });
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    Future.delayed(Duration(seconds: 3)).then((_) {
      if (login == true) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Login()));
      }
      if (home == true) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Home()));
      }
    });
  }

  var dia;
  var mes;
  var ano;
  var dias;
  var hora;
  var minuto;

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

  void initState() {
    super.initState();
    this.logarUsuario();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    Size size = mediaQuery.size;
    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        color: Colors.green,
        child: Center(
          child: Text(
            'MADECONTROL',
            style: TextStyle(fontSize: 40),
          ),
        ),
      ),
    );
  }
}
