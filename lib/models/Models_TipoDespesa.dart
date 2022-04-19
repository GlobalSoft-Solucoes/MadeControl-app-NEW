class ModelsTipoDespesa {
  int? idtipoDespesa;
  String? nome;
  String? descricao;
  ModelsTipoDespesa({
    this.idtipoDespesa,
    this.nome,
    this.descricao,
  });
  ModelsTipoDespesa.fromJson(Map<String, dynamic> json) {
    idtipoDespesa = json['idtipo_despesa'];
    nome = json['nome'];
    descricao = json['descricao'];
  }
}

class ModelsSubTipoDespesa {
  int? idSubTipoDespesa;
  int? idtipoDespesa;
  String? nome;
  String? totalGrupoDespesa;
  String? qtdDespesasGrupo;
  String? totalSubGrupoDespesa;
  String? qtdDespesasSubGrupo;
  // resumo despesas
  String? valorDespesasAno;
  String? totalNumMeses;
  String? qtdTotalGrupos;
  int? numeroMes;
  String? nomeMes;
  String? valorDespesaMes;
  String? qtdDespesasMes;
  String? mediaGastoPorDespesa;

  ModelsSubTipoDespesa({
    this.idSubTipoDespesa,
    this.idtipoDespesa,
    this.nome,
    this.qtdDespesasGrupo,
    this.totalGrupoDespesa,
    this.totalSubGrupoDespesa,
    this.qtdDespesasSubGrupo,
    this.valorDespesasAno,
    this.totalNumMeses,
    this.qtdTotalGrupos,
    this.nomeMes,
    this.numeroMes,
    this.qtdDespesasMes,
    this.valorDespesaMes,
    this.mediaGastoPorDespesa,
  });

  ModelsSubTipoDespesa.fromJson(Map<String, dynamic> json) {
    idSubTipoDespesa = json['idsub_tipo_despesa'];
    idtipoDespesa = json['idtipo_despesa'];
    nome = json['nome'];
    qtdDespesasGrupo = json['qtd_despesas_grupo_despesa'];
    totalGrupoDespesa = json['total_grupo_despesa'];
    totalSubGrupoDespesa = json['total_sub_grupo_despesa'];
    qtdDespesasSubGrupo = json['qtd_despesas_sub_grupo'];
    valorDespesasAno = json['valor_despesas_ano'];
    totalNumMeses = json['total_meses'];
    qtdTotalGrupos = json['total_grupos'];
    nomeMes = json['nome_mes'];
    numeroMes = json['numero_mes'];
    qtdDespesasMes = json['qtd_despesas_mes'];
    valorDespesaMes = json['valor_despesa_mes'];
    mediaGastoPorDespesa = json['media_gasto_por_despesa'];
  }
}
