//
//  =========== ARQUIVO QUE CAPTURA OS DADOS DA EMPRESA DE ACORDO COM O USUÁRIO LOGADO =============
//
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:madecontrol_desenvolvimento/models/Models_Empresa.dart';
import 'package:madecontrol_desenvolvimento/models/Models_ProcessoMad.dart';
import 'package:madecontrol_desenvolvimento/models/Models_Usuario.dart';
import '../models/constantes.dart';

// ============ DADOS DO USUÁRIO LOGADO ===============
class FieldsProcessoMadeira {
  var listaDados = <MadProcessada>[];
  static int? tipoTora;
  static String? qtdProcessoTipoTora;
  static String? qtdTorrasPorTipoTora;

  Future<dynamic> detalhesProcessoPorTipoTora(tipoTota) async {
    var result = await http.get(
      Uri.parse(
        BuscaDetalhesMadPorTipoTora +
            tipoTota.toString() +
            '/' +
            ModelsUsuarios.caminhoBaseUser.toString(),
      ),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'authorization': ModelsUsuarios.tokenAuth.toString(),
      },
    );
    print(result.body);
    print(result.request);

    Iterable lista = json.decode(result.body);
    listaDados = lista.map((model) => MadProcessada.fromJson(model)).toList();
    qtdTorrasPorTipoTora = listaDados[0].qtdTorrasPorTipoTora;
  }
}
