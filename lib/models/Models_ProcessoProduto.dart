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
  String? qtdPacote;
  String? qtdCubicos;

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
  }
}
