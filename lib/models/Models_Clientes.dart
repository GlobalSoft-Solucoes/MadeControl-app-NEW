class ModelsClientes {
  int? idCliente;
  String? cidade;
  String? bairro;
  String? endereco;
  int? numResidencia;
  String? telefone;
  String? nome;
  String? cpf;
  String? cnpj;
  String? tipoPessoa;
  bool? dof;
  String? codigoCliente;

  ModelsClientes({
    this.idCliente,
    this.cidade,
    this.bairro,
    this.endereco,
    this.numResidencia,
    this.telefone,
    this.nome,
    this.cpf,
    this.cnpj,
    this.tipoPessoa,
    this.dof,
    this.codigoCliente,
  });

  ModelsClientes.fromJson(Map<String, dynamic> json) {
    idCliente = json['idcliente'];
    cidade = json['cidade'];
    bairro = json['bairro'];
    endereco = json['endereco'];
    numResidencia = json['num_residencia'];
    telefone = json['telefone'];
    nome = json['nome'];
    cpf = json['cpf'];
    cnpj = json['cnpj'];
    tipoPessoa = json['tipo_pessoa'];
    dof = json['dof'];
    codigoCliente = json['codigo_cliente'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idcliente'] = this.idCliente;
    data['cidade'] = this.cidade;
    data['bairro'] = this.bairro;
    data['endereco'] = this.endereco;
    data['num_residencia'] = this.numResidencia;
    data['telefone'] = this.telefone;
    data['nome'] = this.nome;
    data['cpf'] = this.cpf;
    data['cnpj'] = this.cnpj;
    data['tipo_pessoa'] = this.tipoPessoa;
    data['dof'] = this.dof;
    data['codigo_cliente'] = this.codigoCliente;
    return data;
  }
}
