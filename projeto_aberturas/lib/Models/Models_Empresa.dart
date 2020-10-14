class ModelsEmpresa {
  int idEmpresa;
  String nome;
  String cnpj;
  String cod_Acesso;
  String cod_Adm;
  String email;
  String senha;

  ModelsEmpresa({
    this.idEmpresa,
    this.nome,
    this.cnpj,
    this.cod_Acesso,
    this.cod_Adm,
    this.email,
    this.senha,
  });
  ModelsEmpresa.fromJson(Map<String, dynamic> json) {
    idEmpresa = json['IdEmpresa'];
    nome = json['Nome'];
    cnpj = json['Cnpj'];
    cod_Acesso = json['Cod_Acesso'];
    cod_Adm = json['Cod_Adm'];
    email = json['Email'];
    senha = json['Senha'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['IdEmpresa'] = this.idEmpresa;
    data['Nome'] = this.nome;
    data['Cnpj'] = this.cnpj;
    data['Cod_Acesso'] = this.cod_Acesso;
    data['Cod_Adm'] = this.cod_Adm;
    data['Email'] = this.email;
    data['Senha'] = this.senha;
    return data;
  }
}
