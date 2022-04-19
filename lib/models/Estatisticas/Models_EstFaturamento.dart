class ModelsEstFaturamento {
  String? faturamentoTotalAno;
  String? mediaFaturamentoMes;
  String? qtdPedidosAno;
  String? qtdMeses;
  //
  int? numeroMes;
  String? nomeMes;
  String? valorTotalMes;
  String? qtdPedidosMes;
  //
  String? mediaFaturaPedidoMes;
  //
  String? nomeCliente;
  int? idCliente;
  String? faturamentoClienteMes;
  var percentualFaturaClienteMes;

  ModelsEstFaturamento({
    this.faturamentoTotalAno,
    this.mediaFaturamentoMes,
    this.qtdPedidosAno,
    this.qtdMeses,
    this.numeroMes,
    this.nomeMes,
    this.valorTotalMes,
    this.qtdPedidosMes,
    this.mediaFaturaPedidoMes,
    this.idCliente,
    this.nomeCliente,
    this.faturamentoClienteMes,
    this.percentualFaturaClienteMes,
  });

  ModelsEstFaturamento.fromJson(Map<String, dynamic> json) {
    faturamentoTotalAno = json['faturamento_total_ano'];
    qtdMeses = json['qtd_meses'];
    mediaFaturamentoMes = json['media_faturamento_mes'];
    qtdPedidosAno = json['qtd_pedidos_ano'];
    numeroMes = json['numero_mes'];
    nomeMes = json['nome_mes'];
    valorTotalMes = json['valor_total_mes'];
    qtdPedidosMes = json['qtd_pedidos_mes'];
    mediaFaturaPedidoMes = json['media_fatura_pedido_mes'];
    idCliente = json['idcliente'];
    nomeCliente = json['nome_cliente'];
    faturamentoClienteMes = json['faturamento_cliente_mes'];
    percentualFaturaClienteMes = json['percentual_faturamento_mes'];
  }
}
