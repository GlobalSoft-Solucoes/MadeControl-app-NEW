import 'dart:convert';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:madecontrol_desenvolvimento/Statics/Static_SaldoDevedor.dart';
import 'package:madecontrol_desenvolvimento/Widget/Cabecalho.dart';
import 'package:madecontrol_desenvolvimento/Widget/ListFieldsDataBase.dart';
import 'package:madecontrol_desenvolvimento/models/Models_SaldoDevedor.dart';
import 'package:madecontrol_desenvolvimento/models/Models_Usuario.dart';
import 'package:madecontrol_desenvolvimento/models/constantes.dart';
import 'SaldoDevedorPorCliente.dart';

class GeralSaldoDevedor extends StatefulWidget {
  @override
  _GeralSaldoDevedorState createState() => _GeralSaldoDevedorState();
}

class _GeralSaldoDevedorState extends State<GeralSaldoDevedor> {
  TextEditingController controllerNomeDespesa = TextEditingController();
  TextEditingController controllerDescricao = TextEditingController();
  var dadosListagem = <ModelsSaldoDevedor>[];
  RxBool? loading = true.obs;

  Future<dynamic> listarDados() async {
    final response = await http.get(
      Uri.parse(ListaClientesDevedores + ModelsUsuarios.caminhoBaseUser.toString()),
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
              lista.map((model) => ModelsSaldoDevedor.fromJson(model)).toList();
        },
      );
    loading!.value = false;
  }

  @override
  void initState() {
    super.initState();
    FieldsSaldoDevedor().detalhesTotalSaldoDevedor();
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
            color: Colors.black12,
            child: Column(
              children: [
                Cabecalho().tituloCabecalho(
                  context,
                  'Saldo devedor',
                  iconeVoltar: true,
                  marginBottom: 0,
                  marginLeft: 0.005,
                  corIcone: Colors.black,
                  corTextoTitulo: Colors.black54,
                ),
                // =================== CADASTRO DO PALLET =====================
                Padding(
                  padding: EdgeInsets.only(
                    left: size.width * 0.02,
                    right: size.width * 0.02,
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    width: size.width,
                    height: size.height * 0.16,
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
                                    'Valor à receber: ',
                                    FieldsSaldoDevedor.saldoDevedorTotal,
                                    sizeCampoBanco: 22,
                                    sizeTextoCampo: 22,
                                  ),
                                  SizedBox(height: 15),
                                  FieldsDatabase().listaDadosBanco(
                                    'Empresas devedoras: ',
                                    FieldsSaldoDevedor.qtdDevedores,
                                    sizeCampoBanco: 22,
                                    sizeTextoCampo: 22,
                                  ),
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
                    height: size.height * 0.66,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
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
                                            await FieldsSaldoDevedor()
                                                .buscaDadosSaldoDevedorClientePorid(
                                                    dadosListagem[index]
                                                        .idCliente);
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    SaldoDevedorPorCliente(
                                                        idCliente:
                                                            dadosListagem[index]
                                                                .idCliente),
                                              ),
                                            );
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            height: size.height * 0.12,
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
                                                      'Empresa: ',
                                                      dadosListagem[index]
                                                          .nomeCliente,
                                                    ),
                                                    SizedBox(height: 5),
                                                    FieldsDatabase()
                                                        .listaDadosBanco(
                                                            'Saldo devedor: ',
                                                            dadosListagem[index]
                                                                .saldoCliente),
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
