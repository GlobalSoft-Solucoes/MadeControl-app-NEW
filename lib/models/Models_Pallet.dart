class ModelsPallet {
  int? idPallet;
  String? codigoPallet;
  String? nome;
  String? descricao;
  int? idUsuario;
  double?largura;
  double?comprimento;
  ModelsPallet({
    this.codigoPallet,
    this.descricao,
    this.idPallet,
    this.idUsuario,
    this.nome,
    this.largura,
    this.comprimento,
  });
  ModelsPallet.fromJson(Map<String, dynamic> json) {
    idPallet = json['idpallet'];
    codigoPallet = json['codigo_pallet'];
    nome = json['nome'];
    descricao = json['descricao'];
    idUsuario = json['idusuario'];
    largura = json['largura']?.toDouble();
    comprimento = json['comprimento']?.toDouble();
  }
}
