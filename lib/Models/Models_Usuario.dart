class ModelsUsuarios {
  int idUsuario;
  int idEmpresa;
  String name;
  String email;
  String adm;
  String senha;
  String cpf;
  String token;
  String dataCadastro;
  static String tokenAuth;
  static int iddoUsuario;

  ModelsUsuarios({
    this.idUsuario,
    this.idEmpresa,
    this.name,
    this.adm,
    this.email,
    this.senha,
    this.cpf,
    this.token,
    this.dataCadastro,
  });

  ModelsUsuarios.fromJson(Map<String, dynamic> json) {
    idUsuario = json['idusuario'];
    idEmpresa = json['idempresa'];
    name = json['nome'];
    email = json['email'];
    senha = json['senha'];
    cpf = json['cpf'];
    adm = json['adm'];
    token = json['token'];
    dataCadastro = json['data_cadastro'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idusuario'] = this.idUsuario;
    data['idempresa'] = this.idEmpresa;
    data['nome'] = this.name;
    data['email'] = this.email;
    data['senha'] = this.senha;
    data['cpf'] = this.cpf;
    data['adm'] = this.adm;
    data['token'] = this.token;
    data['data_cadastro'] = this?.dataCadastro;
    return data;
  }
}
