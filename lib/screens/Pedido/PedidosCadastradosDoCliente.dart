import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:madecontrol_desenvolvimento/Statics/Static_Cliente.dart';
import 'package:madecontrol_desenvolvimento/Statics/Static_GrupoPedido.dart';
import 'package:madecontrol_desenvolvimento/Statics/Static_Modulo.dart';
import 'package:madecontrol_desenvolvimento/Statics/Static_Pedidos.dart';
import 'package:madecontrol_desenvolvimento/Widget/Cabecalho.dart';
import 'package:madecontrol_desenvolvimento/Widget/ListFieldsDataBase.dart';
import 'package:madecontrol_desenvolvimento/Widget/MsgPopup.dart';
import 'package:madecontrol_desenvolvimento/funcoes/FuncoesParaDatas.dart';
import 'package:madecontrol_desenvolvimento/models/ClassesStaticas.dart';
import 'package:madecontrol_desenvolvimento/models/Models_Pedidos.dart';
import 'package:http/http.dart' as http;
import 'package:madecontrol_desenvolvimento/models/Models_Usuario.dart';
import 'package:madecontrol_desenvolvimento/models/constantes.dart';
import 'package:madecontrol_desenvolvimento/screens/Pedido/DetalhesDoPedidoDoCliente.dart';
// import 'package:madecontrol_desenvolvimento/screens/pedido/DetalhesDoPedidoDoCliente.dart';
import 'CadastroPedido/CadastrarPedido.dart';

class PedidosCadastradosCliente extends StatefulWidget {
  final int? idGrupoPedido;
  PedidosCadastradosCliente({Key? key, @required this.idGrupoPedido})
      : super(key: key);
  @override
  _PedidosCadastradosClienteState createState() =>
      _PedidosCadastradosClienteState(idGrupoPedido: idGrupoPedido);
}

class Processo {
  static String? opcProximoProcesso = FieldsModulo.processoPedido == true
      ? AlteraStatusGrupoPedidoParaProducao
      : AlteraStatusGrupoPedidoParaPronto;
}

class _PedidosCadastradosClienteState extends State<PedidosCadastradosCliente> {
  _PedidosCadastradosClienteState({@required this.idGrupoPedido}) {
    listarDados(idGrupoPedido);
  }

  RxBool? loading = true.obs;
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

