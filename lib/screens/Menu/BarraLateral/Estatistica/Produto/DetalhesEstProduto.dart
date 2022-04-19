import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:madecontrol_desenvolvimento/Statics/Estatisticas/Static_EstProduto.dart';
import 'package:madecontrol_desenvolvimento/Widget/Cabecalho.dart';
import 'package:madecontrol_desenvolvimento/Widget/ListFieldsDataBase.dart';
import 'package:madecontrol_desenvolvimento/models/Estatisticas/Models_EstProduto.dart';
import 'package:madecontrol_desenvolvimento/models/Models_Usuario.dart';
import 'package:http/http.dart' as http;
import 'package:madecontrol_desenvolvimento/models/constantes.dart';

import 'EstatisticaProduto.dart';

class DetalhesEstatisticaProduto extends StatefulWidget {
  final int? idProduto;
  final int? idAno;
  DetalhesEstatisticaProduto({Key? key, @required this.idProduto, this.idAno})
      : super(key: key);
  @override
  _DetalhesEstatisticaClienteState createState() =>
      _DetalhesEstatisticaClienteState(idProduto: idProduto, idAno: idAno);
}

class _DetalhesEstatisticaClienteState
    extends State<DetalhesEstatisticaProduto> {
  _DetalhesEstatisticaClienteState({@required this.idProduto, this.idAno}) {
    listarDados();
  }
  int? idProduto;
  int? idAno;
  var dadosListagem = <ModelsEstProduto>[];
  RxBool? loading = true.obs;
  Future<dynamic> listarDados() async {
    final response = await http.get(
      Uri.parse(ProdutoOuPallet.opcProduto!.value == true
          ? ListaMesesProdutoPorId +
              idAno.toString() +
              '/' +
              idProduto.toString() +
              '/' +
              ModelsUsuarios.caminhoBaseUser.toString():
          //
          ListaMesesPalletPorId +
              idAno.toString() +
              '/' +
              idProduto.toString() +
              '/' +
              ModelsUsuarios.caminhoBaseUser.toString()),
      headers: {
        "Content-Type": "application/json",
        "authorization": ModelsUsuarios.tokenAuth.toString()
      },
    );

    if (mounted) {
      setState(
        () {
          Iterable lista = json.decode(response.body);
          dadosListagem =
              lista.map((model) => ModelsEstProduto.fromJson(model)).toList();
        },
      );
    }
    loading!.value = false;
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    Size size = mediaQuery.size;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            height: size.height,
            width: size.width,
            color: Colors.black12, //Colors.green[200],
            child: Column(
              children: [
                Cabecalho().tituloCabecalho(
                  context,
                  'Detalhes do produto',
                  sizeTextTitulo: 0.058,
                  iconeVoltar: true,
                  marginBottom: 0,
                  marginLeft: 0.005,
                  corIcone: Colors.black,
                  corTextoTitulo: Colors.black54,
                ),
                // =================== DADOS FATURAMENTO =====================
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(
                    left: size.width * 0.02,
                    right: size.width * 0.02,
                    top: size.height * 0.01,
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: size.width,
                        height: size.height * 0.2,
                        padding: EdgeInsets.only(left: size.width * 0.03),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black, width: 2),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: size.width,
                              alignment: Alignment.center,
                              // color: Colors.red,
                              child: FieldsDatabase().listaDadosBanco(
                                '',
                                FieldsEstatisticaProdutos.nomeProduto,
                                sizeCampoBanco: 25,
                                sizeTextoCampo: 22,
                              ),
                            ),
                            SizedBox(height: size.height * 0.02),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                FieldsDatabase().listaDadosBanco(
                                  'Qtd total de vendas: ',
                                  FieldsEstatisticaProdutos
                                      .qtdPedidosTotalProduto,
                                  sizeCampoBanco: 22,
                                  sizeTextoCampo: 22,
                                ),
                                SizedBox(height: 15),
                                FieldsDatabase().listaDadosBanco(
                                  'Faturamento total: ',
                                  FieldsEstatisticaProdutos
                                      .faturamentoTotalProduto,
                                  sizeCampoBanco: 22,
                                  sizeTextoCampo: 22,
                                ),
                                SizedBox(height: 15),
                                FieldsDatabase().listaDadosBanco(
                                  'Data do último pedido: ',
                                  FieldsEstatisticaProdutos.dataUltimoPedido,
                                  sizeCampoBanco: 22,
                                  sizeTextoCampo: 22,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: size.height * 0.015),
                        child: Container(
                          padding: const EdgeInsets.only(
                            bottom: 5,
                            top: 5,
                          ),
                          width: size.width,
                          height: size.height * 0.63,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: FutureBuilder(
                            future: listarDados(),
                            builder: (BuildContext context, snapshot) {
                              return Obx(
                                () => loading!.value == true
                                    ? Center(
                                        child: CircularProgressIndicator(),
                                      )
                                    : ListView.builder(
                                        itemCount: dadosListagem.length,
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                              bottom: 4,
                                              top: 4,
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                left: 5,
                                                right: 5,
                                              ),
                                              child: GestureDetector(
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  height: size.height * 0.14,
                                                  width: size.width,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      5,
                                                    ),
                                                    color: Color(0XFFD1D6DC),
                                                  ),
                                                  child: SingleChildScrollView(
                                                    child: ListTile(
                                                      title: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          FieldsDatabase()
                                                              .listaDadosBanco(
                                                            'Mês: ',
                                                            dadosListagem[index]
                                                                .nomeMes
                                                                .toString(),
                                                            sizeCampoBanco: 21,
                                                            sizeTextoCampo: 21,
                                                          ),
                                                          SizedBox(height: 3),
                                                          FieldsDatabase()
                                                              .listaDadosBanco(
                                                            'Qtd vendas: ',
                                                            dadosListagem[index]
                                                                .qtdPedidosMes,
                                                            sizeCampoBanco: 21,
                                                            sizeTextoCampo: 21,
                                                          ),
                                                          SizedBox(height: 3),
                                                          FieldsDatabase()
                                                              .listaDadosBanco(
                                                            'Faturamento total: ',
                                                            dadosListagem[index]
                                                                .valorTotalMes,
                                                            sizeCampoBanco: 21,
                                                            sizeTextoCampo: 21,
                                                          ),
                                                          // SizedBox(height: 3),
                                                          // FieldsDatabase()
                                                          //     .listaDadosBanco(
                                                          //   'Preço médio de venda: ',
                                                          //   dadosListagem[index]
                                                          //       .precoMedioVendaMes
                                                          //       .toString(),
                                                          //   sizeCampoBanco: 21,
                                                          //   sizeTextoCampo: 21,
                                                          // ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                              );
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
