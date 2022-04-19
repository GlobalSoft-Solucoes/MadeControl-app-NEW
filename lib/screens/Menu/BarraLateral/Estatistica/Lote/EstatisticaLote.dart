import 'dart:async';
import 'dart:convert';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:madecontrol_desenvolvimento/Statics/Estatisticas/Static_EstFaturamento.dart';
import 'package:madecontrol_desenvolvimento/Statics/Estatisticas/Static_EstLote.dart';
import 'package:madecontrol_desenvolvimento/Widget/Cabecalho.dart';
import 'package:madecontrol_desenvolvimento/Widget/ListFieldsDataBase.dart';
import 'package:madecontrol_desenvolvimento/models/Estatisticas/Models_EstFaturamento.dart';
import 'package:madecontrol_desenvolvimento/models/Estatisticas/Models_EstLote.dart';
import 'package:madecontrol_desenvolvimento/models/Models_Usuario.dart';
import 'package:madecontrol_desenvolvimento/models/constantes.dart';

import 'DetalhesEstLote.dart';

class EstatisticaLote extends StatefulWidget {
  @override
  _EstatisticaLoteState createState() => _EstatisticaLoteState();
}

class _EstatisticaLoteState extends State<EstatisticaLote> {
  TextEditingController controllerNomeDespesa = TextEditingController();
  TextEditingController controllerDescricao = TextEditingController();
  var dadosListagem = <ModelsEstLote>[];
  RxBool? loading = true.obs;

