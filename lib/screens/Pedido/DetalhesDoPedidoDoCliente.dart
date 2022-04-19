import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:madecontrol_desenvolvimento/Widget/Cabecalho.dart';
import 'package:madecontrol_desenvolvimento/Widget/ListFieldsDataBase.dart';
import 'package:madecontrol_desenvolvimento/Widget/MsgPopup.dart';
import 'package:madecontrol_desenvolvimento/models/Models_Pedidos.dart';
import 'package:madecontrol_desenvolvimento/models/Models_Usuario.dart';
import 'package:http/http.dart' as http;
import 'package:madecontrol_desenvolvimento/models/constantes.dart';

class ListarDadosPedido extends StatefulWidget {
  final int? idPedido;
  ListarDadosPedido({Key? key, @required this.idPedido}) : super(key: key);
  @override
  _ListarDadosPedidoState createState() =>
      _ListarDadosPedidoState(idPedido: idPedido);
}

class PermissaoExcluir {
  static RxBool? permissao = false.obs;
}

class _ListarDadosPedidoState extends State<ListarDadosPedido> {
  _ListarDadosPedidoState({@required this.idPedido}) {
    fetchPost(idPedido);
  }
  int? idPedido;
  var dadosListagem = <ModelsPedidos>[];
  RxBool? loading = true.obs;
  Future<dynamic> fetchPost(int? id) async {
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

  msgConfirmacaoDeletarPedido() {
    MsgPopup().msgComDoisBotoes(
      context,
      'Você deseja remover este pedido?',
      'Não',
      'Sim',
      () => Navigator.pop(context),
      () {
        deletar();
        Navigator.pop(context);
        Navigator.pop(context);
      },
    );
  }

  Future<dynamic> deletar() async {
    var response = await http.delete(
      Uri.parse(DeletarPedido +
          idPedido.toString() +
          '/' +
          ModelsUsuarios.caminhoBaseUser.toString()),
      headers: {"authorization": ModelsUsuarios.tokenAuth.toString()},
    );
    print(response.statusCode);
    print(idPedido);
    if (response.statusCode == 401) {
      Navigator.pushNamed(context, '/login');
    } else if (response.statusCode == 201) {
      Navigator.pop(context);
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
            color: Colors.green[200],
            width: size.width,
            height: size.height,
            child: Column(
              children: [
                Cabecalho().tituloCabecalho(
                  context,
                  'Detalhes do pedido',
                  iconeVoltar: true,
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: size.width * 0.02,
                    right: size.width * 0.02,
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: size.width,
                        height: size.height * 0.75,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white),
                        child: FutureBuilder(
                          future: fetchPost(idPedido),
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
                                              left: 4, right: 4),
                                          child: Container(
                                            width: size.width,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                15,
                                              ),
                                            ),
                                            child: Container(
                                              alignment: Alignment.center,
                                              // padding: const EdgeInsets.only(
                                              //     left: 0, right: 10),
                                              child: Container(
                                                // alignment: Alignment.center,
                                                padding:
                                                    EdgeInsets.only(left: 5),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    15,
                                                  ),
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
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
                                                            .beneficiado !=
                                                        null)
                                                      SizedBox(height: 15),
                                                    if (dadosListagem[index]
                                                            .beneficiado !=
                                                        null)
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
                                                            .observacoes !=
                                                        null)
                                                      SizedBox(height: 15),
                                                    if (dadosListagem[index]
                                                            .observacoes !=
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
                                                    //========================================================
                                                    Container(
                                                        margin:
                                                            EdgeInsets.fromLTRB(
                                                                10, 0, 10, 0),
                                                        height: 2,
                                                        color: Colors.black,
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 20)),
                                                    if (dadosListagem[index]
                                                            .qtdMetros !=
                                                        null)
                                                      Container(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 5,
                                                                top: 15),
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
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontSize: 22,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 5, top: 15),
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            dadosListagem[index]
                                                                        .idUnidadeMedida ==
                                                                    3
                                                                ? 'Preço metro corrido: '
                                                                : dadosListagem[index]
                                                                            .idUnidadeMedida ==
                                                                        2
                                                                    ? 'Preço metro quadrado: '
                                                                    : dadosListagem[index].beneficiado ==
                                                                            true
                                                                        ? 'Preço por quantidade: '
                                                                        : dadosListagem[index].idPallet !=
                                                                                null
                                                                            ? 'Preço pallet: '
                                                                            : 'Preço metro cúbico:',
                                                            style: TextStyle(
                                                              fontSize: 25,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Text(
                                                              '${dadosListagem[index].precoCubico}',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .green[600],
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                fontSize: 22,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 5,
                                                              top: 15,
                                                              bottom: 10),
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            'Valor total: ',
                                                            style: TextStyle(
                                                              fontSize: 25,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Text(
                                                              '${dadosListagem[index].valorTotal}',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .green[600],
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                fontSize: 22,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    //==================================================
                                                  ],
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
                      Obx(
                        () => PermissaoExcluir.permissao!.value == true
                            ? Padding(
                                padding:
                                    EdgeInsets.only(top: size.height * 0.02),
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: Padding(
                                      padding: EdgeInsets.only(
                                          bottom: size.height * 0.02),
                                      child: IconButton(
                                        icon: Icon(Icons.delete_forever),
                                        onPressed: () =>
                                            {msgConfirmacaoDeletarPedido()},
                                        iconSize: 40,
                                        color: Colors.red,
                                      ),
                                    ))
                                  ],
                                ),
                              )
                            : Container(),
                      ),
                    ],
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
