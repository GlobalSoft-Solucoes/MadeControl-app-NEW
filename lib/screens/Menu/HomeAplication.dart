import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:madecontrol_desenvolvimento/Statics/Static_ConfigAcesso.dart';
import 'package:madecontrol_desenvolvimento/Statics/Static_Despesa.dart';
import 'package:madecontrol_desenvolvimento/Statics/Static_Empresa.dart';
import 'package:madecontrol_desenvolvimento/Statics/Static_Financeiro.dart';
import 'package:madecontrol_desenvolvimento/Statics/Static_Usuario.dart';
import 'package:madecontrol_desenvolvimento/Widget/Botao.dart';
import 'package:madecontrol_desenvolvimento/Widget/FieldData.dart';
import 'package:madecontrol_desenvolvimento/Widget/MsgPopup.dart';
import 'package:madecontrol_desenvolvimento/models/Models_Usuario.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:madecontrol_desenvolvimento/Statics/Static_Modulo.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  mensagemErroAcesso() async {
    await MsgPopup().msgFeedback(
      context,
      '\n Você não tem permissão para acessar!',
      'Aviso',
      fontMsg: 20,
    );
    await FieldsAcessoTelas()
        .capturaConfigAcessoTelasUsuario(ModelsUsuarios.idDoUsuario);
  }

  @override
  void initState() {
    super.initState();
    FieldsAcessoTelas()
        .capturaConfigAcessoTelasUsuario(ModelsUsuarios.idDoUsuario);
  }

  acessoBotaoPedProd() {
    return FieldsModulo.processoPedido == true
        ? Botao().botaoPadrao(
            'Pedidos em produção',
            () {
              setState(
                () {
                  FieldsAcessoTelas.pedidosCadastrados == true
                      ? Navigator.pushNamed(context, '/GrupoPedidosProducao')
                      : mensagemErroAcesso();
                },
              );
            },
            corFonte: Colors.green,
            tamanhoLetra: 27,
          )
        : Container();
  }

  acessoBotaoProcessMad() {
    return FieldsModulo.processoMadeira == true
        ? Botao().botaoPadrao(
            'Processar madeira',
            () {
              setState(
                () {
                  FieldsAcessoTelas.processoMadeira == true
                      ? Navigator.pushNamed(context, '/SerraFita')
                      : mensagemErroAcesso();
                },
              );
            },
            corFonte: Colors.green,
          )
        : Container();
  }

  acessoBotaoProcessProduto() {
    return FieldsModulo.processoProduto == true
        ? Botao().botaoPadrao(
            'Processar Produto',
            () {
              setState(
                () {
                  FieldsAcessoTelas.processoMadeira == true
                      ? Navigator.pushNamed(context, '/SelectProcessoProduto')
                      : mensagemErroAcesso();
                },
              );
            },
            corFonte: Colors.green,
          )
        : Container();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    Size size = mediaQuery.size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${BuscaDadosEmpresaPorUsuario.nome!.toUpperCase()}',
          style: const TextStyle(fontSize: 22),
        ),
        centerTitle: true,
        backgroundColor: Colors.green[400]!.withOpacity(0.8),
      ),
      body: Container(
        width: size.width,
        height: size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/madeiras/fundo02.jpg"),
              fit: BoxFit.cover),
        ),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                width: size.width,
                height: size.height * 0.88,
                alignment: Alignment.topCenter,
                padding: EdgeInsets.only(
                    left: size.width * 0.09, right: size.width * 0.09),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    //-------------------------------------------------------
                    Botao().botaoPadrao(
                      'Lotes cadastrados',
                      () {
                        setState(
                          () {
                            FieldsAcessoTelas.cadLote == true
                                ? Navigator.pushNamed(context, '/Historico')
                                : mensagemErroAcesso();
                          },
                        );
                      },
                      corFonte: Colors.green,
                    ),
                    Botao().botaoPadrao(
                      'Pedidos cadastrados',
                      () {
                        setState(
                          () {
                            FieldsAcessoTelas.pedidosCadastrados == true
                                ? Navigator.pushNamed(
                                    context, '/GrupoPedidosCadastrados')
                                : mensagemErroAcesso();
                          },
                        );
                      },
                      corFonte: Colors.green,
                    ),
                    // acessoBotaoPedProd(),
                    FieldsModulo.processoPedido == true
                        ? Botao().botaoPadrao(
                            'Pedidos em produção',
                            () {
                              setState(
                                () {
                                  FieldsAcessoTelas.pedidosCadastrados == true
                                      ? Navigator.pushNamed(
                                          context, '/GrupoPedidosProducao')
                                      : mensagemErroAcesso();
                                },
                              );
                            },
                            corFonte: Colors.green,
                            tamanhoLetra: 27,
                          )
                        : Container(),

                    Botao().botaoPadrao(
                      'Pedidos prontos',
                      () {
                        setState(
                          () {
                            FieldsAcessoTelas.pedidosProntos == true
                                ? Navigator.pushNamed(
                                    context, '/GrupoPedidosProntos')
                                : mensagemErroAcesso();
                          },
                        );
                      },
                      corFonte: Colors.green,
                    ),
                    Botao().botaoPadrao(
                      'Romaneios feitos',
                      () {
                        FieldsAcessoTelas.historicoRomaneios == true
                            ? Navigator.pushNamed(
                                context, '/ListarRomaneiosEntregues')
                            : mensagemErroAcesso();
                      },
                      corFonte: Colors.green,
                    ),
                    acessoBotaoProcessMad(),
                    acessoBotaoProcessProduto(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              margin: const EdgeInsets.all(0),
              padding: const EdgeInsets.all(5),
              curve: Curves.fastOutSlowIn,
              child: UserAccountsDrawerHeader(
                onDetailsPressed: () {
                  const Text(
                    "Mteste",
                    style: TextStyle(fontSize: 40.0),
                  );
                },
                decoration: BoxDecoration(
                  color: Colors.grey[600]!.withOpacity(0.2),
                ),
                currentAccountPicture: new Container(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Text(
                      "${BuscaDadosUsuarioPorId.nome!.substring(0, 1).toUpperCase()}",
                      style: const TextStyle(
                        fontSize: 35,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                accountName: new Text(
                  "${BuscaDadosUsuarioPorId.nome}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.black26,
                  ),
                ),
                accountEmail: new Text(
                  "${BuscaDadosUsuarioPorId.email}",
                  style: const TextStyle(color: Colors.black38),
                ),
              ),
            ),
            // ======== TELA QUE MOSTRA INFORMAÇÕES DO PERFIL DO USUÁRIO ========
            ListTile(
                title: const Text(
                  'Perfil do usuário',
                  style: TextStyle(fontSize: 19),
                ),
                leading: const Icon(
                  Icons.perm_contact_calendar,
                  size: 30,
                ),
                contentPadding: const EdgeInsets.only(top: 20, left: 10),
                dense: true,
                onTap: () async {
                  await BuscaDadosUsuarioPorId()
                      .capturaDadosUsuariosPorId(ModelsUsuarios.idDoUsuario)
                      .then((value) =>
                          {Navigator.pushNamed(context, '/PerfilUsuario')});
                }),
            // ========= TELA DE CADASTRO PARA OS USUÁRIOS DO SISTEMA =========
            ListTile(
              title: const Text(
                'Usuários',
                style: TextStyle(fontSize: 19),
              ),
              leading: const Icon(
                Icons.supervisor_account,
                size: 30,
              ),
              contentPadding: const EdgeInsets.only(top: 20, left: 10),
              dense: true,
              onTap: () {
                FieldsAcessoTelas.cadUsuario == true
                    ? Navigator.pushNamed(context, '/TelaUsuarios')
                    : mensagemErroAcesso();
              },
            ),
            //Lista os processos da serra fita
            FieldsModulo.processoProduto == true
                ? ListTile(
                    title: const Text(
                      'Processo Produto',
                      style: TextStyle(fontSize: 18),
                    ),
                    leading: const Icon(
                      Icons.assignment,
                      size: 30,
                    ),
                    contentPadding: const EdgeInsets.only(top: 20, left: 10),
                    dense: true,
                    onTap: () {
                      setState(
                        () {
                          FieldsAcessoTelas.processoMadeira == true
                              ? Navigator.pushNamed(
                                  context, '/TelaProcessoProduto')
                              : mensagemErroAcesso();
                        },
                      );
                    },
                  )
                : Container(),
            ListTile(
              title: const Text(
                'Logs-SerraFita',
                style: TextStyle(fontSize: 18),
              ),
              leading: const Icon(
                Icons.assignment,
                size: 30,
              ),
              contentPadding: const EdgeInsets.only(top: 20, left: 10),
              dense: true,
              onTap: () {
                setState(
                  () {
                    FieldsAcessoTelas.processoMadeira == true
                        ? Navigator.pushNamed(context,
                            '/TelaMadProcessada') //ListaHistoricoSerraFita
                        : mensagemErroAcesso();
                  },
                );
              },
            ),
            // ======= TELA PARA AS CONFIGURAÇÕES ========
            ListTile(
              title: const Text(
                'Configurações',
                style: TextStyle(fontSize: 19),
              ),
              leading: const Icon(
                Icons.settings,
                size: 30,
              ),
              contentPadding: const EdgeInsets.only(top: 20, left: 10),
              dense: true,
              onTap: () async {
                FieldsAcessoTelas.listaClientes == true
                    ? await FieldsModulo().buscaModelsPorEmpresa(
                        BuscaDadosEmpresaPorUsuario.idEmpresa)
                    : mensagemErroAcesso();
                FieldsAcessoTelas.listaClientes == true
                    ? Navigator.pushNamed(context, '/ConfigModulos')
                    : mensagemErroAcesso();
              },
            ),
            ListTile(
              title: const Text(
                'Lista de Clientes',
                style: TextStyle(fontSize: 19),
              ),
              leading: const Icon(
                Icons.article_outlined,
                size: 30,
              ),
              contentPadding: const EdgeInsets.only(top: 20, left: 10),
              dense: true,
              onTap: () {
                setState(
                  () {
                    FieldsAcessoTelas.listaClientes == true
                        ? Navigator.pushNamed(context, '/ListaClientes')
                        : mensagemErroAcesso();
                  },
                );
              },
            ),
            // ======== TELA DA PARTE FINANCEIRA DA EMPRESA ========
            ListTile(
              title: const Text(
                'Financeiro',
                style: TextStyle(fontSize: 19),
              ),
              leading: const Icon(
                Icons.attach_money_outlined,
                size: 30,
              ),
              contentPadding: const EdgeInsets.only(top: 20, left: 10),
              dense: true,
              onTap: () async {
                await BuscaValoresFinanceiroPorData().capturaDadosFinanceiro(
                  FiltroDatasPesquisa.dataInicial,
                  FiltroDatasPesquisa.dataFinal,
                );
                await BuscaDespesasPorData().capturaDadosDespesasPorData(
                  FiltroDatasPesquisa.dataInicial,
                  FiltroDatasPesquisa.dataFinal,
                );
                FieldsAcessoTelas.financeiro == true
                    ? Navigator.pushNamed(
                        context,
                        '/HomeFinanceiro',
                      )
                    : mensagemErroAcesso();
              },
            ),
            // ======== TELA DA PARTE DE DESPESAS DA EMPRESA ========
            ListTile(
              title: const Text(
                'Despesas',
                style: TextStyle(fontSize: 19),
              ),
              leading: const Icon(
                Icons.trending_down,
                size: 30,
              ),
              contentPadding: const EdgeInsets.only(top: 10, left: 10),
              dense: true,
              onTap: () async {
                setState(
                  () {
                    FieldsAcessoTelas.listaDespesas == true
                        ? Navigator.pushNamed(
                            context,
                            '/ListarTipoDespesa', // '/TelaDespesas',
                          )
                        : mensagemErroAcesso();
                  },
                );
              },
            ),
            // =========== TELA DA PARTE DE RECEBIMENTOS DA EMPRESA ===========
            ListTile(
              title: const Text(
                'Recebimentos',
                style: TextStyle(fontSize: 19),
              ),
              leading: const Icon(
                Icons.trending_up,
                size: 30,
              ),
              contentPadding: const EdgeInsets.only(top: 10, left: 10),
              dense: true,
              onTap: () async {
                setState(
                  () {
                    FieldsAcessoTelas.listaRecebimentos == true
                        ? Navigator.pushNamed(
                            context,
                            '/ListaRecebimentos',
                          )
                        : mensagemErroAcesso();
                  },
                );
              },
            ),
            // ==================== ESTATISTICAS ==================
            ListTile(
              title: const Text(
                'Estatísticas',
                style: TextStyle(fontSize: 19),
              ),
              leading: const Icon(
                Icons.extension_sharp,
                size: 30,
              ),
              contentPadding: const EdgeInsets.only(top: 10, left: 10),
              dense: true,
              onTap: () {
                setState(
                  () {
                    FieldsAcessoTelas.estatisticas == true
                        ? Navigator.pushNamed(context, '/TelaEstatisticas')
                        : mensagemErroAcesso();
                  },
                );
              },
            ),
            // =================== CADASTRO DE PELLET ====================
            ListTile(
              title: const Text(
                'Cadastro de pallet',
                style: TextStyle(fontSize: 19),
              ),
              leading: const Icon(
                Icons.calendar_view_day,
                size: 30,
              ),
              contentPadding: const EdgeInsets.only(top: 20, left: 10),
              dense: true,
              onTap: () {
                setState(
                  () {
                    FieldsAcessoTelas.cadPallet == true
                        ? Navigator.pushNamed(context, '/CadastrarPallet')
                        : mensagemErroAcesso();
                  },
                );
              },
            ),
            // =========== TELA DA PARTE DE DESPESAS DA EMPRESA ===========
            ListTile(
              title: const Text(
                'Produtos',
                style: TextStyle(fontSize: 19),
              ),
              leading: const Icon(
                Icons.view_compact_sharp,
                size: 30,
              ),
              contentPadding: const EdgeInsets.only(top: 10, left: 10),
              dense: true,
              onTap: () async {
                setState(
                  () {
                    FieldsAcessoTelas.cadProduto == true
                        ? Navigator.pushNamed(
                            context,
                            '/CadastroDeProdutos',
                          )
                        : mensagemErroAcesso();
                  },
                );
              },
            ),
            // =========== TELA PARA CADASTRO DE MAEIRAS ===========
            ListTile(
              title: const Text(
                'Madeiras',
                style: TextStyle(fontSize: 19),
              ),
              leading: const Icon(
                Icons.eco_sharp,
                size: 30,
              ),
              contentPadding: const EdgeInsets.only(top: 10, left: 10),
              dense: true,
              onTap: () async {
                setState(
                  () {
                    FieldsAcessoTelas.cadMadeira == true
                        ? Navigator.pushNamed(
                            context,
                            '/CadastroDeMadeira',
                          )
                        : mensagemErroAcesso();
                  },
                );
              },
            ),
            // =======================================================
            ListTile(
              title: const Text(
                'Venda avulso',
                style: TextStyle(fontSize: 19),
              ),
              leading: const Icon(
                Icons.shopping_bag_outlined,
                size: 30,
              ),
              contentPadding: const EdgeInsets.only(top: 10, left: 10),
              dense: true,
              onTap: () async {
                setState(
                  () {
                    FieldsAcessoTelas.vendaAvulso == true
                        ? Navigator.pushNamed(
                            context,
                            '/ListaVendaAvulso',
                          )
                        : mensagemErroAcesso();
                  },
                );
              },
            ),
            // =======================================================
            ListTile(
              title: const Text(
                'Histórico',
                style: TextStyle(fontSize: 19),
              ),
              leading: const Icon(
                Icons.history,
                size: 30,
              ),
              contentPadding: const EdgeInsets.only(top: 10, left: 10),
              dense: true,
              onTap: () async {
                setState(
                  () {
                    FieldsAcessoTelas.historicoPedidos == true
                        ? Navigator.pushNamed(
                            context,
                            '/TelaHistoricoPedidos',
                          )
                        : mensagemErroAcesso();
                  },
                );
              },
            ),
            //======================= LIXEIRA =======================
            ListTile(
              title: const Text(
                'Lixeira',
                style: TextStyle(fontSize: 19),
              ),
              leading: const Icon(
                Icons.restore_from_trash,
                size: 30,
              ),
              contentPadding: const EdgeInsets.only(top: 10, left: 10),
              dense: true,
              onTap: () {
                setState(
                  () {
                    FieldsAcessoTelas.lixeiraGrupoPedidos == true
                        ? Navigator.pushNamed(context, '/Lixeira')
                        : mensagemErroAcesso();
                  },
                );
              },
            ),
            //======================= Deslogar usuário =======================
            ListTile(
              title: const Text(
                'Deslogar usuário',
                style: TextStyle(fontSize: 19),
              ),
              leading: const Icon(
                Icons.supervised_user_circle_sharp,
                size: 30,
              ),
              contentPadding: const EdgeInsets.only(top: 10, left: 10),
              dense: true,
              onTap: () async {
                SharedPreferences user = await SharedPreferences.getInstance();
                user.remove('Token');
                user.remove('idusuario');
                Navigator.pushNamed(context, '/login');
              },
            ),
            //======================= Sair =======================
            ListTile(
              title: const Text(
                'Sair',
                style: TextStyle(fontSize: 19),
              ),
              leading: const Icon(
                Icons.login_outlined,
                size: 30,
              ),
              contentPadding:
                  const EdgeInsets.only(top: 10, left: 10, bottom: 70),
              dense: true,
              onTap: () {
                setState(
                  () {
                    exit(0);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
