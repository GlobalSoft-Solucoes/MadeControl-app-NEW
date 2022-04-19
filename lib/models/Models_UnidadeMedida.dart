class ModelsUnidadeMedida {
  int? idunidadeMedida;
  String? nomeUnidade;
  double?totalQtdMetros;

  ModelsUnidadeMedida({
    this.idunidadeMedida,
    this.nomeUnidade,
    this.totalQtdMetros,
  });
  
  ModelsUnidadeMedida.fromJson(Map<String, dynamic> json) {
    idunidadeMedida = json['idunidade_medida'];
    nomeUnidade = json['nome'];
    totalQtdMetros = json['total_qtd_metros']?.toDouble();
  }
}