  var anoEscolhido = DateTime.now().year.toString();
  var mudarCor = Colors.white;
  var corAno = Colors.orange[700];
  var corTextoEscolhido = Colors.black;
  var corTexto = Colors.white;
  //
  Future<dynamic> listarDados() async {
    final response = await http.get(
      Uri.parse(EstListaMesesTotalLotePorAno +
          anoEscolhido +
          '/' +
          ModelsUsuarios.caminhoBaseUser.toString()),
      headers: {"authorization": ModelsUsuarios.tokenAuth.toString()},
    );
    if (response.statusCode == 401) {
      Navigator.pushNamed(context, '/login');
    }
    //IF(MOUNTED) É nescessario para não recarregar a arvore apos retornar das outras listas
    if (mounted)
      setState(
        () {
          Iterable lista = json.decode(response.body);
          dadosListagem =
              lista.map((model) => ModelsEstLote.fromJson(model)).toList();
        },
      );
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
                  'Entrada de madeiras',
                  sizeTextTitulo: 0.058,
                  iconeVoltar: true,
                  marginBottom: 0,
                  marginLeft: 0.005,
                  corIcone: Colors.black,
                  corTextoTitulo: Colors.black54,
                ),
                // ==============================================
                Container(
                  child: Container(
                    alignment: Alignment.center,
                    color: Colors.grey[100],
                    child: Container(
                      width: size.width * 0.4,
                      color: Colors.white,
                      padding: const EdgeInsets.all(5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Flexible(
                            child: Container(
                              alignment: Alignment.center,
                              height: size.height * 0.055,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: [
                                  SizedBox(width: 15),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() async {
                                        anoEscolhido = '2020';
                                        await FieldsEstatisticaFaturamento()
                                            .detalhesFaturamentoTotalMeses(
                                                anoEscolhido);
                                      });
                                    },
                                    child: Container(
                                      width: size.width * 0.2,
                                      height: 10,
                                      alignment: Alignment.center,
                                      child: Text(
                                        '2020',
                                        style: TextStyle(
                                            color: anoEscolhido == '2020'
                                                ? corTextoEscolhido
                                                : corTexto,
                                            fontSize: 21,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: anoEscolhido == '2020'
                                            ? mudarCor
                                            : corAno,
                                        border: Border.all(
                                          color: Colors.red[100]!,
                                          width: 3,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 15),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() async {
                                        anoEscolhido = '2021';
                                        await FieldsEstatisticaFaturamento()
                                            .detalhesFaturamentoTotalMeses(
                                                anoEscolhido);
                                      });
                                    },
                                    child: Container(
                                      width: size.width * 0.2,
                                      height: size.height * 0.05,
                                      alignment: Alignment.center,
                                      child: Text(
                                        '2021',
                                        style: TextStyle(
                                            color: anoEscolhido == '2021'
                                                ? corTextoEscolhido
                                                : corTexto,
                                            fontSize: 21,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: anoEscolhido == '2021'
                                            ? mudarCor
                                            : corAno,
                                        border: Border.all(
                                          color: Colors.red[100]!,
                                          width: 3,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 15),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() async {
                                        anoEscolhido = '2022';
                                        await FieldsEstatisticaFaturamento()
                                            .detalhesFaturamentoTotalMeses(
                                                anoEscolhido);
                                        // return Future;
                                      });
                                    },
                                    child: Container(
                                      width: size.width * 0.2,
                                      height: size.height * 0.05,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: anoEscolhido == '2022'
                                            ? mudarCor
                                            : corAno,
                                        border: Border.all(
                                          color: Colors.red[100]!,
                                          width: 3,
                                        ),
                                      ),
                                      child: Text(
                                        '2022',
                                        style: TextStyle(
                                            color: anoEscolhido == '2022'
                                                ? corTextoEscolhido
                                                : corTexto,
                                            fontSize: 21,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 15),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                //=================================================
                SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.only(
                    left: size.width * 0.02,
                    right: size.width * 0.02,
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    width: size.width,
                    height: size.height * 0.18,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5)),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SingleChildScrollView(
                            child: ListTile(
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  FieldsDatabase().listaDadosBanco(
                                    'Metros cúbicos no ano: ',
                                    FieldsEstatisticaLote.metrosTotalAno,
                                    sizeCampoBanco: 21,
                                    sizeTextoCampo: 21,
                                  ),
                                  SizedBox(height: 10),
                                  FieldsDatabase().listaDadosBanco(
                                    'Número de meses: ',
                                    FieldsEstatisticaLote.qtdMeses,
                                    sizeCampoBanco: 21,
                                    sizeTextoCampo: 21,
                                  ),
                                  SizedBox(height: 10),
                                  FieldsDatabase().listaDadosBanco(
                                    'Média metros por mês: ',
                                    FieldsEstatisticaLote.mediaMetrosMes,
                                    sizeCampoBanco: 20,
                                    sizeTextoCampo: 20,
                                  ),
                                  SizedBox(height: 10),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: size.width * 0.02,
                      right: size.width * 0.02,
                      top: size.height * 0.02),
                  child: Container(
                    padding: const EdgeInsets.only(
                      bottom: 5,
                      top: 5,
                    ),
                    width: size.width,
                    height: size.height * 0.60,
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
                                          onTap: () async {
                                            await FieldsEstatisticaLote()
                                                .buscaDetalhesLotePorMes(
                                                    anoEscolhido.toString(),
                                                    dadosListagem[index]
                                                        .numeroMes);

                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    DetalhesEstatisticaLote(
                                                        idAno: int.tryParse(
                                                            anoEscolhido),
                                                        idMes:
                                                            dadosListagem[index]
                                                                .numeroMes),
                                              ),
                                            );
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            height: size.height * 0.15,
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
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    FieldsDatabase()
                                                        .listaDadosBanco(
                                                      'Mês: ',
                                                      dadosListagem[index]
                                                          .nomeMes,
                                                    ),
                                                    SizedBox(
                                                      height: size.height * 0.01
                                                    ),
                                                    FieldsDatabase()
                                                        .listaDadosBanco(
                                                            'Metros cúbicos: ',
                                                            dadosListagem[index]
                                                                .metrosTotalMes.toString()),
                                                    SizedBox(height: 5),
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
        ),
      ),
    );
  }
}
