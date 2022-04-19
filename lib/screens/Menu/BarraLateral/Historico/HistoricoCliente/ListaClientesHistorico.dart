import 'dart:convert';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:madecontrol_desenvolvimento/Statics/Static_Cliente.dart';
import 'package:madecontrol_desenvolvimento/Widget/Cabecalho.dart';
import 'package:madecontrol_desenvolvimento/Widget/ListFieldsDataBase.dart';
import 'package:madecontrol_desenvolvimento/models/Models_Clientes.dart';
import 'package:madecontrol_desenvolvimento/models/Models_Usuario.dart';
import 'package:madecontrol_desenvolvimento/models/constantes.dart';
import 'HistoricoGrupoPedidosCliente.dart';

class ListaClientesHistorico extends StatefulWidget {
  @override
  _HistoricoPedidosState createState() => _HistoricoPedidosState();
}

class _HistoricoPedidosState extends State<ListaClientesHistorico> {

  var dadosClientes = <ModelsClientes>[];
  RxBool? loading = true.obs;
  Future<dynamic> listarDados() async {
    final response = await http.get(
      Uri.parse(ListarTodosClientes + ModelsUsuarios.caminhoBaseUser.toString()),
      headers: {"authorization": ModelsUsuarios.tokenAuth.toString()},
    );
    if (response.statusCode == 401) {
      Navigator.pushNamed(context, '/Login');
    }
    //IF(MOUNTED) É nescessario para não recarregar a arvore apos retornar das outras listas
    if (mounted)
      setState(() {
        Iterable lista = json.decode(response.body);
        dadosClientes =
            lista.map((model) => ModelsClientes.fromJson(model)).toList();
      });
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
            width: size.width,
            height: size.height,
            color: Colors.green[200],
            child: Column(
              children: [
                Cabecalho().tituloCabecalho(
                  context,
                  'Clientes',
                  iconeVoltar: true,
                  sizeTextTitulo: 0.065,
                  marginBottom: 0.02,
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: size.width * 0.02,
                      right: size.width * 0.02,
                      top: size.height * 0.00,
                      bottom: size.height * 0.01),
                  child: Container(
                    padding: EdgeInsets.only(top: 5, bottom: 5),
                    width: size.width,
                    height: size.height * 0.86,
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
                                  itemCount: dadosClientes.length,
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
                                            motion: const ScrollMotion(),
                                            children: [
                                            ],
                                          ),
                                          child: GestureDetector(
                                            onTap: () {
                                              Cliente.nomeCliente =
                                                  dadosClientes[index].nome;
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      HistoricoGrupoPedidosCliente(
                                                          idCliente:
                                                              dadosClientes[
                                                                      index]
                                                                  .idCliente),
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
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  child: ListTile(
                                                    title: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        FieldsDatabase()
                                                            .listaDadosBanco(
                                                                'Nome: ',
                                                                dadosClientes[
                                                                        index]
                                                                    .nome),
                                                        SizedBox(height: 3),
                                                        dadosClientes[index]
                                                                        .cnpj !=
                                                                    '' &&
                                                                dadosClientes[
                                                                            index]
                                                                        .cnpj !=
                                                                    null
                                                            ? FieldsDatabase()
                                                                .listaDadosBanco(
                                                                    'CNPJ: ',
                                                                    dadosClientes[
                                                                            index]
                                                                        .cnpj)
                                                            : FieldsDatabase()
                                                                .listaDadosBanco(
                                                                    'CPF: ',
                                                                    dadosClientes[
                                                                            index]
                                                                        .cpf),
                                                        SizedBox(height: 3),
                                                        FieldsDatabase()
                                                            .listaDadosBanco(
                                                                'Cidade: ',
                                                                dadosClientes[
                                                                        index]
                                                                    .cidade),
                                                        SizedBox(height: 3),
                                                        FieldsDatabase()
                                                            .listaDadosBanco(
                                                                'Telefone: ',
                                                                dadosClientes[
                                                                        index]
                                                                    .telefone),
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
    );
  }
}
