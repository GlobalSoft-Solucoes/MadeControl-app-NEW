import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:madecontrol_desenvolvimento/Statics/Static_ConfigAcesso.dart';
import 'package:madecontrol_desenvolvimento/Widget/Botao.dart';
import 'package:madecontrol_desenvolvimento/Widget/Cabecalho.dart';
import 'package:madecontrol_desenvolvimento/Widget/CheckBox.dart';
import 'package:madecontrol_desenvolvimento/Widget/MsgPopup.dart';
import 'package:madecontrol_desenvolvimento/models/Models_Usuario.dart';
import 'package:http/http.dart' as http;
import 'package:madecontrol_desenvolvimento/models/constantes.dart';

class ConfigAcessoTelas extends StatefulWidget {
  final int? idUsuario;
  ConfigAcessoTelas({Key? key, @required this.idUsuario}) : super(key: key);
  @override
  _CadPortaPadraoState createState() => _CadPortaPadraoState();
}

class _CadPortaPadraoState extends State<ConfigAcessoTelas> {
  TextEditingController controllerComodo = TextEditingController();

// ATIBUI VAMOS PARA AS VARIÁVEIS DE ACORDO COM OS VALORES SELECIONADOS PARA CADA USUÁRIO
  var cadUsuarioSim = FieldsAcessoTelas.cadUsuario == true ? true : false;
  var cadUsuarioNao =
      FieldsAcessoTelas.cadUsuario == false ? true : false;
  var cadCargoSim = FieldsAcessoTelas.cadCargo == true ? true : false;
  var cadCargoNao = FieldsAcessoTelas.cadCargo == false ? true : false;
  var cadLoteSim = FieldsAcessoTelas.cadLote == true ? true : false;
  var cadLoteNao = FieldsAcessoTelas.cadLote == false ? true : false;
  var cadPedidoSim = FieldsAcessoTelas.cadPedido == true ? true : false;
  var cadPedidoNao = FieldsAcessoTelas.cadPedido == false ? true : false;
  var cadProdutoSim = FieldsAcessoTelas.cadProduto == true ? true : false;
  var cadProdutoNao =
      FieldsAcessoTelas.cadProduto == false ? true : false;
  var cadRomaneioSim =
      FieldsAcessoTelas.cadRomaneio == true ? true : false;
  var cadRomaneioNao =
      FieldsAcessoTelas.cadRomaneio == false ? true : false;
  var cadPalletSim = FieldsAcessoTelas.cadPallet == true ? true : false;
  var cadPalletNao = FieldsAcessoTelas.cadPallet == false ? true : false;
  var cadMadeiraSim = FieldsAcessoTelas.cadMadeira == true ? true : false;
  var cadMadeiraNao =
      FieldsAcessoTelas.cadMadeira == false ? true : false;

  var processoMadeiraSim =
      FieldsAcessoTelas.processoMadeira == true ? true : false;
  var processoMadeiraNao =
      FieldsAcessoTelas.processoMadeira == false ? true : false;
  var historicoPedidosSim =
      FieldsAcessoTelas.historicoPedidos == true ? true : false;
  var historicoPedidosNao =
      FieldsAcessoTelas.historicoPedidos == false ? true : false;

  var listaPedidosCadastradosSim =
      FieldsAcessoTelas.pedidosCadastrados == true ? true : false;
  var listaPedidosCadastradosNao =
      FieldsAcessoTelas.pedidosCadastrados == false ? true : false;
  var listaPedidosProducaoSim =
      FieldsAcessoTelas.pedidosProducao == true ? true : false;
  var listaPedidosProducaoNao =
      FieldsAcessoTelas.pedidosProducao == false ? true : false;
  var listaPedidosProntosSim =
      FieldsAcessoTelas.pedidosProntos == true ? true : false;
  var listaPedidosProntosNao =
      FieldsAcessoTelas.pedidosProntos == false ? true : false;

