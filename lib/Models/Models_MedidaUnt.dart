class ModelsMedidasUnt {
  int idMedidaUnt;
  int idGrupoMedidas;
  int idCodRef;
  int idRolPivotante;
  int idFechadura;
  int idDobradica;
  String comodo;
  double marco;
  double altura_Folha;
  double largura_Folha;
  double altura_Externa;
  double largura_Externa;
  String ladoAbertura;
  String localizacao;
  String tipoPorta;
  String estruturaPorta;
  String cor;
  String observacoes;
  String tipoMedida;
  dynamic dataCadastro;
  String horaCadastro;
  String nomePivotante;
  String nomeDobradica;
  String nomeFechadura;
  String codigoReferenciaNum;
  int numeroPorta;

  ModelsMedidasUnt({
    this.idGrupoMedidas,
    this.idMedidaUnt,
    this.comodo,
    this.localizacao,
    this.altura_Folha,
    this.largura_Folha,
    this.altura_Externa,
    this.largura_Externa,
    this.ladoAbertura,
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
    this.horaCadastro,
    this.codigoReferenciaNum,
    this.nomeDobradica,
    this.nomeFechadura,
    this.nomePivotante,
    this.numeroPorta,
  });
  ModelsMedidasUnt.fromJson(Map<String, dynamic> json) {
    idMedidaUnt = json['idmedida_unt'];
    idGrupoMedidas = json['idgrupo_medidas'];
    idRolPivotante = json['idpivotante'];
    idDobradica = json['iddobradica'];
    idFechadura = json['idfechadura'];
    idCodRef = json['idcod_referencia'];
    comodo = json['comodo'];
    altura_Folha = json['altura_folha']?.toDouble();
    largura_Folha = json['largura_folha']?.toDouble();
    altura_Externa = json['altura_externa']?.toDouble();
    largura_Externa = json['largura_externa']?.toDouble();
    ladoAbertura = json['lado_abertura'];
    estruturaPorta = json['estrutura_porta'];
    cor = json['cor'];
    marco = json['marco_parede']?.toDouble();
    observacoes = json['observacoes'];
    localizacao = json['localizacao'];
    tipoPorta = json['tipo_porta'];
    tipoMedida = json['tipo_medida'];
    dataCadastro = json['data_cadastro'];
    horaCadastro = json['hora_cadastro'];
    nomeDobradica = json['nome_dobradica'];
    nomeFechadura = json['nome_fechadura'];
    nomePivotante = json['nome_pivotante'];
    codigoReferenciaNum = json['cod_referencia'];
    numeroPorta = json['numero_porta'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idgrupo_medidas'] = this.idGrupoMedidas;
    data['idcod_referencia'] = this.idCodRef;
    data['idpivotante'] = this.idRolPivotante;
    data['iddobradica'] = this.idDobradica;
    data['altura_folha'] = this?.altura_Folha;
    data['largura_folha'] = this?.largura_Folha;
    data['altura_externa'] = this?.altura_Externa;
    data['largura_externa'] = this?.largura_Externa;
    data['idfechadura'] = this.idFechadura;
    data['lado_abertura'] = this.ladoAbertura;
    data['localizacao'] = this.localizacao;
    data['tipo_porta'] = this.tipoPorta;
    data['estrutura_porta'] = this.estruturaPorta;
    data['data_cadastro'] = this.dataCadastro;
    data['hora_cadastro'] = this.horaCadastro;
    data['cor'] = this.cor;
    data['marco_parede'] = this.marco;
    data['comodo'] = this.comodo;
    data['observacoes'] = this.observacoes;
    data['tipo_medida'] = this.tipoMedida;
    data['numero_porta'] = this.numeroPorta;
    data['nome_dobradica'] = this.nomeDobradica;
    data['nome_fechadura'] = this.nomeFechadura;
    data['nome_pivotante'] = this.nomePivotante;
    data['cod_referencia'] = this.codigoReferenciaNum;

    return data;
  }
}
