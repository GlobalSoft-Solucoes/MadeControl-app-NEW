class ModelsSaldoDevedor{
  var qtdDevedores;
  var saldoDevedorTotal;
  //
  int? idCliente;
  String? nomeCliente;
  String? saldoCliente;
  //
  String? cnpj;
  String? telefone;
  String? dataUltimoPedido;
  String? dividaCliente;
  String? cidade;

  ModelsSaldoDevedor({
    this.qtdDevedores,
    this.saldoDevedorTotal,
    this.idCliente,
    this.saldoCliente,
    this.cnpj,
    this.telefone,
    this.dataUltimoPedido,
    this.nomeCliente,
    this.dividaCliente,
    this.cidade,
  });
  ModelsSaldoDevedor.fromJson(Map<String, dynamic> json) {
    qtdDevedores = json['qtd_devedores'];
    saldoDevedorTotal = json['saldo_devedor_total'];
    idCliente = json['idcliente'];
    nomeCliente = json['nome_cliente'];
    saldoCliente = json['saldo_por_cliente'];
    cnpj = json['cnpj'];
    telefone = json['telefone'];
    dataUltimoPedido = json['data_ultimo_pedido'];
    dividaCliente = json['divida_cliente'];
    cidade = json['cidade'];
  }
}
