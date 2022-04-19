import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:madecontrol_desenvolvimento/Widget/Botao.dart';
import 'package:madecontrol_desenvolvimento/Widget/ListFieldsDataBase.dart';
import 'package:madecontrol_desenvolvimento/Widget/MsgPopup.dart';
import 'package:madecontrol_desenvolvimento/Widget/TextField.dart';
import 'package:madecontrol_desenvolvimento/models/Models_TipoDespesa.dart';
import 'package:madecontrol_desenvolvimento/models/Models_Usuario.dart';
import 'package:madecontrol_desenvolvimento/models/constantes.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class CadastroTipoDespesa extends StatefulWidget {
  @override
  _CadastroTipoDespesaState createState() => _CadastroTipoDespesaState();
}

class _CadastroTipoDespesaState extends State<CadastroTipoDespesa> {
  TextEditingController controllerNomeDespesa = TextEditingController();
  TextEditingController controllerDescricao = TextEditingController();
  var dadosTipoDespesa = <ModelsTipoDespesa>[];
  Future<dynamic> listarDados() async {
    final response = await http.get(
      Uri.parse(
          ListarTodosTipoDespesa + ModelsUsuarios.caminhoBaseUser.toString()),
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
          dadosTipoDespesa =
              lista.map((model) => ModelsTipoDespesa.fromJson(model)).toList();
        },
      );
  }

  Future<dynamic> delete(int? id) async {
    var response = await http.delete(
      Uri.parse(ExcluirTipoDespesa +
          id.toString() +
          '/' +
          ModelsUsuarios.caminhoBaseUser.toString()),
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
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: size.height,
          width: size.width,
          color: Colors.green[200],
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: size.height * 0.01),
                child: Container(
                  width: size.width,
                  height: size.height * 0.10,
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: IconButton(
                          icon: Icon(Icons.arrow_back),
                          onPressed: () => Navigator.pop(context),
                          iconSize: 35,
                          color: Colors.white,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: size.width * 0.02),
                        child: Text(
                          'Cadastrar tipo de despesas',
                          style: TextStyle(
                            fontSize: size.width * 0.06,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // =================== CADASTRO DO PALLET =====================
              Padding(
                padding: EdgeInsets.only(
                  left: size.width * 0.02,
                  right: size.width * 0.02,
                ),
                child: Container(
                  width: size.width,
                  height: size.height * 0.30,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15)),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: size.height * 0.01),
                          child: CampoText().textField(
                            controllerNomeDespesa,
                            'Nome da despesa:',
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: size.height * 0.01),
                          child: CampoText().textField(
                            controllerDescricao,
                            'Descrição:',
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: size.height * 0.02),
                          child: Botao().botaoAnimacaoLoading(
                            context,
                            onTap: () {
                              validarCampos();
                            },
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
                  height: size.height * 0.54,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: FutureBuilder(
                    future: listarDados(),
                    builder: (BuildContext context, snapshot) {
                      return ListView.builder(
                        itemCount: dadosTipoDespesa.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(
                              bottom: 4,
                              top: 4,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 4,
                                right: 4,
                              ),
                              child: Container(
                                alignment: Alignment.center,
                                height: size.height * 0.12,
                                width: size.width,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    15,
                                  ),
                                  color: Color(0XFFD1D6DC),
                                ),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 5, right: 10),
                                  child: SingleChildScrollView(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Color(0XFFD1D6DC),
                                        borderRadius: BorderRadius.circular(
                                          15,
                                        ),
                                      ),
                                      child: ListTile(
                                        title: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            FieldsDatabase().listaDadosBanco(
                                              'Nome da despesa: ',
                                              dadosTipoDespesa[index].nome,
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            FieldsDatabase().listaDadosBanco(
                                                'Descrição: ',
                                                dadosTipoDespesa[index]
                                                    .descricao),
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
                                              dadosTipoDespesa[index]
                                                  .idtipoDespesa,
                                            ),
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
