//
//  =========== ARQUIVO QUE CAPTURA OS DADOS DO USUARIO LOGADO =============

import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:madecontrol_desenvolvimento/models/Models_Recebimento.dart';
import 'package:madecontrol_desenvolvimento/models/Models_Usuario.dart';
import '../models/constantes.dart';

// ============ DADOS DE TODOS AS DESPESAS CADASTRADAS ===============
class FieldsRecebimento {
  var dadosRecebimento = <ModelsRecebimento>[];

  static int? idRecebimento;
  static int? idCliente;
  static String? dataRecebimento;
  static String? horaRecebimento;
  static String? valorRecebido;
  static String? tipoPagamento;
  static String? observacoes;
  static String? valorTotalRecebimentos;
  static String? qtdTotalRecebimentos;
  static final atualizaValorTotalRecebidos = ValueNotifier<String>('');

  Future<void> capturaDadosRecebimento(idDoRecebimento) async {
    var result = await http.get(
      Uri.parse(
        BuscarRecebimentoPorId +
            idDoRecebimento.toString() +
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
    dadosRecebimento =
        lista.map((model) => ModelsRecebimento.fromJson(model)).toList();

    idRecebimento = dadosRecebimento[0].idrecebimento;
    idCliente = dadosRecebimento[0].idcliente;
    dataRecebimento = dadosRecebimento[0].dataRecebimento;
    horaRecebimento = dadosRecebimento[0].horaRecebimento;
    valorRecebido = dadosRecebimento[0].valorRecebido;
    tipoPagamento = dadosRecebimento[0].tipoPagamento;
    observacoes = dadosRecebimento[0].observacoes;
  }

  Future<dynamic> capturaDadosRecebimentoPorData(dataInicio, dataFim) async {
    var result = await http.get(
      Uri.parse(
        BuscaValorTotalRecebimentoPorData +
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
    dadosRecebimento =
        lista.map((model) => ModelsRecebimento.fromJson(model)).toList();

    if (dadosRecebimento.toList().length > 0) {
      idRecebimento = dadosRecebimento[0].idrecebimento;
      idCliente = dadosRecebimento[0].idcliente;
      dataRecebimento = dadosRecebimento[0].dataRecebimento;
      horaRecebimento = dadosRecebimento[0].horaRecebimento;
      valorRecebido = dadosRecebimento[0].valorRecebido;
      tipoPagamento = dadosRecebimento[0].tipoPagamento;
      observacoes = dadosRecebimento[0].observacoes;
      qtdTotalRecebimentos = dadosRecebimento[0].qtdTotalRecebimentos;
      valorTotalRecebimentos = dadosRecebimento[0].valorTotalRecebimentos;

      atualizaValorTotalRecebidos.value = valorTotalRecebimentos!;
    } else {
      atualizaValorTotalRecebidos.value = 'R\$ 0,00';
    }
  }
}
