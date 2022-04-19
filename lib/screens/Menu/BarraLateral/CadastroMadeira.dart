import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:madecontrol_desenvolvimento/Widget/Botao.dart';
import 'package:madecontrol_desenvolvimento/Widget/Cabecalho.dart';
import 'package:madecontrol_desenvolvimento/Widget/ListFieldsDataBase.dart';
import 'package:madecontrol_desenvolvimento/Widget/MsgPopup.dart';
import 'package:madecontrol_desenvolvimento/Widget/TextField.dart';
import 'package:madecontrol_desenvolvimento/models/Models_Madeira.dart';
import 'package:madecontrol_desenvolvimento/models/Models_Usuario.dart';
import 'package:madecontrol_desenvolvimento/models/constantes.dart';

class CadastroDeMadeira extends StatefulWidget {
  @override
  _CadastroDeMadeiraState createState() => _CadastroDeMadeiraState();
}

class _CadastroDeMadeiraState extends State<CadastroDeMadeira> {
  TextEditingController controllerNome = TextEditingController();
  TextEditingController controllerDescricao = TextEditingController();
  RxBool? loading = false.obs;
  bool? madeiraLicenca = false;
  bool? madeiraNormal = false;
  bool? madeiraLei;

  var dadosListagem = <ModelsMadeira>[];
  Future<dynamic> listarDados() async {
    final response = await http.get(
      Uri.parse(ListarTodasMadeiras + ModelsUsuarios.caminhoBaseUser.toString()),
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
            lista.map((model) => ModelsMadeira.fromJson(model)).toList();
      });
    loading!.value = false;
  }

  Future<dynamic> delete(int? id) async {
    var response = await http.delete(
      Uri.parse(ExcluirMadeira + id.toString() + '/' + ModelsUsuarios.caminhoBaseUser.toString()),
      headers: {"authorization": ModelsUsuarios.tokenAuth.toString()},
    );
    print(response.statusCode);
    if (response.statusCode == 401) {
      Navigator.pushNamed(context, '/login');
    }
  }

  confExcluir(id) {
    MsgPopup().msgComDoisBotoes(
      context,
      'Deseja excluir a madeira selecionado?',
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
        'nome': controllerNome.text.toUpperCase(),
        'madeira_lei': madeiraLei,
      },
    );
    var state = await http.post(
      Uri.parse(CadastrarMadeira + ModelsUsuarios.caminhoBaseUser.toString()),
      headers: {
        "Content-Type": "application/json",
        "authorization": ModelsUsuarios.tokenAuth.toString()
      },
      body: bodyy,
    );
    print(state.statusCode);
    print(bodyy);
    if (state.statusCode == 201) {
      controllerNome.text = '';
      controllerDescricao.text = '';
      madeiraLei = null;
      madeiraLicenca = false;
      madeiraNormal = false;
      return;
    } else if (state.statusCode == 401) {
      Navigator.pushNamed(context, '/login');
    }
    print('chegou');
  }

  msgValidaCampos(mensagem) {
    MsgPopup().msgFeedback(
      context,
      '\n' + mensagem,
      'Erro',
      fontMsg: 20,
      sizeTitulo: 20,
    );
  }

//valida os campos
  validarCampos() {
    if (controllerNome.text.isEmpty) {
      msgValidaCampos('O campo nome não foi preenchido');
    } else if (madeiraLei == '') {
      msgValidaCampos('Informe se a madeira é de lei ou não');
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
            color: Colors.green[200],
            child: Column(
              children: [
                Cabecalho().tituloCabecalho(context, 'Cadastro de madeira',
                    iconeVoltar: true, marginBottom: 0.02),
                // ====================== CADASTRO DO PRODUTO =======================
                Padding(
                  padding: EdgeInsets.only(
                    left: size.width * 0.02,
                    right: size.width * 0.02,
                  ),
                  child: Container(
                    width: size.width,
                    height: size.height * 0.28,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5)),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: size.height * 0.009),
                            child: CampoText().textField(
                                controllerNome, 'Nome da madeira:',
                                icone: Icons.nature_sharp),
                          ),
                          Container(
                            padding: EdgeInsets.only(
                                left: 10, right: 10, top: size.height * 0.01),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.black),
                              ),
                              child: Column(
                                children: [
                                  SizedBox(height: 3),
                                  Text(
                                    'Madeira de lei?',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(
                                        left: 40,
                                        right: 40,
                                        top: size.height * 0.0),
                                    alignment: Alignment.center,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: CheckboxListTile(
                                              title: Text(
                                                'Não',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18),
                                              ),
                                              key: Key('check1'),
                                              value: madeiraNormal,
                                              onChanged: (bool? valor) {
                                                setState(() {
                                                  madeiraLicenca = false;
                                                  madeiraNormal = true;
                                                  madeiraLei = false;
                                                });
                                              }),
                                        ),
                                        SizedBox(width: 30),
                                        Expanded(
                                          child: CheckboxListTile(
                                            title: Text(
                                              'Sim',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18),
                                            ),
                                            key: Key('check2'),
                                            value: madeiraLicenca,
                                            onChanged: (bool? valor) {
                                              setState(
                                                () {
                                                  madeiraLicenca = true;
                                                  madeiraNormal = false;
                                                  madeiraLei = true;
                                                },
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: size.height * 0.02),
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
                                                    FieldsDatabase()
                                                        .listaDadosBanco(
                                                            'Madeira de lei? ',
                                                            dadosListagem[index]
                                                                .madeiraLei
                                                                .toString()
                                                                .replaceAll(
                                                                    'false',
                                                                    'Não')
                                                                .replaceAll(
                                                                    'true',
                                                                    'Sim'),
                                                            sizeCampoBanco: 21,
                                                            sizeTextoCampo: 21),
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
                                                          .idMadeira,
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
