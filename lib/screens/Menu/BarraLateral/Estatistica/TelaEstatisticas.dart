import 'package:flutter/material.dart';
import 'package:madecontrol_desenvolvimento/Statics/Estatisticas/Static_EstCliente.dart';
import 'package:madecontrol_desenvolvimento/Statics/Estatisticas/Static_EstFaturamento.dart';
import 'package:madecontrol_desenvolvimento/Statics/Estatisticas/Static_EstLote.dart';
import 'package:madecontrol_desenvolvimento/Statics/Estatisticas/Static_EstProduto.dart';
import 'package:madecontrol_desenvolvimento/Statics/Static_SaldoDevedor.dart';
import 'package:madecontrol_desenvolvimento/Widget/Botao.dart';

import 'Lote/EstatisticaLote.dart';

class TelaEstatisticas extends StatefulWidget {
  TelaEstatisticas({Key? key}) : super(key: key);

  @override
  _TelaEstatisticasState createState() => _TelaEstatisticasState();
}

class _TelaEstatisticasState extends State<TelaEstatisticas> {
  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    Size size = mediaQuery.size;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/estatisticas/estatistica04.png"),
              fit: BoxFit.fill),
        ),
        child: Column(
          children: [
            Container(
              alignment: Alignment.bottomLeft,
              padding: EdgeInsets.only(top: size.height * 0.03, left: 10),
              child: Container(
                // color: Colors.black26,
                width: size.width * 0.13,
                height: size.height * 0.065,
                child: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                  iconSize: 35,
                  color: Colors.white,
                ),
                decoration: BoxDecoration(
                    color: Colors.black26,
                    border: Border.all(
                      color: Colors.black12,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(5)),
              ),
            ),
            Container(
              height: size.height * 0.85,
              alignment: Alignment.center,
              margin: EdgeInsets.only(
                left: size.width * 0.04,
                right: size.width * 0.04,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: size.height * 0.0),
                  Botao().botaoAnimacaoLoading(
                    context,
                    altura: size.height * 0.12,
                    comprimento: 400,
                    txtbutton: 'Clientes',
                    corFonte: Colors.white,
                    tamanhoLetra: 35,
                    onTap: () async {
                      await FieldsEstatisticaClientes()
                          .detalhesFaturamentoClientesPorData(
                              '01-01-2000', '01-01-2100');
                      Navigator.pushNamed(context, '/EstatisticaClientes');
                    },
                    timeLoading: 2,
                    colorButton: Colors.grey[200]!.withOpacity(0.5),
                  ),
                  SizedBox(height: size.height * 0.03),
                  Botao().botaoAnimacaoLoading(
                    context,
                    altura: size.height * 0.12,
                    comprimento: 400,
                    txtbutton: 'Faturamento',
                    corFonte: Colors.white,
                    tamanhoLetra: 35,
                    onTap: () async {
                      var anoAtual = DateTime.now().year;
                      await FieldsEstatisticaFaturamento()
                          .detalhesFaturamentoTotalMeses(anoAtual.toString());
                      Navigator.pushNamed(context, '/EstatisticaFaturamento');
                    },
                    timeLoading: 2,
                    colorButton: Colors.grey[200]!.withOpacity(0.5),
                  ),
                  SizedBox(height: size.height * 0.03),
                  Botao().botaoAnimacaoLoading(
                    context,
                    altura: size.height * 0.12,
                    comprimento: 400,
                    txtbutton: 'Produtos',
                    corFonte: Colors.white,
                    tamanhoLetra: 35,
                    onTap: () async {
                      await FieldsEstatisticaProdutos()
                          .buscaDetalhesTotalProdutos('2021');
                      Navigator.pushNamed(context, '/EstatisticaProduto');
                    },
                    timeLoading: 2,
                    colorButton: Colors.grey[200]!.withOpacity(0.5),
                  ),
                  // SizedBox(height: size.height * 0.02),
                  // Botao().botaoAnimacaoLoading(
                  //   context,
                  //   altura: size.height * 0.12,
                  //   comprimento: 400,
                  //   txtbutton: 'Saldo devedor',
                  //   corFonte: Colors.white,
                  //   tamanhoLetra: 35,
                  //   onTap: () async {
                  //     await FieldsSaldoDevedor().detalhesTotalSaldoDevedor();
                  //     Navigator.pushNamed(context, '/GeralSaldoDevedor');
                  //   },
                  //   timeLoading: 2,
                  //   colorButton: Colors.grey[200].withOpacity(0.5),
                  // ),
                  SizedBox(height: size.height * 0.03),
                  Botao().botaoAnimacaoLoading(
                    context,
                    altura: size.height * 0.12,
                    comprimento: 400,
                    txtbutton: 'Entrada de madeira',
                    corFonte: Colors.white,
                    tamanhoLetra: 35,
                    onTap: () async {
                      await FieldsEstatisticaLote().detalhesLoteTotalMeses(
                          DateTime.now().year.toString());
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EstatisticaLote()),
                      );
                    },
                    timeLoading: 2,
                    colorButton: Colors.grey[200]!.withOpacity(0.5),
                  ),
                  SizedBox(height: size.height * 0.02),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
