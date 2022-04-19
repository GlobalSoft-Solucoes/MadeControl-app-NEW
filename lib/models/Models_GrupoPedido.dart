class ModelsGrupoPedido {
  int? idGrupoPedido;
  String? status;
  int? idCliente;
  int? idUsuario;
  int? idUnidadeMedida;
  String? dataCadastro;
  String? horaCadastro;
  String? dataEntrega;
  String? nomeCliente;
  String? codigoGrupo;
  String? nomeUsuario;
  String? qtdPedidos;
  double?totalQtdMetros;
  String? valorTotalPedidos;
  String? mediaPrecoMetro;
  String? tipoVenda;
  String? faturamentoGrupo;

  ModelsGrupoPedido({
    this.dataCadastro,
    this.idCliente,
    this.idGrupoPedido,
    this.idUsuario,
    this.status,
    this.nomeCliente,
    this.codigoGrupo,
    this.nomeUsuario,
    this.qtdPedidos,
    this.totalQtdMetros,
    this.valorTotalPedidos,
    this.mediaPrecoMetro,
    this.tipoVenda,
    this.idUnidadeMedida,
    this.faturamentoGrupo,
    this.horaCadastro,
    this.dataEntrega,
  });

  ModelsGrupoPedido.fromJson(Map<String, dynamic> json) {
    idGrupoPedido = json['idgrupo_pedido'];
    idUnidadeMedida = json['idunidade_medida'];
    status = json['status_grupo'];
    nomeCliente = json['nome_cliente'];
    dataCadastro = json['data_cadastro'];
    idUsuario = json['idusuario'];
    idCliente = json['idcliente'];
    codigoGrupo = json['codigo_grupo'];
    nomeUsuario = json['nome_usuario'];
    qtdPedidos = json['qtd_pedidos'];
    totalQtdMetros = json['total_qtd_metros']?.toDouble();
    valorTotalPedidos = json['valor_total_pedidos'];
    mediaPrecoMetro = json['media_preco_metro'];
    tipoVenda = json['tipo_venda'];
    faturamentoGrupo = json['faturamento_grupo'];
    horaCadastro = json['hora_cadastro'];
    dataEntrega = json['data_entrega'];
  }
}
