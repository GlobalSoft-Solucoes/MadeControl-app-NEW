import 'dart:convert';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:http/http.dart' as http;
import 'package:madecontrol_desenvolvimento/models/Models_ConfigAcesso.dart';
import '..//../models/Models_Usuario.dart';
import '../models/constantes.dart';

class FieldsAcessoTelas {
  static int? idAcessoTelas;
  static int? idUsuario;
  static String? nomeUsuario;
  static bool? cadUsuario;
  static bool? cadCargo;
  static bool? cadLote;
  static bool? cadPedido;
  static bool? cadProduto;
  static bool? cadMadeira;
  static bool? cadPallet;
  static bool? cadRomaneio;
  static bool? processoMadeira;
  static bool? historicoPedidos;
  static bool? pedidosCadastrados;
  static bool? pedidosProducao;
  static bool? pedidosProntos;
  static bool? historicoRomaneios;
  static bool? listaClientes;
  static bool? lixeiraGrupoPedidos;
  static bool? financeiro;
  static bool? estatisticas;
  static bool? listaDespesas;
  static bool? listaRecebimentos;
  static bool? vendaAvulso;

  var listaDadosAcessoTelas = <ModelsAcessoTelas>[];

  Future<dynamic> capturaConfigAcessoTelasUsuario(
      idUsuarioSelecionado) async {
    var result = await http.get(
      Uri.parse(
        BuscarConfigAcessoTelasPorUsuario +
            idUsuarioSelecionado.toString() +
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

    listaDadosAcessoTelas =
        lista.map((model) => ModelsAcessoTelas.fromJson(model)).toList();

    FieldsAcessoTelas.idAcessoTelas ??= listaDadosAcessoTelas[0].idAcessoTelas;
    FieldsAcessoTelas.idUsuario = listaDadosAcessoTelas[0].idUsuario;
    FieldsAcessoTelas.nomeUsuario = listaDadosAcessoTelas[0].nomeUsuario;
    FieldsAcessoTelas.cadUsuario = listaDadosAcessoTelas[0].cadUsuario;
    FieldsAcessoTelas.cadCargo = listaDadosAcessoTelas[0].cadCargo;
    FieldsAcessoTelas.cadLote = listaDadosAcessoTelas[0].cadLote;
    FieldsAcessoTelas.cadPedido = listaDadosAcessoTelas[0].cadPedido;
    FieldsAcessoTelas.cadMadeira = listaDadosAcessoTelas[0].cadMadeira;
    FieldsAcessoTelas.cadProduto = listaDadosAcessoTelas[0].cadProduto;
    FieldsAcessoTelas.cadPallet = listaDadosAcessoTelas[0].cadPallet;
    FieldsAcessoTelas.cadRomaneio = listaDadosAcessoTelas[0].cadRomaneio;
    FieldsAcessoTelas.processoMadeira =
        listaDadosAcessoTelas[0].processoMadeira;
    FieldsAcessoTelas.historicoPedidos =
        listaDadosAcessoTelas[0].historicoPedidos;
    FieldsAcessoTelas.pedidosCadastrados =
        listaDadosAcessoTelas[0].pedidosCadastrados;
    FieldsAcessoTelas.pedidosProducao =
        listaDadosAcessoTelas[0].pedidosProducao;
    FieldsAcessoTelas.pedidosProntos =
        listaDadosAcessoTelas[0].pedidosProntos;
    FieldsAcessoTelas.historicoRomaneios =
        listaDadosAcessoTelas[0].historicoRomaneios;
    FieldsAcessoTelas.listaClientes =
        listaDadosAcessoTelas[0].listaClientes;
    FieldsAcessoTelas.lixeiraGrupoPedidos =
        listaDadosAcessoTelas[0].lixeiraGrupoPedidos;
    FieldsAcessoTelas.financeiro = listaDadosAcessoTelas[0].financeiro;
    FieldsAcessoTelas.estatisticas = listaDadosAcessoTelas[0].estatisticas;
    FieldsAcessoTelas.listaDespesas =
        listaDadosAcessoTelas[0].listaDespesas;
    FieldsAcessoTelas.listaRecebimentos =
        listaDadosAcessoTelas[0].listaRecebimentos;
    FieldsAcessoTelas.vendaAvulso = listaDadosAcessoTelas[0].vendaAvulso;
  }
}
