//
//  =========== ARQUIVO QUE CAPTURA OS DADOS DA EMPRESA DE ACORDO COM O USUÁRIO LOGADO =============
//
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:madecontrol_desenvolvimento/models/Models_Empresa.dart';
import 'package:madecontrol_desenvolvimento/models/Models_Usuario.dart';
import '../models/constantes.dart';

// ============ DADOS DO USUÁRIO LOGADO ===============
class BuscaDadosEmpresaPorUsuario {
  var listaDadosEmpresa = <ModelsEmpresa>[];
  static int? idEmpresa;
  static String? nome;
  static String? email;
  static String? senha;
  static String? codAdm;
  static String? cnpj;

  Future<dynamic> capturaDadosEmpresa(idUsuario) async {
    var result = await http.get(
      Uri.parse(
        BuscarEmpresaPorIdUsuario + idUsuario.toString() + '/' +  ModelsUsuarios.caminhoBaseUser.toString(),
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
    listaDadosEmpresa =
        lista.map((model) => ModelsEmpresa.fromJson(model)).toList();
    idEmpresa = listaDadosEmpresa[0].idEmpresa;
    nome = listaDadosEmpresa[0].nome;
    email = listaDadosEmpresa[0].email;
    senha = listaDadosEmpresa[0].senha;
    cnpj = listaDadosEmpresa[0].cnpj;
    codAdm = listaDadosEmpresa[0].codadm; 
  }
}
