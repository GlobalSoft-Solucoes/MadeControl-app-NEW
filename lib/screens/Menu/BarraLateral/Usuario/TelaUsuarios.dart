import 'package:flutter/material.dart';
import 'package:madecontrol_desenvolvimento/Statics/Static_ConfigAcesso.dart';
import 'package:madecontrol_desenvolvimento/Widget/MsgPopup.dart';
import 'package:madecontrol_desenvolvimento/models/Models_Usuario.dart';

class TelaUsuarios extends StatefulWidget {
  TelaUsuarios({Key? key}) : super(key: key);

  @override
  _TelaUsuariosState createState() => _TelaUsuariosState();
}

class _TelaUsuariosState extends State<TelaUsuarios> {
  mensagemErroAcesso() async {
    await MsgPopup().msgFeedback(
      context,
      '\n Você não tem permissão para acessar!',
      'aviso',
      fontMsg: 20,
    );
    await FieldsAcessoTelas()
        .capturaConfigAcessoTelasUsuario(ModelsUsuarios.idDoUsuario);
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    Size size = mediaQuery.size;
    return SafeArea(
      child: Scaffold(
        // backgroundColor: Colors.white,//(0XFF515667),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/usuarios/usuario04.png"),
              fit: BoxFit.fill),
            gradient: LinearGradient(colors: [
              Colors.grey[100]!.withAlpha(300),
              Colors.grey.withAlpha(1100)
            ]),
          ),
          child: Column(
            children: [
              Container(
                alignment: Alignment.bottomLeft,
                padding: EdgeInsets.only(top: size.height * 0.03, left: 10),
                child: Container(
                  color: Colors.black26,
                  width: size.width * 0.13,
                  height: size.height * 0.06,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                    iconSize: 35,
                    color: Colors.white,
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // =================== LISTA USUÁRIOS =======================
                  GestureDetector(
                    onTap: () {
                      FieldsAcessoTelas.cadUsuario == true
                          ? Navigator.pushNamed(context, '/ListaUsuarios')
                          : mensagemErroAcesso();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          stops: [0.1, 0.3, 0.7, 1],
                          colors: [
                            Colors.grey[400]!.withAlpha(450),
                            Colors.grey[400]!.withAlpha(450),
                            Colors.grey[400]!.withAlpha(450),
                            Colors.grey[400]!.withAlpha(450),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      width: size.width * 0.1,
                      height: size.width * 0.3,
                      margin: EdgeInsets.only(
                          left: 15, right: 15, top: size.height * 0.16),
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          'Usuários',
                          style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  // =================== CARGOS ====================
                  GestureDetector(
                    onTap: () {
                      FieldsAcessoTelas.cadCargo == true
                          ? Navigator.pushNamed(
                              context,
                              '/CadastrarCargo',
                            )
                          : mensagemErroAcesso();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          stops: [0.1, 0.3, 0.7, 1],
                          colors: [
                            Colors.grey[400]!.withAlpha(450),
                            Colors.grey[400]!.withAlpha(150),
                            Colors.grey[400]!.withAlpha(150),
                            Colors.grey[400]!.withAlpha(200),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      height: size.width * 0.3,
                      margin: EdgeInsets.only(left: 15, right: 15),
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          'Cargos',
                          style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // =================== LOGS USUÁRIOS =======================
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      FieldsAcessoTelas.cadUsuario == true
                          ? Navigator.pushNamed(context, '/LogsDatas')
                          : mensagemErroAcesso();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          stops: [0.1, 0.3, 0.7, 1],
                          colors: [
                            Colors.grey[400]!.withAlpha(450),
                            Colors.grey[400]!.withAlpha(450),
                            Colors.grey[400]!.withAlpha(450),
                            Colors.grey[400]!.withAlpha(250),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      height: size.width * 0.3,
                      margin: EdgeInsets.only(left: 15, right: 15),
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          'Logs-usuários',
                          style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
