class ModelsEmpresa {
  int idEmpresa;
  String nome;
  String cnpj;
  String codAcesso;
  String codAdm;
  String email;
  String senha;

  ModelsEmpresa({
    this.idEmpresa,
    this.nome,
    this.cnpj,
    this.codAcesso,
    this.codAdm,
    this.email,
    this.senha,
  });
  ModelsEmpresa.fromJson(Map<String, dynamic> json) {
    idEmpresa = json['idempresa'];
    nome = json['nome'];
    cnpj = json['cnpj'];
    codAcesso = json['cnpj'];
    codAdm = json['cod_adm'];
    email = json['email'];
    senha = json['senha'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idempresa'] = this.idEmpresa;
    data['nome'] = this.nome;
    data['cnpj'] = this.cnpj;
    data['cnpj'] = this.codAcesso;
    data['cod_adm'] = this.codAdm;
    data['email'] = this.email;
    data['senha'] = this.senha;
    return data;
  }
}
