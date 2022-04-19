import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:madecontrol_desenvolvimento/Widget/Botao.dart';
import 'package:madecontrol_desenvolvimento/Widget/Cabecalho.dart';
import 'package:madecontrol_desenvolvimento/Widget/ListFieldsDataBase.dart';
import 'package:madecontrol_desenvolvimento/Widget/MsgPopup.dart';
import 'package:madecontrol_desenvolvimento/Widget/TextField.dart';
import 'package:madecontrol_desenvolvimento/models/Models_Produto.dart';
import 'package:madecontrol_desenvolvimento/models/Models_Usuario.dart';
import 'package:madecontrol_desenvolvimento/models/constantes.dart';

class CadastroDeProdutos extends StatefulWidget {
  @override
  _CadastroDeProdutosState createState() => _CadastroDeProdutosState();
}

class _CadastroDeProdutosState extends State<CadastroDeProdutos> {
  TextEditingController controllerNome = TextEditingController();
  TextEditingController controllerDescricao = TextEditingController();

  var dadosListagem = <ModelsProduto>[];
  RxBool? loading = false.obs;
  Future<dynamic> listarDados() async {
    final response = await http.get(
      Uri.parse(ListarTodosProdutos + ModelsUsuarios.caminhoBaseUser.toString()),
      headers: {"authorization": ModelsUsuarios.tokenAuth.toString()},
    );
    if (response.statusCode == 401) {
      Navigator.pushNamed(context, '/login');
    }
    //IF(MOUNTED) É nescessario para não recarregar a arvore apos retornar das outras listas
    if (mounted)
      setState(() {
        Iterable lista = json.decode(response.body);
        dadosListagem =
            lista.map((model) => ModelsProduto.fromJson(model)).toList();
      });
    loading!.value = false;
  }

  Future<dynamic> delete(int? id) async {
    var response = await http.delete(
      Uri.parse(ExcluirProduto + id.toString() + '/' + ModelsUsuarios.caminhoBaseUser.toString()),
      headers: {"authorization": ModelsUsuarios.tokenAuth.toString()},
    );
    print(response.statusCode);
    if (response.statusCode == 401) {
      Navigator.pushNamed(context, '/login');
    } else if (response.statusCode == 400) {
      msgErro(
          'Este produto não pode ser excluído pois tem dependências com outros registros!',
          titulo: 'Atenção');
    }
  }

  msgErro(mensagem, {titulo}) {
    MsgPopup().msgFeedback(
      context,
      '\n' + mensagem,
      titulo,
    );
  }

  confExcluir(id) {
    MsgPopup().msgComDoisBotoes(
      context,
      'Deseja excluir o produto selecionado?',
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

// Salva os dados no banco
  salvarBanco() async {
    var bodyy = jsonEncode(
      {
        'nome': controllerNome.text,
        'descricao': controllerDescricao.text,
      },
    );
    var state = await http.post(
      Uri.parse(CadastrarProduto + ModelsUsuarios.caminhoBaseUser.toString()),
      headers: {
        "Content-Type": "application/json",
        "authorization": ModelsUsuarios.tokenAuth.toString()
      },
      body: bodyy,
    );
    print(state.statusCode);
    print(bodyy);
    if (state.statusCode == 200) {
      return;
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
    if (controllerNome.text.isEmpty) {
      msgValidaCampos('O campo nome precisa ser preenchido!');
    } else {
      salvarBanco();
      controllerNome.text = '';
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
                Cabecalho().tituloCabecalho(context, 'Cadastro de produto',
                    iconeVoltar: true, marginBottom: 0.02),
                // ====================== CADASTRO DO PRODUTO =======================
                Padding(
                  padding: EdgeInsets.only(
                    left: size.width * 0.02,
                    right: size.width * 0.02,
                  ),
                  child: Container(
                    width: size.width,
                    height: size.height * 0.27,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5)),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: size.height * 0.009),
                            child: CampoText().textField(
                              controllerNome,
                              'Nome:',
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
                    padding: EdgeInsets.only(bottom: 5, top: 5),
                    width: size.width,
                    height: size.height * 0.56,
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
                                  itemCount: dadosListagem.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 4,
                                        top: 4,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 4, right: 4),
                                        child: Container(
                                          alignment: Alignment.center,
                                          height: size.height * 0.10,
                                          width: size.width,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              5,
                                            ),
                                            color: Color(0XFFD1D6DC),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 5, right: 5),
                                            child: SingleChildScrollView(
                                              child: ListTile(
                                                subtitle: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    FieldsDatabase()
                                                        .listaDadosBanco(
                                                            'Nome: ',
                                                            dadosListagem[index]
                                                                .nome,
                                                            sizeCampoBanco: 21,
                                                            sizeTextoCampo: 21),
                                                    SizedBox(height: 5),
                                                    dadosListagem[index]
                                                                .descricao !=
                                                            null
                                                        ? FieldsDatabase()
                                                            .listaDadosBanco(
                                                                'Descrição: ',
                                                                dadosListagem[
                                                                        index]
                                                                    .descricao,
                                                                sizeCampoBanco:
                                                                    21,
                                                                sizeTextoCampo:
                                                                    21)
                                                        : Container(),
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
                                                      dadosListagem[index]
                                                          .idProduto,
                                                    ),
                                                  },
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
