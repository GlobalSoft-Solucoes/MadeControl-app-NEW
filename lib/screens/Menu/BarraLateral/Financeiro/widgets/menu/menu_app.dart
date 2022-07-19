import 'package:flutter/material.dart';
import 'package:madecontrol_desenvolvimento/screens/Menu/BarraLateral/Financeiro/widgets/menu/item_menu.dart';

class MenuApp extends StatelessWidget {
  final double? top;
  final bool? showMenu;

  const MenuApp({Key? key, this.top, this.showMenu}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top! + 50,
      left: 0,
      right: 0,
      child: AnimatedOpacity(
        duration: Duration(milliseconds: 100),
        opacity: showMenu! ? 1 : 0,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.55,
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: <Widget>[
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 30),
                //   child: Column(
                //     children: const <Widget>[
                //       ItemMenu(
                //         icon: Icons.signal_cellular_alt,
                //         text: 'Dados de faturamento',
                //       ),
                //       ItemMenu(
                //         icon: Icons.signal_cellular_connected_no_internet_4_bar,
                //         text: 'Dados de despesas',
                //       ),
                //       SizedBox(
                //         height: 25,
                //       ),
                //     ],
                //   ),
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
