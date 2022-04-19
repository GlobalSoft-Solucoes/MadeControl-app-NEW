//
//  =========== ARQUIVO QUE CAPTURA OS DADOS DO USUARIO LOGADO =============

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import '..//../models/Models_Usuario.dart';
import '../models/constantes.dart';

class FieldsUsuario {
  static int? idUsuario;
  static int? idEmpresa;
  static int? idCargo;
  static String? nome;
  static String? email;
  static String? senha;
  static String? adm;
  static String? token;
}

// ============ DADOS DE TODOS OS USUÁRIOS CADASTRADOS ===============
class ListaTodosUsuarios {
  var listaUsuarios = <ModelsUsuarios>[];
  static int? idUsuario;
  static int? idEmpresa;
  static int? idCargo;
  static String? nome;
  static String? email;
  static String? senha;
  static String? adm;
  static String? token;

  Future capturaDadosTodosUsuarios() async {
    var result = await http.get(
        Uri.parse(
          ListarTodosUsuarios + ModelsUsuarios.caminhoBaseUser.toString(),
        ),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'authorization': ModelsUsuarios.tokenAuth.toString(),
        });

    Iterable lista = json.decode(result.body);
    listaUsuarios =
        lista.map((model) => ModelsUsuarios.fromJson(model)).toList();
    idEmpresa ??= listaUsuarios[0].idEmpresa;
    nome = listaUsuarios[0].name;
    email = listaUsuarios[0].email;
    senha = listaUsuarios[0].senha;
    adm = listaUsuarios[0].adm;
  }
}

// ============ DADOS DO USUÁRIO LOGADO ===============
class BuscaDadosUsuarioPorId {
  var listaUsuarios = <ModelsUsuarios>[];
  static int? idUsuario;
  static int? idEmpresa;
  static int? idCargo;
  static String? nome;
  static String? email;
  static String? senha;
  static String? adm;
  static String? cargoUsuario;
  static String? token;

  Future capturaDadosUsuariosPorId(idUsuarioSelecionado) async {
    var result = await http.get(
      Uri.parse(
        BuscarUsuarioPorId +
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
    listaUsuarios =
        lista.map((model) => ModelsUsuarios.fromJson(model)).toList();
    idUsuario = listaUsuarios[0].idUsuario;
    idEmpresa = listaUsuarios[0].idEmpresa;
    idCargo = listaUsuarios[0].idCargo;
    nome = listaUsuarios[0].name;
    email = listaUsuarios[0].email;
    senha = listaUsuarios[0].senha;
    cargoUsuario = listaUsuarios[0].cargoUsuario;
    adm = listaUsuarios[0].adm;
  }
}
