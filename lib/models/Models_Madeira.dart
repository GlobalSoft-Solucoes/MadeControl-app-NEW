class ModelsMadeira {
  int? idMadeira;
  String? nome;
  bool? madeiraLei;

  ModelsMadeira({
    this.idMadeira,
    this.madeiraLei,
    this.nome,
  });

  ModelsMadeira.fromJson(Map<String, dynamic> json) {
    idMadeira = json['idmadeira'];
    nome = json['nome'];
    madeiraLei = json['madeira_lei'];
  }
}
