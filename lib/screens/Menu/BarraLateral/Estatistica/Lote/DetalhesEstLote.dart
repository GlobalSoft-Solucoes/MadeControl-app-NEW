import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:madecontrol_desenvolvimento/Statics/Estatisticas/Static_EstLote.dart';
import 'package:madecontrol_desenvolvimento/Widget/Cabecalho.dart';
import 'package:madecontrol_desenvolvimento/Widget/ListFieldsDataBase.dart';
import 'package:madecontrol_desenvolvimento/models/Estatisticas/Models_EstLote.dart';
import 'package:madecontrol_desenvolvimento/models/Models_Usuario.dart';
import 'package:http/http.dart' as http;
import 'package:madecontrol_desenvolvimento/models/constantes.dart';

class DetalhesEstatisticaLote extends StatefulWidget {
  final int? idMes;
  final int? idAno;
  DetalhesEstatisticaLote({Key? key, @required this.idAno, this.idMes})
      : super(key: key);
  @override
  _DetalhesEstatisticaLoteState createState() =>
      _DetalhesEstatisticaLoteState(idAno: idAno, idMes: idMes);
}

class _DetalhesEstatisticaLoteState extends State<DetalhesEstatisticaLote> {
  _DetalhesEstatisticaLoteState({@required this.idAno, this.idMes}) {
  }
  int? idMes;
  int? idAno;
  var dadosListagem = <ModelsEstLote>[];
  RxBool? loading = true.obs;

  Future<dynamic> listarDados() async {
    final response = await http.get(
      Uri.parse(EstListaoFornecedoresLotePorMes +
          idAno.toString() +
          '/' +
          idMes.toString() +
          '/' +
          ModelsUsuarios.caminhoBaseUser.toString()),
      headers: {"authorization": ModelsUsuarios.tokenAuth.toString()},
    );
    if (response.statusCode == 401) {
      Navigator.pushNamed(context, '/login');
    }
    //IF(MOUNTED) É nescessario para não recarregar a arvore apos retornar das outras listas
    if (mounted){
      setState(
        () {
          Iterable lista = json.decode(response.body);
          dadosListagem =
              lista.map((model) => ModelsEstLote.fromJson(model)).toList();
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
                  'Detalhes do mês',
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
                        height: size.height * 0.30,
                        padding: EdgeInsets.only(left: size.width * 0.03),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black, width: 2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.centerLeft,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Container(
                              alignment: Alignment.center,
                              child: FieldsDatabase().listaDadosBanco(
                                '',
                                idAno.toString(),
                                sizeCampoBanco: 25,
                                sizeTextoCampo: 22,
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(height: 30),
                                FieldsDatabase().listaDadosBanco(
                                  'Mês: ',
                                  FieldsEstatisticaLote.nomeMes,
                                  sizeCampoBanco: 22,
                                  sizeTextoCampo: 22,
                                ),
                                SizedBox(height: 15),
                                FieldsDatabase().listaDadosBanco(
                                  'Faturamento mês: ',
                                  FieldsEstatisticaLote.metrosTotalMes
                                      .toString(),
                                  sizeCampoBanco: 22,
                                  sizeTextoCampo: 22,
                                ),
                                SizedBox(height: 15),
                                FieldsDatabase().listaDadosBanco(
                                  'Qtd entradas: ',
                                  FieldsEstatisticaLote.qtdEntradaLoteMes,
                                  sizeCampoBanco: 23,
                                  sizeTextoCampo: 23,
                                ),
                                SizedBox(height: 15),
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
                          height: size.height * 0.56,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
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
                                                  height: size.height * 0.13,
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
                                                            'Fornecedor: ',
                                                            dadosListagem[index]
                                                                .nomeFornecedor,
                                                          ),
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                          FieldsDatabase()
                                                              .listaDadosBanco(
                                                                  'Data entrada: ',
                                                                  dadosListagem[
                                                                          index]
                                                                      .dataEntrada),
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                          FieldsDatabase().listaDadosBanco(
                                                              'Metros cúbicos: ',
                                                              dadosListagem[
                                                                      index]
                                                                  .metrosEntrada
                                                                  .toString()
                                                                  .replaceAll(
                                                                      'null',
                                                                      ''))
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
