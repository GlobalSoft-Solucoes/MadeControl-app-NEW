class ModelsEstClientes {
  int? idCliente;
  String? mediaFaturamentoPedido;
  String? qtdTotalPedidos;
  String? faturamentoTotalPedidos;
  //
  String? faturamentoIndividual;
  var representacaoFaturamento;
  //
  String? nomeCliente;
  String? cnpj;
  String? dataUltimoPedido;
  String? faturamentoCliente;
  String? qtdTotalPedidosCliente;
  String? mediaFaturamentoCliente;

  ModelsEstClientes({
    this.idCliente,
    this.mediaFaturamentoPedido,
    this.qtdTotalPedidos,
    this.faturamentoTotalPedidos,
    this.faturamentoIndividual,
    this.representacaoFaturamento,
    this.nomeCliente,
    this.cnpj,
    this.dataUltimoPedido,
    this.faturamentoCliente,
    this.qtdTotalPedidosCliente,
    this.mediaFaturamentoCliente,
  });
  ModelsEstClientes.fromJson(Map<String, dynamic> json) {
    idCliente = json['idcliente'];
    mediaFaturamentoPedido = json['media_faturamento_pedido'];
    qtdTotalPedidos = json['qtd_total_pedidos'];
    faturamentoTotalPedidos = json['faturamento_total_pedidos'];
    faturamentoIndividual = json['faturamento_individual'];
    representacaoFaturamento = json['percentual_faturamento'];
    nomeCliente = json['nome_cliente'];
    cnpj = json['cnpj'];
    dataUltimoPedido = json['data_ultimo_pedido'];
    faturamentoCliente = json['faturamento_cliente'];
    qtdTotalPedidosCliente = json['qtd_total_pedidos_cliente'];
    mediaFaturamentoCliente = json['media_faturamento_cliente'];
  }
}
