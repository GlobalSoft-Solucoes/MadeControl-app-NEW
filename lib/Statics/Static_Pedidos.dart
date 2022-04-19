//
//  =========== ARQUIVO QUE CAPTURA OS DADOS DO USUARIO LOGADO =============

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:madecontrol_desenvolvimento/models/Models_Pedidos.dart';
import 'package:madecontrol_desenvolvimento/models/Models_Usuario.dart';
import '../models/constantes.dart';

// ============ DADOS DE TODOS OS USU�RIOS CADASTRADOS ===============
class FieldsPedido {
  var dadosPedido = <ModelsPedidos>[];

  static int? idPedido;
  static int? idUsuario;
  static int? idGrupoPedido;
  static int? idProduto;
  static int? idMadeira;
  static int? idUnidadeMedida;
  static int? idPallet;
  static String? dataPedido;
  static String? horaPedido;
  static String? codPedido;
  static double?espessura;
  static double?comprimento;
  static double?largura;
  static String? observacoes;
  static String? precoMetro;
  static String? valorTotal;
  static double?qtdMetros;
  static String? valorTotalTodosPedidos;
  static String? qtdPedidos;
  static double?totalQtdMetros;
  static String? nomeCliente;
  static double?quantidade;
  static String? nomeProduto;
  static String? nomeMadeira;
  static bool? beneficiado;
  static String? tipoProcesso;
  static int? tipoCalculo;

  static final atualizaValorTotalPedidos = ValueNotifier<String>('');

  Future<dynamic> capturaDadosPedidosPorData(dataInicio, dataFim) async {
    var result = await http.get(
      Uri.parse(
        BuscaValorTotalPedidosPorData +
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
    dadosPedido = lista.map((model) => ModelsPedidos.fromJson(model)).toList();

    if (dadosPedido.toList().length > 0) {
      idPedido = dadosPedido[0].idPedido;
      idUsuario = dadosPedido[0].idUsuario;
      idGrupoPedido = dadosPedido[0].idGrupoPedido;
      dataPedido = dadosPedido[0].dataPedido;
      horaPedido = dadosPedido[0].horaPedido;
      codPedido = dadosPedido[0].codPedido;
      comprimento = dadosPedido[0].comprimento;
      largura = dadosPedido[0].largura;
      idProduto = dadosPedido[0].idProduto;
      idMadeira = dadosPedido[0].idMadeira;
      idUnidadeMedida = dadosPedido[0].idUnidadeMedida;
      precoMetro = dadosPedido[0].precoCubico;
      qtdMetros = dadosPedido[0].qtdMetros;
      valorTotal = dadosPedido[0].valorTotal;
      observacoes = dadosPedido[0].observacoes;
      valorTotalTodosPedidos = dadosPedido[0].valorTotalTodosPedidos;
      qtdPedidos = dadosPedido[0].qtdPedidos;
      totalQtdMetros = dadosPedido[0].totalQtdMetros;
      nomeCliente = dadosPedido[0].nomeCliente;
      nomeProduto = dadosPedido[0].nomeProduto;
      nomeMadeira = dadosPedido[0].nomeMadeira;

      atualizaValorTotalPedidos.value = valorTotalTodosPedidos!;
    } else {
      atualizaValorTotalPedidos.value = 'R\$ 0,00';
    }
  }

  // =============================== EDIÇÃO DO PEDIDO ================================

  Future<dynamic> buscaDadosPedidoPorId(idPedidoSelecionado) async {
    var result = await http.get(
      Uri.parse(
        BuscarPedidoPorId +
            idPedidoSelecionado.toString() +
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
    dadosPedido = lista.map((model) => ModelsPedidos.fromJson(model)).toList();

    if (dadosPedido.toList().length > 0) {
      idPedido = dadosPedido[0].idPedido;
      idUsuario = dadosPedido[0].idUsuario;
      idGrupoPedido = dadosPedido[0].idGrupoPedido;
      idProduto = dadosPedido[0].idProduto;
      idMadeira = dadosPedido[0].idMadeira;
      idUnidadeMedida = dadosPedido[0].idUnidadeMedida;
      idPallet = dadosPedido[0].idPallet;
      dataPedido = dadosPedido[0].dataPedido;
      horaPedido = dadosPedido[0].horaPedido;
      codPedido = dadosPedido[0].codPedido;
      comprimento = dadosPedido[0].comprimento;
      largura = dadosPedido[0].largura;
      precoMetro = dadosPedido[0].precoCubico;
      qtdMetros = dadosPedido[0].qtdMetros;
      valorTotal = dadosPedido[0].valorTotal;
      observacoes = dadosPedido[0].observacoes;
      valorTotalTodosPedidos = dadosPedido[0].valorTotalTodosPedidos;
      qtdPedidos = dadosPedido[0].qtdPedidos;
      totalQtdMetros = dadosPedido[0].totalQtdMetros;
      nomeCliente = dadosPedido[0].nomeCliente;
      quantidade = dadosPedido[0].quantidade;
      espessura = dadosPedido[0].espessura;
      nomeProduto = dadosPedido[0].nomeProduto;
      nomeMadeira = dadosPedido[0].nomeMadeira;
      beneficiado = dadosPedido[0].beneficiado;
      tipoProcesso = dadosPedido[0].tipoProcesso;
      tipoCalculo = dadosPedido[0].tipoCalculo;
    }
  }
}
