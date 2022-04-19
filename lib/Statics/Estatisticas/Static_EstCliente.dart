//  =========== ARQUIVO QUE CAPTURA OS DADOS DO CLIENTE =============

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:madecontrol_desenvolvimento/models/Estatisticas/Models_EstClientes.dart';
import 'package:madecontrol_desenvolvimento/models/constantes.dart';
import '../../models/Models_Usuario.dart';

class FieldsEstatisticaClientes {
  static int? idCliente;
  static String? mediaFaturamentoPedido;
  static String? qtdTotalPedidos;
  static String? faturamentoTotalPedidos;
  static String? faturamentoIndividual;
  static var representacaoFaturamento;
  static String? nomeCliente;
  static String? cnpj;
  static String? dataUltimoPedido;
  static String? faturamentoCliente;
  static String? qtdTotalPedidosCliente;
  static String? mediaFaturamentoCliente;

  var dadosCliente = <ModelsEstClientes>[];

  Future<void> buscaDadosEstClientePorid(idDoCliente) async {
    var result = await http.get(
      Uri.parse(
        EstatisticaBuscarClientePorId +
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
        lista.map((model) => ModelsEstClientes.fromJson(model)).toList();

    FieldsEstatisticaClientes.idCliente = dadosCliente[0].idCliente;
    FieldsEstatisticaClientes.nomeCliente = dadosCliente[0].nomeCliente;
    FieldsEstatisticaClientes.cnpj = dadosCliente[0].cnpj;
    FieldsEstatisticaClientes.mediaFaturamentoCliente =
        dadosCliente[0].mediaFaturamentoCliente;
    FieldsEstatisticaClientes.qtdTotalPedidosCliente =
        dadosCliente[0].qtdTotalPedidosCliente;
    FieldsEstatisticaClientes.representacaoFaturamento =
        dadosCliente[0].representacaoFaturamento;
    FieldsEstatisticaClientes.faturamentoIndividual =
        dadosCliente[0].faturamentoIndividual;
    FieldsEstatisticaClientes.dataUltimoPedido =
        dadosCliente[0].dataUltimoPedido;
    FieldsEstatisticaClientes.faturamentoCliente =
        dadosCliente[0].faturamentoCliente;
  }

//
// ==========================================================================================
//
  Future<void> detalhesFaturamentoClientesPorData(
      datadeInicio, datadeFim) async {
    var result = await http.get(
      Uri.parse(
        EstatisticaDetalhesFaturamentoClientePorData +
            datadeInicio +
            '/' +
            datadeFim +
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
        lista.map((model) => ModelsEstClientes.fromJson(model)).toList();

    FieldsEstatisticaClientes.idCliente = dadosCliente[0].idCliente;
    FieldsEstatisticaClientes.faturamentoTotalPedidos =
        dadosCliente[0].faturamentoTotalPedidos;
    FieldsEstatisticaClientes.mediaFaturamentoPedido =
        dadosCliente[0].mediaFaturamentoPedido;
    FieldsEstatisticaClientes.qtdTotalPedidos = dadosCliente[0].qtdTotalPedidos;
  }
}
