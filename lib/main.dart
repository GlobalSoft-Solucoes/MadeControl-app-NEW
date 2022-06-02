// ignore_for_file: null_check_always_fails

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:madecontrol_desenvolvimento/screens/Login/AcompanharPedido.Dart';
import 'package:madecontrol_desenvolvimento/screens/Menu/BarraLateral/Historico/TelaHistoricoPedidos.dart';
import 'package:madecontrol_desenvolvimento/screens/Menu/BarraLateral/ProcessoMadeira/ContadorSerraFita/SerraFita.dart';
import 'package:madecontrol_desenvolvimento/screens/Menu/BarraLateral/ProcessoMadeira/TelaMadProcessada.dart';
import 'package:madecontrol_desenvolvimento/screens/Menu/BarraLateral/Usuario/CadastrarUsuario.dart';
import 'package:madecontrol_desenvolvimento/screens/Menu/BarraLateral/VendaAvulso/CadVendaAvulso.dart';
import 'package:madecontrol_desenvolvimento/screens/Menu/BarraLateral/CadastroMadeira.dart';
import 'package:madecontrol_desenvolvimento/screens/Menu/BarraLateral/Cliente/EditarCliente.dart';
import 'package:madecontrol_desenvolvimento/screens/Menu/BarraLateral/Despesas/CadastroDespesa.dart';
import 'package:madecontrol_desenvolvimento/screens/Menu/BarraLateral/Estatistica/Clientes/EstatisticaClientes.dart';
import 'package:madecontrol_desenvolvimento/screens/Menu/BarraLateral/Estatistica/TelaEstatisticas.dart';
import 'package:madecontrol_desenvolvimento/screens/Menu/BarraLateral/ProcessoMadeira/DetalhesMadProcessada.dart';
import 'package:madecontrol_desenvolvimento/screens/Menu/BarraLateral/Recebimentos/CadastroRecebimento.dart';
import 'package:madecontrol_desenvolvimento/screens/Menu/BarraLateral/Despesas/DetalhesDespesa.dart';
import 'package:madecontrol_desenvolvimento/screens/Menu/BarraLateral/Despesas/ListaDespesas.dart';
import 'package:madecontrol_desenvolvimento/screens/Menu/BarraLateral/Despesas/TelaDespesas.dart';
import 'package:madecontrol_desenvolvimento/screens/Menu/BarraLateral/Despesas/EditarDespesa.dart';
import 'package:madecontrol_desenvolvimento/screens/Menu/BarraLateral/Financeiro/HomeFinanceiro.dart';
import 'package:madecontrol_desenvolvimento/screens/Menu/BarraLateral/ProcessoMadeira/ListaProcessoSerraFita.dart';
import 'package:madecontrol_desenvolvimento/screens/Menu/BarraLateral/Recebimentos/DetalhesRecebimento.dart';
import 'package:madecontrol_desenvolvimento/screens/Menu/BarraLateral/Recebimentos/EditarRecebimento.dart';
import 'package:madecontrol_desenvolvimento/screens/Menu/BarraLateral/Recebimentos/ListaRecebimento.dart';
import 'package:madecontrol_desenvolvimento/screens/Menu/BarraLateral/usuario/ConfigAcessoTelas.dart';
import 'package:madecontrol_desenvolvimento/screens/Menu/BarraLateral/usuario/EditarUsuario.Dart';
import 'package:madecontrol_desenvolvimento/screens/Menu/BarraLateral/usuario/LogsDatas.dart';
import 'package:madecontrol_desenvolvimento/screens/Menu/BarraLateral/usuario/LogUsuarioPorData.dart';
import 'package:madecontrol_desenvolvimento/screens/Menu/BarraLateral/usuario/PerfilUser.dart';
import 'package:madecontrol_desenvolvimento/screens/Pedido/CadGrupoPedidos.dart';
import 'package:madecontrol_desenvolvimento/screens/Pedido/DetalhesGrupoPedido.dart';
import 'package:madecontrol_desenvolvimento/screens/Pedido/EditarPedido.dart';
import 'package:madecontrol_desenvolvimento/screens/RomaneioEntrega/EditarRomaneio.dart';
import 'package:madecontrol_desenvolvimento/screens/RomaneioEntrega/Romaneio.dart';
import 'package:madecontrol_desenvolvimento/screens/Menu/BarraLateral/Cliente/CadastroClientes.dart';
import 'package:madecontrol_desenvolvimento/screens/Menu/BarraLateral/CadastroDePallets.dart';
import 'package:madecontrol_desenvolvimento/screens/Menu/BarraLateral/Cliente/ListarClientes.dart';
import 'package:madecontrol_desenvolvimento/screens/Menu/BarraLateral/Lixeira.dart';
import 'package:madecontrol_desenvolvimento/screens/pedido/CadastroPedido/CadastrarPedido.dart';
import 'package:madecontrol_desenvolvimento/screens/pedido/GrupoPedidosCadastrados.dart';
import 'package:madecontrol_desenvolvimento/screens/pedido/PedidosProntosDoCliente.dart';
import 'package:madecontrol_desenvolvimento/screens/pedido/PedidosCadastradosDoCliente.dart';
import 'package:madecontrol_desenvolvimento/screens/pedido/GrupoPedidosProntos.dart';
import 'package:madecontrol_desenvolvimento/screens/RomaneioEntrega/ListaPedidosEntregues.dart';
import 'package:madecontrol_desenvolvimento/screens/splashScreen/Splash.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:responsive_framework/utils/scroll_behavior.dart';
import 'package:madecontrol_desenvolvimento/screens/Menu/HomeAplication.Dart';
import 'package:madecontrol_desenvolvimento/screens/Login/LoginApp.Dart';
import 'screens/Menu/BarraLateral/Configuracao/ConfigModulos.dart';
import 'screens/Menu/BarraLateral/Financeiro/Entradas_E_Saidas/RelatorioRecebimentos.dart';
import 'screens/Menu/BarraLateral/ProcessoMadeira/DetalhesPesquisaToras.dart';
import 'screens/Menu/BarraLateral/ProcessoProduto/CadProcessoProduto.dart';
import 'screens/Menu/BarraLateral/ProcessoProduto/SelectProcessoProduto.dart';
import 'screens/Menu/BarraLateral/ProcessoProduto/TelaProcProduto.dart';
import 'screens/Menu/CadastrarEntradaLote/CadastrarLote.dart';
import 'screens/Menu/CadastrarEntradaLote/Historico/HistoricoMedidas.dart';
import 'package:madecontrol_desenvolvimento/screens/Menu/BarraLateral/usuario/ListarUsuarios.dart';
import 'package:madecontrol_desenvolvimento/screens/Menu/BarraLateral/CadastroCargo.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:madecontrol_desenvolvimento/screens/Menu/BarraLateral/Financeiro/Entradas_E_Saidas/RelatorioDespesas.dart';
import 'package:madecontrol_desenvolvimento/screens/Menu/BarraLateral/Financeiro/Entradas_E_Saidas/RelatorioFaturamento.dart';
import 'package:madecontrol_desenvolvimento/screens/Menu/BarraLateral/CadastroDeProdutos.dart';
import 'screens/Menu/BarraLateral/Despesas/ListaTipoDespesas.dart';
import 'screens/Menu/BarraLateral/Estatistica/Faturamento/EstatisticaFaturamento.dart';
import 'screens/Menu/BarraLateral/Estatistica/Produto/EstatisticaProduto.dart';
import 'screens/Menu/BarraLateral/Estatistica/SaldoDevedor/GeralSaldoDevedor.dart';
import 'screens/Menu/BarraLateral/Usuario/TelaUsuarios.dart';
import 'screens/Menu/BarraLateral/VendaAvulso/EditarVendaAvulso.dart';
import 'screens/Menu/BarraLateral/VendaAvulso/ListarVendaAvulso.dart';
import 'screens/Menu/BarraLateral/historico/HistoricoCliente/HistoricoGrupoPedidosCliente.dart';
import 'screens/Menu/BarraLateral/historico/HistoricoCliente/HistoricoPedidosCliente.dart';
import 'screens/Menu/BarraLateral/historico/HistoricoCliente/ListaClientesHistorico.dart';
import 'screens/Pedido/GrupoPedidosProducao.dart';

