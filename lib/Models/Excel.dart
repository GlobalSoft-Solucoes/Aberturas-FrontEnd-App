class FeedbackForm {
  String dataCadastro;
  String proprietario;
  String cidade;
  String comodo;
  String altura;
  String largura;
  String marco;
  String ladoabertura;
  String localizacao;
  String cor;
  String tipo;
  String estruturaPorta;
  String observacoes;
  String dobradica;
  String fechadura;
  String pivotante;
  String codReferencia;
  String usuario;

  FeedbackForm(
    this.dataCadastro,
    this.proprietario,
    this.cidade,
    this.comodo,
    this.altura,
    this.largura,
    this.marco,
    this.ladoabertura,
    this.localizacao,
    this.cor,
    this.tipo,
    this.estruturaPorta,
    this.observacoes,
    this.dobradica,
    this.fechadura,
    this.pivotante,
    this.codReferencia,
    this.usuario,
  );
  String toParams() =>
      "?dataCadastro=$dataCadastro&proprietario=$proprietario&cidade=$cidade&comodo=$comodo&altura=$altura&largura=$largura&marco=$marco&ladoAbertura=$ladoabertura&localizacao=$localizacao&cor=$cor&tipo=$tipo&estruturaPorta=$estruturaPorta&observacoes=$observacoes&dobradica=$dobradica&fechadura=$fechadura&pivotante=$pivotante&codReferencia=$codReferencia&usuario=$usuario";
}

//"?dataCadastro=$dataCadastro&proprietario=$proprietario&cidade=$cidade&comodo=$comodo&altura=$altura&largura=$largura&marco=$marco&ladoAbertura=$ladoabertura&localizacao=$localizacao";
