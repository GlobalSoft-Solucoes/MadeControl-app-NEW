class ModelsLogUsuario {
  int? idLogin;
  int? idUsuario;
  String? dataLogin;
  String? horaLogin;
  String? mensagem;
  String? nomeUsuario;
  ModelsLogUsuario(
      {this.dataLogin,
      this.horaLogin,
      this.mensagem,
      this.idLogin,
      this.idUsuario,
      this.nomeUsuario});

  ModelsLogUsuario.fromJson(Map<String, dynamic> json) {
    idLogin = json['idlogin'];
    idUsuario = json['idusuario'];
    dataLogin = json['data_login'].toString();
    horaLogin = json['hora_login'].toString();
    mensagem = json['mensagem'].toString();
    nomeUsuario = json['nome_usuario'];
  }
}
