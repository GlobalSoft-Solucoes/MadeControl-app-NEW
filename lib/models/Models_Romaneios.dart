class ModelsRomaneio {
  int? idRomaneio;
  int? idUsuario;
  int? idGrupoPedido;
  int? motorista;
  String? destino;
  String? dataentrega;
  String? horaEntrega;
  String? observacoes;
  String? nomeCliente;
  String? nomeMotorista;
  String? codigoGrupo;

  ModelsRomaneio({
    this.dataentrega,
    this.destino,
    this.idGrupoPedido,
    this.idRomaneio,
    this.idUsuario,
    this.motorista,
    this.observacoes,
    this.nomeCliente,
    this.horaEntrega,
    this.nomeMotorista,
    this.codigoGrupo
  });

  ModelsRomaneio.fromJson(Map<String, dynamic> json) {
    idRomaneio = json['idromaneio'];
    idUsuario = json['idusuario'];
    idGrupoPedido = json['idgrupo_pedido'];
    motorista = json['motorista'];
    destino = json['destino'];
    observacoes = json['observacoes'];
    dataentrega = json['data_entrega'];
    horaEntrega = json['hora_entrega'];
    nomeCliente = json['nome_cliente'];
    nomeMotorista = json['nome_motorista'];
    codigoGrupo = json['codigo_grupo'];
  }
}
