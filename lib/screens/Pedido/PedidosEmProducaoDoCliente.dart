import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:madecontrol_desenvolvimento/Statics/Static_Cliente.dart';
import 'package:madecontrol_desenvolvimento/Statics/Static_GrupoPedido.dart';
import 'package:madecontrol_desenvolvimento/Statics/Static_Pedidos.dart';
import 'package:madecontrol_desenvolvimento/Statics/Static_ProducaoPedido.dart';
import 'package:madecontrol_desenvolvimento/Widget/Cabecalho.dart';
import 'package:madecontrol_desenvolvimento/Widget/ListFieldsDataBase.dart';
import 'package:madecontrol_desenvolvimento/Widget/MsgPopup.dart';
import 'package:madecontrol_desenvolvimento/funcoes/FuncoesParaDatas.dart';
import 'package:madecontrol_desenvolvimento/models/Models_Pedidos.dart';
import 'package:http/http.dart' as http;
import 'package:madecontrol_desenvolvimento/models/Models_Usuario.dart';
import 'package:madecontrol_desenvolvimento/models/constantes.dart';
import 'CadastroPedido/CadastrarPedido.dart';
import 'DetalhesProducaoPedido.dart';

class PedidosProducaoCliente extends StatefulWidget {
  final int? idGrupoPedido;
  PedidosProducaoCliente({Key? key, @required this.idGrupoPedido})
      : super(key: key);
  @override
  _PedidosProducaoClienteState createState() =>
      _PedidosProducaoClienteState(idGrupoPedido: idGrupoPedido);
}

class _PedidosProducaoClienteState extends State<PedidosProducaoCliente> {
  _PedidosProducaoClienteState({@required this.idGrupoPedido}) {
    listarDados(idGrupoPedido);
  }
  RxBool? loading = true.obs;
  int? idGrupoPedido;
  var dadosListagem = <ModelsPedidos>[];

  var producaoPronta;

