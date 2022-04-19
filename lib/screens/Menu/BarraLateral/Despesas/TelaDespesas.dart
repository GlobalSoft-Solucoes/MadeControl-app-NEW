import 'package:flutter/material.dart';

class TelaDespesas extends StatefulWidget {
  TelaDespesas({Key? key}) : super(key: key);

  @override
  _TelaDespesasState createState() => _TelaDespesasState();
}

class _TelaDespesasState extends State<TelaDespesas> {
  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    Size size = mediaQuery.size;
    return Scaffold(
      backgroundColor: Colors.green[100],
      body: Container(
        child: Column(
          children: [
            Container(
              alignment: Alignment.bottomLeft,
              padding: EdgeInsets.only(top: size.height * 0.03, left: 10),
              child: Container(
                color: Colors.green[400],
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
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/CadastroTipoDespesa');
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        stops: [0.1, 0.3, 0.7, 1],
                        colors: [
                          Colors.green[400]!,
                          Colors.green[300]!,
                          Colors.green[300]!,
                          Colors.green[400]!
                        ],
                      ),
                    ),
                    width: size.width * 0.1,
                    height: size.width * 0.3,
                    margin: EdgeInsets.only(
                        left: 15, right: 15, top: size.height * 0.23),
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        'Tipo de despesas',
                        style: TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/ListarDespesas');
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        stops: [0.1, 0.3, 0.7, 1],
                        colors: [
                          Colors.green[300]!,
                          Colors.green[400]!,
                          Colors.green[400]!,
                          Colors.green[300]!
                        ],
                      ),
                    ),
                    height: size.width * 0.3,
                    margin: EdgeInsets.only(left: 15, right: 15),
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        'Despesas',
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
    );
  }
}
