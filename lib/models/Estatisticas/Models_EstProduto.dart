class ModelsEstProduto {
  String? qtdprodutos;
  String? qtdPedidosTotal;
  String? valorTotalAno;
  //
  int? idProduto;
  int? idPallet;
  String? nomeProduto;
  String? nomePallet;
  String? qtdPedidosAno;
  String? totalVendaProduto;
  String? percentualMediaVendaAno;
  String? precoMedioVendaAno;
  //
  String? dataUltimoPedido;
  String? qtdPedidosTotalProduto;
  String? faturamentoTotalProduto;
  //
  var numeroMes;
  String? nomeMes;
  String? valorTotalMes;
  String? qtdPedidosMes;
  String? precoMedioVendaMes;

  ModelsEstProduto({
    this.qtdprodutos,
    this.qtdPedidosTotal,
    this.valorTotalAno,
    this.idProduto,
    this.idPallet,
    this.nomePallet,
    this.nomeProduto,
    this.qtdPedidosAno,
    this.totalVendaProduto,
    this.percentualMediaVendaAno,
    this.precoMedioVendaAno,
    this.dataUltimoPedido,
    this.qtdPedidosTotalProduto,
    this.faturamentoTotalProduto,
    this.numeroMes,
    this.nomeMes,
    this.valorTotalMes,
    this.qtdPedidosMes,
    this.precoMedioVendaMes,
  });

  ModelsEstProduto.fromJson(Map<String, dynamic> json) {
    qtdprodutos = json['qtd_produtos'];
    qtdPedidosTotal = json['qtd_pedidos_total_ano'];
    valorTotalAno = json['valor_total_ano'];
    //
    idProduto = json['idproduto'];
    nomeProduto = json['nome'];
    idPallet = json['idpallet'];
    nomePallet = json['nome_pallet'];
    qtdPedidosAno = json['qtd_pedidos_ano'];
    totalVendaProduto = json['total_venda_produto'];
    percentualMediaVendaAno = json['percentual_faturamento_produto'];
    precoMedioVendaAno = json['preco_medio_venda_ano'];
    //
    dataUltimoPedido = json['data_ultimo_pedido'];
    qtdPedidosTotalProduto = json['qtd_pedidos_total_produto'];
    faturamentoTotalProduto = json['faturamento_total_produto'];
    //
    numeroMes = json['numero_mes'];
    nomeMes = json['nome_mes'];
    valorTotalMes = json['valor_total_mes'];
    qtdPedidosMes = json['qtd_pedidos_mes'];
    precoMedioVendaMes = json['preco_medio_venda_mes'];
  }
}
