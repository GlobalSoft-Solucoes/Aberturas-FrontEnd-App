class ModelsTipoPorta {
  int idTipoPorta;
  String nome;
  String descricao;
  double descontoAltura;
  double descontoLargura;

  ModelsTipoPorta({
    this.idTipoPorta,
    this.nome,
    this.descricao,
    this.descontoAltura,
    this.descontoLargura,
  });
  ModelsTipoPorta.fromJson(Map<String, dynamic> json) {
    idTipoPorta = json['idtipo_porta'];
    nome = json['nome'];
    descricao = json['descricao'];
    descontoAltura = json['desconto_altura']?.toDouble();
    descontoLargura = json['desconto_largura']?.toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idtipo_porta'] = this.idTipoPorta;
    data['nome'] = this.nome;
    data['descricao'] = this.descricao;
    data['desconto_altura'] = this?.descontoAltura;
    data['desconto_largura'] = this?.descontoLargura;
    return data;
  }
}
