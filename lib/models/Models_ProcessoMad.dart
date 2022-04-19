class ModelsProcessoMad {
  int? idMadProcessada;
  int? idProcessoMadeira;
  String? dataProcesso;
  String? media;
  int? quantidadeTotal;
  String? statusProcesso;
  String? horaInicio;
  String? horaFim;
  String? tempoProcesso;
  String? nomeUsuario;
  String? qtdProcessoTipoTora;
  String? qtdTorrasPorTipoTora;

  ModelsProcessoMad({
    this.dataProcesso,
    this.idProcessoMadeira,
    this.media,
    this.quantidadeTotal,
    this.statusProcesso,
    this.horaFim,
    this.horaInicio,
    this.idMadProcessada,
    this.tempoProcesso,
    this.nomeUsuario,
    this.qtdProcessoTipoTora,
    this.qtdTorrasPorTipoTora,
  });

  ModelsProcessoMad.fromJson(Map<String, dynamic> json) {
    idProcessoMadeira = json['idprocesso_madeira'];
    dataProcesso = json['data_processo'];
    media = json['media'];
    horaInicio = json['hora_inicio'];
    horaFim = json['hora_fim'];
    quantidadeTotal = json['qtd_total'];
    statusProcesso = json['status_processo'];
    idMadProcessada = json['idmad_processada'];
    tempoProcesso = json['duracao_processo'];
    nomeUsuario = json['nome_usuario'];
    qtdProcessoTipoTora = json['qtd_processo_tipo_tora'];
    qtdTorrasPorTipoTora = json['qtd_torras_por_tipo_tora'];
  }
}

class MadProcessada {
  int? idMadProcessada;
  int? idProcessoMadeira;
  String? tempoProcesso;
  String? nomeUsuario;
  String? qtdTorrasPorTipoTora;
  String? data;
  int? tipoTora;

  MadProcessada({
    this.idProcessoMadeira,
    this.idMadProcessada,
    this.tempoProcesso,
    this.qtdTorrasPorTipoTora,
    this.data,
    this.nomeUsuario,
    this.tipoTora,
  });
  MadProcessada.fromJson(Map<String, dynamic> json) {
    idProcessoMadeira = json['idprocesso_madeira'];
    idMadProcessada = json['idmad_processada'];
    tempoProcesso = json['tempo_processo'];
    data = json['data'];
    qtdTorrasPorTipoTora = json['qtd_torras_por_tipo_tora'];
    nomeUsuario = json['nome_usuario'];
    tipoTora = json['tipo_tora'];
  }
}
