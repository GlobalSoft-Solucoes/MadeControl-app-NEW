import 'dart:convert';
import 'package:get/get.dart';
import 'package:madecontrol_desenvolvimento/Widget/Botao.dart';
import 'package:madecontrol_desenvolvimento/Widget/Cabecalho.dart';
import 'package:madecontrol_desenvolvimento/Widget/MsgPopup.dart';
import 'package:madecontrol_desenvolvimento/Widget/TextField.dart';
import 'package:madecontrol_desenvolvimento/models/Models_Cargo.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:madecontrol_desenvolvimento/models/Models_Usuario.dart';
import 'package:madecontrol_desenvolvimento/models/constantes.dart';
import '../../../Widget/MsgPopup.dart';
import '../../../models/Models_Cargo.dart';
import '../../../models/Models_Usuario.dart';
import '../../../models/constantes.dart';

class CadastroCargo extends StatefulWidget {
  @override
  _CadCargoState createState() => _CadCargoState();
}

class _CadCargoState extends State<CadastroCargo> {
  TextEditingController controllerNome = TextEditingController();
  TextEditingController controllerDescricao = TextEditingController();

  var cargo = <ModelsCargo>[];
  var mensagemErro = '';
  RxBool? loading = true.obs;
// ======== LISTA TODOS OS CARGOS CADASTRADOS =========
  Future listaDados() async {
    final response = await http.get(
        Uri.parse(
          ListarTodosCargos + ModelsUsuarios.caminhoBaseUser.toString(),
        ),
        headers: {
          "authorization": ModelsUsuarios.tokenAuth.toString(),
        });

    if (mounted) {
      setState(() {
        Iterable lista = json.decode(response.body);
        cargo = lista.map((model) => ModelsCargo.fromJson(model)).toList();
      });
    }
    loading!.value = false;
  }

// MENSAGEM DISPARADA QUANDO O CADASTRO É CONCLUÍDO
  // cadSucesso() {
  //   MsgPopup().msgFeedback(
  //     context,
  //     'cargo cadastrado com sucesso',
  //     '',
  //     txtButton: 'OK',
  //     corMsg: Colors.green[500],
  //     fontMsg: 20,
  //   );
  //   controllerDescricao.text = "";
  //   controllerNome.text = "";
  // }

// ======= CADASTRA O REGISTRO NO BANCO DE DADOS ========
  Future<dynamic> salvarDadosBanco() async {
    var nomeCargo = controllerNome.text;
    var descricao = controllerDescricao.text;
    var bodyy = jsonEncode({
      'nome': nomeCargo,
      'descricao': descricao,
    });

    print(bodyy);
    http.Response state = await http.post(
      Uri.parse(CadastrarCargo + ModelsUsuarios.caminhoBaseUser.toString()),
      headers: {
        "Content-Type": "application/json",
        "authorization": ModelsUsuarios.tokenAuth.toString()
      },
      body: bodyy,
    );
    if (state.statusCode == 201) {
      // cadSucesso();
    } else if (state.statusCode == 400) popupConfirmacaoErro();
  }

// MENSAGEM DISPARADA CASO ACONTECER UM ERRO AO CADASTRAR
  popupConfirmacaoErro() {
    MsgPopup().msgFeedback(context, 'Ocorreu um erro ao cadastrar', '',
        txtButton: 'OK!');
  }

// MENSAGEM DE ERRO AO TENTAR CADASTRAR DE FORMA ERRADA
  verificarDados() {
    if (controllerNome.text.isNotEmpty) {
      if (controllerNome.text.length > 2) {
        salvarDadosBanco();
        mensagemErro = '';
      } else {
        setState(() {
          mensagemErro = 'Nome do cargo é muito curto!';
          _mensagemErroCadastro();
        });
      }
    } else
      setState(() {
        mensagemErro = 'O nome do cargo não pode ficar vazio!';
        _mensagemErroCadastro();
      });
  }

// MENSAGEM DE ERRO AO TENTAR CADASTRAR DE FORMA ERRADA
  _mensagemErroCadastro() {
    MsgPopup().msgFeedback(
      context,
      '\n' + mensagemErro,
      'Erro',
    );
  }

