//
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:madecontrol_desenvolvimento/models/Models_TipoDespesa.dart';
import 'package:madecontrol_desenvolvimento/models/Models_Usuario.dart';
import 'package:madecontrol_desenvolvimento/models/constantes.dart';

class FieldsSubTipoDespesa {
  static String? nomeTipoDespesa;
  static int? idTipoDespesa;
  static String? nomeSubTipoDespesa;
  static int? idSubTipoDespesa;
  static String? totalGrupoDespesa;
  static String? qtdDespesasGrupo;
  static String? totalSubGrupoDespesa;
  static String? qtdDespesasSubGrupo;
  static String? mediaGastoPorDespesa;

  // RESUMO DESPESAS
  static String? valorDespesasAno;
  static String? totalNumMeses;
  static String? qtdTotalGrupos;
  static int? numeroMes;
  static String? nomeMes;
  static String? valorDespesaMes;
  static String? qtdDespesasMes;

  var dadosLista = <ModelsSubTipoDespesa>[];

  Future totalDespesaPorGrupoDespesa(idGrupo) async {
    var result = await http.get(
      Uri.parse(
        BuscarTotalDespesaPorTipoDespesa +
            idGrupo.toString() +
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
    dadosLista =
        lista.map((model) => ModelsSubTipoDespesa.fromJson(model)).toList();

    FieldsSubTipoDespesa.totalGrupoDespesa = dadosLista[0].totalGrupoDespesa;
    FieldsSubTipoDespesa.qtdDespesasGrupo = dadosLista[0].qtdDespesasGrupo;
  }

  Future totalDespesaPorSubGrupoDespesa(idSubGrupo) async {
    var result = await http.get(
      Uri.parse(
        BuscarTotalDespesaPorSubTipoDespesa +
            idSubGrupo.toString() +
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
    dadosLista =
        lista.map((model) => ModelsSubTipoDespesa.fromJson(model)).toList();

    FieldsSubTipoDespesa.totalSubGrupoDespesa =
        dadosLista[0].totalSubGrupoDespesa;
    FieldsSubTipoDespesa.qtdDespesasSubGrupo =
        dadosLista[0].qtdDespesasSubGrupo;
    FieldsSubTipoDespesa.mediaGastoPorDespesa =
        dadosLista[0].mediaGastoPorDespesa;
  }

  Future resumoDespesasPorAno(idano) async {
    var result = await http.get(
      Uri.parse(
        ResumoTotalTipoDespesaPorAno +
            idano.toString() +
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
    dadosLista =
        lista.map((model) => ModelsSubTipoDespesa.fromJson(model)).toList();

    FieldsSubTipoDespesa.valorDespesasAno = dadosLista[0].valorDespesasAno;
    FieldsSubTipoDespesa.totalNumMeses = dadosLista[0].totalNumMeses;
    FieldsSubTipoDespesa.qtdTotalGrupos = dadosLista[0].qtdTotalGrupos;
  }
}