  alterarStatusProducao() async {
    var response = await http.put(
      Uri.parse(Processo.opcProximoProcesso! +
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
    print(FieldsGrupoPedido.tipoVenda!.toUpperCase());
    if (FieldsGrupoPedido.tipoVenda!.toUpperCase() == "BALCAO") {
      MsgPopup().msgComDoisBotoes(
        context,
        'O que deseja fazer com está venda de balcão?',
        'Finalizar',
        'Pedido pronto',
        () => alterarStatusEntregue(),
        () => {
          alterarStatusProducao(),
        },
      );
    } else {
      MsgPopup().msgComDoisBotoes(
        context,
        FieldsModulo.processoPedido == true
            ? 'Deseja iniciar a produção deste pedido?'
            : 'Deseja marcar como pronto os pedidos deste cliente?',
        'Não',
        'Sim',
        () => Navigator.pop(context),
        () => {
          alterarStatusProducao(),
        },
      );
    }
  }

  confirmarEdicao(id) {
    MsgPopup().msgComDoisBotoes(
      context,
      'Deseja editar este pedido?',
      'Não',
      'Sim',
      () {
        Navigator.pop(context);
      },
      () async {
        await FieldsPedido().buscaDadosPedidoPorId(id);
        ConstantePedidos.cadastraroGrupo = false;
        ConstantePedidos.idGrupoPedidos = idGrupoPedido;
        EdicaoGrupoPedidos.clienteescolhido = true;
        EdicaoGrupoPedidos.clienteescolhido = false;
        EdicaoGrupoPedidos.idProduto = false;
        Navigator.pop(context);
        Navigator.pushNamed(context, '/EditarDadosPedido');
      },
    );
  }

  msgConfirmacaoDeletarPedido(idPedido) {
    MsgPopup().msgComDoisBotoes(
      context,
      'Você deseja remover este pedido?',
      'Não',
      'Sim',
      () => Navigator.pop(context),
      () {
        deletar(idPedido);
        Navigator.pop(context);
      },
    );
  }

  Future<dynamic> deletar(idPedido) async {
    var response = await http.delete(
      Uri.parse(DeletarPedido +
          idPedido.toString() +
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
          child: Icon(Icons.add, size: 35),
          backgroundColor: Colors.blue,
          label: 'Cadastrar pedido',
          labelStyle: TextStyle(fontSize: 20),
          onTap: () => {
            setState(
              () {
                ConstantePedidos.cadastraroGrupo = false;
                ConstantePedidos.idGrupoPedidos = idGrupoPedido;
                EdicaoGrupoPedidos.clienteescolhido = true;
                EdicaoGrupoPedidos.clienteescolhido = false;
              },
            ),
            Navigator.pushNamed(context, '/CadastrarPedido'),
          },
        ),
        SpeedDialChild(
          child: FieldsModulo.processoPedido == true
              ? Icon(Icons.pages_rounded, size: 35)
              : Icon(Icons.check, size: 35),
          backgroundColor: Colors.green,
          label: FieldsModulo.processoPedido == true
              ? 'Iniciar produção'
              : 'Finalizar',
          labelStyle: TextStyle(fontSize: 20),
          onTap: () => {msgFinalizar()},
        ),
        SpeedDialChild(
          child: Icon(Icons.info_outline_rounded, size: 35),
          backgroundColor: Colors.grey,
          label: 'Resumo dos pedidos',
          labelStyle: TextStyle(fontSize: 20),
          onTap: () => {
            FieldsGrupoPedido.idGrupoPedido = idGrupoPedido,
            Navigator.pushNamed(context, '/DetalhesGrupoPedido'),
          },
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    Processo.opcProximoProcesso = FieldsModulo.processoPedido == true
        ? AlteraStatusGrupoPedidoParaProducao
        : AlteraStatusGrupoPedidoParaPronto;
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
                    'Pedidos cadastrados',
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
                      corCampoBanco: Colors.green[700],
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
                                              motion: const StretchMotion(),
                                              children: [
                                                SlidableAction(
                                                  label: 'Editar',
                                                  backgroundColor: Colors.white,
                                                  icon: Icons.edit_outlined,
                                                  onPressed:
                                                      (BuildContext context) =>
                                                          {
                                                    confirmarEdicao(
                                                        dadosListagem[index]
                                                            .idPedido),
                                                  },
                                                ),
                                                SlidableAction(
                                                    label: 'Copiar',
                                                    backgroundColor:
                                                        Colors.blue[300]!,
                                                    icon: Icons.copy,
                                                    onPressed: (BuildContext
                                                        context) async {
                                                      await FieldsPedido()
                                                          .buscaDadosPedidoPorId(
                                                              dadosListagem[
                                                                      index]
                                                                  .idPedido);
                                                      await salvarPedidoCopiado();
                                                    }),
                                                SlidableAction(
                                                    label: 'Excluir',
                                                    backgroundColor: Colors.red,
                                                    icon: Icons.delete_forever,
                                                    onPressed: (BuildContext
                                                        context) async {
                                                      msgConfirmacaoDeletarPedido(
                                                          dadosListagem[index]
                                                              .idPedido);
                                                    }),
                                              ],
                                            ),
                                            child: GestureDetector(
                                              onTap: () {
                                                PermissaoExcluir
                                                    .permissao!.value = true;
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        ListarDadosPedido(
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
                                                height: size.height * 0.2,
                                                width: size.width,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    5,
                                                  ),
                                                  color: Colors.grey[
                                                      400], //(0XFFD1D6DC),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 0, right: 10),
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
                                                          ),
                                                          SizedBox(height: 1),
                                                          if (dadosListagem[
                                                                      index]
                                                                  .idPallet !=
                                                              null)
                                                            FieldsDatabase()
                                                                .listaDadosBanco(
                                                              'Produto: ',
                                                              'Pallet ' +
                                                                  '${dadosListagem[index].nomePallet}',
                                                            ),
                                                          if (dadosListagem[
                                                                      index]
                                                                  .idPallet ==
                                                              null)
                                                            FieldsDatabase()
                                                                .listaDadosBanco(
                                                              'Produto: ',
                                                              dadosListagem[
                                                                      index]
                                                                  .nomeProduto,
                                                            ),
                                                          SizedBox(height: 1),
                                                          Row(
                                                            children: [
                                                              FieldsDatabase()
                                                                  .listaDadosBanco(
                                                                'Data: ',
                                                                dadosListagem[
                                                                        index]
                                                                    .dataPedido,
                                                              ),
                                                              FieldsDatabase()
                                                                  .listaDadosBanco(
                                                                '  -  Hora: ',
                                                                dadosListagem[
                                                                        index]
                                                                    .horaPedido!
                                                                    .substring(
                                                                        0, 5),
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(height: 1),
                                                          if (dadosListagem[
                                                                      index]
                                                                  .qtdMetros !=
                                                              null)
                                                            FieldsDatabase()
                                                                .listaDadosBanco(
                                                              dadosListagem[index]
                                                                          .idUnidadeMedida ==
                                                                      3
                                                                  ? 'Metros corridos: '
                                                                  : dadosListagem[index]
                                                                              .idUnidadeMedida ==
                                                                          2
                                                                      ? 'Metros quadrados: '
                                                                      : 'Metros cúbicos: ',
                                                              dadosListagem[
                                                                      index]
                                                                  .qtdMetros
                                                                  .toString(),
                                                            ),
                                                          SizedBox(height: 1),
                                                          FieldsDatabase().listaDadosBanco(
                                                              dadosListagem[index].idUnidadeMedida == 3
                                                                  ? 'Preço metro corrido: '
                                                                  : dadosListagem[index].idUnidadeMedida == 2
                                                                      ? 'Preço metro quadrado: '
                                                                      : dadosListagem[index].beneficiado == true
                                                                          ? 'Preço por quantidade: '
                                                                          : 'Preço metro cúbico: ',
                                                              dadosListagem[index].precoCubico),
                                                          SizedBox(height: 1),
                                                          FieldsDatabase()
                                                              .listaDadosBanco(
                                                            'Valor total: ',
                                                            dadosListagem[index]
                                                                .valorTotal
                                                                .toString(),
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
