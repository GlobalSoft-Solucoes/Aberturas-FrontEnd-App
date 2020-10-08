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
      "?altura=$altura&cidade=$cidade&codReferencia=$codReferencia&comodo=$comodo&cor=$cor&dataCadastro=$dataCadastro&estruturaPorta=$estruturaPorta&fechadura=$fechadura&ladoAbertura=$ladoabertura&largura=$largura&localizacao=$localizacao&marco=$marco&observacoes=$observacoes&pivotante=$pivotante&proprietario=$proprietario&tipo=$tipo&dobradica=$dobradica";
}
