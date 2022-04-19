class ModelsEmpresa {
  int? idEmpresa;
  String? nome;
  String? email;
  String? senha;
  String? codadm;
  String? cnpj;
  ModelsEmpresa({
    this.idEmpresa,
    this.email,
    this.senha,
    this.nome,
    this.codadm,
    this.cnpj,
  });
  ModelsEmpresa.fromJson(Map<String, dynamic> json) {
    idEmpresa = json['idempresa'];
    nome = json['nome'];
    email = json['email'];
    senha = json['senha'];
    codadm = json['cod_adm'];
    cnpj = json['cnpj'];
  }
}
