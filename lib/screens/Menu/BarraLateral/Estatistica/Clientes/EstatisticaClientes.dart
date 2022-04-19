import 'dart:convert';
import 'dart:math';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:madecontrol_desenvolvimento/Statics/Estatisticas/Static_EstCliente.dart';
import 'package:madecontrol_desenvolvimento/Widget/Cabecalho.dart';
import 'package:madecontrol_desenvolvimento/Widget/ListFieldsDataBase.dart';
import 'package:madecontrol_desenvolvimento/Widget/MsgPopup.dart';
import 'package:madecontrol_desenvolvimento/models/Estatisticas/Models_EstClientes.dart';
import 'package:madecontrol_desenvolvimento/models/Models_Usuario.dart';
import 'package:madecontrol_desenvolvimento/models/constantes.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import 'DetalhesEstCliente.dart';

class EstatisticaClientes extends StatefulWidget {
  @override
  _EstatisticaClientesState createState() => _EstatisticaClientesState();
}

class _EstatisticaClientesState extends State<EstatisticaClientes> {
  TextEditingController controllerNomeDespesa = TextEditingController();
  TextEditingController controllerDescricao = TextEditingController();
  var dadosListagem = <ModelsEstClientes>[];
  RxBool? loading = true.obs;
  var dataInicio = '01-01-2000';
  var dataFim = '01-03-2100';
  //
  Future<dynamic> listarDados() async {
    final response = await http.get(
      Uri.parse(EstatisticaListarClientes +
          dataInicio.toString() +
          '/' +
          dataFim.toString() +
          '/' +
          ModelsUsuarios.caminhoBaseUser.toString()),
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
              lista.map((model) => ModelsEstClientes.fromJson(model)).toList();
        },
      );
    loading!.value = false;
  }

  Future<dynamic> delete(int? id) async {
    var response = await http.delete(
      Uri.parse(ExcluirTipoDespesa + id.toString() + '/' + ModelsUsuarios.caminhoBaseUser.toString()),
      headers: {"authorization": ModelsUsuarios.tokenAuth.toString()},
    );
    print(response.statusCode);
    if (response.statusCode == 401) {
      Navigator.pushNamed(context, '/login');
    }
  }

  var mascaraLargura = new MaskTextInputFormatter(
      mask: '#.#####', filter: {"#": RegExp(r'[0-9]')});
  var mascaraComprimento = new MaskTextInputFormatter(
      mask: '*.*****', filter: {"*": RegExp(r'[0-9]')});

  confExcluir(id) {
    MsgPopup().msgComDoisBotoes(
      context,
      'Deseja excluir a despesa selecionada?',
      'Cancelar',
      'Confirmar',
      () => {
        Navigator.pop(context),
      },
      () => {
        delete(id),
        Navigator.pop(context),
      },
    );
  }

  // Gera os codigos para o pallet
  gerarCodPallet() {
    var _random = Random.secure();
    var random = List<int>.generate(4, (i) => _random.nextInt(256));
    var verificador = base64Url.encode(random);
    verificador = verificador
        .replaceAll('+', '')
        .replaceAll('-', '')
        .replaceAll('/', '')
        .replaceAll('', '')
        .replaceAll('=', '')
        .replaceAll(' ', '');

    return verificador.trim();
  }

// Salva os dados no banco
  salvarBanco() async {
    var bodyy = jsonEncode(
      {
        'nome': controllerNomeDespesa.text,
        'descricao': controllerDescricao.text
      },
    );
    var state = await http.post(
      Uri.parse(CadastrarTipoDespesa + ModelsUsuarios.caminhoBaseUser.toString()),
      headers: {
        "Content-Type": "application/json",
        "authorization": ModelsUsuarios.tokenAuth.toString()
      },
      body: bodyy,
    );
    print(state.statusCode);
    print(bodyy);
    if (state.statusCode == 201) {
      controllerNomeDespesa.text = "";
      controllerDescricao.text = "";
    } else if (state.statusCode == 401) {
      Navigator.pushNamed(context, '/login');
    }
    print('chegou');
  }

  msgValidaCampos(mensagem) {
    MsgPopup().msgFeedback(context, '\n' + mensagem, 'Erro');
  }

//valida os campos
  validarCampos() {
    if (controllerNomeDespesa.text.isEmpty) {
      msgValidaCampos('O campo nome da despesa não foi preenchido');
    } else {
      salvarBanco();
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
            color: Colors.black12, //Colors.green[200],
            child: Column(
              children: [
                Cabecalho().tituloCabecalho(
                  context,
                  'Estatisticas de clientes',
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
                    height: size.height * 0.20,
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
                                    'Faturamento total: ',
                                    FieldsEstatisticaClientes
                                        .faturamentoTotalPedidos,
                                    sizeCampoBanco: 21,
                                    sizeTextoCampo: 21,
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  FieldsDatabase().listaDadosBanco(
                                    'Número total de pedidos: ',
                                    FieldsEstatisticaClientes.qtdTotalPedidos,
                                    sizeCampoBanco: 21,
                                    sizeTextoCampo: 21,
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  FieldsDatabase().listaDadosBanco(
                                    'Média faturamento por pedido: ',
                                    FieldsEstatisticaClientes
                                        .mediaFaturamentoPedido,
                                    sizeCampoBanco: 20,
                                    sizeTextoCampo: 20,
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
                    height: size.height * 0.60,
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
                                            await FieldsEstatisticaClientes()
                                                .buscaDadosEstClientePorid(
                                                    dadosListagem[index]
                                                        .idCliente);
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    DetalhesEstatisticaCliente(
                                                        idCliente:
                                                            dadosListagem[index]
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
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    FieldsDatabase()
                                                        .listaDadosBanco(
                                                            'Faturamento: ',
                                                            dadosListagem[index]
                                                                .faturamentoIndividual),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    FieldsDatabase()
                                                        .listaDadosBanco(
                                                      'Representação faturamento total: ',
                                                      dadosListagem[index]
                                                              .representacaoFaturamento +
                                                          ' %',
                                                      corCampoBanco:
                                                          Colors.green[700],
                                                    )
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
