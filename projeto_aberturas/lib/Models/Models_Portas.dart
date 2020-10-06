class Referencias {
  int idCodReferencia;
  String codigo;
  Referencias({this.idCodReferencia, this.codigo});
  Referencias.fromJson(Map<String, dynamic> json) {
    idCodReferencia = json['IdCod_Referencia'];
    codigo = json['Codigo'];
  }
}

class Fechaduras {
  int idFechaduras;
  String nome;
  String descricao;
  Fechaduras({this.idFechaduras, this.nome, this.descricao});
  Fechaduras.fromJson(Map<String, dynamic> json) {
    idFechaduras = json['IdFechadura'];
    nome = json['nome'];
    descricao = json['Descricao'];
  }
}

class Dobradicas {
  int idDobradica;
  String nome;
  String descricao;
  Dobradicas({this.descricao, this.idDobradica, this.nome});
  Dobradicas.fromJson(Map<String, dynamic> json) {
    idDobradica = json['IdDobradica'];
    nome = json['Nome'];
    descricao = json['Descricao'];
  }
}

class Pivotantes {
  int idPivotante;
  String nome;
  String descricao;
  Pivotantes({this.descricao, this.idPivotante, this.nome});
  Pivotantes.fromJson(Map<String, dynamic> json) {
    idPivotante = json['IdPivotante'];
    nome = json['Nome'];
    descricao = json['Descricao'];
  }
}
