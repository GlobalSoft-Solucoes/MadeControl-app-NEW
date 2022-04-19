//  =========== ARQUIVO QUE CAPTURA OS DADOS DO CLIENTE =============

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:madecontrol_desenvolvimento/models/Estatisticas/Models_EstLote.dart';
import 'package:madecontrol_desenvolvimento/models/constantes.dart';
import '../../models/Models_Usuario.dart';

class FieldsEstatisticaLote {
  static String? metrosTotalAno;
  static String? mediaMetrosMes;
  static String? qtdMeses;
  static int? numeroMes;
  static String? nomeMes;
  static double?metrosTotalMes;
  static String? qtdEntradaLoteMes;

  var dadosLote = <ModelsEstLote>[];

// ==========================================================================================
  Future<dynamic> detalhesLoteTotalMeses(ano) async {
    var result = await http.get(
      Uri.parse(
        EstDetalhesTotalLoteTodosAno +
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
    dadosLote = lista.map((model) => ModelsEstLote.fromJson(model)).toList();

    if (dadosLote.toList().length > 0) {
      FieldsEstatisticaLote.metrosTotalAno = dadosLote[0].metrosTotalAno;
      FieldsEstatisticaLote.qtdMeses = dadosLote[0].qtdMeses;
      FieldsEstatisticaLote.mediaMetrosMes = dadosLote[0].mediaMetrosMes;
    }
  }

  // ==========================================================================================
  Future<dynamic> buscaDetalhesLotePorMes(ano, mes) async {
    var result = await http.get(
      Uri.parse(
        EstBuscaDetalhesLotePorMes +
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
    dadosLote = lista.map((model) => ModelsEstLote.fromJson(model)).toList();

    if (dadosLote.toList().length > 0) {
      FieldsEstatisticaLote.nomeMes = dadosLote[0].nomeMes;
      FieldsEstatisticaLote.metrosTotalMes = dadosLote[0].metrosTotalMes;
      FieldsEstatisticaLote.qtdEntradaLoteMes = dadosLote[0].qtdEntradaLoteMes;
    }
  }
}
