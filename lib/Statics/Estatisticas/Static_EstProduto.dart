import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:madecontrol_desenvolvimento/models/Estatisticas/Models_EstProduto.dart';
import 'package:madecontrol_desenvolvimento/models/constantes.dart';
import 'package:madecontrol_desenvolvimento/screens/Menu/BarraLateral/Estatistica/Produto/EstatisticaProduto.dart';
import '../../models/Models_Usuario.dart';

class FieldsEstatisticaProdutos {
  static String? qtdprodutos;
  static String? qtdPedidosTotal;
  static String? faturamentoTodosProdutos;
  //
  static int? idProduto;
  static String? nomeProduto;
  static String? qtdPedidosAno;
  static String? totalVendaProduto;
  static String? percentualMediaVendaAno;
  static String? precoMedioVendaAno;
  //
  static String? dataUltimoPedido;
  static String? qtdPedidosTotalProduto;
  static String? faturamentoTotalProduto;
  //
  static String? numeroMes;
  static String? nomeMes;
  static String? valorTotalMes;
  static String? qtdPedidosMes;
  static String? precoMedioVendaMes;

  var dadosProduto = <ModelsEstProduto>[];

  Future buscaDetalhesTotalProdutos(ano) async {
    var result = await http.get(
      Uri.parse(
        BuscaDetalhesTotalProdutoPorAno +
            ano +
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
    dadosProduto =
        lista.map((model) => ModelsEstProduto.fromJson(model)).toList();

    FieldsEstatisticaProdutos.qtdprodutos = dadosProduto[0].qtdprodutos;
    FieldsEstatisticaProdutos.qtdPedidosTotal = dadosProduto[0].qtdPedidosTotal;
    FieldsEstatisticaProdutos.faturamentoTodosProdutos =
        dadosProduto[0].valorTotalAno;
  }

  Future buscaDadosAnoProdutoPorid(ano, idDoProduto) async {
    var result = await http.get(
      Uri.parse(
        ProdutoOuPallet.opcProduto!.value == true?
        BuscaDetalhesProdutoPorId+
            ano +
            '/' +
            idDoProduto.toString() +
            '/' +
            ModelsUsuarios.caminhoBaseUser.toString(): 
            //
            BuscaDetalhesPalletPorId +
              ano +
            '/' +
            idDoProduto.toString() +
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
    dadosProduto =
        lista.map((model) => ModelsEstProduto.fromJson(model)).toList();

    FieldsEstatisticaProdutos.dataUltimoPedido =
        dadosProduto[0].dataUltimoPedido;
    FieldsEstatisticaProdutos.qtdPedidosTotalProduto =
        dadosProduto[0].qtdPedidosTotalProduto;
    FieldsEstatisticaProdutos.faturamentoTotalProduto =
        dadosProduto[0].faturamentoTotalProduto;
  }

//
// ==========================================================================================
//
  Future dadosMesesProdutoPorId(ano, iddoproduto) async {
    var result = await http.get(
      Uri.parse(
        ListaMesesProdutoPorId +
            ano +
            '/' +
            iddoproduto +
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
    dadosProduto =
        lista.map((model) => ModelsEstProduto.fromJson(model)).toList();

    FieldsEstatisticaProdutos.numeroMes = dadosProduto[0].numeroMes;
    FieldsEstatisticaProdutos.nomeMes = dadosProduto[0].nomeMes;
    FieldsEstatisticaProdutos.valorTotalMes = dadosProduto[0].valorTotalMes;
    FieldsEstatisticaProdutos.qtdPedidosMes = dadosProduto[0].qtdPedidosMes;
    FieldsEstatisticaProdutos.precoMedioVendaMes =
        dadosProduto[0].precoMedioVendaMes;
  }
}
