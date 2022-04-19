import 'dart:convert';
import 'dart:math';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:madecontrol_desenvolvimento/Widget/Botao.dart';
import 'package:madecontrol_desenvolvimento/Widget/Cabecalho.dart';
import 'package:madecontrol_desenvolvimento/Widget/ListFieldsDataBase.dart';
import 'package:madecontrol_desenvolvimento/Widget/MsgPopup.dart';
import 'package:madecontrol_desenvolvimento/Widget/TextField.dart';
import 'package:madecontrol_desenvolvimento/models/Models_Pallet.dart';
import 'package:madecontrol_desenvolvimento/models/Models_Usuario.dart';
import 'package:madecontrol_desenvolvimento/models/constantes.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class CadastroDePallets extends StatefulWidget {
  @override
  _CadastroDePalletsState createState() => _CadastroDePalletsState();
}

class _CadastroDePalletsState extends State<CadastroDePallets> {
  TextEditingController controllerModelo = TextEditingController();
  TextEditingController controllerDescricao = TextEditingController();
  TextEditingController controllerLargura = TextEditingController();
  TextEditingController controllerComprimento = TextEditingController();
  var dadosPallet = <ModelsPallet>[];
  RxBool? loading = true.obs;
  Future<dynamic> listarDados() async {
    final response = await http.get(
      Uri.parse(ListarTodosOsPallet + ModelsUsuarios.caminhoBaseUser.toString()),
      headers: {"authorization": ModelsUsuarios.tokenAuth.toString()},
    );
    if (response.statusCode == 401) {
      Navigator.pushNamed(context, '/login');
    }
    //IF(MOUNTED) É nescessario para não recarregar a arvore apos retornar das outras listas
    if (mounted)
      setState(() {
        Iterable lista = json.decode(response.body);
        dadosPallet =
            lista.map((model) => ModelsPallet.fromJson(model)).toList();
      });
    loading!.value = false;
  }

  Future<dynamic> delete(int? id) async {
    var response = await http.delete(
        Uri.parse(DeletarPallet + id.toString() + '/' + ModelsUsuarios.caminhoBaseUser.toString()),
        headers: {"authorization": ModelsUsuarios.tokenAuth.toString()});
    print(response.statusCode);
    if (response.statusCode == 401) {
      Navigator.pushNamed(context, '/login');
    } else if (response.statusCode == 400) {
      msgErro(
          'Este pallet não pode ser excluído pois tem dependências com outros registros!',
          titulo: 'Atenção');
    }
  }

  var mascaraLargura = new MaskTextInputFormatter(
      mask: '#.#####', filter: {"#": RegExp(r'[0-9]')});
  var mascaraComprimento = new MaskTextInputFormatter(
      mask: '*.*****', filter: {"*": RegExp(r'[0-9]')});

  confExcluir(id) {
    MsgPopup().msgComDoisBotoes(
      context,
      'Deseja excluir o pallet selecionado?',
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
        'nome': controllerModelo.text.toUpperCase(),
        'descricao': controllerDescricao.text,
        'codigo_pallet': gerarCodPallet().toString(),
        'idusuario': ModelsUsuarios.idDoUsuario,
        'largura': double.tryParse(controllerLargura.text),
        'comprimento': double.tryParse(controllerComprimento.text)
      },
    );
    var state = await http.post(
      Uri.parse(CadastrarPallet + ModelsUsuarios.caminhoBaseUser.toString()),
      headers: {
        "Content-Type": "application/json",
        "authorization": ModelsUsuarios.tokenAuth.toString()
      },
      body: bodyy,
    );
    print(state.statusCode);
    if (state.statusCode == 200) {
      return;
    } else if (state.statusCode == 401) {
      Navigator.pushNamed(context, '/login');
    }
  }

  msgValidaCampos(mensagem) {
    MsgPopup().msgFeedback(context, '\n' + mensagem, 'Erro');
  }

  msgErro(mensagem, {titulo}) {
    MsgPopup().msgFeedback(
      context,
      '\n' + mensagem,
      titulo,
    );
  }

