class ModelsCargo {
  int? idCargo;
  String? nome;
  String? descricao;
  Map? dados;

  ModelsCargo({
    this.idCargo,
    this.nome,
    this.descricao,
  });

ModelsCargo.fromJson(Map<String, dynamic> json) {
    idCargo = json['idcargo'];
    nome = json['nome'];
    descricao = json['descricao'];
    dados = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idcargo'] = this.idCargo;
    data['nome'] = this.nome;
    data['descricao'] = this.descricao;
    return data;
  }
}
