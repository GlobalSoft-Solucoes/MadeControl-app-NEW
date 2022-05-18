class ModelsModulo {
  int? idModulo;
  int? idEmpresa;
  bool? processoPedido;
  bool? processoMadeira;
  bool? processoProduto;
  ModelsModulo({
    this.idModulo,
    this.idEmpresa,
    this.processoPedido,
    this.processoMadeira,
    this.processoProduto,
  });
  ModelsModulo.fromJson(Map<String, dynamic> json) {
    idModulo = json['idmodulo'];
    idEmpresa = json['idempresa'];
    processoPedido = json['producao_pedido'];
    processoMadeira = json['processo_madeira'];
    processoProduto = json['processo_produto'];
  }
}
