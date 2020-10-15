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
    idEmpresa = json['IdEmpresa'];
    nome = json['Nome'];
    cnpj = json['Cnpj'];
    codAcesso = json['Cod_Acesso'];
    codAdm = json['Cod_Adm'];
    email = json['Email'];
    senha = json['Senha'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['IdEmpresa'] = this.idEmpresa;
    data['Nome'] = this.nome;
    data['Cnpj'] = this.cnpj;
    data['Cod_Acesso'] = this.codAcesso;
    data['Cod_Adm'] = this.codAdm;
    data['Email'] = this.email;
    data['Senha'] = this.senha;
    return data;
  }
}
