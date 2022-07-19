import 'package:flutter/material.dart';

class ItemMenu extends StatelessWidget {
  final IconData? icon;
  final String? text;

  const ItemMenu({Key? key, this.icon, this.text}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 0.7, color: Colors.white54),
          top: BorderSide(width: 0.8, color: Colors.white54),
        ),
      ),
      child: FloatingActionButton(
        heroTag: "teste 1",
        backgroundColor: Colors.green[200],
        // highlightColor: Colors.transparent,
        elevation: 0,
        disabledElevation: 0,
        focusElevation: 0,
        highlightElevation: 0,
        hoverElevation: 0,
        splashColor: Colors.green[400],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                const SizedBox(
                  width: 10,
                ),
                Icon(
                  icon,
                  size: 30,
                ),
                const SizedBox(
                  width: 20,
                ),
                Text(
                  text!,
                  style: const TextStyle(fontSize: 19),
                ),
              ],
            ),
            const Icon(
              Icons.chevron_right,
              size: 25,
            )
          ],
        ),
        onPressed: () {},
      ),
    );
  }
}
