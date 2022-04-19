//
//  =========== ARQUIVO QUE CAPTURA OS DADOS DO CLIENTE =============

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:madecontrol_desenvolvimento/models/Models_Clientes.dart';
import '..//../models/Models_Usuario.dart';
import '../models/constantes.dart';

class Cliente {
  static String? nomeCliente;
  static String? codigoGrupo;
  static int? idCliente;
  static int? idUsuario;
  static int? idGrupoPedido;
}

// ============ DADOS DE TODOS OS USU?RIOS CADASTRADOS ===============
class BuscaClientePorId {
  var dadosCliente = <ModelsClientes>[];

  static int? idCliente;
  static String? nomeCliente;
  static String? telefone;
  static String? cpf;
  static String? cnpj;
  static String? tipoPessoa;
  static String? cidade;
  static String? bairro;
  static String? endereco;
  static int? numResidencia;
  static String? codigoCliente;
  static final dof = ValueNotifier<bool>(false);

  Future<dynamic> capturaDadosCliente(idDoCliente) async {
    var result = await http.get(
      Uri.parse(
        BuscarClienteporId +
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
    dadosCliente =
        lista.map((model) => ModelsClientes.fromJson(model)).toList();

    idCliente = dadosCliente[0].idCliente;
    nomeCliente = dadosCliente[0].nome;
    telefone = dadosCliente[0].telefone;
    cpf = dadosCliente[0].cpf;
    cnpj = dadosCliente[0].cnpj;
    tipoPessoa = dadosCliente[0].tipoPessoa;
    cidade = dadosCliente[0].cidade;
    bairro = dadosCliente[0].bairro;
    endereco = dadosCliente[0].endereco;
    dof.value = dadosCliente[0].dof!;
    numResidencia = dadosCliente[0].numResidencia;
    codigoCliente = dadosCliente[0].codigoCliente;
  }
}
