class Referencias {
  int idCodReferencia;
  String codigo;
  Referencias({this.idCodReferencia, this.codigo});
  Referencias.fromJson(Map<String, dynamic> json) {
    idCodReferencia = json['idcod_referencia'];
    codigo = json['codigo'];
  }
}

class Fechaduras {
  int idFechaduras;
  String nome;
  String descricao;
  Fechaduras({this.idFechaduras, this.nome, this.descricao});
  Fechaduras.fromJson(Map<String, dynamic> json) {
    idFechaduras = json['idfechadura'];
    nome = json['nome'];
    descricao = json['descricao'];
  }
}

class Dobradicas {
  int idDobradica;
  String nome;
  String descricao;
  Dobradicas({this.descricao, this.idDobradica, this.nome});
  Dobradicas.fromJson(Map<String, dynamic> json) {
    idDobradica = json['iddobradica'];
    nome = json['nome'];
    descricao = json['descricao'];
  }
}

class Pivotantes {
  int idPivotante;
  String nome;
  String descricao;
  Pivotantes({this.descricao, this.idPivotante, this.nome});
  Pivotantes.fromJson(Map<String, dynamic> json) {
    idPivotante = json['idpivotante'];
    nome = json['nome'];
    descricao = json['descricao'];
  }
}

class DadosExcel {
  static String cidade;
  static String proprietario;
}
