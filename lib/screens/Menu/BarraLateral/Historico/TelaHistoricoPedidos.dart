import 'package:flutter/material.dart';
import 'package:madecontrol_desenvolvimento/Widget/Botao.dart';
import 'HistoricoTodosPedidos/HistoricoGrupoPedidos.dart';

class TelaHistoricoPedidos extends StatefulWidget {
  TelaHistoricoPedidos({Key? key}) : super(key: key);

  @override
  _TelaHistoricoPedidosState createState() => _TelaHistoricoPedidosState();
}

class _TelaHistoricoPedidosState extends State<TelaHistoricoPedidos> {
  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    Size size = mediaQuery.size;
    return Scaffold(
      backgroundColor: Colors.green[100],
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              alignment: Alignment.bottomLeft,
              padding: EdgeInsets.only(top: size.height * 0.03, left: 10),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.green[400],
                    border: Border.all(
                      color: Colors.black12,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(5)),
                width: size.width * 0.13,
                height: size.height * 0.065,
                child: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                  iconSize: 35,
                  color: Colors.white,
                ),
              ),
            ),
            Container(
              height: size.height * 0.8,
              alignment: Alignment.center,
              margin: EdgeInsets.only(
                left: 15,
                right: 15,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 20),
                  Botao().botaoAnimacaoLoading(
                    context,
                    altura: size.height * 0.13,
                    txtbutton: 'Pedidos por cliente',
                    tamanhoLetra: 30,
                    onTap: () {
                      Navigator.pushNamed(context, '/ListaClientesHistorico');
                    },
                    timeLoading: 2,
                  ),
                  SizedBox(height: size.height * 0.04),
                  Botao().botaoAnimacaoLoading(
                    context,
                    altura: size.height * 0.13,
                    comprimento: 400,
                    txtbutton: 'Todos os pedidos',
                    tamanhoLetra: 30,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HistoricoGrupoPedidos(),
                        ),
                      );
                    },
                    timeLoading: 2,
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
