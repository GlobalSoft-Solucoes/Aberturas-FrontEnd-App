class Imoveis {
  int id;
  String name;
  Imoveis({this.id, this.name});
  Imoveis.fromJson(Map<String, dynamic> json) {
    id = json['IdImovel'];
    name = json['Nome'];
  }
}
