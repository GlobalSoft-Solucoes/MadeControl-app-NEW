//  =========== ARQUIVO QUE CAPTURA OS DADOS DO CLIENTE =============

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:madecontrol_desenvolvimento/models/Models_SaldoDevedor.dart';
import 'package:madecontrol_desenvolvimento/models/constantes.dart';
import '../models/Models_Usuario.dart';

class FieldsSaldoDevedor {
  static var qtdDevedores;
  static var saldoDevedorTotal;
  //
  static int? idCliente;
  static String? nomeCliente;
  static String? saldoCliente;
  //
  static String? cnpj;
  static String? telefone;
  static String? dataUltimoPedido;
  static String? dividaCliente;
  static String? cidade;

  var dadosSaldo = <ModelsSaldoDevedor>[];

  Future buscaDadosSaldoDevedorClientePorid(idDoCliente) async {
    var result = await http.get(
      Uri.parse(
        BuscaSaldoDevedorClientePorId +
            idDoCliente.toString() +
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
    dadosSaldo =
        lista.map((model) => ModelsSaldoDevedor.fromJson(model)).toList();

    FieldsSaldoDevedor.idCliente = dadosSaldo[0].idCliente;
    FieldsSaldoDevedor.nomeCliente = dadosSaldo[0].nomeCliente;
    FieldsSaldoDevedor.cnpj = dadosSaldo[0].cnpj;
    FieldsSaldoDevedor.telefone = dadosSaldo[0].telefone;
    FieldsSaldoDevedor.cidade = dadosSaldo[0].cidade;
    FieldsSaldoDevedor.dataUltimoPedido = dadosSaldo[0].dataUltimoPedido;
    FieldsSaldoDevedor.dividaCliente = dadosSaldo[0].dividaCliente;
  }

//
// ==========================================================================================
//
  Future detalhesTotalSaldoDevedor() async {
    var result = await http.get(
      Uri.parse(
        BuscaDetalhesTotalSaldoDevedor + ModelsUsuarios.caminhoBaseUser.toString(),
      ),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'authorization': ModelsUsuarios.tokenAuth.toString(),
      },
    );

    Iterable lista = json.decode(result.body);
    dadosSaldo =
        lista.map((model) => ModelsSaldoDevedor.fromJson(model)).toList();

    FieldsSaldoDevedor.saldoDevedorTotal = dadosSaldo[0].saldoDevedorTotal;
    FieldsSaldoDevedor.qtdDevedores = dadosSaldo[0].qtdDevedores;
  }
}
