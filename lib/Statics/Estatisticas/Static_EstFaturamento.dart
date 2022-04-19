//  =========== ARQUIVO QUE CAPTURA OS DADOS DO CLIENTE =============

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:madecontrol_desenvolvimento/models/Estatisticas/Models_EstFaturamento.dart';
import 'package:madecontrol_desenvolvimento/models/constantes.dart';
import '../../models/Models_Usuario.dart';

class FieldsEstatisticaFaturamento {
  static String? faturamentoTotalAno;
  static String? mediaFaturamentoMes;
  static String? qtdPedidosAno;
  static String? qtdMeses;
  static int? numeroMes;
  static String? nomeMes;
  static String? valorTotalMes;
  static String? qtdPedidosMes;
  static String? mediaFaturaPedidoMes;
  static String? nomeCliente;
  static String? idCliente;
  static String? faturamentoClienteMes;
  static String? percentualFaturaClienteMes;

  var dadosFaturamento = <ModelsEstFaturamento>[];

  Future buscarDadosPorMes(ano, mes) async {
    var result = await http.get(
      Uri.parse(
        EstBuscaDetalhesPorMes +
            ano.toString() +
            '/' +
            mes.toString() +
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
    dadosFaturamento =
        lista.map((model) => ModelsEstFaturamento.fromJson(model)).toList();

    FieldsEstatisticaFaturamento.mediaFaturamentoMes =
        dadosFaturamento[0].mediaFaturaPedidoMes;
    FieldsEstatisticaFaturamento.numeroMes = dadosFaturamento[0].numeroMes;
    FieldsEstatisticaFaturamento.nomeMes = dadosFaturamento[0].nomeMes;
    FieldsEstatisticaFaturamento.valorTotalMes =
        dadosFaturamento[0].valorTotalMes;
    FieldsEstatisticaFaturamento.qtdPedidosMes =
        dadosFaturamento[0].qtdPedidosMes;
    FieldsEstatisticaFaturamento.mediaFaturaPedidoMes =
        dadosFaturamento[0].mediaFaturaPedidoMes;
  }

//
// ==========================================================================================
//
  Future detalhesFaturamentoTotalMeses(ano) async {
    var result = await http.get(
      Uri.parse(
        EstDetalhesTotalFaturamentoMeses +
            ano.toString() +
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
    dadosFaturamento =
        lista.map((model) => ModelsEstFaturamento.fromJson(model)).toList();

    if (dadosFaturamento.toList().length > 0) {
      FieldsEstatisticaFaturamento.faturamentoTotalAno =
          dadosFaturamento[0].faturamentoTotalAno;
      FieldsEstatisticaFaturamento.qtdMeses = dadosFaturamento[0].qtdMeses;
      FieldsEstatisticaFaturamento.mediaFaturamentoMes =
          dadosFaturamento[0].mediaFaturamentoMes;
      FieldsEstatisticaFaturamento.qtdPedidosAno =
          dadosFaturamento[0].qtdPedidosAno;
    }
  }
}
