//
//  =========== ARQUIVO QUE CAPTURA OS DADOS DO GRUPO DE PEDIDOS =============
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:madecontrol_desenvolvimento/models/Models_GrupoPedido.dart';
import 'package:madecontrol_desenvolvimento/models/Models_Usuario.dart';
import 'package:madecontrol_desenvolvimento/models/constantes.dart';

class FieldsGrupoPedido {
  static int? idGrupoPedido;
  static int? idCliente;
  static String? tipoVenda;
  static String? dataEntrega;
  var dadosGrupoPedido = <ModelsGrupoPedido>[];

  Future<dynamic> buscaDadosGrupoPedidoPorId(idPedidoSelecionado) async {
    var result = await http.get(
      Uri.parse(
        BuscaGrupoPedidoPorId +
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
    dadosGrupoPedido =
        lista.map((model) => ModelsGrupoPedido.fromJson(model)).toList();

    if (dadosGrupoPedido.toList().length > 0) {
      FieldsGrupoPedido.idGrupoPedido = dadosGrupoPedido[0].idGrupoPedido;
      FieldsGrupoPedido.idCliente = dadosGrupoPedido[0].idCliente;
      FieldsGrupoPedido.tipoVenda = dadosGrupoPedido[0].tipoVenda;
      FieldsGrupoPedido.dataEntrega = dadosGrupoPedido[0].dataEntrega;
    }
  }
}
