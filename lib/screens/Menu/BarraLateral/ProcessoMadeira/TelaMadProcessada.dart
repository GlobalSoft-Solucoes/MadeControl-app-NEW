import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:madecontrol_desenvolvimento/Statics/Static_ConfigAcesso.dart';
import 'package:madecontrol_desenvolvimento/Statics/Static_ProcessoMadeira.dart';
import 'package:madecontrol_desenvolvimento/Widget/MsgPopup.dart';
import 'package:madecontrol_desenvolvimento/models/Models_Usuario.dart';

import 'ListaProcessoPorTora.dart';

class TelaMadProcessada extends StatefulWidget {
  TelaMadProcessada({Key? key}) : super(key: key);

  @override
  TelaMadProcessadaState createState() => TelaMadProcessadaState();
}

class TelaMadProcessadaState extends State<TelaMadProcessada> {
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
            gradient: LinearGradient(colors: [
              Colors.grey[100]!.withAlpha(300),
              Colors.grey.withAlpha(1100)
            ]),
          ),
          child: Column(
            children: [
              Container(
                alignment: Alignment.bottomLeft,
                padding: EdgeInsets.only(top: size.height * 0.02, left: 10),
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
                  // ======================= TORA FINA ===========================
                  GestureDetector(
                    onTap: () {
                      FieldsProcessoMadeira.tipoTora = 1;
                      FieldsProcessoMadeira().detalhesProcessoPorTipoTora(1);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ListaProcessoPorTora(),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[400]!.withAlpha(450),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      width: size.width * 0.1,
                      height: size.width * 0.25,
                      margin: EdgeInsets.only(
                          left: 15, right: 15, top: size.height * 0.1),
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          'TORA FINA',
                          style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  // =================== TORA MÉDIA =======================
                  GestureDetector(
                    onTap: () {
                      FieldsProcessoMadeira.tipoTora = 2;
                      FieldsProcessoMadeira().detalhesProcessoPorTipoTora(2);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ListaProcessoPorTora(),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[400]!.withAlpha(450),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      width: size.width * 0.1,
                      height: size.width * 0.25,
                      margin: EdgeInsets.only(
                        left: 15,
                        right: 15,
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          'TORA MÉDIA',
                          style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  // =================== TORA DO GROSSA =======================
                  GestureDetector(
                    onTap: () {
                      FieldsProcessoMadeira.tipoTora = 3;
                      FieldsProcessoMadeira().detalhesProcessoPorTipoTora(3);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ListaProcessoPorTora(),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[400]!.withAlpha(450),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      height: size.width * 0.25,
                      margin: EdgeInsets.only(left: 15, right: 15),
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          'TORA GROSSA',
                          style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // =================== TORA DO PÉ =======================
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      FieldsProcessoMadeira.tipoTora = 4;
                      FieldsProcessoMadeira().detalhesProcessoPorTipoTora(4);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ListaProcessoPorTora(),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[400]!.withAlpha(450),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      height: size.width * 0.25,
                      margin: EdgeInsets.only(left: 15, right: 15),
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          'TORA DO PÉ',
                          style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // =================== TORA DO PÉ =======================
                  SizedBox(height: Get.height * 0.1),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/ListaHistoricoSerraFita');
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[500],
                        borderRadius: BorderRadius.circular(5),
                      ),
                      height: size.width * 0.25,
                      margin: EdgeInsets.only(left: 15, right: 15),
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          'VER PROCESSO POR USUÁRIO',
                          style: TextStyle(
                            fontSize: 26,
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