  var listaRomaneioSim =
      FieldsAcessoTelas.historicoRomaneios == true ? true : false;
  var listaRomaneioNao =
      FieldsAcessoTelas.historicoRomaneios == false ? true : false;
  var listaClientesSim =
      FieldsAcessoTelas.listaClientes == true ? true : false;
  var listaClientesNao =
      FieldsAcessoTelas.listaClientes == false ? true : false;
  var lixeiraGrupoPedidosSim =
      FieldsAcessoTelas.lixeiraGrupoPedidos == true ? true : false;
  var lixeiraGrupoPedidosNao =
      FieldsAcessoTelas.lixeiraGrupoPedidos == false ? true : false;
  var listaDespesasSim =
      FieldsAcessoTelas.listaDespesas == true ? true : false;
  var listaDespesasNao =
      FieldsAcessoTelas.listaDespesas == false ? true : false;
  var listaRecebimentosSim =
      FieldsAcessoTelas.listaRecebimentos == true ? true : false;
  var listaRecebimentosNao =
      FieldsAcessoTelas.listaRecebimentos == false ? true : false;

  var financeiroSim =
      FieldsAcessoTelas.financeiro == true ? true : false;
  var financeiroNao =
      FieldsAcessoTelas.financeiro == false ? true : false;
  var estatisticasSim =
      FieldsAcessoTelas.estatisticas == true ? true : false;
  var estatisticasNao =
      FieldsAcessoTelas.estatisticas == false ? true : false;
  var vendaAvulsoSim =
      FieldsAcessoTelas.vendaAvulso == true ? true : false;
  var vendaAvulsoNao =
      FieldsAcessoTelas.vendaAvulso == false ? true : false;

  //
  var sim = true;
  var nao = false;

  // verifica para cada usuário se o acesso há uma determinada tela está livre ou não
  var cadUsuario = FieldsAcessoTelas.cadUsuario == true ? true : false;
  var cadCargo = FieldsAcessoTelas.cadCargo == true ? true : false;
  var cadLote = FieldsAcessoTelas.cadLote == true ? true : false;
  var cadPedido = FieldsAcessoTelas.cadPedido == true ? true : false;
  var cadRomaneio = FieldsAcessoTelas.cadRomaneio == true ? true : false;
  var cadPallet = FieldsAcessoTelas.cadPallet == true ? true : false;
  var cadMadeira = FieldsAcessoTelas.cadMadeira == true ? true : false;
  var cadProduto = FieldsAcessoTelas.cadProduto == true ? true : false;
  var processoMadeira =
      FieldsAcessoTelas.processoMadeira == true ? true : false;
  var historicoPedidos =
      FieldsAcessoTelas.historicoPedidos == true ? true : false;
  var listaPedidosCadastrados =
      FieldsAcessoTelas.pedidosCadastrados == true ? true : false;
  var listaPedidosProducao =
      FieldsAcessoTelas.pedidosProducao == true ? true : false;
  var listaPedidosProntos =
      FieldsAcessoTelas.pedidosProntos == true ? true : false;
  var listaRomaneios =
      FieldsAcessoTelas.historicoRomaneios == true ? true : false;
  var listaClientes =
      FieldsAcessoTelas.listaClientes == true ? true : false;
  var lixeiraGrupoPedidos =
      FieldsAcessoTelas.lixeiraGrupoPedidos == true ? true : false;
  var listaDespesas =
      FieldsAcessoTelas.listaDespesas == true ? true : false;
  var listaRecebimentos =
      FieldsAcessoTelas.listaRecebimentos == true ? true : false;
  var financeiro = FieldsAcessoTelas.financeiro == true ? true : false;
  var estatisticas =
      FieldsAcessoTelas.estatisticas == true ? true : false;
  var vendaAvulso = FieldsAcessoTelas.vendaAvulso == true ? true : false;

