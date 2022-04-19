class ModelsEstLote {
  String? metrosTotalAno;
  String? mediaMetrosMes;
  String? qtdMeses;
  //
  int? numeroMes;
  String? nomeMes;
  double?metrosTotalMes;
  //
  String? qtdEntradaLoteMes;
  double?metrosEntrada;
  String? dataEntrada;
  String? nomeFornecedor;
  //
  ModelsEstLote({
    this.metrosTotalAno,
    this.mediaMetrosMes,
    this.qtdMeses,
    this.numeroMes,
    this.nomeMes,
    this.metrosTotalMes,
    this.qtdEntradaLoteMes,
    this.dataEntrada,
    this.nomeFornecedor,
    this.metrosEntrada,
  });

  ModelsEstLote.fromJson(Map<String, dynamic> json) {
    metrosTotalAno = json['metros_total_ano'];
    qtdMeses = json['qtd_meses'];
    mediaMetrosMes = json['media_metros_mes'];
    numeroMes = json['numero_mes'];
    nomeMes = json['nome_mes'];
    metrosTotalMes = json['metros_total_mes']?.toDouble();
    metrosEntrada = json['metros_entrada'];
    qtdEntradaLoteMes = json['qtd_entrada_lote_mes'];
    dataEntrada = json['data_cadastro'];
    nomeFornecedor = json['nome_fornecedor'];
  }
}