  erroDeletarCargo() {
    MsgPopup().msgFeedback(
      context,
      '\n' + mensagemErro,
      'Aviso',
    );
  }

// ======== FUNÇÃO QUE DELETA O PIVOTANTE DO BANCO DE DADOS ==========
  Future<dynamic> deletar(int? id) async {
    http.Response state = await http.delete(
      Uri.parse(DeletarCargo + id.toString() + '/' + ModelsUsuarios.caminhoBaseUser.toString()),
      headers: {"authorization": ModelsUsuarios.tokenAuth.toString()},
    );

    if (state.statusCode == 400) {
      mensagemErro =
          'O cargo selecionado está sendo usado e portanto não pode ser excluído.';
      erroDeletarCargo();
    }
  }

  // ======== chama um popup pedindo permissão para deletar o registro =========
  _deletarReg(int? index) {
    MsgPopup().msgComDoisBotoes(
      context,
      'Confirma a exclusão da cargo selecionado?',
      'Não',
      'Sim',
      () => {Navigator.of(context).pop()},
      () => {
        deletar(index),
        listaDados(),
        Navigator.of(context).pop(),
      },
      corBotaoEsq: Color(0XFFF4485C),
      sairAoPressionar: true,
    );
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
            color: Colors.green[300],
            child: Column(
              children: [
                //===========================================
                Cabecalho().tituloCabecalho(
                  context,
                  'Cadastro de cargo',
                  iconeVoltar: true,
                  sizeTextTitulo: 0.065,
                ),
                //============== WIDGET DO CADASTRO =================
                Container(
                  width: size.width,
                  height: size.height * 0.34,
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: size.width * 0.017,
                      left: size.width * 0.02,
                      right: size.width * 0.02,
                      bottom: size.height * 0.02,
                    ),
                    child: Container(
                      alignment: Alignment.topCenter,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      width: size.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                right: size.width * 0.02,
                                left: size.width * 0.02,
                                top: size.height * 0.015),
                            child: CampoText().textField(
                                controllerNome, 'Nome do cargo:',
                                altura: size.height * 0.10,
                                icone: Icons.home_repair_service_outlined,
                                raioBorda: 10),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                right: size.width * 0.02,
                                left: size.width * 0.02,
                                top: size.height * 0.005),
                            child: CampoText().textField(
                                controllerDescricao, 'Descrição:',
                                altura: size.height * 0.10,
                                icone: Icons.description_outlined,
                                raioBorda: 10),
                          ),
                            SizedBox(height: size.height * 0.02),
                          Botao().botaoAnimacaoLoading(
                            context,
                            onTap: () {
                              verificarDados();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                //============== WIDGET DA LISTAGEM =================
                Padding(
                  padding: EdgeInsets.only(
                      left: size.width * 0.02, right: size.width * 0.02),
                  child: Container(
                    width: size.width,
                    height: size.height * 0.52,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: FutureBuilder(
                      future: listaDados(),
                      builder: (BuildContext context, snapshot) {
                        return Obx(
                          () => loading!.value == true
                              ? Center(
                                  child: CircularProgressIndicator(),
                                )
                              : ListView.builder(
                                  itemCount: cargo.length,
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      // print(cargo.idCargo[index].nome);
                                      leading: Text(
                                        '${index + 1}',
                                        style: TextStyle(
                                          fontSize: 20,
                                        ),
                                      ),
                                      title: Text('${cargo[index].nome}'),
                                      subtitle:
                                          Text('${cargo[index].descricao}'),
                                      trailing: GestureDetector(
                                        onTap: () {
                                          _deletarReg(cargo[index].idCargo);
                                        },
                                        child: Icon(
                                          Icons.delete_forever,
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
                //----------------------------------------
              ],
            ),
          ),
        ),
      ),
    );
  }
}
