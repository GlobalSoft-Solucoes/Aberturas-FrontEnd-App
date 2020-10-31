class ModelsMedidasUnt {
  int idMedidaUnt;
  int idGrupoMedidas;
  int idCodRef;
  int idRolPivotante;
  int idFechadura;
  int idDobradica;
  String comodo;
  double marco;
  double altura;
  String ladoAbertura;
  double largura;
  String localizacao;
  String tipoPorta;
  String estruturaPorta;
  String cor;
  String observacoes;
  String tipoMedida;
  dynamic dataCadastro;
  String nomePivotante;
  String nomeDobradica;
  String nomeFechadura;
  String codigoReferenciaNum;

  ModelsMedidasUnt({
    this.idGrupoMedidas,
    this.idMedidaUnt,
    this.comodo,
    this.localizacao,
    this.altura,
    this.ladoAbertura,
    this.largura,
    this.idCodRef,
    this.idFechadura,
    this.idRolPivotante,
    this.idDobradica,
    this.marco,
    this.tipoPorta,
    this.cor,
    this.observacoes,
    this.estruturaPorta,
    this.tipoMedida,
    this.dataCadastro,
    this.codigoReferenciaNum,
    this.nomeDobradica,
    this.nomeFechadura,
    this.nomePivotante,
  });
  ModelsMedidasUnt.fromJson(Map<String, dynamic> json) {
    idMedidaUnt = json['IdMedida_Unt'];
    idGrupoMedidas = json['IdGrupo_Medidas'];
    idRolPivotante = json['IdPivotante'];
    idDobradica = json['IdDobradica'];
    idFechadura = json['IdFechadura'];
    idCodRef = json['IdCod_Referencia'];
    comodo = json['Comodo'];
    altura = json['Altura']?.toDouble();
    ladoAbertura = json['Lado_Abertura'];
    largura = json['Largura']?.toDouble();
    estruturaPorta = json['Estrutura_Porta'];
    cor = json['Cor'];
    marco = json['Marco_Parede']?.toDouble();
    observacoes = json['Observacoes'];
    localizacao = json['Localizacao'];
    tipoPorta = json['Tipo_Porta'];
    tipoMedida = json['Tipo_Medida'];
    dataCadastro = json['Data_Cadastro'];
    nomeDobradica = json['Nome_Dobradica'];
    nomeFechadura = json['Nome_Fechadura'];
    nomePivotante = json['Nome_Pivotante'];
    codigoReferenciaNum = json['Cod_Referencia'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['IdGrupo_Medidas'] = this.idGrupoMedidas;
    data['IdCod_Referencia'] = this.idCodRef;
    data['IdPivotante'] = this.idRolPivotante;
    data['IdDobradica'] = this.idDobradica;
    data['Altura'] = this.altura;
    data['Lado_Abertura'] = this.ladoAbertura;
    data['IdFechadura'] = this.idFechadura;
    data['Tipo_Porta'] = this.tipoPorta;
    data['Estrutura_Porta'] = this.estruturaPorta;
    data['Cor'] = this.cor;
    data['Largura'] = this.largura;
    data['Localizacao'] = this.localizacao;
    data['Marco_Parede'] = this.marco;
    data['Comodo'] = this.comodo;
    data['Observacoes'] = this.observacoes;
    data['Tipo_Medida'] = this.tipoMedida;
    data['Data_Cadastro'] = this.dataCadastro;
    data['Nome_Dobradica'] = this.nomeDobradica;
    data['Nome_Fechadura'] = this.nomeFechadura;
    data['Nome_Pivotante'] = this.nomePivotante;
    data['Cod_Referencia'] = this.codigoReferenciaNum;
    return data;
  }
}
