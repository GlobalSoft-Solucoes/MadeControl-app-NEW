//
//  =========== ARQUIVO QUE CAPTURA OS DADOS DO CLIENTE =============

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:madecontrol_desenvolvimento/models/Models_Financeiro.dart';
import '../models/constantes.dart';
import 'package:madecontrol_desenvolvimento/models/Models_Usuario.dart';
import 'package:intl/intl.dart';

class Financeiro {
  static String? valorTotalTodosPedidos;
  static String? valorTotalTodosDespesas;
}

// ============ DADOS DE TODOS OS USU?RIOS CADASTRADOS ===============
class BuscaValoresFinanceiroPorData {
  var dadosFinanceiro = <ModelsFinanceiro>[];

  static String? valorTotalTodosPedidos;
  static String? valorTotalTodosDespesas;
  static final saldoSemana = ValueNotifier<String>('');
  static final saldoMes = ValueNotifier<String>('');
  static final saldoAno = ValueNotifier<String>('');
  static final saldoHistorico = ValueNotifier<String>('');
  static final saldoEmCaixa = ValueNotifier<String>('');
  static String? totalPedidoDespesa;
  static double?subtrair;
  static double?pedidos;
  static double?despesas;

  // final formatCurrency = new NumberFormat.currency(symbol: 'R\$ ');

  final formatCurrency = new NumberFormat.simpleCurrency();

  Future capturaDadosFinanceiro(dataInicio, dataFim) async {
    var result = await http.get(
      Uri.parse(
        BuscarSaldoDaEmpresaPorData +
            dataInicio.toString() +
            '/' +
            dataFim.toString() +
            '/' +
            ModelsUsuarios.caminhoBaseUser.toString(),
      ),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'authorization': ModelsUsuarios.tokenAuth.toString(),
      },
    );

    Iterable lista = json.decode(result.body);
    dadosFinanceiro =
        lista.map((model) => ModelsFinanceiro.fromJson(model)).toList();

    valorTotalTodosDespesas = dadosFinanceiro[0].valorTotalDespesas;
    valorTotalTodosPedidos = dadosFinanceiro[0].valorTotalPedidos;

    pedidos = null;
    despesas = null;

//--------------------------------------------------------------------------
    if (valorTotalTodosPedidos != null) {
      pedidos = double.tryParse(BuscaValoresFinanceiroPorData
          .valorTotalTodosPedidos!
          .replaceAll('R\$', '')
          .replaceAll('.', '')
          .replaceAll(',', '.'));
    }
    if (valorTotalTodosDespesas != null) {
      despesas = double.tryParse(BuscaValoresFinanceiroPorData
          .valorTotalTodosDespesas!
          .replaceAll('R\$', '')
          .replaceAll('.', '')
          .replaceAll(',', '.'));
    }

    if (pedidos == null && despesas != null) {
      saldoEmCaixa.value = valorTotalTodosDespesas!;
      // formatCurrency.format(despesas).replaceAll('\$', 'R\$ - ');
    } else if (despesas == null && pedidos != null) {
      saldoEmCaixa.value = valorTotalTodosPedidos!;
      // formatCurrency.format(pedidos).replaceAll('\$', 'R\$ ');
    } else if (despesas == null && pedidos == null) {
      saldoEmCaixa.value = 'R\$ 0,00';
    } else if (despesas != null && pedidos != null) {
      subtrair = pedidos! - despesas!;
      // subtrair = subtrair.toString().replaceAll(',', '').replaceAll('.', ',');
      totalPedidoDespesa = formatCurrency
          .format(subtrair)
          .replaceAll('\$', ' R\$ ')
          .replaceAll(',', '/')
          .replaceAll('.', ',')
          .replaceAll('/', '.');

      saldoEmCaixa.value = totalPedidoDespesa!;
    }

    print(saldoEmCaixa.value);
  }
 
  Future buscaSaldoPorOpcPesquisa() async {
    var result = await http.get(
      Uri.parse(BuscarSaldoDaEmpresaPorOpcoesPesquisa +
          ModelsUsuarios.caminhoBaseUser.toString()),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'authorization': ModelsUsuarios.tokenAuth.toString(),
      },
    );
    Iterable<dynamic> lista = json.decode(result.body);
    dadosFinanceiro =
        lista.map((model) => ModelsFinanceiro.fromJson(model)).toList();

    if (dadosFinanceiro.toList().length > 0) {
      saldoSemana.value = dadosFinanceiro[0].saldoSemana!;
      saldoMes.value = dadosFinanceiro[0].saldoMes!;
      saldoAno.value = dadosFinanceiro[0].saldoAno!;
      saldoHistorico.value = dadosFinanceiro[0].saldoHistorico!;
    }
  }
}
