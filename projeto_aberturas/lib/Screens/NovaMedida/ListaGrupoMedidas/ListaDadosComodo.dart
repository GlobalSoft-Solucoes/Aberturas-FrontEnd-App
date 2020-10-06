import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:projeto_aberturas/Models/Models_GrupoMedidas.dart';
import 'package:projeto_aberturas/Models/Models_MedidaUnt.dart';
import 'package:http/http.dart' as http;
import 'package:projeto_aberturas/Models/constantes.dart';
import 'package:projeto_aberturas/Static/Static_GrupoMedidas.dart';
import 'package:projeto_aberturas/Static/Static_MedidaUnt.dart';
import 'package:projeto_aberturas/Widget/MsgPopup.dart';

//TELA QUE LISTA OS DADOS DE CADA COMODO CADASTRADO
class ListaDadosComodo extends StatefulWidget {
  final int idMedidaUnt;
  ListaDadosComodo({Key key, @required this.idMedidaUnt}) : super(key: key);
  @override
  _ListaDadosComodoState createState() =>
      _ListaDadosComodoState(idMedidaUnt: idMedidaUnt);
}

class _ListaDadosComodoState extends State<ListaDadosComodo> {
  //LISTA DOS COMODOS

  var medidasComodo = new List<ModelsMedidasUnt>();
  TextEditingController controllerEditDados = TextEditingController();
  final int idMedidaUnt;
  ModelGrupoMedidas classe = ModelGrupoMedidas();

  //FUNÇÃO QUE BUSCA OS DADOS NA DB
  Future<dynamic> listaDadosPorComodo(int id) async {
    final response = await http.get(
      Uri.encodeFull(UrlServidor + BuscaUnicoRegistro + id.toString()),
      headers: {"accept": "application/json"},
    );

    //IF(MOUNTED) É nescessario para não recarregar a arvore apos retornar das outras listas
    if (mounted) {
      setState(
        () {
          Iterable lista = json.decode(response.body);
          medidasComodo =
              lista.map((model) => ModelsMedidasUnt.fromJson(model)).toList();
        },
      );
    }
  }

// ======== DEIXA OBRIGATORIO O RECEBIMENTO DO ID PARA LISTAGEM CORRETA =========
  _ListaDadosComodoState({@required this.idMedidaUnt}) {
    listaDadosPorComodo(idMedidaUnt);
  }

  // ============== DELETA O REGISTRO DO COMODO PELO ID ==============
  Future<dynamic> delete(int id) async =>
      await http.delete(UrlServidor + DeletarMedidaUnt + id.toString());

// ======== ALERT DIALOGUE PARA DELETAR O COMODO ==========
  _deletarReg(int index) {
    MsgPopup().msgComDoisBotoes(
      context,
      'Confirmar exclusão do registro?',
      'Não',
      'Sim',
      () => {
        Navigator.of(context).pop(),
      },
      () => {
        delete(index),
        Navigator.of(context).pop(),
        Navigator.pushNamed(context, '/ListaComodosPorImovel'),
      },
      corBotaoEsq: Color(0XFFF4485C),
      corBotaoDir: Color(0XFF0099FF),
      sairAoPressionar: true,
    );
  }

