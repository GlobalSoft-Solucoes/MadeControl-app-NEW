class ModelsProducao {
  int? idProducao;
  int? idPedido;
  String? dataInicio;
  String? dataFim;
  String? horaInicio;
  String? horaFim;
  String? duracaoProcesso;
  double?media;
  int? qtdProducao;
  double?percentualProduzido;
  ModelsProducao({
    this.idProducao,
    this.idPedido,
    this.dataInicio,
    this.dataFim,
    this.horaInicio,
    this.horaFim,
    this.duracaoProcesso,
    this.media,
    this.qtdProducao,
    this.percentualProduzido,
  });
  ModelsProducao.fromJson(Map<String, dynamic> json) {
    idProducao = json['idproducao'];
    idPedido = json['idpedido'];
    dataInicio = json['data_inicio'];
    dataFim = json['data_fim'];
    horaInicio = json['hora_inicio'];
    horaFim = json['hora_fim'];
    duracaoProcesso = json['duracao_processo'];
    media = json['media']?.toDouble();
    qtdProducao = json['qtd_producao'];
    percentualProduzido = json['percentual_produzido']?.toDouble();
  }
}
