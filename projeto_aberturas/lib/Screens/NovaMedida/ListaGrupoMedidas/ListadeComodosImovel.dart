import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:projeto_aberturas/Models/constantes.dart';
import 'package:projeto_aberturas/Static/Static_GrupoMedidas.dart';
import 'package:projeto_aberturas/Screens/NovaMedida/ListaGrupoMedidas/ListaDadosComodo.dart';
import 'package:projeto_aberturas/Models/Models_MedidaUnt.dart';
import 'package:projeto_aberturas/Widget/MsgPopup.dart';

//TELA QUE MOSTRA OS COMODOS CADASTRADOS EM CADA IMOVEL
class ListaComodoImoveis extends StatefulWidget {
  final int idGrupoMedidas;
  ListaComodoImoveis({Key key, @required this.idGrupoMedidas})
      : super(key: key);
  @override
  _ListaComodoImoveisState createState() =>
      _ListaComodoImoveisState(idGrupoMedidas: idGrupoMedidas);
}

class _ListaComodoImoveisState extends State<ListaComodoImoveis> {
  var medidasComodo = new List<ModelsMedidasUnt>();
  int idGrupoMedidas = GrupoMediddas.idGrupoMedidas;
  // MENSAGEM QUE DISPARA QUANDO CLICA EM FINALIZAR PROCESSO
  _finalizaProcesso() async {
    await MsgPopup().msgFeedback(
      context,
      '\n Este grupo de medidas foi finalizado!' +
          '\n Confira no histórico as medidas cadastradas e envie para a empresa.',
      'Grupo Finalizado.',
      sizeTitulo: 20,
      onPressed: () {
        Navigator.of(context).pop();
        // Navigator.pushNamed(context, '/ListaGrupoMedidas');
      },
    );
  }

  escolhaTelaNovaMedida() {
    MsgPopup().msgComDoisBotoes(
      context,
      'Escolha o tipo de Porta',
      'Fora de Padrão',
      'Padrão',
      () => {
        Navigator.of(context)
            .pop(), // Fecha o popup da escolha para medir a porta
        Navigator.pushNamed(context, '/CadDadosPorta'),
      },
      () => {
        Navigator.of(context)
            .pop(), // Fecha o popup da escolha para medir a porta
        Navigator.pushNamed(context, '/CadPortaPadrao'),
      },
      sairAoPressionar: true,
    );
  }

  // altera o STATUS do registro para FINALIZADO
  Future<dynamic> alterarStatus() async {
    int idRegistro = GrupoMediddas.idGrupoMedidas;
    http.put(
      UrlServidor + AlterarStatusProcesso + idRegistro.toString(),
      headers: {"Content-Type": "application/json"},
    );
  }

  //FUNÇÃO PARA BUSCAR OS DADOS NA DB
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

  _ListaComodoImoveisState({@required this.idGrupoMedidas}) {
    fetchPost(idGrupoMedidas);
  }
//ALERT DIALOGUE DE DELETAR COMODO

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    Size size = mediaQuery.size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Comodos cadastrados do imovel'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            height: size.height * 0.750,
            width: size.width,
            child: FutureBuilder(
                future: fetchPost(GrupoMediddas.idGrupoMedidas),
                builder: (BuildContext context, snapshot) {
                  return ListView.builder(
                    itemCount: medidasComodo.length,
                    itemBuilder: (context, index) {
                      return Padding(
                          padding: const EdgeInsets.only(
                            bottom: 2.0,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Container(
                              height: 130,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  10,
                                ),
                                color: Color(0XFFD1D6DC),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 15, right: 15),
                                child: GestureDetector(
                                  onDoubleTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ListaDadosComodo(
                                          idMedidaUnt:
                                              medidasComodo[index].idMedidaUnt,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: Color(0XFFD1D6DC),
                                      borderRadius: BorderRadius.circular(
                                        15,
                                      ),
                                    ),
                                    child: ListTile(
                                      leading: Text(
                                        '${index + 1}',
                                        style: TextStyle(
                                          fontSize: 20,
                                        ),
                                      ),
                                      subtitle: Text(
                                        'Comodo: ${medidasComodo[index].comodo}',
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.blue[600]),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ));
                    },
                  );
                }),
          ),
          Container(
            width: size.width,
            height: size.height * 0.10,
            padding: EdgeInsets.only(top: 10, left: 4, right: 4),
            color: Colors.white.withOpacity(1.0),
            child: Row(
              verticalDirection: VerticalDirection.down,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Container(
                  alignment: Alignment.bottomCenter,
                  child: new FloatingActionButton.extended(
                    heroTag: "btn1",
                    onPressed: () async {
                      await _finalizaProcesso();
                      alterarStatus();
                      Navigator.pushNamed(context, '/ListaGrupoMedidas');
                    },
                    label: new Text(
                      'Finalizar processo',
                      style: new TextStyle(
                        fontSize: 24,
                      ),
                    ),
                  ),
                ),

                // ============ BOTÃO PARA ADICIONAR NOVA MEDIDA ============

                new Container(
                  alignment: Alignment.bottomCenter,
                  padding: EdgeInsets.only(left: 20),
                  child: new FloatingActionButton(
                    heroTag: "btn2",
                    elevation: 10,
                    child: new IconButton(
                      iconSize: 35,
                      icon: Icon(Icons.add, color: Colors.white),
                      onPressed: () {
                        escolhaTelaNovaMedida();
                      },
                    ),
                    onPressed: () {},
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