  salvarAlteracoesAcessoTela() async {
    var bodyy = jsonEncode(
      {
        'cad_usuario': cadUsuario,
        'cad_cargo': cadCargo,
        'cad_lote': cadLote,
        'cad_pedido': cadPedido,
        'cad_produto': cadProduto,
        'cad_madeira': cadMadeira,
        'cad_pallet': cadPallet,
        'cad_romaneio': cadRomaneio,
        'processo_madeira': processoMadeira,
        'historico_pedidos': historicoPedidos,
        'historico_romaneios': listaRomaneios,
        'lista_clientes': listaClientes,
        'lixeira_grupopedidos': lixeiraGrupoPedidos,
        'pedidos_cadastrados': listaPedidosCadastrados,
        'pedidos_producao': listaPedidosProducao,
        'pedidos_prontos': listaPedidosProntos,
        'financeiro': financeiro,
        'lista_despesas': listaDespesas,
        'lista_recebimentos': listaRecebimentos,
        'estatisticas': estatisticas,
        'venda_avulso': vendaAvulso,
      },
    );

    http.Response state = await http.put(
      Uri.parse(EditarAcessoTelasUsuario +
          FieldsAcessoTelas.idUsuario.toString() +
          '/' +
          ModelsUsuarios.caminhoBaseUser.toString()),
      headers: {
        "Content-Type": "application/json",
        "authorization": ModelsUsuarios.tokenAuth.toString()
      },
      body: bodyy,
    );
    print(bodyy);
    print(state.statusCode);

    // chama a funcao para atualizar o acesso das telas de acordo com o usuário logado
    FieldsAcessoTelas()
        .capturaConfigAcessoTelasUsuario(ModelsUsuarios.idDoUsuario);
  }

