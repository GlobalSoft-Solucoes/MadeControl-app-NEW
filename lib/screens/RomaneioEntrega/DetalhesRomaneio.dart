import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:madecontrol_desenvolvimento/Statics/Static_GrupoPedido.dart';
import 'package:madecontrol_desenvolvimento/Statics/Static_Romaneio.dart';
import 'package:madecontrol_desenvolvimento/Widget/Cabecalho.dart';
import 'package:madecontrol_desenvolvimento/Widget/ListFieldsDataBase.dart';
import 'package:madecontrol_desenvolvimento/models/Models_Pedidos.dart';
import 'package:madecontrol_desenvolvimento/models/Models_Usuario.dart';
import 'package:http/http.dart' as http;
import 'package:madecontrol_desenvolvimento/models/constantes.dart';
import 'package:madecontrol_desenvolvimento/screens/Pedido/DetalhesDoPedidoDoCliente.dart';

class DetalhesRomaneio extends StatefulWidget {
  final int? idGrupoPedido;
  DetalhesRomaneio({Key? key, @required this.idGrupoPedido}) : super(key: key);
  @override
  _DetalhesRomaneioState createState() =>
      _DetalhesRomaneioState(idGrupoPedido: idGrupoPedido);
}

class _DetalhesRomaneioState extends State<DetalhesRomaneio> {
  _DetalhesRomaneioState({@required this.idGrupoPedido}) {
    listarDados(idGrupoPedido);
  }
  int? idGrupoPedido;

  var dadosListagem = <ModelsPedidos>[];
  Future<dynamic> listarDados(id) async {
    final response = await http.get(
      Uri.parse(ListarPorGrupoPedido +
          id.toString() +
          '/' +
          ModelsUsuarios.caminhoBaseUser.toString()),
      headers: {"authorization": ModelsUsuarios.tokenAuth.toString()},
    );
    if (response.statusCode == 401) {
      Navigator.pushNamed(context, '/login');
    }
    //IF(MOUNTED) É nescessario para não recarregar a arvore apos retornar das outras listas
    if (mounted) {
      setState(() {
        Iterable lista = json.decode(response.body);
        dadosListagem =
            lista.map((model) => ModelsPedidos.fromJson(model)).toList();
      });
    }
  }

