class ModelsUsuarios {
  int? idUsuario;
  int? idEmpresa;
  int? idCargo;
  String? name;
  String? email;
  String? senha;
  String? adm;
  String? token;
  String? cargoUsuario;
  String? caminho;
  String? codUsuario;

  var dataCadastro;
  static String? tokenAuth;
  static int? idDoUsuario;
  static String? caminhoBaseUser;

  ModelsUsuarios({
    this.idUsuario,
    this.idEmpresa,
    this.idCargo,
    this.name,
    this.adm,
    this.email,
    this.senha,
    this.dataCadastro,
    this.cargoUsuario,
    this.token,
    this.caminho,
    this.codUsuario,
  });

  ModelsUsuarios.fromJson(Map<String, dynamic> json) {
    idUsuario = json['idusuario'];
    idEmpresa = json['idempresa'];
    idCargo = json['idcargo'];
    name = json['nome'];
    email = json['email'];
    senha = json['senha'];
    adm = json['adm'];
    dataCadastro = json['data_cadastro'];
    cargoUsuario = json['cargo_usuario'];
    caminho = json['caminho'];
    codUsuario = json['codigo_usuario'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idusuario'] = this.idUsuario;
    data['idempresa'] = this.idEmpresa;
    data['idcargo'] = this.idCargo;
    data['nome'] = this.name;
    data['email'] = this.email;
    data['senha'] = this.senha;
    data['adm'] = this.adm;
    data['data_cadastro'] = this.dataCadastro;
    data['cargo_usuario'] = this.cargoUsuario;
    data['caminho'] = this.caminho;
    data['codigo_usuario'] = this.codUsuario;
    return data;
  }
}
