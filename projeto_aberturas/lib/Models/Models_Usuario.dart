class ModelsUsuarios {
  int idUsuario;
  int idEmpresa;
  String name;
  String email;
  String adm;
  String senha;
  String cpf;
  ModelsUsuarios({
    this.idUsuario,
    this.idEmpresa,
    this.name,
    this.adm,
    this.email,
    this.senha,
    this.cpf,
  });
  ModelsUsuarios.fromJson(Map<String, dynamic> json) {
    idUsuario = json['IdUsuario'];
    idEmpresa = json['IdEmpresa'];
    name = json['Nome'];
    email = json['Email'];
    senha = json['Senha'];
    cpf = json['Cpf'];
    adm = json['Adm'];
  }
}
