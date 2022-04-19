import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:madecontrol_desenvolvimento/Statics/Static_Pedidos.dart';
import 'package:madecontrol_desenvolvimento/Statics/Static_ProducaoPedido.dart';
import 'package:madecontrol_desenvolvimento/Widget/Botao.dart';
import 'package:madecontrol_desenvolvimento/Widget/Cabecalho.dart';
import 'package:madecontrol_desenvolvimento/Widget/ListFieldsDataBase.dart';
import 'package:madecontrol_desenvolvimento/Widget/MsgPopup.dart';
import 'package:madecontrol_desenvolvimento/funcoes/FuncoesParaDatas.dart';
import 'package:madecontrol_desenvolvimento/models/Models_Pedidos.dart';
import 'package:madecontrol_desenvolvimento/models/Models_Usuario.dart';
import 'package:http/http.dart' as http;
import 'package:madecontrol_desenvolvimento/models/constantes.dart';
import 'package:progress_indicator/progress_indicator.dart';

class DetalhesProducaoPedido extends StatefulWidget {
  final int? idPedido;
  DetalhesProducaoPedido({Key? key, @required this.idPedido}) : super(key: key);
  @override
  _DetalhesProducaoPedidoState createState() =>
      _DetalhesProducaoPedidoState(idPedido: idPedido);
}

class _DetalhesProducaoPedidoState extends State<DetalhesProducaoPedido> {
  _DetalhesProducaoPedidoState({@required this.idPedido}) {
    listarDados(idPedido);
  }

  int? idPedido;
  var dadosListagem = <ModelsPedidos>[];

  RxBool? loading = true.obs;
  var idProcessoPedido = FieldsProducaoPedido.idProducao;
  var tamInteiro = 0.58;
  var tamComprimido = 0.15;
  var opcTamanho = 0.58;
  var contador = FieldsProducaoPedido.qtdProducao != null
      ? FieldsProducaoPedido.qtdProducao
      : 0;

  var percentualProducao = FieldsProducaoPedido.percentualProduzido != null
      ? FieldsProducaoPedido.percentualProduzido!.toInt()
      : 0.0;

  var check25 = FieldsProducaoPedido.idPedido != null &&
          FieldsProducaoPedido.percentualProduzido != null &&
          FieldsProducaoPedido.percentualProduzido! >= 25
      ? true
      : false;
  var check50 = FieldsProducaoPedido.idPedido != null &&
          FieldsProducaoPedido.percentualProduzido != null &&
          FieldsProducaoPedido.percentualProduzido! >= 50
      ? true
      : false;
  var check75 = FieldsProducaoPedido.idPedido != null &&
          FieldsProducaoPedido.percentualProduzido != null &&
          FieldsProducaoPedido.percentualProduzido! >= 75
      ? true
      : false;
  var check100 = FieldsProducaoPedido.idPedido != null &&
          FieldsProducaoPedido.percentualProduzido != null &&
          FieldsProducaoPedido.percentualProduzido == 100
      ? true
      : false;
  var retornoPercent;
  var mediaTempo;

  var processoIniciado = false;

  var cronometroProcesso = new Stopwatch();
  var traformResultCronometro;

