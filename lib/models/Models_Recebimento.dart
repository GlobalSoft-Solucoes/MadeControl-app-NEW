class ModelsRecebimento {
  int? idrecebimento;
  int? idcliente;
  String? valorRecebido;
  String? dataRecebimento;
  String? horaRecebimento;
  String? tipoPagamento;
  String? observacoes;
  String? nomeCliente;
  String? valorTotalRecebimentos;
  String? qtdTotalRecebimentos;
  int? numParcelas;
  String? dataCadastro;

  ModelsRecebimento({
    this.idrecebimento,
    this.idcliente,
    this.valorRecebido,
    this.dataRecebimento,
    this.horaRecebimento,
    this.tipoPagamento,
    this.observacoes,
    this.nomeCliente,
    this.valorTotalRecebimentos,
    this.qtdTotalRecebimentos,
    this.numParcelas,
    this.dataCadastro,
  });

  ModelsRecebimento.fromJson(Map<String, dynamic> json) {
    idrecebimento = json['idrecebimento'];
    idcliente = json['idcliente'];
    valorRecebido = json['valor_recebido'];
    dataRecebimento = json['data_recebimento'];
    horaRecebimento = json['hora_recebimento'];
    tipoPagamento = json['tipo_pagamento'];
    observacoes = json['observacoes'];
    nomeCliente = json['nome_cliente'];
    valorTotalRecebimentos = json['valor_total_recebimentos'];
    qtdTotalRecebimentos = json['qtd_recebimentos'];
    numParcelas = json['num_parcelas'];
    dataCadastro = json['data_cadastro'];
  }
}

class ModelsParcelaRecibo {
  int? idParcelaRecibo;
  int? idRecebimento;
  int? numParcela;
  String? valorParcela;
  String? vencimento;

  ModelsParcelaRecibo({
    this.idParcelaRecibo,
    this.idRecebimento,
    this.numParcela,
    this.valorParcela,
    this.vencimento,
  });

  ModelsParcelaRecibo.fromJson(Map<String, dynamic> json) {
    idParcelaRecibo = json['idparcela_recibo'];
    idRecebimento = json['idrecebimento'];
    numParcela = json['num_parcela'];
    valorParcela = json['valor_parcela'];
    vencimento = json['vencimento'];
  }
}
