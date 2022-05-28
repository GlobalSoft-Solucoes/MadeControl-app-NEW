class ModelsProcProduto {
  int? idProcessoProduto;
  String? produto;
  int? quantidade;
  String? metrosCubicos;
  String? data;
  String? hora;
  int? numProduto;
  String? qtdCubicosPorTipo;
  String? qtdPacotePorTipo;
  String? qtdPecasPorTipo;
  String? qtdPacote;
  String? qtdCubicos;
  String? qtdPecas;
  String? opcMedida;
  String? totalPacotesPorTipoMedida;
  String? totalCubicosPorTipoMedida;
  String? totalPecasPorTipoMedida;
  String? madeira;
  String? medida;
  String? tipoMedida;

  ModelsProcProduto({
    this.idProcessoProduto,
    this.produto,
    this.quantidade,
    this.metrosCubicos,
    this.data,
    this.hora,
    this.numProduto,
    this.qtdCubicosPorTipo,
    this.qtdPacotePorTipo,
    this.qtdPacote,
    this.qtdCubicos,
    this.opcMedida,
    this.totalPacotesPorTipoMedida,
    this.totalCubicosPorTipoMedida,
    this.madeira,
    this.medida,
    this.tipoMedida,
    this.qtdPecasPorTipo,
    this.qtdPecas,
    this.totalPecasPorTipoMedida,
  });
  ModelsProcProduto.fromJson(Map<String, dynamic> json) {
    idProcessoProduto = json['idprocesso_produto'];
    produto = json['produto'];
    quantidade = json['quantidade'];
    metrosCubicos = json['metros_cubicos'];
    data = json['data'];
    hora = json['hora'];
    numProduto = json['num_produto'];
    qtdCubicosPorTipo = json['qtd_cubicos_por_tipo'];
    qtdPacotePorTipo = json['qtd_pacote_por_tipo'];
    qtdPacote = json['qtd_pacote'];
    qtdCubicos = json['qtd_cubicos'];
    opcMedida = json['opc_medida'];
    totalPacotesPorTipoMedida = json['total_pacotes_por_tipo_medida'];
    totalCubicosPorTipoMedida = json['total_cubicos_por_tipo_medida'];
    totalPecasPorTipoMedida = json['total_pecas_por_tipo_medida'];
    madeira = json['madeira'];
    medida = json['medida'];
    tipoMedida = json['tipo_medida'];
    qtdPecasPorTipo = json['qtd_pecas_por_tipo'];
    qtdPecas = json['qtd_pecas'];
  }
}
