import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:madecontrol_desenvolvimento/Statics/Static_Recebimento.dart';
import 'package:madecontrol_desenvolvimento/Widget/Cabecalho.dart';
import 'package:madecontrol_desenvolvimento/Widget/ListFieldsDataBase.dart';
import 'package:madecontrol_desenvolvimento/models/Models_Recebimento.dart';
import 'package:madecontrol_desenvolvimento/models/Models_Usuario.dart';
import 'package:madecontrol_desenvolvimento/models/constantes.dart';
import 'package:http/http.dart' as http;
import 'package:madecontrol_desenvolvimento/screens/Menu/BarraLateral/Financeiro/widgets/cards/four_card.dart';
import 'package:madecontrol_desenvolvimento/screens/Menu/BarraLateral/Recebimentos/DetalhesRecebimento.dart';

class RelatorioRecebimento extends StatefulWidget {
  @override
  _RelatorioRecebimentoState createState() => _RelatorioRecebimentoState();
}

class _RelatorioRecebimentoState extends State<RelatorioRecebimento> {
  var dadosListagem = <ModelsRecebimento>[];
  RxBool? loading = true.obs;
  Future<dynamic> listarDados() async {
    final response = await http.get(
      Uri.parse(
        BuscaValorTotalRecebimentoPorData +
            FourCard.dataInicial! +
            '/' +
            FourCard.dataFinal! +
            '/' +
            ModelsUsuarios.caminhoBaseUser.toString(),
      ),
      headers: {"authorization": ModelsUsuarios.tokenAuth.toString()},
    );
    if (response.statusCode == 401) {
      Navigator.pushNamed(context, '/login');
    }
    //IF(MOUNTED) É nescessario para não recarregar a arvore apos retornar das outras listas
    if (mounted) {
      setState(
        () {
          Iterable lista = json.decode(response.body);
          dadosListagem =
              lista.map((model) => ModelsRecebimento.fromJson(model)).toList();
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
            decoration: BoxDecoration(
              image: DecorationImage(
                image:
                    AssetImage("assets/images/financeiro/FundoDinheiro01.jpg"),
                fit: BoxFit.fitHeight,
              ),
            ),
            height: size.height,
            width: size.width,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    color: Colors.grey[400]!.withOpacity(0.7),
                    child: Cabecalho().tituloCabecalho(
                      context,
                      'Relatorio de Recebimentos',
                      iconeVoltar: true,
                      sizeTextTitulo: 0.062,
                      marginBottom: 0,
                    ),
                  ),
                  Container(
                    color: Colors.grey[200]!.withOpacity(0.7),
                    padding: EdgeInsets.only(
                      left: size.width * 0.03,
                      bottom: size.height * 0.015,
                      top: size.height * 0.01,
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              'Registros de recebimentos: ',
                              style: TextStyle(
                                fontSize: 22,
                                color: Color(0XFFf3f1e1a),
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                FieldsRecebimento.qtdTotalRecebimentos == null
                                    ? '0'
                                    : '${FieldsRecebimento.qtdTotalRecebimentos}',
                                style: TextStyle(
                                  fontSize: 22,
                                  color: Color(0XFFf3f1e1a),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Text(
                              'Valor total recebido: ',
                              style: TextStyle(
                                fontSize: 22,
                                color: Color(0XFFf3f1e1a),
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                FieldsRecebimento.valorTotalRecebimentos == null
                                    ? '0,00'
                                    : '${FieldsRecebimento.valorTotalRecebimentos}',
                                style: TextStyle(
                                  fontSize: 22,
                                  color: Color(0XFfF3f1e1a),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  //------------------------------------------------
                  Container(
                    color: Colors.grey[200]!.withOpacity(0.7),
                    padding: EdgeInsets.only(
                      left: size.width * 0.025,
                      right: size.width * 0.025,
                      bottom: size.height * 0.03,
                    ),
                    child: Container(
                      padding: const EdgeInsets.only(
                        bottom: 5,
                        top: 5,
                      ),
                      width: size.width,
                      height: size.height * 0.75,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey[400]!.withOpacity(0.5),
                        // color: Colors.white.withOpacity(0.5),
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
                                      return GestureDetector(
                                        onTap: () {
                                          PermissaoExcluir.permissao!.value =
                                              false;
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  DetalhesRecebimento(
                                                      idRecebimento:
                                                          dadosListagem[index]
                                                              .idrecebimento),
                                            ),
                                          );
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            bottom: 4,
                                            top: 4,
                                          ),
                                          child: Container(
                                            padding: const EdgeInsets.only(
                                              left: 4,
                                              right: 4,
                                            ),
                                            child: Container(
                                              height: size.height * 0.14,
                                              width: size.width,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  10,
                                                ),
                                                color: Colors.green[300],
                                              ),
                                              child: Container(
                                                alignment: Alignment.center,
                                                child: SingleChildScrollView(
                                                  child: Container(
                                                    child: ListTile(
                                                      title: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          FieldsDatabase()
                                                              .listaDadosBanco(
                                                                  'Cliente: ',
                                                                  dadosListagem[
                                                                          index]
                                                                      .nomeCliente),
                                                          SizedBox(
                                                              height:
                                                                  size.height *
                                                                      0.005),
                                                          FieldsDatabase()
                                                              .listaDadosBanco(
                                                            'Data: ',
                                                            dadosListagem[index]
                                                                .dataRecebimento!
                                                                .substring(
                                                                    0, 10),
                                                          ),
                                                          SizedBox(
                                                              height:
                                                                  size.height *
                                                                      0.005),
                                                          FieldsDatabase()
                                                              .listaDadosBanco(
                                                            'Valor recebido: ',
                                                            dadosListagem[index]
                                                                .valorRecebido,
                                                          ),
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
      ),
    );
  }
}
