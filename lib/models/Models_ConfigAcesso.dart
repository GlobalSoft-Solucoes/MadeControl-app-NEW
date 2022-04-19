class ModelsAcessoTelas {
  int? idAcessoTelas;
  int? idUsuario;
  String? nomeUsuario;
  bool? cadUsuario;
  bool? cadCargo;
  bool? cadLote;
  bool? cadPedido;
  bool? cadProduto;
  bool? cadMadeira;
  bool? cadPallet;
  bool? cadRomaneio;
  bool? processoMadeira;
  bool? historicoPedidos;
  bool? pedidosCadastrados;
  bool? pedidosProducao;
  bool? pedidosProntos;
  bool? historicoRomaneios;
  bool? listaClientes;
  bool? lixeiraGrupoPedidos;
  bool? financeiro;
  bool? estatisticas;
  bool? listaDespesas;
  bool? listaRecebimentos;
  bool? vendaAvulso;

  ModelsAcessoTelas({
    this.idAcessoTelas,
    this.idUsuario,
    this.nomeUsuario,
    this.cadUsuario,
    this.cadCargo,
    this.cadLote,
    this.cadPedido,
    this.cadProduto,
    this.cadMadeira,
    this.cadPallet,
    this.cadRomaneio,
    this.processoMadeira,
    this.historicoPedidos,
    this.pedidosCadastrados,
    this.pedidosProducao,
    this.pedidosProntos,
    this.historicoRomaneios,
    this.listaClientes,
    this.lixeiraGrupoPedidos,
    this.financeiro,
    this.estatisticas,
    this.listaDespesas,
    this.listaRecebimentos,
    this.vendaAvulso,
  });

  ModelsAcessoTelas.fromJson(Map<String, dynamic> json) {
    idAcessoTelas = json['idacesso_telas'];
    idUsuario = json['idusuario'];
    nomeUsuario = json['nome_usuario'];
    cadUsuario = json['cad_usuario'];
    cadCargo = json['cad_cargo'];
    cadLote = json['cad_lote'];
    cadPedido = json['cad_pedido'];
    cadPallet = json['cad_pallet'];
    cadProduto = json['cad_produto'];
    cadMadeira = json['cad_madeira'];
    cadRomaneio = json['cad_romaneio'];
    processoMadeira = json['processo_madeira'];
    historicoPedidos = json['historico_pedidos'];
    pedidosCadastrados = json['pedidos_cadastrados'];
    pedidosProducao = json['pedidos_producao'];
    pedidosProntos = json['pedidos_prontos'];
    historicoRomaneios = json['historico_romaneios'];
    listaClientes = json['lista_clientes'];
    lixeiraGrupoPedidos = json['lixeira_grupopedidos'];
    financeiro = json['financeiro'];
    estatisticas = json['estatisticas'];
    listaDespesas = json['lista_despesas'];
    listaRecebimentos = json['lista_recebimentos'];
    vendaAvulso = json['venda_avulso'];
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['idacesso_telas'] = this.idAcessoTelas;
  //   data['idusuario'] = this.idUsuario;
  //   data['lista_usuarios'] = this.listaUsuarios;
  //   data['cad_usuario'] = this.cadUsuario;
  //   data['cad_cargo'] = this.cadCargo;
  //   data['cad_lote'] = this.cadLote;
  //   data['cad_pedido'] = this.cadPedido;
  //   data['processo_madeira'] = this.processoMadeira;
  //   data['historico_pedido'] = this.historicoPedido;
  //   data['cad_romaneio'] = this.cadRomaneio;
  //   data['historico_romaneio'] = this.historicoRomaneio;
  //   data['Nome_Usuario'] = this.nomeUsuario;
  //   data['lista_clientes'] = this.listaClientes;
  //   data['lixeira_grupopedidos'] = this.lixeiraGrupoPedidos;
  //   data['cad_cliente'] = this.cadCliente;
  //   data['cad_pedido'] = this.cadPallet;
  //   data['pedidos_cadastrados'] = this.listaPedidosCadastrados;
  //   data['pedidos_prontos'] = this.listaPedidosProntos;
  //   return data;
  // }
}
