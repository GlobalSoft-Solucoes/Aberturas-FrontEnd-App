import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:projeto_aberturas/Models/Models_GrupoMedidas.dart';
import 'package:projeto_aberturas/Models/Models_MedidaUnt.dart';
import 'package:projeto_aberturas/Models/constantes.dart';
import 'package:projeto_aberturas/Widget/MsgPopup.dart';

// NESTA TELA, E MOSTRADO TODOS OS DADOS DO IMOVEL SELECIONADO NA TELA ANTERIOR
class RelatorioMedidaUnt extends StatefulWidget {
  final int idGrupoMedidas;
  RelatorioMedidaUnt({Key key, @required this.idGrupoMedidas})
      : super(key: key);
  @override
  _RelatorioMedidaUntState createState() =>
      _RelatorioMedidaUntState(idGrupoMedidas: idGrupoMedidas);
}

class _RelatorioMedidaUntState extends State<RelatorioMedidaUnt> {
  var medidasComodo = new List<ModelsMedidasUnt>();
  var end = new List<ModelGrupoMedidas>();
  final int idGrupoMedidas;
  //BUSCA OS DADOS NO BANCO
  Future<dynamic> fetchPost(int id) async {
    final response = await http.get(
      Uri.encodeFull(UrlServidor + ListarMedidasPorGrupo + id.toString()),
      headers: {"accept": "application/json"},
    );
    //IF(MOUNTED) É nescessario para não recarregar a arvore apos retornar das outras listas
    if (mounted)
      setState(() {
        Iterable lista = json.decode(response.body);
        medidasComodo =
            lista.map((model) => ModelsMedidasUnt.fromJson(model)).toList();
      });
  }

  _RelatorioMedidaUntState({@required this.idGrupoMedidas}) {
    fetchPost(idGrupoMedidas);
  }

  _popopConfirmarEnvio() {
    MsgPopup().msgComDoisBotoes(
      context,
      'Você confirma o envio deste grupo de medidas para a empresa?',
      'Não',
      'sim',
      () => {
        Navigator.of(context).pop(),
      },
      () => {},
      sairAoPressionar: true,
      corBotaoDir: Color(0XFF0099FF),
      corBotaoEsq: Color(0XFFF4485C),
    );
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    Size size = mediaQuery.size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Relatório dos Comodos'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            height: size.height * 0.790,
            width: size.width,
            child: Stack(
              children: [
                FutureBuilder(
                  future: fetchPost(idGrupoMedidas),
                  builder: (BuildContext context, snapshot) {
                    return ListView.builder(
                      itemCount: medidasComodo.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.black, width: 2),
                                borderRadius: BorderRadius.circular(10)),
                            alignment: Alignment.center,
                            height: size.height * 0.65,
                            width: size.width,
                            child: Column(
                              children: [
                                Card(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 5),
                                        child: Row(
                                          children: [
                                            Text(
                                              'Comodo: ',
                                              style: TextStyle(
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              '${medidasComodo[index].comodo}',
                                              style: TextStyle(fontSize: 25),
                                            )
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 5),
                                        child: Row(
                                          children: [
                                            Text(
                                              'Altura: ',
                                              style: TextStyle(
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              '${medidasComodo[index].altura}',
                                              style: TextStyle(
                                                fontSize: 25,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 5),
                                        child: Row(
                                          children: [
                                            Text('Tipo de Fechadura: ',
                                                style: TextStyle(
                                                    fontSize: 25,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Text(
                                                '${medidasComodo[index].largura}',
                                                style: TextStyle(fontSize: 25))
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 5),
                                        child: Row(
                                          children: [
                                            Text('Lado de abertura: ',
                                                style: TextStyle(
                                                    fontSize: 25,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Text(
                                                '${medidasComodo[index].ladoAbertura}',
                                                style: TextStyle(
                                                  fontSize: 25,
                                                ))
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 5),
                                        child: Row(
                                          children: [
                                            Text('Largura do topo: ',
                                                style: TextStyle(
                                                    fontSize: 25,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Text(
                                                '${medidasComodo[index].localizacao}',
                                                style: TextStyle(
                                                  fontSize: 25,
                                                ))
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 5),
                                        child: Row(
                                          children: [
                                            Text('Largura do Meio: ',
                                                style: TextStyle(
                                                    fontSize: 25,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 5),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    '${medidasComodo[index].estruturaPorta}',
                                                    style:
                                                        TextStyle(fontSize: 25),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 5),
                                        child: Row(
                                          children: [
                                            Text('Largura do Rodape: ',
                                                style: TextStyle(
                                                    fontSize: 25,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Text(
                                                '${medidasComodo[index].tipoPorta}',
                                                style: TextStyle(
                                                  fontSize: 25,
                                                ))
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 5),
                                        child: Row(
                                          children: [
                                            Text('Decoração da porta: ',
                                                style: TextStyle(
                                                    fontSize: 25,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Text(
                                                '${medidasComodo[index].codigoReferenciaNum}',
                                                style: TextStyle(
                                                  fontSize: 25,
                                                ))
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 5),
                                        child: Row(
                                          children: [
                                            Text('Espessura da Parede: ',
                                                style: TextStyle(
                                                    fontSize: 25,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Text('${medidasComodo[index].cor}',
                                                style: TextStyle(
                                                  fontSize: 25,
                                                ))
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 5),
                                        child: Row(
                                          children: [
                                            Text('Fechadura: ',
                                                style: TextStyle(
                                                    fontSize: 25,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Text(
                                              '${medidasComodo[index].nomeFechadura}',
                                              style: TextStyle(
                                                fontSize: 25,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 5),
                                        child: Row(
                                          children: [
                                            Text('Espessura do marco: ',
                                                style: TextStyle(
                                                    fontSize: 25,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Text(
                                              '${medidasComodo[index].marco}',
                                              style: TextStyle(
                                                fontSize: 25,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 5),
                                        child: Row(
                                          children: [
                                            Text('Dobradica: ',
                                                style: TextStyle(
                                                    fontSize: 25,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Text(
                                              '${medidasComodo[index].nomeDobradica}',
                                              style: TextStyle(
                                                fontSize: 25,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 5),
                                        child: Row(
                                          children: [
                                            Text(
                                              'Pivotante: ',
                                              style: TextStyle(
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              '${medidasComodo[index].nomePivotante}',
                                              style: TextStyle(
                                                fontSize: 25,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 5),
                                        child: Row(
                                          children: [
                                            Text(
                                              'Observaçoes: ',
                                              style: TextStyle(
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              '${medidasComodo[index].observacoes}',
                                              style: TextStyle(
                                                fontSize: 25,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          // ============ BOTÃO PARA ENVIAR OS DADOS PARA A EMPRESA ============
          Container(
            width: size.width,
            height: size.height * 0.095,
            padding: EdgeInsets.only(top: 0, left: 4, right: 4),
            color: Colors.transparent, //.withOpacity(1.0),
            child: Column(
              verticalDirection: VerticalDirection.down,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Container(
                  child: new FloatingActionButton.extended(
                    heroTag: "btn1",
                    onPressed: () async {
                      _popopConfirmarEnvio();
                    },
                    label: new Text(
                      'Enviar grupo',
                      style: new TextStyle(
                        fontSize: 24,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}