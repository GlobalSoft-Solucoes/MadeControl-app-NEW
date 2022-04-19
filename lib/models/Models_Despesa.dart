class ModelsDespesa {
  int? idDespesa;
  int? idUsuario;
  int? idTipoDespesa;
  String? descricao;
  String? dataDespesa;
  String? valorDespesa;
  String? observacoes;
  String? horaDespesa;
  String? nomeTipoDespesa;
  String? nomeUsuario;
  String? valorTotalTodosDespesas;
  String? qtdDespesas;

  ModelsDespesa({
    this.idDespesa,
    this.idUsuario,
    this.idTipoDespesa,
    this.descricao,
    this.dataDespesa,
    this.valorDespesa,
    this.observacoes,
    this.horaDespesa,
    this.nomeTipoDespesa,
    this.nomeUsuario,
    this.valorTotalTodosDespesas,
    this.qtdDespesas,
  });
  ModelsDespesa.fromJson(Map<String, dynamic> json) {
    idDespesa = json['iddespesa'];
    idUsuario = json['idusuario'];
    idTipoDespesa = json['idtipo_despesa'];
    descricao = json['descricao'];
    valorDespesa = json['valor_despesa'];
    dataDespesa = json['data_despesa'];
    observacoes = json['observacoes'];
    horaDespesa = json['hora_despesa'];
    nomeTipoDespesa = json['nome_tipo_despesa'];
    nomeUsuario = json['nome_usuario'];
    valorTotalTodosDespesas = json['valor_total_despesa'];
    qtdDespesas = json['qtd_despesas'];
  }
}