  mostrarSpeedDial() {
    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: IconThemeData(size: 30),
      child: Icon(Icons.add),
      visible: true,
      curve: Curves.bounceIn,
      overlayColor: Colors.white,
      overlayOpacity: 0.6,
      // onOpen: () => print('OPENING DIAL'),
      // onClose: () => print('DIAL CLOSED'),
      tooltip: 'Speed Dial',
      heroTag: 'speed-dial-hero-tag',
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 8.0,
      shape: CircleBorder(),
      children: [
        SpeedDialChild(
          child: Icon(Icons.info_outline_rounded, size: 35),
          backgroundColor: Colors.grey,
          label: 'Resumo dos pedidos',
          labelStyle: TextStyle(fontSize: 20),
          onTap: () => {
            FieldsGrupoPedido.idGrupoPedido = idGrupoPedido,
            Navigator.pushNamed(context, '/DetalhesGrupoPedido'),
          },
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    Size size = mediaQuery.size;
    return SafeArea(
      child: Scaffold(
        floatingActionButton: mostrarSpeedDial(),
        body: SingleChildScrollView(
          child: Container(
            color: Colors.green[200],
            width: size.width,
            height: size.height,
            child: Column(
              children: [
                Cabecalho().tituloCabecalho(
                  context,
                  'Detalhes do romaneio',
                  iconeVoltar: true,
                  sizeTextTitulo: 0.065,
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: size.width * 0.02,
                    right: size.width * 0.02,
                    bottom: size.height * 0.02,
                  ),
                  child: Container(
                    width: size.width,
                    height: size.height * 0.21,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15)),
                    child: SingleChildScrollView(
                      child: Container(
                        padding: EdgeInsets.only(
                          left: size.width * 0.02,
                          top: size.width * 0.02,
                          bottom: size.width * 0.02,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 5,
                            ),
                            FieldsDatabase().listaDadosBanco(
                              'Destino: ',
                              BuscaRomaneioPorId.destino,
                              sizeTextoCampo: 22,
                              sizeCampoBanco: 22,
                            ),
                            SizedBox(height: 5),
                            FieldsDatabase().listaDadosBanco(
                              'Cliente: ',
                              BuscaRomaneioPorId.nomeCliente,
                              sizeTextoCampo: 22,
                              sizeCampoBanco: 20,
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                FieldsDatabase().listaDadosBanco(
                                  'Data: ',
                                  BuscaRomaneioPorId.dataEntrega,
                                  sizeTextoCampo: 22,
                                  sizeCampoBanco: 22,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                FieldsDatabase().listaDadosBanco(
                                  '   -   Hora: ',
                                  BuscaRomaneioPorId.horaEntrega,
                                  sizeTextoCampo: 22,
                                  sizeCampoBanco: 22,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            FieldsDatabase().listaDadosBanco(
                              'Motorista: ',
                              BuscaRomaneioPorId.motorista.toString(),
                              sizeTextoCampo: 22,
                              sizeCampoBanco: 22,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            FieldsDatabase().listaDadosBanco(
                              'Observações: ',
                              BuscaRomaneioPorId.observacoes,
                              sizeTextoCampo: 22,
                              sizeCampoBanco: 22,
                            ),
                            //==================================================
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: size.width * 0.02,
                      right: size.width * 0.02,
                      bottom: size.height * 0.02),
                  child: Container(
                    padding: EdgeInsets.only(top: 5, bottom: 5),
                    width: size.width,
                    height: size.height * 0.60,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white),
                    child: FutureBuilder(
                      future: listarDados(idGrupoPedido),
                      builder: (BuildContext context, snapshot) {
                        return ListView.builder(
                          itemCount: dadosListagem.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onDoubleTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ListarDadosPedido(
                                        idPedido:
                                            dadosListagem[index].idPedido),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  bottom: 0,
                                  top: 8,
                                ),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 4, right: 4),
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: size.height * 0.15,
                                    width: size.width,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                        15,
                                      ),
                                      color: Color(0XFFD1D6DC),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 0, right: 10),
                                      child: SingleChildScrollView(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Color(0XFFD1D6DC),
                                            borderRadius: BorderRadius.circular(
                                              15,
                                            ),
                                          ),
                                          child: ListTile(
                                            title: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                FieldsDatabase()
                                                    .listaDadosBanco(
                                                        'Codigo pedido: ',
                                                        dadosListagem[index]
                                                            .codPedido),
                                                Row(
                                                  children: [
                                                    FieldsDatabase()
                                                        .listaDadosBanco(
                                                      'Data: ',
                                                      dadosListagem[index]
                                                          .dataPedido!
                                                          .substring(0, 10),
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    FieldsDatabase()
                                                        .listaDadosBanco(
                                                      '   -   Hora: ',
                                                      dadosListagem[index]
                                                          .horaPedido,
                                                    ),
                                                  ],
                                                ),
                                                FieldsDatabase().listaDadosBanco(
                                                    dadosListagem[index]
                                                                .idUnidadeMedida ==
                                                            3
                                                        ? 'Metros corridos: '
                                                        : dadosListagem[index]
                                                                    .idUnidadeMedida ==
                                                                2
                                                            ? 'Metros quadrados: '
                                                            : 'Metros cúbicos: ',
                                                    dadosListagem[index]
                                                        .qtdMetros
                                                        .toString()),
                                                FieldsDatabase()
                                                    .listaDadosBanco(
                                                        'Preço metro: ',
                                                        dadosListagem[index]
                                                            .precoCubico),
                                                FieldsDatabase()
                                                    .listaDadosBanco(
                                                        'Valor total: ',
                                                        dadosListagem[index]
                                                            .valorTotal),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
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
