class ModelGrupoMedidas {
  String statusProcesso;
  String enviado;
  int idGrupoMedidas;
  int idUsuario;
  int idImovel;
  String endereco;
  String dataCadastro;
  String proprietario;
  int numEndereco;
  String cidade;
  String bairro;
  ModelGrupoMedidas(
      {this.statusProcesso,
      this.enviado,
      this.idGrupoMedidas,
      this.idUsuario,
      this.idImovel,
      this.endereco,
      this.dataCadastro,
      this.proprietario,
      this.numEndereco,
      this.bairro,
      this.cidade});

  ModelGrupoMedidas.fromJson(Map<String, dynamic> json) {
    idGrupoMedidas = json['IdGrupo_Medidas'];
    idUsuario = json['IdUsuario'];
    idImovel = json['IdImovel'];
    endereco = json['Endereco'];
    dataCadastro = json['Data_Cadastro'];
    proprietario = json['Proprietario'];
    numEndereco = json['Num_Endereco'];
    statusProcesso = json['Status_Processo'];
    cidade = json['Cidade'];
    bairro = json['Bairro'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['IdGrupo_Medidas'] = this.idGrupoMedidas;
    data['IdUsuario'] = this.idUsuario;
    data['IdImovel'] = this.idImovel;
    data['Endereco'] = this.endereco;
    data['Enviado'] = this.enviado;
    data['Proprietario'] = this.proprietario;
    data['Num_Endereco'] = this.numEndereco;
    data['Status_Processo'] = this.statusProcesso;
    data['Cidade'] = this.cidade;
    data['Bairro'] = this.bairro;
    return data;
  }
}
