import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:madecontrol_desenvolvimento/models/Models_Producao.dart';
import '../../models/Models_Usuario.dart';
import '../models/constantes.dart';

class FieldsProducaoPedido {
  static int? idProducao;
  static int? idPedido;
  static String? dataInicio;
  static String? dataFim;
  static String? horaInicio;
  static String? horaFim;
  static String? duracaoProcesso;
  static double?media;
  static int? qtdProducao;
  static double?percentualProduzido;

  var listaProducaoPedido = <ModelsProducao>[];

  Future<dynamic> buscaProducaoPedidoPorId(idProducaoPedidoSelect) async {
    var result = await http.get(
      Uri.parse(
       await BuscaProducaoPedidoPorId +
            idProducaoPedidoSelect.toString() +
            '/' +
            ModelsUsuarios.caminhoBaseUser.toString(),
      ),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'authorization': ModelsUsuarios.tokenAuth.toString(),
      },
    );

    if (idProducaoPedidoSelect != null) {
      Iterable lista = json.decode(result.body);

      listaProducaoPedido =
          lista.map((model) => ModelsProducao.fromJson(model)).toList();

      if (listaProducaoPedido.toList().length > 0) {
        FieldsProducaoPedido.idProducao = listaProducaoPedido[0].idProducao;
        FieldsProducaoPedido.idPedido = listaProducaoPedido[0].idPedido;
        FieldsProducaoPedido.dataInicio = listaProducaoPedido[0].dataInicio;
        FieldsProducaoPedido.dataFim = listaProducaoPedido[0].dataFim;
        FieldsProducaoPedido.horaInicio = listaProducaoPedido[0].horaInicio;
        FieldsProducaoPedido.horaFim = listaProducaoPedido[0].horaFim;
        FieldsProducaoPedido.duracaoProcesso =
            listaProducaoPedido[0].duracaoProcesso;
        FieldsProducaoPedido.media = listaProducaoPedido[0].media;
        FieldsProducaoPedido.qtdProducao = listaProducaoPedido[0].qtdProducao;
        FieldsProducaoPedido.percentualProduzido =
            listaProducaoPedido[0].percentualProduzido;
      }
    } else {
      FieldsProducaoPedido.idPedido = null;
    }
  }
}
