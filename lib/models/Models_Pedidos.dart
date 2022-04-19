class ModelsPedidos {
  int? idGrupoPedido;
  int? idPedido;
  int? idPallet;
  int? idUsuario;
  int? idUnidadeMedida;
  int? idMadeira;
  int? idProduto;
  int? idProducao;
  String? codPedido;
  String? proprietario;
  double?comprimento;
  double?largura;
  double?espessura;
  double?quantidade;
  String? cidade;
  String? bairro;
  String? telefone;
  String? endereco;
  int? numResidencia;
  String? dataPedido;
  String? horaPedido;
  String? statusPedido;
  String? nomeCliente;
  String? nomePallet;
  String? observacoes;
  String? precoCubico;
  String? valorTotal;
  double?qtdMetros;
  String? valorTotalTodosPedidos;
  String? qtdPedidos;
  double?totalQtdMetros;
  String? nomeProduto;
  String? nomeUndMedida;
  String? nomeMadeira;
  bool? beneficiado;
  String? tipoProcesso;
  int? tipoCalculo;
  double?percentualProduzido;

  ModelsPedidos({
    this.nomePallet,
    this.nomeCliente,
    this.idGrupoPedido,
    this.statusPedido,
    this.dataPedido,
    this.idMadeira,
    this.idProduto,
    this.idPedido,
    this.codPedido,
    this.proprietario,
    this.comprimento,
    this.largura,
    this.espessura,
    this.quantidade,
    this.idUsuario,
    this.cidade,
    this.bairro,
    this.telefone,
    this.endereco,
    this.numResidencia,
    this.horaPedido,
    this.idPallet,
    this.observacoes,
    this.precoCubico,
    this.valorTotal,
    this.qtdMetros,
    this.valorTotalTodosPedidos,
    this.qtdPedidos,
    this.totalQtdMetros,
    this.nomeProduto,
    this.nomeMadeira,
    this.idUnidadeMedida,
    this.nomeUndMedida,
    this.beneficiado,
    this.tipoProcesso,
    this.tipoCalculo,
    this.idProducao,
    this.percentualProduzido,
  });

  ModelsPedidos.fromJson(Map<String, dynamic> json) {
    idPedido = json['idpedido'];
    idPallet = json['idpallet'];
    idUsuario = json['idusuario'];
    idGrupoPedido = json['idgrupo_pedido'];
    idUnidadeMedida = json['idunidade_medida'];
    idMadeira = json['idmadeira'];
    idProduto = json['idproduto'];
    idProducao = json['idproducao'];
    codPedido = json['cod_pedido'];
    proprietario = json['Proprietario'];
    comprimento = json['comprimento']?.toDouble();
    largura = json['largura']?.toDouble();
    espessura = json['espessura']?.toDouble();
    quantidade = json['quantidade']?.toDouble();
    cidade = json['cidade'];
    bairro = json['bairro'];
    telefone = json['telefone'];
    endereco = json['endereco'];
    numResidencia = json['num_residencia'];
    dataPedido = json['data_pedido'];
    horaPedido = json['hora_pedido'];
    statusPedido = json['Status_Pedido'];
    nomeCliente = json['nome_cliente'];
    nomePallet = json['nome_pallet'];
    observacoes = json['observacoes'];
    precoCubico = json['preco_metro'];
    valorTotal = json['valor_total'];
    qtdMetros = json['qtd_metros']?.toDouble();
    valorTotalTodosPedidos = json['valor_total_pedidos'];
    qtdPedidos = json['qtd_pedidos'];
    totalQtdMetros = json['total_qtd_metros']?.toDouble();
    nomeProduto = json['nome_produto'];
    nomeMadeira = json['nome_madeira'];
    nomeUndMedida = json['nome_undmedida'];
    beneficiado = json['beneficiado'];
    tipoProcesso = json['tipo_processo'];
    tipoCalculo = json['tipo_calculo'];
    percentualProduzido = json['percentual_produzido']?.toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idpedido'] = this.idPedido;
    data['cod_pedido'] = this.codPedido;
    data['Proprietario'] = this.proprietario;
    data['comprimento'] = this.comprimento;
    data['largura'] = this.largura;
    data['espessura'] = this.espessura;
    data['quantidade'] = this.quantidade;
    data['idusuario'] = this.idUsuario;
    data['cidade'] = this.cidade;
    data['bairro'] = this.bairro;
    data['telefone'] = this.telefone;
    data['endereco'] = this.endereco;
    data['num_residencia'] = this.numResidencia;
    data['data_pedido'] = this.dataPedido;
    data['hora_pedido'] = this.horaPedido;
    data['nome_cliente'] = this.nomeCliente;
    data['nome_pallet'] = this.nomePallet;
    data['observacoes'] = this.observacoes;
    data['preco_metro'] = this.precoCubico;
    data['valor_total'] = this.valorTotal;
    data['qtd_metros'] = this.qtdMetros;
    data['valor_total_pedidos'] = this.valorTotalTodosPedidos;
    data['total_qtd_metros'] = this.totalQtdMetros;
    data['qtd_pedidos'] = this.qtdPedidos;
    data['nome_produto'] = this.nomeProduto;
    data['nome_madeira'] = this.nomeMadeira;
    data['nome_undmedida'] = this.nomeUndMedida;
    data['beneficiado'] = this.beneficiado;
    data['tipo_processo'] = this.tipoProcesso;
    data['tipo_calculo'] = this.tipoCalculo;
    data['percentual_produzidos'] = this.percentualProduzido;
    return data;
  }
}
