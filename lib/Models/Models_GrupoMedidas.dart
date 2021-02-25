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
  String statusGrupo;
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
      this.cidade,
      this.statusGrupo});

  ModelGrupoMedidas.fromJson(Map<String, dynamic> json) {
    idGrupoMedidas = json['idgrupo_medidas'];
    idUsuario = json['idusuario'];
    idImovel = json['idimovel'];
    endereco = json['endereco'];
    dataCadastro = json['data_cadastro'];
    proprietario = json['proprietario'];
    numEndereco = json['num_endereco'];
    statusProcesso = json['status_processo'];
    cidade = json['cidade'];
    bairro = json['bairro'];
    statusGrupo = json['status_grupo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idgrupo_medidas'] = this.idGrupoMedidas;
    data['idusuario'] = this.idUsuario;
    data['idimovel'] = this.idImovel;
    data['endereco'] = this.endereco;
    data['enviado'] = this.enviado;
    data['proprietario'] = this.proprietario;
    data['num_endereco'] = this.numEndereco;
    data['status_processo'] = this.statusProcesso;
    data['cidade'] = this.cidade;
    data['bairro'] = this.bairro;
    data['status_grupo'] = this.statusGrupo;
    return data;
  }
}
