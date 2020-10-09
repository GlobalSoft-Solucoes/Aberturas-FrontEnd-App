class FeedbackForm {
  var dataCadastro;
  var proprietario;
  var cidade;
  var comodo;
  var altura;
  var largura;
  var marco;
  var ladoabertura;
  var localizacao;
  var cor;
  var tipo;
  var estruturaPorta;
  var observacoes;
  var dobradica;
  var fechadura;
  var pivotante;
  var codReferencia;

  FeedbackForm(
      this.altura,
      this.cidade,
      this.codReferencia,
      this.comodo,
      this.cor,
      this.dataCadastro,
      this.dobradica,
      this.estruturaPorta,
      this.fechadura,
      this.ladoabertura,
      this.largura,
      this.localizacao,
      this.marco,
      this.observacoes,
      this.pivotante,
      this.proprietario,
      this.tipo);

  // Method to make GET parameters.
  String toParams() =>
      "?dataCadastro=$dataCadastro&cidade=$cidade&proprietario=$proprietario&comodo=$comodo&altura=$altura&largura=$largura&codReferencia=$codReferencia&cor=$cor&estruturaPorta=$estruturaPorta&fechadura=$fechadura&ladoAbertura=$ladoabertura&localizacao=$localizacao&marco=$marco&observacoes=$observacoes&pivotante=$pivotante&tipo=$tipo&dobradica=$dobradica";
}
