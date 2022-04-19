import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:madecontrol_desenvolvimento/Statics/Static_ConfigAcesso.dart';
import 'package:madecontrol_desenvolvimento/Statics/Static_Empresa.dart';
import 'package:madecontrol_desenvolvimento/Statics/Static_Modulo.dart';
import 'package:madecontrol_desenvolvimento/Widget/Botao.dart';
import 'package:madecontrol_desenvolvimento/Widget/Cabecalho.dart';
import 'package:madecontrol_desenvolvimento/Widget/MsgPopup.dart';
import 'package:madecontrol_desenvolvimento/models/Models_Usuario.dart';
import 'package:http/http.dart' as http;
import 'package:madecontrol_desenvolvimento/models/constantes.dart';
import 'package:madecontrol_desenvolvimento/Widget/CheckBox.dart';
import 'package:madecontrol_desenvolvimento/screens/splashScreen/Splash.dart';

class ConfigModulosEmpresa extends StatefulWidget {
  @override
  ConfigModulosEmpresaState createState() => ConfigModulosEmpresaState();
}

class ConfigModulosEmpresaState extends State<ConfigModulosEmpresa> {
  //
  var sim = "SIM";
  var nao = "NAO";

  bool? producaoPedidoSim =
      FieldsModulo.processoPedido == true ? true : false;
  bool? producaoPedidoNao =
      FieldsModulo.processoPedido == false ? true : false;
  bool? opcProducaoPedido =
      FieldsModulo.processoPedido == true ? true : false;

  bool? processoMadeiraSim =
      FieldsModulo.processoMadeira == true ? true : false;
  bool? processoMadeiraNao =
      FieldsModulo.processoMadeira == false ? true : false;
  bool? opcProcessoMadeira =
      FieldsModulo.processoMadeira == true ? true : false;

  salvarAlteracoesAcessoTela() async {
    var bodyy = jsonEncode(
      {
        'producao_pedido': opcProducaoPedido,
        'processo_madeira': opcProcessoMadeira,
      },
    );

    http.Response state = await http.put(
      Uri.parse(EditarModuloEmpresa +
          FieldsModulo.idEmpresa.toString() +
          '/' +
          ModelsUsuarios.caminhoBaseUser.toString()),
      headers: {
        "Content-Type": "application/json",
        "authorization": ModelsUsuarios.tokenAuth.toString()
      },
      body: bodyy,
    );
    print(bodyy);
    print(state.statusCode);

    // chama a funcao para atualizar o acesso das telas de acordo com o usuário logado
    FieldsAcessoTelas()
        .capturaConfigAcessoTelasUsuario(ModelsUsuarios.idDoUsuario);
  }

  _msgAlteracoesConcluidas() async {
    await MsgPopup().msgFeedback(
      context,
      'Alterações concluídas com sucesso!',
      '',
      fontMsg: 20,
      corMsg: Colors.green[500],
    );

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Splash()));
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
                  'Configurações de uso',
                  iconeVoltar: true,
                  sizeTextTitulo: 0.06,
                  marginBottom: 0,
                ),
                Padding(
                  padding: EdgeInsets.only(
                      right: size.width * 0.02,
                      left: size.width * 0.02,
                      top: size.height * 0.01),
                  child: Container(
                    height: size.height * 0.77,
                    width: size.width,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          //----------------------------------------------------
                          new Container(
                            alignment: Alignment.center,
                            padding: new EdgeInsets.only(
                              top: size.height * 0.01,
                              bottom: size.height * 0.02,
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Escolha os modulos extras para utilizar:',
                                    style: TextStyle(
                                      fontSize: size.width * 0.045,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          //-------------------------------------------------------
                          CheckBox().checkBoxDuasOpcoes(
                            context,
                            'Produção de pedidos:',
                            'Não',
                            'Sim',
                            producaoPedidoNao,
                            producaoPedidoSim,
                            () => {
                              setState(
                                () {
                                  producaoPedidoNao = true;
                                  producaoPedidoSim = false;
                                  opcProducaoPedido = false;
                                },
                              ),
                            },
                            () => {
                              setState(
                                () {
                                  producaoPedidoSim = true;
                                  producaoPedidoNao = false;
                                  opcProducaoPedido = true;
                                },
                              ),
                            },
                            marginLeft: 0.013,
                            marginTop: 0.025,
                            distanciaTituloDosChecks: 0.005,
                            backgroundColor: Colors.white.withOpacity(0.9),
                            distanciaEntreChecks: 0.1,
                          ),
                          SizedBox(height: size.height * 0.02),
                          //-------------------------------------------------------
                          CheckBox().checkBoxDuasOpcoes(
                            context,
                            'Processamento de madeira:',
                            'Não',
                            'Sim',
                            processoMadeiraNao,
                            processoMadeiraSim,
                            () => {
                              setState(
                                () {
                                  processoMadeiraNao = true;
                                  processoMadeiraSim = false;
                                  opcProcessoMadeira = false;
                                },
                              ),
                            },
                            () => {
                              setState(
                                () {
                                  processoMadeiraSim = true;
                                  processoMadeiraNao = false;
                                  opcProcessoMadeira = true;
                                },
                              ),
                            },
                            marginLeft: 0.013,
                            marginTop: 0.025,
                            distanciaTituloDosChecks: 0.005,
                            backgroundColor: Colors.white.withOpacity(0.9),
                            distanciaEntreChecks: 0.1,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.03),
                Botao().botaoAnimacaoLoading(
                  context,
                  altura: size.height * 0.068,
                  comprimento: size.width * 0.4,
                  tamanhoLetra: 29,
                  minComprimento: size.width * 0.15,
                  onTap: () async {
                    salvarAlteracoesAcessoTela();
                    _msgAlteracoesConcluidas();
                    await FieldsModulo().buscaModelsPorEmpresa(
                        BuscaDadosEmpresaPorUsuario.idEmpresa);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