  Future<dynamic> listarDados(id) async {
    final response = await http.get(
      Uri.parse(ListaPedidoProducaoPorGrupo +
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
      loading!.value = false;
    }
  }

  alterarStatusEntregue() async {
    var response = await http.put(
      Uri.parse(AlteraStatusGrupoPedidoParaEntregue +
          idGrupoPedido.toString() +
          '/' +
          ModelsUsuarios.caminhoBaseUser.toString()),
      headers: {"authorization": ModelsUsuarios.tokenAuth.toString()},
    );
    if (response.statusCode == 200) {
      Navigator.pop(context);
    }
  }

  alterarStatusPronto() async {
    var response = await http.put(
      Uri.parse(AlteraStatusGrupoPedidoParaPronto +
          idGrupoPedido.toString() +
          '/' +
          ModelsUsuarios.caminhoBaseUser.toString()),
      headers: {"authorization": ModelsUsuarios.tokenAuth.toString()},
    );
    if (response.statusCode == 200) {
      Navigator.pop(context);
    }
  }

  msgFinalizar() {
    // print(FieldsGrupoPedido.tipoVenda.toUpperCase());
    if (FieldsGrupoPedido.tipoVenda!.toUpperCase() == "BALCAO") {
      MsgPopup().msgComDoisBotoes(
        context,
        'O que deseja com esta venda de balcão?',
        'Finalizar',
        'Pedido pronto',
        () => alterarStatusEntregue(),
        () => {
          alterarStatusPronto(),
        },
      );
    } else {
      MsgPopup().msgComDoisBotoes(
        context,
        'Deseja marcar como pronto os pedidos deste cliente?',
        'Não',
        'Sim',
        () => Navigator.pop(context),
        () => {
          alterarStatusPronto(),
          Navigator.pop(context),
        },
      );
    }
  }

  msgConfirmacaoDeletarPedido(idPedido) {
    MsgPopup().msgComDoisBotoes(
      context,
      'Tem certeza que deseja excluir o processo deste pedido?',
      'Não',
      'Sim',
      () => Navigator.pop(context),
      () {
        deletar(idPedido);
        Navigator.pop(context);
      },
    );
  }

  Future<dynamic> deletar(idproducaoPedido) async {
    var response = await http.delete(
      Uri.parse(ExcluirProducaoPedido +
          idproducaoPedido.toString() +
          '/' +
          ModelsUsuarios.caminhoBaseUser.toString()),
      headers: {"authorization": ModelsUsuarios.tokenAuth.toString()},
    );
    if (response.statusCode == 401) {
      Navigator.pushNamed(context, '/login');
    } else if (response.statusCode == 201) {
      Navigator.pop(context);
    }
  }

  salvarPedidoCopiado() async {
    var bodyy = jsonEncode(
      {
        'idusuario': ModelsUsuarios.idDoUsuario,
        'idgrupo_pedido': FieldsPedido.idGrupoPedido,
        "idpallet": FieldsPedido.idPallet,
        'idproduto': FieldsPedido.idProduto,
        'idunidade_medida': FieldsPedido.idUnidadeMedida,
        'idmadeira': FieldsPedido.idMadeira,
        'cod_pedido': CadastrarPedidoState().gerarCodPedido() as String,
        'comprimento': FieldsPedido.comprimento,
        'largura': FieldsPedido.largura,
        'espessura': FieldsPedido.espessura,
        'quantidade': FieldsPedido.quantidade,
        'data_pedido': DataAtual().pegardataBR() as String,
        'hora_pedido': DataAtual().pegarHora() as String,
        'preco_metro': FieldsPedido.precoMetro,
        'valor_total': FieldsPedido.valorTotal,
        'qtd_metros': FieldsPedido.qtdMetros,
        'observacoes': FieldsPedido.observacoes,
        'tipo_calculo': FieldsPedido.tipoCalculo,
        'tipo_processo': FieldsPedido.tipoProcesso,
        'beneficiado': FieldsPedido.beneficiado,
      },
    );

    http.Response state = await http.post(
      Uri.parse(CadastrarUmPedido + ModelsUsuarios.caminhoBaseUser.toString()),
      headers: {
        "Content-Type": "application/json",
        "authorization": ModelsUsuarios.tokenAuth.toString()
      },
      body: bodyy,
    );
    if (state.statusCode == 201) {
      print('deu boa');
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
          child: Icon(Icons.check, size: 35),
          backgroundColor: Colors.green,
          label: 'Finalizar',
          labelStyle: TextStyle(fontSize: 20),
          onTap: () => {msgFinalizar()},
        ),
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
            height: size.height,
            width: size.width,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Cabecalho().tituloCabecalho(
                    context,
                    'Pedidos em produção',
                    iconeVoltar: true,
                    marginBottom: 0,
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      left: size.width * 0.025,
                      top: size.height * 0.015,
                      bottom: size.height * 0.014,
                      right: size.width * 0.025,
                    ),
                    child: FieldsDatabase().listaDadosBanco(
                      '',
                      '${Cliente.nomeCliente!.toUpperCase()}',
                      sizeCampoBanco: size.width * 0.05,
                      corCampoBanco: Colors.orange[600],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: size.width * 0.02,
                        right: size.width * 0.02,
                        bottom: size.height * 0.02),
                    child: Container(
                      padding: EdgeInsets.only(
                        top: 5,
                        bottom: 5,
                      ),
                      width: size.width,
                      height: size.height * 0.79,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white),
                      child: FutureBuilder(
                        future: listarDados(idGrupoPedido),
                        builder: (BuildContext context, snapshot) {
                          return Obx(
                            () => loading!.value == true
                                ? Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : ListView.builder(
                                    itemCount: dadosListagem.length,
                                    itemBuilder: (context, index) {
                                      producaoPronta = dadosListagem[index]
                                                  .percentualProduzido ==
                                              100
                                          ? Colors.green[700]
                                          : Colors.yellow[400];
                                      return Padding(
                                        padding: EdgeInsets.only(
                                          left: size.width * 0.015,
                                          right: size.width * 0.015,
                                          top: size.width * 0.01,
                                          bottom: size.width * 0.01,
                                        ),
                                        child: Container(
                                          child: Slidable(
                                            key: const ValueKey(0),
                                            startActionPane: ActionPane(
                                              motion: const ScrollMotion(),
                                              children: [
                                                SlidableAction(
                                                  label: 'Excluir',
                                                  backgroundColor: Colors.red,
                                                  icon: Icons.delete_forever,
                                                  onPressed: (BuildContext
                                                          context) =>
                                                      msgConfirmacaoDeletarPedido(
                                                          dadosListagem[index]
                                                              .idProducao),
                                                ),
                                              ],
                                            ),
                                            child: GestureDetector(
                                              onTap: () async {
                                                await FieldsProducaoPedido()
                                                    .buscaProducaoPedidoPorId(
                                                        dadosListagem[index]
                                                            .idProducao);
                                                await FieldsPedido()
                                                    .buscaDadosPedidoPorId(
                                                        dadosListagem[index]
                                                            .idPedido);
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        DetalhesProducaoPedido(
                                                      idPedido:
                                                          dadosListagem[index]
                                                              .idPedido,
                                                    ),
                                                    // color: Color(0XFFD1D6DC),
                                                  ),
                                                );
                                              },
                                              child: Container(
                                                alignment: Alignment.center,
                                                height: size.height * 0.20,
                                                width: size.width,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    5,
                                                  ),
                                                  color: Colors.grey[
                                                      400], //(0XFFD1D6DC),
                                                ),
                                                child: SingleChildScrollView(
                                                  child: ListTile(
                                                    title: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        FieldsDatabase()
                                                            .listaDadosBanco(
                                                          'Codigo pedido: ',
                                                          dadosListagem[index]
                                                              .codPedido,
                                                          corCampoBanco:
                                                              producaoPronta,
                                                        ),
                                                        SizedBox(height: 5),
                                                        if (dadosListagem[index]
                                                                .idPallet !=
                                                            null)
                                                          FieldsDatabase()
                                                              .listaDadosBanco(
                                                            'Produto: ',
                                                            'Pallet ' +
                                                                '${dadosListagem[index].nomePallet}',
                                                            corCampoBanco:
                                                                producaoPronta,
                                                          ),
                                                        if (dadosListagem[index]
                                                                .idPallet ==
                                                            null)
                                                          FieldsDatabase()
                                                              .listaDadosBanco(
                                                            'Produto: ',
                                                            dadosListagem[index]
                                                                .nomeProduto,
                                                            corCampoBanco:
                                                                producaoPronta,
                                                          ),
                                                        SizedBox(height: 5),
                                                        Row(
                                                          children: [
                                                            FieldsDatabase()
                                                                .listaDadosBanco(
                                                              'Data: ',
                                                              dadosListagem[
                                                                      index]
                                                                  .dataPedido,
                                                              corCampoBanco:
                                                                  producaoPronta,
                                                            ),
                                                            FieldsDatabase()
                                                                .listaDadosBanco(
                                                              '  -  Hora: ',
                                                              dadosListagem[
                                                                      index]
                                                                  .horaPedido!
                                                                  .substring(
                                                                      0, 5),
                                                              corCampoBanco:
                                                                  producaoPronta,
                                                            ),
                                                          ],
                                                        ),
                                                        if (dadosListagem[index]
                                                                .qtdMetros !=
                                                            null)
                                                          SizedBox(height: 5),
                                                        if (dadosListagem[index]
                                                                .qtdMetros !=
                                                            null)
                                                          FieldsDatabase()
                                                              .listaDadosBanco(
                                                            dadosListagem[index]
                                                                        .idUnidadeMedida ==
                                                                    3
                                                                ? 'Metros corridos:  '
                                                                : dadosListagem[index]
                                                                            .idUnidadeMedida ==
                                                                        2
                                                                    ? 'Metros quadrados:  '
                                                                    : 'Metros cúbicos:  ',
                                                            dadosListagem[index]
                                                                .qtdMetros
                                                                .toString(),
                                                            corCampoBanco:
                                                                producaoPronta,
                                                          ),
                                                        SizedBox(height: 5),
                                                        FieldsDatabase()
                                                            .listaDadosBanco(
                                                          'Percentual produzido:  ',
                                                          dadosListagem[index]
                                                                  .percentualProduzido
                                                                  .toString()
                                                                  .replaceAll(
                                                                      '.0', '')
                                                                  .replaceAll(
                                                                      'null',
                                                                      '0') +
                                                              ' %',
                                                          corCampoBanco:
                                                              producaoPronta,
                                                        ),
                                                      ],
                                                    ),
                                                    trailing: Container(
                                                      padding: EdgeInsets.only(
                                                          bottom: size.height *
                                                              0.04),
                                                      child: dadosListagem[
                                                                      index]
                                                                  .percentualProduzido ==
                                                              100
                                                          ? Icon(
                                                              Icons
                                                                  .check_circle_sharp,
                                                              color:
                                                                  Colors.green[
                                                                      500],
                                                              size: 32)
                                                          : Icon(
                                                              Icons
                                                                  .report_problem_outlined,
                                                              color: Colors
                                                                  .orange[400],
                                                              size: 32),
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
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
