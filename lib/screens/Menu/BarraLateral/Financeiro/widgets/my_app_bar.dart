import 'package:flutter/material.dart';
import 'package:madecontrol_desenvolvimento/Widget/FieldData.dart';

class MyAppBar extends StatelessWidget {
  final bool? showMenu;
  final VoidCallback? onTap;

  const MyAppBar({Key? key, this.showMenu, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    Size size = mediaQuery.size;
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(
            top: size.height * 0.03,
            right: size.width * 0.81,
            bottom: size.height * 0.03,
          ),
          child: Container(
            width: 50,
            height: 51,
            color: Colors.green[500]!.withOpacity(0.5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  iconSize: 35,
                  color: Colors.white,
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                    // caso sair da tela Financeiro, atribui novas datas para somar todos os valores
                    FiltroDatasPesquisa.dataInicial = '1999-01-01';
                    FiltroDatasPesquisa.dataFinal = '2110-01-01';
                  },
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).padding.top,
        ),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.only(
              // top: size.height * 0.03,
              // bottom: size.height * 0.03,
            ),
            height: MediaQuery.of(context).size.height * .12,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      'assets/images/tendencia.png',
                      height: 60,
                      color: Colors.green,
                    ),
                  ],
                ),
                Icon(
                  !showMenu! ? Icons.expand_more : Icons.expand_less,
                  size: 35,
                  color: Colors.green,

                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
