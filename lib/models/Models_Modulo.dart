class ModelsModulo {
  int? idModulo;
  int? idEmpresa;
  bool? processoPedido;
  bool? processoMadeira;
  ModelsModulo({
    this.idModulo,
    this.idEmpresa,
    this.processoPedido,
    this.processoMadeira,
  });
  ModelsModulo.fromJson(Map<String, dynamic> json) {
    idModulo = json['idmodulo'];
    idEmpresa = json['idempresa'];
    processoPedido = json['producao_pedido'];
    processoMadeira = json['processo_madeira'];
  }
}
