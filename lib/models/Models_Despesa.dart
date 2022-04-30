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
  int? numParcelas;
  String? dataVencimento;

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
    this.dataVencimento,
    this.numParcelas,
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
    dataVencimento = json['data_vencimento'];
    numParcelas = json['num_parcelas'];
  }
}

class ModelsParcelaDespesa {
  int? idParcelaDespesa;
  int? idDespesa;
  int? numParcela;
  String? valorParcela;
  String? vencimento;

  ModelsParcelaDespesa({
    this.idParcelaDespesa,
    this.idDespesa,
    this.numParcela,
    this.valorParcela,
    this.vencimento,
  });

  ModelsParcelaDespesa.fromJson(Map<String, dynamic> json) {
    idParcelaDespesa = json['idparcela_despesa'];
    idDespesa = json['iddespesa'];
    numParcela = json['num_parcela'];
    valorParcela = json['valor_parcela'];
    vencimento = json['vencimento'];
  }
}
