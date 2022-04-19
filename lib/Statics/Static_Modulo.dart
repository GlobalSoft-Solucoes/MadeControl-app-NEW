import 'dart:convert';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:http/http.dart' as http;
import 'package:madecontrol_desenvolvimento/models/Models_Modulo.dart';
import '../../models/Models_Usuario.dart';
import '../models/constantes.dart';

class FieldsModulo {
  static int? idModulo;
  static int? idEmpresa;
  static bool? processoPedido;
  static bool? processoMadeira;

  var listaModulosEmpresa = <ModelsModulo>[];

  Future buscaModelsPorEmpresa(idEmpresaSelecionada) async {
    var result = await http.get(
      Uri.parse(
        BuscarModuloPorEmpresa +
            idEmpresaSelecionada.toString() +
            '/' +
            ModelsUsuarios.caminhoBaseUser.toString(),
      ),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'authorization': ModelsUsuarios.tokenAuth.toString(),
      },
    );
    print(result.statusCode);
    if (result.statusCode == 200) {
      Iterable lista = json.decode(result.body);

      listaModulosEmpresa =
          lista.map((model) => ModelsModulo.fromJson(model)).toList();
      if (listaModulosEmpresa.toList().length > 0) {
        FieldsModulo.idModulo = listaModulosEmpresa[0].idModulo;
        FieldsModulo.idEmpresa = listaModulosEmpresa[0].idEmpresa;
        FieldsModulo.processoPedido = listaModulosEmpresa[0].processoPedido;
        FieldsModulo.processoMadeira =
            listaModulosEmpresa[0].processoMadeira;
      }
    }
  }
}
