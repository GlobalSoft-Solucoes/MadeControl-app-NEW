import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:madecontrol_desenvolvimento/Widget/Cabecalho.dart';
import 'package:madecontrol_desenvolvimento/Widget/ListFieldsDataBase.dart';
import 'package:madecontrol_desenvolvimento/Widget/MsgPopup.dart';
import 'package:madecontrol_desenvolvimento/models/Models_Clientes.dart';
import 'package:madecontrol_desenvolvimento/models/Models_Usuario.dart';
import 'package:http/http.dart' as http;
import 'package:madecontrol_desenvolvimento/models/constantes.dart';

class ListarDadosCliente extends StatefulWidget {
  final int? idCliente;
  ListarDadosCliente({Key? key, @required this.idCliente}) : super(key: key);
  @override
  _ListarDadosClienteState createState() =>
      _ListarDadosClienteState(idPedido: idCliente);
}

class _ListarDadosClienteState extends State<ListarDadosCliente> {
  _ListarDadosClienteState({@required this.idPedido}) {
    fetchPost(idPedido);
  }
  var dadosClientes = <ModelsClientes>[];
  RxBool? loading = true.obs;
  Future<dynamic> fetchPost(int? id) async {
    final response = await http.get(
      Uri.parse(BuscarClienteporId +
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
          dadosClientes =
              lista.map((model) => ModelsClientes.fromJson(model)).toList();
        },
      );
    }
    loading!.value = false;
  }

  msgConfirmacaoDeletarCliente() {
    MsgPopup().msgComDoisBotoes(
      context,
      'Você deseja remover este cliente?',
      'Não',
      'Sim',
      () => Navigator.pop(context),
      () {
        deletar();
        Navigator.pop(context);
      },
    );
  }

  Future<dynamic> deletar() async {
    var response = await http.delete(
      Uri.parse(DeletarCliente +
          idPedido.toString() +
          '/' +
          ModelsUsuarios.caminhoBaseUser.toString()),
      headers: {"authorization": ModelsUsuarios.tokenAuth.toString()},
    );
    if (response.statusCode == 401) {
      Navigator.pushNamed(context, '/Login');
    } else if (response.statusCode == 200) {
      Navigator.pop(context);
    }
  }

  int? idPedido;
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
                  'Dados do cliente',
                  iconeVoltar: true,
                  sizeTextTitulo: 0.065,
                ),
                Container(
                  height: size.height * 0.65,
                  width: size.width,
                  child: Stack(
                    //(
                    children: [
                      FutureBuilder(
                        future: fetchPost(idPedido),
                        builder: (BuildContext context, snapshot) {
                          return Obx(
                            () => loading!.value == true
                                ? Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : ListView.builder(
                                    itemCount: dadosClientes.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: EdgeInsets.only(
                                          top: size.height * 0.1,
                                          left: 10,
                                          right: 10,
                                        ),
                                        child: Column(
                                          children: [
                                            Container(
                                              alignment: Alignment.center,
                                              color: Colors.white,
                                              child: Container(
                                                height: size.height * 0.55,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.black,
                                                      width: 2),
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                padding: EdgeInsets.only(
                                                  left: size.width * 0.03,
                                                ),
                                                alignment: Alignment.centerLeft,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    SizedBox(
                                                        height:
                                                            size.height * 0.02),
                                                    FieldsDatabase()
                                                        .listaDadosBanco(
                                                      'Cliente:  ',
                                                      dadosClientes[index].nome,
                                                      sizeCampoBanco: 22,
                                                      sizeTextoCampo: 22,
                                                    ),
                                                    SizedBox(
                                                        height:
                                                            size.height * 0.02),
                                                    FieldsDatabase()
                                                        .listaDadosBanco(
                                                      dadosClientes[index]
                                                                  .cpf !=
                                                              ''
                                                          ? 'CPF:  '
                                                          : 'CNPJ:  ',
                                                      dadosClientes[index]
                                                              .cpf!
                                                              .isEmpty
                                                          ? dadosClientes[index]
                                                              .cnpj
                                                          : dadosClientes[index]
                                                              .cpf,
                                                      sizeCampoBanco: 22,
                                                      sizeTextoCampo: 22,
                                                    ),
                                                    SizedBox(
                                                        height:
                                                            size.height * 0.02),
                                                    FieldsDatabase()
                                                        .listaDadosBanco(
                                                      'Telefone:  ',
                                                      dadosClientes[index]
                                                          .telefone,
                                                      sizeCampoBanco: 22,
                                                      sizeTextoCampo: 22,
                                                    ),
                                                    SizedBox(
                                                        height:
                                                            size.height * 0.02),
                                                    FieldsDatabase()
                                                        .listaDadosBanco(
                                                      'Cidade:  ',
                                                      dadosClientes[index]
                                                          .cidade,
                                                      sizeCampoBanco: 22,
                                                      sizeTextoCampo: 22,
                                                    ),
                                                    SizedBox(
                                                        height:
                                                            size.height * 0.02),
                                                    FieldsDatabase()
                                                        .listaDadosBanco(
                                                      'Bairro:  ',
                                                      dadosClientes[index]
                                                          .bairro,
                                                      sizeCampoBanco: 22,
                                                      sizeTextoCampo: 22,
                                                    ),
                                                    SizedBox(
                                                        height:
                                                            size.height * 0.02),
                                                    FieldsDatabase()
                                                        .listaDadosBanco(
                                                      'Endereço:  ',
                                                      dadosClientes[index]
                                                          .endereco,
                                                      sizeCampoBanco: 22,
                                                      sizeTextoCampo: 22,
                                                    ),
                                                    SizedBox(
                                                        height:
                                                            size.height * 0.02),
                                                    FieldsDatabase()
                                                        .listaDadosBanco(
                                                      'Número residência:  ',
                                                      dadosClientes[index]
                                                          .numResidencia
                                                          .toString(),
                                                      sizeCampoBanco: 22,
                                                      sizeTextoCampo: 22,
                                                    ),
                                                    SizedBox(
                                                        height:
                                                            size.height * 0.02),
                                                    FieldsDatabase()
                                                        .listaDadosBanco(
                                                      'Possui DOF?  ',
                                                      dadosClientes[index]
                                                          .dof
                                                          .toString()
                                                          .replaceAll('A', 'Ã'),
                                                      sizeCampoBanco: 22,
                                                      sizeTextoCampo: 22,
                                                    ),
                                                    SizedBox(
                                                        height:
                                                            size.height * 0.02),
                                                    FieldsDatabase()
                                                        .listaDadosBanco(
                                                      'Código cliente:  ',
                                                      dadosClientes[index]
                                                          .codigoCliente,
                                                      sizeCampoBanco: 22,
                                                      sizeTextoCampo: 22,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: size.height * 0.04),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(bottom: size.height * 0.02),
                          child: IconButton(
                            icon: Icon(Icons.delete_forever),
                            onPressed: () => {msgConfirmacaoDeletarCliente()},
                            iconSize: 40,
                            color: Colors.red,
                          ),
                        ),
                      )
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
