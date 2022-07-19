import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:madecontrol_desenvolvimento/Statics/Static_Despesa.dart';
import 'package:madecontrol_desenvolvimento/Widget/Cabecalho.dart';
import 'package:madecontrol_desenvolvimento/Widget/ListFieldsDataBase.dart';
import 'package:madecontrol_desenvolvimento/Widget/MsgPopup.dart';
import 'package:madecontrol_desenvolvimento/models/Models_Despesa.dart';
import 'package:madecontrol_desenvolvimento/models/Models_Usuario.dart';
import 'package:madecontrol_desenvolvimento/models/constantes.dart';
import 'package:http/http.dart' as http;
import 'package:madecontrol_desenvolvimento/screens/Menu/BarraLateral/Despesas/DetalhesDespesa.dart';
import 'package:madecontrol_desenvolvimento/screens/Menu/BarraLateral/Financeiro/widgets/cards/third_card.dart';

import '../../Despesas/DetalhesParcelaDespesa.dart';

class RelatorioDespesas extends StatefulWidget {
  @override
  _RelatorioDespesasState createState() => _RelatorioDespesasState();
}

class _RelatorioDespesasState extends State<RelatorioDespesas> {
  var dadosListagem = <ModelsDespesa>[];
  RxBool? loading = true.obs;
  Future<dynamic> listarDados() async {
    final response = await http.get(
      Uri.parse(
        BuscaValorTotalDespesasPorData +
            ThirdCard.dataInicial! +
            '/' +
            ThirdCard.dataFinal! +
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
              lista.map((model) => ModelsDespesa.fromJson(model)).toList();
        },
      );
    }
    loading!.value = false;
  }

// abre a tela para edição do grupo de pedidos
  popupEditarGrupoPedidos() {
    MsgPopup().msgComDoisBotoes(
      context,
      'Deseja editar o grupo de pedido selecionado?',
      'Não',
      'Sim',
      () => {},
      () => {},
      sairAoPressionar: true,
    );
  }

  Future<dynamic> alterarstatusRemovido(id) async {
    var response = await http.put(
      Uri.parse(AlteraStatusGrupoPedidoParaRemovido +
          id.toString() +
          '/' +
          ModelsUsuarios.caminhoBaseUser.toString()),
      headers: {
        "Content-Type": "application/json",
        "authorization": ModelsUsuarios.tokenAuth.toString()
      },
    );
    if (response.statusCode == 200) {
      Navigator.pop(context);
    }
    if (response.statusCode == 401) {
      Navigator.pushNamed(context, '/login');
    }
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
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/financeiro/Despesas06.jpg"),
                  fit: BoxFit.fitHeight),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    color: Colors.grey[400]!.withOpacity(0.7),
                    child: Cabecalho().tituloCabecalho(
                      context,
                      'Relatorio de despesas',
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
                      top: size.height * 0.015,
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              'Quantidade de despesas: ',
                              style: TextStyle(
                                fontSize: 22,
                                color: Color(0XFFf3f1e1a),
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                BuscaDespesasPorData.qtdDespesas == null
                                    ? '0'
                                    : '${BuscaDespesasPorData.qtdDespesas}',
                                style: TextStyle(
                                  fontSize: 22,
                                  color: Colors.black, //(0XFFf34629),
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
                              'Valor total das despesas: ',
                              style: TextStyle(
                                fontSize: 22,
                                color: Color(0XFFf3f1e1a),
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                BuscaDespesasPorData.valorTotalTodosDespesas ==
                                        null
                                    ? '0,00'
                                    : '${BuscaDespesasPorData.valorTotalTodosDespesas}',
                                style: TextStyle(
                                  fontSize: 22,
                                  color: Colors.black, //(0XFFf34629),
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
                      height: size.height * 0.77,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white.withOpacity(0.2),
                      ),
                      child: FutureBuilder(
                        future: listarDados(),
                        builder: (BuildContext context, snapshot) {
                          return Obx(
                            () => loading!.value == true
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : ListView.builder(
                                    itemCount: dadosListagem.length,
                                    itemBuilder: (context, index) {
                                      Hero(
                                        tag: 'tag: $index',
                                        child: Container(),
                                      );
                                      return GestureDetector(
                                        onTap: () {
                                          PermissaoExcluirDespesa
                                              .permissao!.value = false;
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  DetalhesParcelasDespesa(
                                                      idDespesa:
                                                          dadosListagem[index]
                                                              .idDespesa),
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
                                                  15,
                                                ),
                                                color: const Color(0XFFf89281),
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
                                                                  'Tipo da despesa: ',
                                                                  dadosListagem[
                                                                          index]
                                                                      .nomeTipoDespesa),
                                                          if (dadosListagem[
                                                                      index]
                                                                  .descricao !=
                                                              null)
                                                            FieldsDatabase()
                                                                .listaDadosBanco(
                                                              'Descricao: ',
                                                              dadosListagem[
                                                                      index]
                                                                  .descricao,
                                                            ),
                                                          SizedBox(
                                                              height:
                                                                  size.height *
                                                                      0.005),
                                                          FieldsDatabase()
                                                              .listaDadosBanco(
                                                            'Data: ',
                                                            dadosListagem[index]
                                                                .dataVencimento,
                                                          ),
                                                          SizedBox(
                                                              height:
                                                                  size.height *
                                                                      0.005),
                                                          FieldsDatabase()
                                                              .listaDadosBanco(
                                                            'Valor: ',
                                                            dadosListagem[index]
                                                                .valorDespesa,
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
