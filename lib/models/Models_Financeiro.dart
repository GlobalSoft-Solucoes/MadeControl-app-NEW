class ModelsFinanceiro {
  String? valorTotalDespesas;
  String? valorTotalPedidos;
  String? saldoSemana;
  String? saldoMes;
  String? saldoAno;
  String? saldoHistorico;

  ModelsFinanceiro({
    this.valorTotalPedidos,
    this.valorTotalDespesas,
    this.saldoSemana,
    this.saldoMes,
    this.saldoAno,
    this.saldoHistorico,
  });

  ModelsFinanceiro.fromJson(Map<String, dynamic> json) {
    valorTotalPedidos = json['valor_total_pedidos'];
    valorTotalDespesas = json['valor_total_despesas'];
    saldoSemana = json['saldo_semana'];
    saldoMes = json['saldo_mes'];
    saldoAno = json['saldo_ano'];
    saldoHistorico = json['saldo_historico'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['valor_total_pedidos'] = this.valorTotalPedidos;
    data['valor_total_despesas'] = this.valorTotalDespesas;
    data['saldo_semana'] = this.saldoSemana;
    data['saldo_mes'] = this.saldoMes;
    data['saldo_ano'] = this.saldoAno;
    data['saldo_historico'] = this.saldoHistorico;
    return data;
  }
}