//valida os campos
  validarCampos() {
    if (controllerModelo.text.isEmpty) {
      msgValidaCampos('O campo Modelo não foi preenchido');
    } else if (controllerLargura.text.isEmpty) {
      msgValidaCampos('O campo largura não foi preenchido');
    } else if (controllerComprimento.text.isEmpty) {
      msgValidaCampos('O campo comprimento não foi preenchido');
    } else {
      salvarBanco();
      controllerComprimento.text = '';
      controllerLargura.text = '';
      controllerModelo.text = '';
      controllerDescricao.text = '';
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
            color: Colors.green[200],
            child: Column(
              children: [
                Cabecalho().tituloCabecalho(context, 'Cadastro de Pallets',
                    iconeVoltar: true, marginBottom: 0.01),
                // =================== CADASTRO DO PALLET =====================
                Padding(
                  padding: EdgeInsets.only(
                    left: size.width * 0.02,
                    right: size.width * 0.02,
                  ),
                  child: Container(
                    width: size.width,
                    height: size.height * 0.32,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5)),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: size.height * 0.005),
                            child: CampoText().textField(
                              controllerModelo,
                              'Modelo:',
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: size.height * 0.005),
                            child: CampoText().textField(
                              controllerLargura,
                              'Largura:',
                              tipoTexto: TextInputType.number,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: size.height * 0.005),
                            child: CampoText().textField(
                              controllerComprimento,
                              'Comprimento:',
                              tipoTexto: TextInputType.number,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: size.height * 0.005),
                            child: CampoText().textField(
                              controllerDescricao,
                              'Descrição:',
                            ),
                          ),
                          SizedBox(height: size.height * 0.015),
                          Botao().botaoAnimacaoLoading(
                            context,
                            onTap: () {
                              validarCampos();
                            },
                          ),
                          SizedBox(height: size.height * 0.015),
                          // Padding(
                          //   padding: EdgeInsets.only(top: size.height * 0.015),
                          //   child: Botao().botaoPadrao(
                          //     'Salvar',
                          //     () => validarCampos(),
                          //     comprimento: 230,
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: size.width * 0.02,
                      right: size.width * 0.02,
                      top: size.height * 0.01),
                  child: Container(
                    padding: EdgeInsets.only(bottom: 5, top: 5),
                    width: size.width,
                    height: size.height * 0.54,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5)),
                    child: FutureBuilder(
                      future: listarDados(),
                      builder: (BuildContext context, snapshot) {
                        return Obx(
                          () => loading!.value == true
                              ? Center(
                                  child: CircularProgressIndicator(),
                                )
                              : ListView.builder(
                                  itemCount: dadosPallet.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 4,
                                        top: 4,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 4, right: 4),
                                        child: SingleChildScrollView(
                                          child: Container(
                                            // alignment: Alignment.center,
                                            height: size.height * 0.13,
                                            decoration: BoxDecoration(
                                              color: Color(0XFFD1D6DC),
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: ListTile(
                                              subtitle: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  FieldsDatabase()
                                                      .listaDadosBanco(
                                                          'Modelo: ',
                                                          dadosPallet[index]
                                                              .nome),
                                                  SizedBox(height: 3),
                                                  if (dadosPallet[index]
                                                      .descricao!
                                                      .isNotEmpty)
                                                    FieldsDatabase()
                                                        .listaDadosBanco(
                                                            'Descrição: ',
                                                            dadosPallet[index]
                                                                .descricao),
                                                  if (dadosPallet[index]
                                                      .descricao!
                                                      .isNotEmpty)
                                                    SizedBox(height: 3),
                                                  FieldsDatabase()
                                                      .listaDadosBanco(
                                                          'Largura: ',
                                                          dadosPallet[index]
                                                              .largura
                                                              .toString()),
                                                  SizedBox(height: 3),
                                                  FieldsDatabase()
                                                      .listaDadosBanco(
                                                          'Comprimento: ',
                                                          dadosPallet[index]
                                                              .comprimento
                                                              .toString()),
                                                  SizedBox(height: 3),
                                                ],
                                              ),
                                              trailing: IconButton(
                                                icon: Icon(
                                                  Icons.delete_forever,
                                                  color: Colors.red,
                                                  size: 32,
                                                ),
                                                padding: EdgeInsets.only(
                                                  left: 25,
                                                  top: 0,
                                                ),
                                                onPressed: () => {
                                                  confExcluir(
                                                    dadosPallet[index].idPallet,
                                                  ),
                                                },
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
