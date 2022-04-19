class ModelsProduto {
  int? idProduto;
  String? nome;
  String? descricao;

  ModelsProduto({
    this.idProduto,
    this.descricao,
    this.nome,
  });

  ModelsProduto.fromJson(Map<String, dynamic> json) {
    idProduto = json['idproduto'];
    nome = json['nome'];
    descricao = json['descricao'];
  }
}
