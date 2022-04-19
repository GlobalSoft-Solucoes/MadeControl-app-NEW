class ModelCalculos {
  int? idCalculos;
  int? idLote;
  double?diametroMenor;
  double?comprimento;
  double?resultado;
  var quantidade;
  double?media;
  
  ModelCalculos({
    this.idCalculos,
    this.idLote,
    this.diametroMenor,
    this.comprimento,
    this.resultado,
    /*this.media,
      this.quantidade*/
  });

  ModelCalculos.fromJson(Map<String, dynamic> json) {
    idCalculos = json['idcalculo'];
    idLote = json['idlote'];
    diametroMenor = json['diametromenor']?.toDouble();
    comprimento = json['comprimento']?.toDouble();
    resultado = json['resultado']?.toDouble();
    quantidade = json['soma_qtd'];
  }
}
