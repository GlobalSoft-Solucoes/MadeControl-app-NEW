//
//  =========== ARQUIVO QUE CAPTURA OS DADOS DO USUARIO LOGADO =============

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:madecontrol_desenvolvimento/models/Models_Romaneios.dart';
import '..//../models/Models_Usuario.dart';
import '../models/constantes.dart';

// ============ DADOS DE TODOS OS USU�RIOS CADASTRADOS ===============
class BuscaRomaneioPorId {
  var dadosRomaneio = <ModelsRomaneio>[];

  static int? idRomaneio;
  static int? idUsuario;
  static int? idGrupoPedido;
  static int? motorista;
  static String? dataEntrega;
  static String? horaEntrega;
  static String? destino;
  static String? observacoes;
  static String? nomeCliente;
  static String? nomeMotorista;
  static String? codigoGrupo;

  Future<dynamic> capturaDadosRomaneio(idDoRomaneio) async {
    var result = await http.get(
      Uri.parse(
        BuscarRomaneioPorId + idDoRomaneio.toString() + '/' +  ModelsUsuarios.caminhoBaseUser.toString(),
      ),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'authorization': ModelsUsuarios.tokenAuth.toString(),
      },
    );

    Iterable lista = json.decode(result.body);
    dadosRomaneio =
        lista.map((model) => ModelsRomaneio.fromJson(model)).toList();

    idRomaneio = dadosRomaneio[0].idRomaneio;
    idUsuario = dadosRomaneio[0].idUsuario;
    idGrupoPedido = dadosRomaneio[0].idGrupoPedido;
    dataEntrega = dadosRomaneio[0].dataentrega;
    horaEntrega = dadosRomaneio[0].horaEntrega;
    destino = dadosRomaneio[0].destino;
    observacoes = dadosRomaneio[0].observacoes;
    motorista = dadosRomaneio[0].motorista;
    nomeCliente = dadosRomaneio[0].nomeCliente;
    nomeMotorista = dadosRomaneio[0].nomeMotorista;
    codigoGrupo = dadosRomaneio[0].codigoGrupo;
  }
}
