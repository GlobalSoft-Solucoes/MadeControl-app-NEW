//
//  =========== ARQUIVO QUE CAPTURA OS DADOS DO USUARIO LOGADO =============

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:madecontrol_desenvolvimento/models/Models_Usuario.dart';
import '../models/constantes.dart';
import 'package:madecontrol_desenvolvimento/models/Models_Despesa.dart';

// ============ DADOS DE TODOS AS DESPESAS CADASTRADAS ===============
class EditarDadosDaDespesa {
  var dadosDespesa = <ModelsDespesa>[];

  static int? iddespesa;
  static int? idUsuario;
  static int? idtipoDespesa;
  static String? dataDespesa;
  static String? horaDespesa;
  static String? descricao;
  static String? observacoes;
  static String? valorDespesa;

  Future<dynamic> capturaDadosDespesa(idDaDespesa) async {
    var result = await http.get(
      Uri.parse(
        BuscarDespesaPorId +
            idDaDespesa.toString() +
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
    dadosDespesa = lista.map((model) => ModelsDespesa.fromJson(model)).toList();

    iddespesa = dadosDespesa[0].idDespesa;
    idUsuario = dadosDespesa[0].idUsuario;
    idtipoDespesa = dadosDespesa[0].idTipoDespesa;
    dataDespesa = dadosDespesa[0].dataDespesa;
    horaDespesa = dadosDespesa[0].horaDespesa;
    descricao = dadosDespesa[0].descricao;
    observacoes = dadosDespesa[0].observacoes;
    valorDespesa = dadosDespesa[0].valorDespesa;
  }
}

class BuscaDespesasPorData {
  var dadosDespesa = <ModelsDespesa>[];

  static int? iddespesa;
  static int? idUsuario;
  static int? idtipoDespesa;
  static String? dataDespesa;
  static String? horaDespesa;
  static String? descricao;
  static String? observacoes;
  static String? valorDespesa;
  static String? valorTotalTodosDespesas;
  static String? qtdDespesas;
  static String? dataVencimento;
  static String? nomeTipoDespesa;

  static final atualizaValorTotalDespesas = ValueNotifier<String>('');

  Future<dynamic> capturaDadosDespesa(dataInicio, dataFim) async {
    var result = await http.get(
      Uri.parse(
        BuscarDetalhesDespesasPorDatas +
            dataInicio +
            '/' +
            dataFim +
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
    dadosDespesa = lista.map((model) => ModelsDespesa.fromJson(model)).toList();

    if (dadosDespesa.toList().length > 0) {
      iddespesa = dadosDespesa[0].idDespesa;
      idUsuario = dadosDespesa[0].idUsuario;
      idtipoDespesa = dadosDespesa[0].idTipoDespesa;
      dataDespesa = dadosDespesa[0].dataDespesa;
      horaDespesa = dadosDespesa[0].horaDespesa;
      descricao = dadosDespesa[0].descricao;
      observacoes = dadosDespesa[0].observacoes;
      valorDespesa = dadosDespesa[0].valorDespesa;
      valorTotalTodosDespesas = dadosDespesa[0].valorTotalTodosDespesas;
      qtdDespesas = dadosDespesa[0].qtdDespesas;

      atualizaValorTotalDespesas.value = valorTotalTodosDespesas!;
    } else {
      atualizaValorTotalDespesas.value = 'R\$ 0,00';
    }
  }

  Future<dynamic> capturaDadosDespesasPorData(dataInicio, dataFim) async {
    var result = await http.get(
      Uri.parse(
        BuscaValorTotalDespesasPorData +
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
    dadosDespesa = lista.map((model) => ModelsDespesa.fromJson(model)).toList();

    if (dadosDespesa.toList().length > 0) {
      iddespesa = dadosDespesa[0].idDespesa;
      nomeTipoDespesa = dadosDespesa[0].nomeTipoDespesa;
      dataVencimento = dadosDespesa[0].dataVencimento;
      descricao = dadosDespesa[0].descricao;
      observacoes = dadosDespesa[0].observacoes;
      valorDespesa = dadosDespesa[0].valorDespesa;
      valorTotalTodosDespesas = dadosDespesa[0].valorTotalTodosDespesas;
      qtdDespesas = dadosDespesa[0].qtdDespesas;

      atualizaValorTotalDespesas.value = valorTotalTodosDespesas!;
    } else {
      atualizaValorTotalDespesas.value = 'R\$ 0,00';
    }
  }
}