  //======== Salva os dados editados no banco de dados =========
  Future<dynamic> salvarDadosBanco(String field, {String url, int id}) async {
    MedidaUntFixa.idMedidaUnt = idMedidaUnt;
    var bodyy = jsonEncode({
      'IdGrupo_Medidas': GrupoMediddas.idGrupoMedidas,
      'IdMedida_Unt': MedidaUntFixa.idMedidaUnt,
      field: valor,
    });
    http.put(
      UrlServidor +
          (url ?? EditarMedidaUnt) +
          (id.toString() ?? idMedidaUnt.toString()),
      headers: {"Content-Type": "application/json"},
      body: bodyy,
    );
  }

// POPUP QUE É DISPARADO QUANDO UM CAMPO É PRECIONADO PARA A EDIÇÃO
  var valor;
  popupEdicao() {
    MsgPopup().campoTextoComDoisBotoes(
      context,
      'Edite o campo Selecionado',
      'Novo valor do campo:',
      'Cancelar',
      'Salvar',
      () => {
        controllerEditDados.text = "",
        Navigator.pop(context),
      },
      () => {
        valor = controllerEditDados.text,
        Navigator.pop(context),
        controllerEditDados.text = '',
      },
      controller: controllerEditDados,
      iconeText: Icons.new_releases,
    );
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    Size size = mediaQuery.size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Dados do Comodo'),
        centerTitle: true,
      ),
      body: Container(
        height: size.height,
        width: size.width,
        child: FutureBuilder(
          future: listaDadosPorComodo(idMedidaUnt),
          builder: (BuildContext context, snapshot) {
            return ListView.builder(
              itemCount: medidasComodo.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Card(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              //================================================
                              GestureDetector(
                                onDoubleTap: () async {
                                  await popupEdicao();
                                  salvarDadosBanco('Comodo');
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 5, top: 7),
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
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              //================================================
                              GestureDetector(
                                onDoubleTap: () async {
                                  await popupEdicao();
                                  salvarDadosBanco('Altura');
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 5, top: 7),
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
                              ),
                              GestureDetector(
                                onDoubleTap: () async {
                                  await popupEdicao();
                                  salvarDadosBanco('Largura');
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 5, top: 7),
                                  child: Row(
                                    children: [
                                      Text('Largura: ',
                                          style: TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold)),
                                      Text(
                                        '${medidasComodo[index].largura}',
                                        style: TextStyle(
                                          fontSize: 25,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              //================================================
                              GestureDetector(
                                onDoubleTap: () async {
                                  await popupEdicao();
                                  salvarDadosBanco('Lado_Abertura');
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 5, top: 7),
                                  child: Row(
                                    children: [
                                      Text('Porta abre para o lado: ',
                                          style: TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold)),
                                      Expanded(
                                        child: Text(
                                            '${medidasComodo[index].ladoAbertura}',
                                            style: TextStyle(fontSize: 25)),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              //================================================
                              GestureDetector(
                                onDoubleTap: () async {
                                  await popupEdicao();
                                  salvarDadosBanco('Localizacao');
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 5, top: 7),
                                  child: Row(
                                    children: [
                                      Text('Lacalizacao da porta: ',
                                          style: TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold)),
                                      Text(
                                        '${medidasComodo[index].localizacao}',
                                        style: TextStyle(
                                          fontSize: 25,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onDoubleTap: () async {
                                  await popupEdicao();
                                  salvarDadosBanco('Tipo_Porta');
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 5, top: 7),
                                  child: Row(
                                    children: [
                                      Text('Estilo da porta: ',
                                          style: TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold)),
                                      Text(
                                        '${medidasComodo[index].tipoPorta}',
                                        style: TextStyle(
                                          fontSize: 25,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              //================================================
                              GestureDetector(
                                onDoubleTap: () async {
                                  await popupEdicao();
                                  salvarDadosBanco('Estrutra_Porta');
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 5, top: 7),
                                  child: Row(
                                    children: [
                                      Text('Estrutura da porta: ',
                                          style: TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold)),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 5),
                                        child: Row(
                                          children: [
                                            Text(
                                              '${medidasComodo[index].estruturaPorta}',
                                              style: TextStyle(fontSize: 25),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              //================================================
                              GestureDetector(
                                onDoubleTap: () async {
                                  await popupEdicao();
                                  salvarDadosBanco('Cor');
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 5, top: 7),
                                  child: Row(
                                    children: [
                                      Text('Cor da porta: ',
                                          style: TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold)),
                                      Expanded(
                                        child: Text(
                                          '${medidasComodo[index].cor}',
                                          style: TextStyle(
                                            fontSize: 25,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              //================================================
                              //================================================
                              GestureDetector(
                                onDoubleTap: () async {
                                  await popupEdicao();
                                  salvarDadosBanco('Marco_Parede');
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 5, top: 7),
                                  child: Row(
                                    children: [
                                      Text('Marco da parede ',
                                          style: TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold)),
                                      Text(
                                        '${medidasComodo[index].marco}',
                                        style: TextStyle(
                                          fontSize: 25,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              //================================================
                              GestureDetector(
                                onDoubleTap: () async {
                                  await popupEdicao();
                                  salvarDadosBanco('Observacoes');
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 5, top: 7),
                                  child: Row(
                                    children: [
                                      Text('Observacoes: ',
                                          style: TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold)),
                                      Text(
                                        '${medidasComodo[index].observacoes}',
                                        style: TextStyle(
                                          fontSize: 25,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onDoubleTap: () async {
                                  await popupEdicao();
                                  salvarDadosBanco('Nome_Dobradica',
                                      id: medidasComodo[index].idDobradica,
                                      url: 'Dobradica/Editar/');
                                  var teste = medidasComodo[index].idDobradica;
                                  print(teste);
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 5, top: 7),
                                  child: Row(
                                    children: [
                                      Text('Tipo de debradiça: ',
                                          style: TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold)),
                                      Text(
                                        '${medidasComodo[index].nomeDobradica}',
                                        style: TextStyle(
                                          fontSize: 25,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onDoubleTap: () async {
                                  await popupEdicao();
                                  salvarDadosBanco(
                                    'Nome_Fechadura',
                                    id: medidasComodo[index].idFechadura,
                                    url: 'Fechadura/editar/',
                                  );
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 5, top: 7),
                                  child: Row(
                                    children: [
                                      Text('Fechadura: ',
                                          style: TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold)),
                                      Text(
                                        '${medidasComodo[index].nomeFechadura}',
                                        style: TextStyle(
                                          fontSize: 25,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onDoubleTap: () async {
                                  await popupEdicao();
                                  salvarDadosBanco('Nome',
                                      id: medidasComodo[index].idRolPivotante,
                                      url: 'Pivotante/Editar/');
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 5, top: 7),
                                  child: Row(
                                    children: [
                                      Text('Pivotante: ',
                                          style: TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold)),
                                      Text(
                                        '${medidasComodo[index].nomePivotante}',
                                        style: TextStyle(
                                          fontSize: 25,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onDoubleTap: () async {
                                  await popupEdicao();
                                  salvarDadosBanco('Codigo',
                                      url: 'CodReferencia/editar/',
                                      id: medidasComodo[index].idCodRef);
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 5, top: 7),
                                  child: Row(
                                    children: [
                                      Text('Cod Referencia: ',
                                          style: TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold)),
                                      Text(
                                        '${medidasComodo[index].codigoReferenciaNum}',
                                        style: TextStyle(
                                          fontSize: 25,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              //================================================

                              //================================================

                              Padding(
                                padding: EdgeInsets.only(top: 20),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: IconButton(
                                        padding: EdgeInsets.only(
                                            right: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2.5),
                                        icon: Icon(
                                          Icons.delete_forever,
                                          color: Colors.red,
                                          size: 30,
                                        ),
                                        alignment: Alignment.centerRight,
                                        onPressed: () => {
                                          _deletarReg(
                                            medidasComodo[index].idMedidaUnt,
                                          ),
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              )
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
      ),
    );
  }
}
