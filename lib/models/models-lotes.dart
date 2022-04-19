class ModelsLotes {
  int? idLote;
  int? idUsuario;
  double?resultado;
  String? data;
  var quantidade;
  var media;
  String? fornecedor;
  String? responsavel;

  ModelsLotes({
    this.idLote,
    this.idUsuario,
    this.resultado,
    this.data,
    this.quantidade,
    this.media,
    this.fornecedor,
    this.responsavel,
  });

  ModelsLotes.fromJson(Map<String, dynamic> json) {
    idLote = json['idlote'];
    idUsuario = json['idusuario'];
    resultado = json['resultado']?.toDouble() ?? null;
    data = json['data_cadastro'];
    quantidade = json['quantidade'];
    media = json['media'];
    fornecedor = json['fornecedor'];
    responsavel = json['responsavel'];
  }
}