// import 'screens/Menu/CadastrarEntradaLote/CadastrarLote.dart';
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String? host, int? port) => true;
  }
}

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(
    GetMaterialApp(
      locale: const Locale('pt', 'BR'),
      localizationsDelegates: const [
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: const [Locale('pt', 'BR')],
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      builder: (context, widget) => ResponsiveWrapper.builder(
        BouncingScrollWrapper.builder(context, widget!),
        maxWidth: 1200,
        minWidth: 450,
        defaultScale: true,
        breakpoints: [
          const ResponsiveBreakpoint.resize(450, name: MOBILE),
          const ResponsiveBreakpoint.autoScale(800, name: TABLET),
          const ResponsiveBreakpoint.autoScale(1000, name: TABLET),
          const ResponsiveBreakpoint.resize(1200, name: DESKTOP),
          const ResponsiveBreakpoint.autoScale(2460, name: "4K"),
        ],
      ),
      routes: {
        '/login': (context) => Login(),
        '/Home': (context) => Home(),
        '/CadastroUsuario': (context) => CadastroUsuario(),
        '/Historico': (context) => Historico(),
        '/ConfigModulos': (context) => ConfigModulosEmpresa(),
        '/CadastrarPedido': (context) => CadastrarPedido(),
        '/SerraFita': (context) => SerraFita(),
        '/GrupoPedidosCadastrados': (context) => GrupoPedidosCadastrados(),
        '/GrupoPedidosProntos': (context) => GrupoPedidosProntos(),
        '/PedidosProntosCliente': (context) =>
            PedidosProntosCliente(idGrupoPedido: null!),
        '/PedidosCadastradosCliente': (context) =>
            PedidosCadastradosCliente(idGrupoPedido: null!),
        '/ListaUsuarios': (context) => ListaUsuarios(),
        '/CadastrarCargo': (context) => CadastroCargo(),
        '/romaneio': (context) => Romaneio(),
        '/ListarRomaneiosEntregues': (context) => RomaneiosEntregues(),
        '/CadastrarLote': (context) => CadastrarLote(),
        '/Lixeira': (context) => Lixeira(),
        '/CadastrarCliente': (context) => CadastroDeClientes(),
        '/EditarCliente': (context) => EditarDadosCliente(),
        '/CadastrarPallet': (context) => CadastroDePallets(),
        '/ListaClientes': (context) => ListadeClientes(),
        '/ConfigAcessoTelas': (context) => ConfigAcessoTelas(idUsuario: null!),
        '/EditarDadosUsuario': (context) => EditarDadosUsuario(),
        '/PerfilUsuario': (context) => PerfilUsuario(),
        '/EditarRomaneio': (context) => EditarDadosRomaneio(),
        '/LogUsuarioPorData': (context) => ListaLogsUsuarioData(data: null!),
        '/LogsDatas': (context) => ListaLogUsuario(),
        '/EditarDadosPedido': (context) => EditarDadosPedido(),
        '/ListaHistoricoSerraFita': (context) => ListaProcessoSerraFita(),
        '/DetalhesGrupoPedido': (context) => ListarDadosGrupoPedido(),
        '/HomeFinanceiro': (context) => HomeFinances(),
        '/RelatorioFaturamento': (context) => RelatorioFaturamento(),
        '/RelatorioDespesas': (context) => RelatorioDespesas(),
        '/RelatorioRecebimento': (context) => RelatorioRecebimento(),
        '/TelaDespesas': (context) => TelaDespesas(),
        '/ListarTipoDespesa': (context) => ListarTipoDespesa(),
        '/CadastroDespesa': (context) => CadastroDespesa(),
        '/ListarDespesas': (context) => ListarDespesas(
              idSubTipoDespesa: null,
            ),
        '/DetalhesDespesas': (context) => ListarDadosDespesa(iddespesa: null),
        '/EditarDespesa': (context) => EditarDadosDespesa(),
        '/CadastroRecebimento': (context) => CadastroRecebimento(),
        '/ListaRecebimentos': (context) => ListarRecebimentos(),
        '/EditarRecebimento': (context) => EditarDadosRecebimento(),
        '/DetalhesMadProcessada': (context) =>
            DetalhesMadProcessada(idProcesso: null),
        '/CadastroDeProdutos': (context) => CadastroDeProdutos(),
        '/CadastroDeMadeira': (context) => CadastroDeMadeira(),
        '/DetalhesRecebimento': (context) =>
            DetalhesRecebimento(idRecebimento: null),
        '/TelaEstatisticas': (context) => TelaEstatisticas(),
        '/EstatisticaClientes': (context) => EstatisticaClientes(),
        '/EstatisticaFaturamento': (context) => EstatisticaFaturamento(),
        '/EstatisticaProduto': (context) => EstatisticaProduto(),
        '/CadastrarGrupodePedidos': (context) => CadGrupoPedido(),
        '/TelaUsuarios': (context) => TelaUsuarios(),
        '/CadVendaAvulso': (context) => CadVendaAvulso(),
        '/ListaVendaAvulso': (context) => ListaVendasAvulso(),
        '/EditarVendaAvulso': (context) => EditarDadosVendaAvulso(),
        '/ListaClientesHistorico': (context) => ListaClientesHistorico(),
        '/HistoricoPedidosCliente': (context) =>
            HistoricoPedidosCliente(idGrupoPedido: null!),
        '/HistoricoGrupoPedidosCliente': (context) =>
            HistoricoGrupoPedidosCliente(idCliente: null!),
        '/GeralSaldoDevedor': (context) => GeralSaldoDevedor(),
        '/GrupoPedidosProducao': (context) => GrupoPedidosProducao(),
        '/TelaHistoricoPedidos': (context) => TelaHistoricoPedidos(),
        '/TelaMadProcessada': (context) => TelaMadProcessada(),
        '/TelaProcessoProduto': (context) => TelaProcProduto(),
        '/SelectProcessoProduto': (context) => SelectProcessoProduto(),
        '/CadProcessoProduto': (context) => CadProcessoProduto(),
      },
      home: Splash(),
    ),
  );
}