  Future<dynamic> listarDados(int? id) async {
    final response = await http.get(
      Uri.parse(BuscarPedidoPorId +
          idPedido.toString() +
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
              lista.map((model) => ModelsPedidos.fromJson(model)).toList();
        },
      );
      loading!.value = false;
    }
  }

  updateProcesso() async {
    // cronometroProcesso.stop();
    var transform = cronometroProcesso.elapsedMilliseconds / 1000;
    var minutos = transform;

    minutos.toStringAsFixed(4);
    mediaTempo = minutos / contador!;

    var bodyy = jsonEncode(
      {
        'hora_fim': DataAtual().pegarHora() as String,
        'data_fim': DataAtual().pegardataBR() as String,
        'duracao_processo': cronometroProcesso.elapsed.toString(),
        'media':
            FieldsPedido.quantidade == null ? 0 : mediaTempo.toStringAsFixed(2),
        'qtd_producao': contador,
        'percentual_produzido': FieldsPedido.quantidade != null
            ? percentualProducao.toStringAsFixed(2)
            : retornoPercent.toString().replaceAll(' %', ''),
      },
    );
    var response = await http.put(
      Uri.parse(EditarProducao +
          idProcessoPedido.toString() +
          '/' +
          ModelsUsuarios.caminhoBaseUser.toString()),
      headers: {
        "Content-Type": "application/json",
        "authorization": ModelsUsuarios.tokenAuth.toString()
      },
      body: bodyy,
    );

    if (response.statusCode == 200) {}
  }

  Future<dynamic> deletarProcesso(int? id) async {
    var response = await http.delete(
     Uri.parse(ExcluirProducaoPedido +
          id.toString() +
          '/' +
          ModelsUsuarios.caminhoBaseUser.toString()),
      headers: {"authorization": ModelsUsuarios.tokenAuth.toString()},
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      Navigator.pop(context);
    } else if (response.statusCode == 401) {
      Navigator.pushNamed(context, '/login');
    } else if (response.statusCode == 400) {
      MsgPopup().msgFeedback(
        context,
        '\n' +
            'Este produto não pode ser excluído pois tem dependências com outros registros!',
        'Atenção',
      );
    }
  }

  salvarProcesso() async {
    var bodyy = jsonEncode(
      {
        'idpedido': FieldsPedido.idPedido,
        'data_inicio': DataAtual().pegardataBR() as String,
        // 'data_fim': '',
        'hora_inicio': DataAtual().pegarHora() as String,
        // 'hora_fim': '',
        // 'duracao_processo': '',
        // 'media': '0',
        'qtd_producao': 0,
        'percentual_produzido': 0,
      },
    );
    var state = await http.post(
     Uri.parse(CadastrarProducao + ModelsUsuarios.caminhoBaseUser.toString()),
      headers: {
        "Content-Type": "application/json",
        "authorization": ModelsUsuarios.tokenAuth.toString()
      },
      body: bodyy,
    );
    // print(state.statusCode);
    // print(bodyy);
    if (state.statusCode == 200) {
      contador = 0;
      percentualProducao = 0.0;
      var state = await http.get(
        Uri.parse(
          BuscaUltimoProducaoPedidoCadastrado + ModelsUsuarios.caminhoBaseUser.toString(),
        ),
        headers: {
          "Content-Type": "application/json",
          "authorization": ModelsUsuarios.tokenAuth.toString()
        },
      );

      String? retorno = state.body;
      if (retorno != "[]") {
        String? valorRetorno = retorno
            .substring(retorno.indexOf(':'), retorno.indexOf('}'))
            .replaceAll(':', '');
        if (valorRetorno.length > 0) {
          setState(() {
            idProcessoPedido = int.parse(valorRetorno);
          });
        } else if (state.statusCode == 401) {
          Navigator.pushNamed(context, '/login');
        }
      }
      return;
    } else if (state.statusCode == 401) {
      Navigator.pushNamed(context, '/login');
    }
    print('chegou');
  }

  Widget iconTimeLine(varCheck) {
    return Container(
      child: IconButton(
        icon: Icon(
          varCheck == true
              ? Icons.check_circle_outline
              : Icons.stop_circle_outlined,
          color: varCheck == true ? Colors.green[500] : Colors.orange,
        ),
        onPressed: () {},
        iconSize: 35,
        color: Colors.black54,
      ),
    );
  }

  Widget line() {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    Size size = mediaQuery.size;
    return Container(
      color: Colors.grey,
      height: 5.0,
      width: size.width * 0.11,
    );
  }

  botaoIniciar() {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    Size size = mediaQuery.size;
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(top: size.height * 0.02),
      child: Botao().botaoAnimacaoLoading(
        context,
        txtbutton: 'INICIAR',
        timeLoading: 2,
        corFonte: Colors.white,
        altura: size.height * 0.12,
        comprimento: size.width * 0.55,
        minComprimento: size.width * 0.65,
        tamanhoLetra: 28,
        onTap: () {
          setState(() {
            Timer(
              Duration(seconds: 2),
              () async {
                processoIniciado = true;
                cronometroProcesso.start();
                await salvarProcesso();
                await FieldsProducaoPedido()
                    .buscaProducaoPedidoPorId(idProcessoPedido);
                opcTamanho = tamComprimido;
              },
            );
          });
        },
        animacao: SpinKitCircle(size: 50, color: Colors.yellow),
        colorButton: Colors.green,
      ),
    );
  }

  processoSemQuantidade() {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    Size size = mediaQuery.size;
    return Container(
      height: size.height * 0.48,
      width: size.width * 1,
      padding: EdgeInsets.only(
          left: size.height * 0.005, right: size.height * 0.005),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7),
        color: Colors.white,
      ),
      child: Column(
        children: <Widget>[
          SizedBox(height: size.height * 0.015),
          Container(
            alignment: Alignment.center,
            child: Text(
              'Produção por etapa',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
            ),
          ),
          SizedBox(height: size.height * 0.02),
          Container(
            alignment: Alignment.topLeft,
            child: FieldsDatabase().listaDadosBanco(
              'Percentual da produção:  ',
              retornoPercent,
              sizeCampoBanco: 23,
              sizeTextoCampo: 23,
            ),
          ),
          SizedBox(height: size.height * 0.03),
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
            height: 2,
            color: Colors.black,
          ),
          Container(
            height: size.height * 0.12,
            color: Colors.blue[100],
            padding: EdgeInsets.only(bottom: size.height * 0.021),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: size.height * 0.02),
                    iconTimeLine(check25),
                    Text(
                      '   25 %',
                      style: TextStyle(fontSize: 17),
                    ),
                  ],
                ),
                line(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: size.height * 0.02),
                    iconTimeLine(check50),
                    Text('   50 %', style: TextStyle(fontSize: 17)),
                  ],
                ),
                line(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: size.height * 0.02),
                    iconTimeLine(check75),
                    Text('   75 %', style: TextStyle(fontSize: 17)),
                  ],
                ),
                line(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: size.height * 0.02),
                    iconTimeLine(check100),
                    Text('   100 %', style: TextStyle(fontSize: 17)),
                  ],
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
            height: 2,
            color: Colors.black,
          ),
          SizedBox(height: size.height * 0.065),
          percentualProducao != null && percentualProducao < 100
              ? Botao().botaoAnimacaoLoading(
                  context,
                  txtbutton: check100 == false ? 'AVANÇAR' : 'FINALIZAR',
                  timeLoading: 2,
                  corFonte:
                      check100 == true ? Colors.green[500] : Colors.black54,
                  altura: size.height * 0.12,
                  comprimento: size.width * 0.55,
                  minComprimento: size.width * 0.65,
                  tamanhoLetra: 29,
                  onTap: () {
                    setState(() {
                      if (check100 == false) {
                        if (check25 == false) {
                          check25 = true;
                          retornoPercent = '25 %';
                          updateProcesso();
                          return;
                        }
                        if (check50 == false) {
                          check50 = true;
                          retornoPercent = '50 %';
                          updateProcesso();
                          return;
                        }
                        if (check75 == false) {
                          check75 = true;
                          retornoPercent = '75 %';
                          updateProcesso();
                          return;
                        }
                        if (check100 == false) {
                          check100 = true;
                          retornoPercent = '100 %';
                          cronometroProcesso.stop();
                          updateProcesso();
                          return;
                        }
                      } else {
                        Navigator.pop(context);
                      }
                    });
                  },
                  animacao: check100 == false
                      ? SpinKitPouringHourGlass(size: 50, color: Colors.orange)
                      : SpinKitCircle(size: 50, color: Colors.green),
                )
              : Container(
                  width: size.width * 1,
                  height: size.height * 0.1,
                  color: Colors.yellow[100],
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(top: size.height * 0.01),
                  child: Text(
                    'PRODUÇÃO DO PRODUTO FINALIZADA!',
                    style: TextStyle(
                      fontSize: size.width * 0.046,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  processoPorQuantidade() {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    Size size = mediaQuery.size;
    return Container(
      height: size.height * 0.48,
      width: size.width * 1,
      padding: EdgeInsets.only(
          left: size.width * 0.02,
          right: size.width * 0.02,
          top: size.height * 0.01),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7),
        color: Colors.white,
      ),
      child: Column(
        children: [
          Container(
            alignment: Alignment.topLeft,
            child: Text(
              'Qtd pedido:     ${FieldsPedido.quantidade.toString().replaceAll('.0', '')}',
              style: TextStyle(fontSize: 23, color: Colors.blue[800]),
            ),
          ),
          SizedBox(height: size.height * 0.01),
          Container(
            alignment: Alignment.topLeft,
            child: Text(
              'Qtd produzida:    ${contador.toString()}',
              style: TextStyle(fontSize: 23, color: Colors.green[600]),
            ),
          ),
          SizedBox(height: size.height * 0.01),
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
            height: 2,
            color: Colors.black,
          ),
          SizedBox(height: size.height * 0.02),
          Container(
            width: size.width * 0.8,
            height: size.height * 0.03,
            child: Container(
              width: size.width * 0.3,
              child: BarProgress(
                percentage: percentualProducao == null
                    ? 0.0
                    : percentualProducao.toDouble(),
                backColor: Colors.grey,
                gradient: LinearGradient(
                    colors: [Colors.blue[100]!, Colors.blue[900]!]),
                showPercentage: true,
                textStyle: TextStyle(color: Colors.white, fontSize: 20),
                stroke: 27,
                round: true,
              ),
            ),
          ),
          SizedBox(height: size.height * 0.075),
          FieldsProducaoPedido.percentualProduzido != null &&
                  FieldsProducaoPedido.percentualProduzido! < 100
              ? Botao().botaoAnimacaoLoading(
                  context,
                  timeLoading: contador! < FieldsPedido.quantidade! ? 1 : 2,
                  altura: size.height * 0.17,
                  comprimento: size.width * 0.65,
                  minComprimento: size.width * 0.45,
                  borderRadius: 20,
                  onTap: () {
                    setState(() {
                      if (contador! < FieldsPedido.quantidade!) {
                        // contador++;
                        contador = contador! + 25;
                        percentualProducao =
                            (contador! / FieldsPedido.quantidade!) * 100;
                        if (percentualProducao > 100) {
                          percentualProducao = 100;
                        }
                        if (contador! > FieldsPedido.quantidade!) {
                          contador = FieldsPedido.quantidade!.toInt();
                        }

                        updateProcesso();
                      } else {
                        cronometroProcesso.stop();
                        Navigator.pop(context);
                      }
                    });
                  },
                  txtbutton:
                      contador! < FieldsPedido.quantidade! ? '+' : 'Finalizar',
                  tamanhoLetra: contador! < FieldsPedido.quantidade! ? 100 : 40,
                  fontWeigh: FontWeight.w300,
                  corFonte: Colors.green[600],
                  animacao: contador! < FieldsPedido.quantidade!
                      ? SpinKitPouringHourGlass(size: 75, color: Colors.orange)
                      : SpinKitCircle(size: 75, color: Colors.orange),
                )
              : Container(
                  width: size.width * 1,
                  height: size.height * 0.1,
                  color: Colors.yellow[100],
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(top: size.height * 0.01),
                  child: Text(
                    'PRODUÇÃO DO PRODUTO FINALIZADA!',
                    style: TextStyle(
                      fontSize: size.width * 0.046,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
        ],
      ),
    );
  }

  @override
  void initState() {
    FieldsPedido().buscaDadosPedidoPorId(idPedido);
    // FieldsProducaoPedido().buscaProducaoPedidoPorId(FieldsProducaoPedido.idProducao);
    contador = FieldsProducaoPedido.qtdProducao != null
        ? FieldsProducaoPedido.qtdProducao
        : 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    Size size = mediaQuery.size;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            color: Colors.green[200],
            width: size.width,
            height: size.height * 1,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Cabecalho().tituloCabecalho(
                    context,
                    '',
                    iconeVoltar: true,
                    marginBottom: 0.01,
                    sizeIcone: 35,
                  ),
                  // SizedBox(height: size.height * 0.01),
                  Padding(
                    padding: EdgeInsets.only(
                      left: size.width * 0.02,
                      right: size.width * 0.02,
                      bottom: size.height * 0.2,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          width: size.width,
                          height: size.height * opcTamanho,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7),
                              color: Colors.white),
                          child: FutureBuilder(
                            future: listarDados(idPedido),
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
                                                left: 8, right: 4),
                                            child: Container(
                                              alignment: Alignment.center,
                                              width: size.width,
                                              height: size.height * opcTamanho,
                                              child: SingleChildScrollView(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    SizedBox(height: 15),
                                                    FieldsDatabase()
                                                        .listaDadosBanco(
                                                      'Cliente: ',
                                                      dadosListagem[index]
                                                          .nomeCliente,
                                                      sizeCampoBanco: 24,
                                                      sizeTextoCampo: 24,
                                                    ),

                                                    SizedBox(height: 15),
                                                    Row(
                                                      children: [
                                                        FieldsDatabase()
                                                            .listaDadosBanco(
                                                          'Data: ',
                                                          dadosListagem[index]
                                                              .dataPedido!
                                                              .substring(0, 10),
                                                          sizeCampoBanco: 24,
                                                          sizeTextoCampo: 24,
                                                        ),
                                                        FieldsDatabase()
                                                            .listaDadosBanco(
                                                          '  -  Hora: ',
                                                          dadosListagem[index]
                                                              .horaPedido!
                                                              .substring(0, 5),
                                                          sizeCampoBanco: 24,
                                                          sizeTextoCampo: 24,
                                                        ),
                                                      ],
                                                    ),
                                                    if (dadosListagem[index]
                                                            .nomeProduto !=
                                                        null)
                                                      SizedBox(height: 15),
                                                    if (dadosListagem[index]
                                                            .nomeProduto !=
                                                        null)
                                                      FieldsDatabase()
                                                          .listaDadosBanco(
                                                        'Produto: ',
                                                        dadosListagem[index]
                                                            .nomeProduto,
                                                        sizeCampoBanco: 24,
                                                        sizeTextoCampo: 24,
                                                      ),
                                                    if (dadosListagem[index]
                                                            .idPallet !=
                                                        null)
                                                      SizedBox(height: 15),
                                                    if (dadosListagem[index]
                                                            .idPallet !=
                                                        null)
                                                      FieldsDatabase()
                                                          .listaDadosBanco(
                                                        'Produto: ',
                                                        dadosListagem[index]
                                                            .nomePallet,
                                                        sizeCampoBanco: 24,
                                                        sizeTextoCampo: 24,
                                                      ),
                                                    if (dadosListagem[index]
                                                            .nomeUndMedida !=
                                                        null)
                                                      SizedBox(height: 15),
                                                    if (dadosListagem[index]
                                                            .nomeUndMedida !=
                                                        null)
                                                      FieldsDatabase()
                                                          .listaDadosBanco(
                                                        'Unidade de medida: ',
                                                        dadosListagem[index]
                                                            .nomeUndMedida,
                                                        sizeCampoBanco: 24,
                                                        sizeTextoCampo: 24,
                                                      ),
                                                    if (dadosListagem[index]
                                                            .beneficiado ==
                                                        true)
                                                      SizedBox(height: 15),
                                                    if (dadosListagem[index]
                                                            .beneficiado ==
                                                        true)
                                                      FieldsDatabase()
                                                          .listaDadosBanco(
                                                        'Pedido beneficiado? ',
                                                        dadosListagem[index]
                                                            .beneficiado
                                                            .toString()
                                                            .replaceAll(
                                                                'false', 'Não')
                                                            .replaceAll(
                                                                'true', 'Sim'),
                                                        sizeCampoBanco: 24,
                                                        sizeTextoCampo: 24,
                                                      ),
                                                    if (dadosListagem[index]
                                                            .tipoProcesso !=
                                                        null)
                                                      SizedBox(height: 15),
                                                    if (dadosListagem[index]
                                                            .tipoProcesso !=
                                                        null)
                                                      FieldsDatabase()
                                                          .listaDadosBanco(
                                                        'Tipo do processo: ',
                                                        dadosListagem[index]
                                                            .tipoProcesso,
                                                        sizeCampoBanco: 24,
                                                        sizeTextoCampo: 24,
                                                      ),
                                                    if (dadosListagem[index]
                                                            .nomeMadeira !=
                                                        null)
                                                      SizedBox(height: 15),
                                                    if (dadosListagem[index]
                                                            .nomeMadeira !=
                                                        null)
                                                      FieldsDatabase()
                                                          .listaDadosBanco(
                                                        'Madeira: ',
                                                        dadosListagem[index]
                                                            .nomeMadeira,
                                                        sizeCampoBanco: 24,
                                                        sizeTextoCampo: 24,
                                                      ),
                                                    if (dadosListagem[index]
                                                            .quantidade !=
                                                        null)
                                                      SizedBox(height: 15),
                                                    if (dadosListagem[index]
                                                            .quantidade !=
                                                        null)
                                                      FieldsDatabase()
                                                          .listaDadosBanco(
                                                        'Quantidade: ',
                                                        dadosListagem[index]
                                                            .quantidade
                                                            .toString(),
                                                        sizeCampoBanco: 24,
                                                        sizeTextoCampo: 24,
                                                      ),
                                                    if (dadosListagem[index]
                                                            .comprimento !=
                                                        null)
                                                      SizedBox(height: 15),
                                                    if (dadosListagem[index]
                                                            .comprimento !=
                                                        null)
                                                      FieldsDatabase()
                                                          .listaDadosBanco(
                                                        'Comprimento: ',
                                                        dadosListagem[index]
                                                            .comprimento
                                                            .toString(),
                                                        sizeCampoBanco: 24,
                                                        sizeTextoCampo: 24,
                                                      ),
                                                    if (dadosListagem[index]
                                                            .largura !=
                                                        null)
                                                      SizedBox(height: 15),
                                                    if (dadosListagem[index]
                                                            .largura !=
                                                        null)
                                                      FieldsDatabase()
                                                          .listaDadosBanco(
                                                        'Largura: ',
                                                        dadosListagem[index]
                                                            .largura
                                                            .toString(),
                                                        sizeCampoBanco: 24,
                                                        sizeTextoCampo: 24,
                                                      ),
                                                    if (dadosListagem[index]
                                                            .espessura !=
                                                        null)
                                                      SizedBox(height: 15),
                                                    if (dadosListagem[index]
                                                            .espessura !=
                                                        null)
                                                      FieldsDatabase()
                                                          .listaDadosBanco(
                                                        'Espessura: ',
                                                        dadosListagem[index]
                                                            .espessura
                                                            .toString(),
                                                        sizeCampoBanco: 24,
                                                        sizeTextoCampo: 24,
                                                      ),
                                                    if (dadosListagem[index]
                                                            .observacoes ==
                                                        null)
                                                      SizedBox(height: 15),
                                                    if (dadosListagem[index]
                                                            .observacoes ==
                                                        null)
                                                      FieldsDatabase()
                                                          .listaDadosBanco(
                                                        'Observações: ',
                                                        dadosListagem[index]
                                                            .observacoes,
                                                        sizeCampoBanco: 24,
                                                        sizeTextoCampo: 24,
                                                      ),
                                                    SizedBox(height: 15),
                                                    if (dadosListagem[index]
                                                            .qtdMetros !=
                                                        null)
                                                      Container(
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                              dadosListagem[index]
                                                                          .idUnidadeMedida ==
                                                                      3
                                                                  ? 'Metros coridos: '
                                                                  : dadosListagem[index]
                                                                              .idUnidadeMedida ==
                                                                          2
                                                                      ? 'Metros quadrados: '
                                                                      : 'Metros cúbicos: ',
                                                              style: TextStyle(
                                                                fontSize: 25,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Text(
                                                                dadosListagem[index].idUnidadeMedida ==
                                                                            1 ||
                                                                        dadosListagem[index].idUnidadeMedida ==
                                                                            4
                                                                    ? '${dadosListagem[index].qtdMetros} M³'
                                                                    : dadosListagem[index].idUnidadeMedida ==
                                                                            2
                                                                        ? '${dadosListagem[index].qtdMetros} M²'
                                                                        : '${dadosListagem[index].qtdMetros}',
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontSize:
                                                                        22,
                                                                    color: Colors
                                                                            .blue[
                                                                        700]),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    SizedBox(height: 15),
                                                    //==================================================
                                                  ],
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
                        Padding(
                          padding: EdgeInsets.only(top: size.height * 0.005),
                          child: Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      bottom: size.height * 0.02),
                                  child: IconButton(
                                    icon: Icon(
                                      opcTamanho == tamInteiro
                                          ? Icons.keyboard_arrow_up_sharp
                                          : Icons.keyboard_arrow_down,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        if (opcTamanho == tamInteiro) {
                                          opcTamanho = tamComprimido;
                                        } else {
                                          opcTamanho = tamInteiro;
                                        }
                                      });
                                    },
                                    iconSize: 55,
                                    color: Colors.black54,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        FieldsProducaoPedido.idPedido == null &&
                                processoIniciado == false
                            ? botaoIniciar()
                            : Container(),
                        if (processoIniciado == true ||
                            FieldsProducaoPedido.idPedido != null)
                          FieldsPedido.quantidade != null
                              ? processoPorQuantidade()
                              : processoSemQuantidade(),
                      ],
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