  _msgAlteracoesConcluidas() async {
    await MsgPopup().msgFeedback(
      context,
      'Alterações concluídas com sucesso!',
      '',
      fontMsg: 20,
      corMsg: Colors.green[500],
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    Size size = mediaQuery.size;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            width: size.width,
            height: size.height,
            color: Colors.green[200],
            child: Column(
              children: [
                Cabecalho().tituloCabecalho(
                  context,
                  'Configurações de acesso',
                  iconeVoltar: true,
                  sizeTextTitulo: 0.058,
                  marginBottom: 0,
                ),
                Padding(
                  padding: EdgeInsets.only(
                      right: size.width * 0.02,
                      left: size.width * 0.02,
                      top: size.height * 0.01,
                      bottom: size.height * 0.0),
                  child: Container(
                    height: size.height * 0.77,
                    width: size.width,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          //----------------------------------------------------
                          new Container(
                            alignment: Alignment.center,
                            padding: new EdgeInsets.only(
                              top: 5,
                              bottom: 10,
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Usuário:    ${FieldsAcessoTelas.nomeUsuario}',
                                    style: TextStyle(
                                        fontSize: 22,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w800),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Escolha as telas que o usuário pode acessar:',
                                    style: TextStyle(
                                      fontSize: 19,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          //-------------------------------------------------------
                          CheckBox().checkBoxDuasOpcoes(
                            context,
                            'Cadastro e listagem de usuários:',
                            'Sim',
                            'Não',
                            cadUsuarioSim,
                            cadUsuarioNao,
                            () => {
                              setState(
                                () {
                                  cadUsuarioSim = true;
                                  cadUsuarioNao = false;
                                  cadUsuario = sim;
                                },
                              ),
                            },
                            () => {
                              setState(
                                () {
                                  cadUsuarioNao = true;
                                  cadUsuarioSim = false;
                                  cadUsuario = nao;
                                },
                              ),
                            },
                            marginLeft: 0.013,
                            marginTop: 0.025,
                            distanciaTituloDosChecks: 0.005,
                            backgroundColor: Colors.white.withOpacity(0.9),
                            distanciaEntreChecks: 0.1,
                          ),
                          //-------------------------------------------------------
                          CheckBox().checkBoxDuasOpcoes(
                            context,
                            'Cadastro de cargos',
                            'Sim',
                            'Não',
                            cadCargoSim,
                            cadCargoNao,
                            () => {
                              setState(
                                () {
                                  cadCargoSim = true;
                                  cadCargoNao = false;
                                  cadCargo = sim;
                                },
                              ),
                            },
                            () => {
                              setState(
                                () {
                                  cadCargoSim = false;
                                  cadCargoNao = true;
                                  cadCargo = nao;
                                },
                              ),
                            },
                            marginLeft: 0.013,
                            marginTop: 0.025,
                            distanciaTituloDosChecks: 0.005,
                            backgroundColor: Colors.white.withOpacity(0.9),
                            distanciaEntreChecks: 0.1,
                          ),
                          //------------------------------------------------
                          CheckBox().checkBoxDuasOpcoes(
                            context,
                            'Cadastro de lote',
                            'Sim',
                            'Não',
                            cadLoteSim,
                            cadLoteNao,
                            () => {
                              setState(
                                () {
                                  cadLoteSim = true;
                                  cadLoteNao = false;
                                  cadLote = sim;
                                },
                              ),
                            },
                            () => {
                              setState(
                                () {
                                  cadLoteSim = false;
                                  cadLoteNao = true;
                                  cadLote = nao;
                                },
                              ),
                            },
                            marginLeft: 0.013,
                            marginTop: 0.025,
                            distanciaTituloDosChecks: 0.005,
                            backgroundColor: Colors.white.withOpacity(0.9),
                            distanciaEntreChecks: 0.1,
                          ),
                          // -----------------------------------------------------
                          CheckBox().checkBoxDuasOpcoes(
                            context,
                            'Cadastro de pedido',
                            'Sim',
                            'Não',
                            cadPedidoSim,
                            cadPedidoNao,
                            () => {
                              setState(
                                () {
                                  cadPedidoSim = true;
                                  cadPedidoNao = false;
                                  cadPedido = sim;
                                },
                              ),
                            },
                            () => {
                              setState(
                                () {
                                  cadPedidoSim = false;
                                  cadPedidoNao = true;
                                  cadPedido = nao;
                                },
                              ),
                            },
                            marginLeft: 0.013,
                            marginTop: 0.025,
                            distanciaTituloDosChecks: 0.005,
                            backgroundColor: Colors.white.withOpacity(0.9),
                            distanciaEntreChecks: 0.1,
                          ),
                          // -------------------------------------------------
                          CheckBox().checkBoxDuasOpcoes(
                            context,
                            'Cadastro de produto',
                            'Sim',
                            'Não',
                            cadProdutoSim,
                            cadProdutoNao,
                            () => {
                              setState(
                                () {
                                  cadProdutoSim = true;
                                  cadProdutoNao = false;
                                  cadProduto = sim;
                                },
                              ),
                            },
                            () => {
                              setState(
                                () {
                                  cadProdutoSim = false;
                                  cadProdutoNao = true;
                                  cadProduto = nao;
                                },
                              ),
                            },
                            marginLeft: 0.013,
                            marginTop: 0.025,
                            distanciaTituloDosChecks: 0.005,
                            backgroundColor: Colors.white.withOpacity(0.9),
                            distanciaEntreChecks: 0.1,
                          ),
                            // -------------------------------------------------
                          CheckBox().checkBoxDuasOpcoes(
                            context,
                            'Cadastro de madeira',
                            'Sim',
                            'Não',
                            cadMadeiraSim,
                            cadMadeiraNao,
                            () => {
                              setState(
                                () {
                                  cadMadeiraSim = true;
                                  cadMadeiraNao = false;
                                  cadMadeira = sim;
                                },
                              ),
                            },
                            () => {
                              setState(
                                () {
                                  cadMadeiraSim = false;
                                  cadMadeiraNao = true;
                                  cadMadeira = nao;
                                },
                              ),
                            },
                            marginLeft: 0.013,
                            marginTop: 0.025,
                            distanciaTituloDosChecks: 0.005,
                            backgroundColor: Colors.white.withOpacity(0.9),
                            distanciaEntreChecks: 0.1,
                          ),
                          // --------------------------------------------------
                          CheckBox().checkBoxDuasOpcoes(
                            context,
                            'Cadastro de pallet',
                            'Sim',
                            'Não',
                            cadPalletSim,
                            cadPalletNao,
                            () => {
                              setState(
                                () {
                                  cadPalletSim = true;
                                  cadPalletNao = false;
                                  cadPallet = sim;
                                },
                              ),
                            },
                            () => {
                              setState(
                                () {
                                  cadPalletSim = false;
                                  cadPalletNao = true;
                                  cadPallet = nao;
                                },
                              ),
                            },
                            marginLeft: 0.013,
                            marginTop: 0.025,
                            distanciaTituloDosChecks: 0.005,
                            backgroundColor: Colors.white.withOpacity(0.9),
                            distanciaEntreChecks: 0.1,
                          ),
                          // -------------------------------------------------
                          CheckBox().checkBoxDuasOpcoes(
                            context,
                            'Cadastro de romaneio',
                            'Sim',
                            'Não',
                            cadRomaneioSim,
                            cadRomaneioNao,
                            () => {
                              setState(
                                () {
                                  cadRomaneioSim = true;
                                  cadRomaneioNao = false;
                                  cadRomaneio = sim;
                                },
                              ),
                            },
                            () => {
                              setState(
                                () {
                                  cadRomaneioSim = false;
                                  cadRomaneioNao = true;
                                  cadRomaneio = nao;
                                },
                              ),
                            },
                            marginLeft: 0.013,
                            marginTop: 0.025,
                            distanciaTituloDosChecks: 0.005,
                            backgroundColor: Colors.white.withOpacity(0.9),
                            distanciaEntreChecks: 0.1,
                          ),
                          // -----------------------------------------------------
                          CheckBox().checkBoxDuasOpcoes(
                            context,
                            'Processamento de madeira',
                            'Sim',
                            'Não',
                            processoMadeiraSim,
                            processoMadeiraNao,
                            () => {
                              setState(
                                () {
                                  processoMadeiraSim = true;
                                  processoMadeiraNao = false;
                                  processoMadeira = sim;
                                },
                              ),
                            },
                            () => {
                              setState(
                                () {
                                  processoMadeiraSim = false;
                                  processoMadeiraNao = true;
                                  processoMadeira = nao;
                                },
                              ),
                            },
                            marginLeft: 0.013,
                            marginTop: 0.025,
                            distanciaTituloDosChecks: 0.005,
                            backgroundColor: Colors.white.withOpacity(0.9),
                            distanciaEntreChecks: 0.1,
                          ),
                          // -----------------------------------------------------
                          CheckBox().checkBoxDuasOpcoes(
                            context,
                            'Histórico dos pedidos',
                            'Sim',
                            'Não',
                            historicoPedidosSim,
                            historicoPedidosNao,
                            () => {
                              setState(
                                () {
                                  historicoPedidosSim = true;
                                  historicoPedidosNao = false;
                                  historicoPedidos = sim;
                                },
                              ),
                            },
                            () => {
                              setState(
                                () {
                                  historicoPedidosSim = false;
                                  historicoPedidosNao = true;
                                  historicoPedidos = nao;
                                },
                              ),
                            },
                            marginLeft: 0.013,
                            marginTop: 0.025,
                            distanciaTituloDosChecks: 0.005,
                            backgroundColor: Colors.white.withOpacity(0.9),
                            distanciaEntreChecks: 0.1,
                          ),
                          // --------------------------------------------------
                          CheckBox().checkBoxDuasOpcoes(
                            context,
                            'Histórico de romaneios',
                            'Sim',
                            'Não',
                            listaRomaneioSim,
                            listaRomaneioNao,
                            () => {
                              setState(
                                () {
                                  listaRomaneioSim = true;
                                  listaRomaneioNao = false;
                                  listaRomaneios = sim;
                                },
                              ),
                            },
                            () => {
                              setState(
                                () {
                                  listaRomaneioSim = false;
                                  listaRomaneioNao = true;
                                  listaRomaneios = nao;
                                },
                              ),
                            },
                            marginLeft: 0.013,
                            marginTop: 0.025,
                            distanciaTituloDosChecks: 0.005,
                            backgroundColor: Colors.white.withOpacity(0.9),
                            distanciaEntreChecks: 0.1,
                          ),
                          // --------------------------------------------------
                          CheckBox().checkBoxDuasOpcoes(
                            context,
                            'Cadastro e listagem de clientes',
                            'Sim',
                            'Não',
                            listaClientesSim,
                            listaClientesNao,
                            () => {
                              setState(
                                () {
                                  listaClientesSim = true;
                                  listaClientesNao = false;
                                  listaClientes = sim;
                                },
                              ),
                            },
                            () => {
                              setState(
                                () {
                                  listaClientesSim = false;
                                  listaClientesNao = true;
                                  listaClientes = nao;
                                },
                              ),
                            },
                            marginLeft: 0.013,
                            marginTop: 0.025,
                            distanciaTituloDosChecks: 0.005,
                            backgroundColor: Colors.white.withOpacity(0.9),
                            distanciaEntreChecks: 0.1,
                          ),
                          // --------------------------------------------------
                          CheckBox().checkBoxDuasOpcoes(
                            context,
                            'Lista de pedidos cadastrados',
                            'Sim',
                            'Não',
                            listaPedidosCadastradosSim,
                            listaPedidosCadastradosNao,
                            () => {
                              setState(
                                () {
                                  listaPedidosCadastradosSim = true;
                                  listaPedidosCadastradosNao = false;
                                  listaPedidosCadastrados = sim;
                                },
                              ),
                            },
                            () => {
                              setState(
                                () {
                                  listaPedidosCadastradosSim = false;
                                  listaPedidosCadastradosNao = true;
                                  listaPedidosCadastrados = nao;
                                },
                              ),
                            },
                            marginLeft: 0.013,
                            marginTop: 0.025,
                            distanciaTituloDosChecks: 0.005,
                            backgroundColor: Colors.white.withOpacity(0.9),
                            distanciaEntreChecks: 0.1,
                          ),
                          // --------------------------------------------------
                          CheckBox().checkBoxDuasOpcoes(
                            context,
                            'Lista dos pedidos em produção',
                            'Sim',
                            'Não',
                            listaPedidosProducaoSim,
                            listaPedidosProducaoNao,
                            () => {
                              setState(
                                () {
                                  listaPedidosProducaoSim = true;
                                  listaPedidosProducaoNao = false;
                                  listaPedidosProducao = sim;
                                },
                              ),
                            },
                            () => {
                              setState(
                                () {
                                  listaPedidosProducaoSim = false;
                                  listaPedidosProducaoNao = true;
                                  listaPedidosProducao = nao;
                                },
                              ),
                            },
                            marginLeft: 0.013,
                            marginTop: 0.025,
                            distanciaTituloDosChecks: 0.005,
                            backgroundColor: Colors.white.withOpacity(0.9),
                            distanciaEntreChecks: 0.1,
                          ),
                          // --------------------------------------------------
                          CheckBox().checkBoxDuasOpcoes(
                            context,
                            'Lista dos pedidos prontos',
                            'Sim',
                            'Não',
                            listaPedidosProntosSim,
                            listaPedidosProntosNao,
                            () => {
                              setState(
                                () {
                                  listaPedidosProntosSim = true;
                                  listaPedidosProntosNao = false;
                                  listaPedidosProntos = sim;
                                },
                              ),
                            },
                            () => {
                              setState(
                                () {
                                  listaPedidosProntosSim = false;
                                  listaPedidosProntosNao = true;
                                  listaPedidosProntos = nao;
                                },
                              ),
                            },
                            marginLeft: 0.013,
                            marginTop: 0.025,
                            distanciaTituloDosChecks: 0.005,
                            backgroundColor: Colors.white.withOpacity(0.9),
                            distanciaEntreChecks: 0.1,
                          ),
                          // --------------------------------------------------
                          CheckBox().checkBoxDuasOpcoes(
                            context,
                            'Despesas',
                            'Sim',
                            'Não',
                            listaDespesasSim,
                            listaDespesasNao,
                            () => {
                              setState(
                                () {
                                  listaDespesasSim = true;
                                  listaDespesasNao = false;
                                  listaDespesas = sim;
                                },
                              ),
                            },
                            () => {
                              setState(
                                () {
                                  listaDespesasSim = false;
                                  listaDespesasNao = true;
                                  listaDespesas = nao;
                                },
                              ),
                            },
                            marginLeft: 0.013,
                            marginTop: 0.025,
                            distanciaTituloDosChecks: 0.005,
                            backgroundColor: Colors.white.withOpacity(0.9),
                            distanciaEntreChecks: 0.1,
                          ),
                          // --------------------------------------------------
                          CheckBox().checkBoxDuasOpcoes(
                            context,
                            'Recebimentos',
                            'Sim',
                            'Não',
                            listaRecebimentosSim,
                            listaRecebimentosNao,
                            () => {
                              setState(
                                () {
                                  listaRecebimentosSim = true;
                                  listaRecebimentosNao = false;
                                  listaRecebimentos = sim;
                                },
                              ),
                            },
                            () => {
                              setState(
                                () {
                                  listaRecebimentosSim = false;
                                  listaRecebimentosNao = true;
                                  listaRecebimentos = nao;
                                },
                              ),
                            },
                            marginLeft: 0.013,
                            marginTop: 0.025,
                            distanciaTituloDosChecks: 0.005,
                            backgroundColor: Colors.white.withOpacity(0.9),
                            distanciaEntreChecks: 0.1,
                          ),
                          // --------------------------------------------------
                          CheckBox().checkBoxDuasOpcoes(
                            context,
                            'Financeiro',
                            'Sim',
                            'Não',
                            financeiroSim,
                            financeiroNao,
                            () => {
                              setState(
                                () {
                                  financeiroSim = true;
                                  financeiroNao = false;
                                  financeiro = sim;
                                },
                              ),
                            },
                            () => {
                              setState(
                                () {
                                  financeiroSim = false;
                                  financeiroNao = true;
                                  financeiro = nao;
                                },
                              ),
                            },
                            marginLeft: 0.013,
                            marginTop: 0.025,
                            distanciaTituloDosChecks: 0.005,
                            backgroundColor: Colors.white.withOpacity(0.9),
                            distanciaEntreChecks: 0.1,
                          ),
                          // --------------------------------------------------
                          CheckBox().checkBoxDuasOpcoes(
                            context,
                            'Estatísticas',
                            'Sim',
                            'Não',
                            estatisticasSim,
                            estatisticasNao,
                            () => {
                              setState(
                                () {
                                  estatisticasSim = true;
                                  estatisticasNao = false;
                                  estatisticas = sim;
                                },
                              ),
                            },
                            () => {
                              setState(
                                () {
                                  estatisticasSim = false;
                                  estatisticasNao = true;
                                  estatisticas = nao;
                                },
                              ),
                            },
                            marginLeft: 0.013,
                            marginTop: 0.025,
                            distanciaTituloDosChecks: 0.005,
                            backgroundColor: Colors.white.withOpacity(0.9),
                            distanciaEntreChecks: 0.1,
                          ),
                           // --------------------------------------------------
                          CheckBox().checkBoxDuasOpcoes(
                            context,
                            'Venda avulso',
                            'Sim',
                            'Não',
                            vendaAvulsoSim,
                            vendaAvulsoNao,
                            () => {
                              setState(
                                () {
                                  vendaAvulsoSim = true;
                                  vendaAvulsoNao = false;
                                  vendaAvulso = sim;
                                },
                              ),
                            },
                            () => {
                              setState(
                                () {
                                  vendaAvulsoSim = false;
                                  vendaAvulsoNao = true;
                                  vendaAvulso = nao;
                                },
                              ),
                            },
                            marginLeft: 0.013,
                            marginTop: 0.025,
                            distanciaTituloDosChecks: 0.005,
                            backgroundColor: Colors.white.withOpacity(0.9),
                            distanciaEntreChecks: 0.1,
                          ),
                          // --------------------------------------------------
                          CheckBox().checkBoxDuasOpcoes(
                            context,
                            'Lixeira dos pedidos cadastrados',
                            'Sim',
                            'Não',
                            lixeiraGrupoPedidosSim,
                            lixeiraGrupoPedidosNao,
                            () => {
                              setState(
                                () {
                                  lixeiraGrupoPedidosSim = true;
                                  lixeiraGrupoPedidosNao = false;
                                  lixeiraGrupoPedidos = sim;
                                },
                              ),
                            },
                            () => {
                              setState(
                                () {
                                  lixeiraGrupoPedidosSim = false;
                                  lixeiraGrupoPedidosNao = true;
                                  lixeiraGrupoPedidos = nao;
                                },
                              ),
                            },
                            marginLeft: 0.013,
                            marginTop: 0.025,
                            distanciaTituloDosChecks: 0.005,
                            backgroundColor: Colors.white.withOpacity(0.9),
                            distanciaEntreChecks: 0.1,
                          ),
                          SizedBox(height: size.height * 0.015)
                          // --------------------------------------------------
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.03),
                Botao().botaoAnimacaoLoading(
                  context,
                  onTap: () {
                    salvarAlteracoesAcessoTela();
                    _msgAlteracoesConcluidas();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
