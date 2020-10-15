import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:projeto_aberturas/Models/Excel.dart';
import 'package:projeto_aberturas/Models/Models_GrupoMedidas.dart';
import 'package:projeto_aberturas/Models/Models_MedidaUnt.dart';
import 'package:projeto_aberturas/Models/Models_Portas.dart';
import 'package:projeto_aberturas/Models/Models_Usuario.dart';
import 'package:projeto_aberturas/Models/constantes.dart';
import 'package:projeto_aberturas/Screens/Excel/Controller.dart';
import 'package:projeto_aberturas/Static/Static_Usuario.dart';
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
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var medidasComodo = new List<ModelsMedidasUnt>();
  var end = new List<ModelGrupoMedidas>();
  final int idGrupoMedidas;
  //BUSCA OS DADOS NO BANCO
  Future<dynamic> fetchPost(int id) async {
    final response = await http.get(
      Uri.encodeFull(UrlServidor + ListarMedidasPorGrupo + id.toString()),
      headers: {"authorization": ModelsUsuarios.tokenAuth},
    );
    //IF(MOUNTED) É nescessario para não recarregar a arvore apos retornar das outras listas
    if (mounted)
      setState(() {
        Iterable lista = json.decode(response.body);
        medidasComodo =
            lista.map((model) => ModelsMedidasUnt.fromJson(model)).toList();
      });
  }

  TextEditingController controllerData = TextEditingController();
  TextEditingController controllerProprietario = TextEditingController();
  TextEditingController controllercidade = TextEditingController();
  TextEditingController controllercomodo = TextEditingController();
  TextEditingController controlleraltura = TextEditingController();
  TextEditingController controllerlargura = TextEditingController();
  TextEditingController controllermarco = TextEditingController();
  TextEditingController controllerladoabertura = TextEditingController();
  TextEditingController controllerlocalizacao = TextEditingController();
  TextEditingController controllercor = TextEditingController();
  TextEditingController controllertipo = TextEditingController();
  TextEditingController controllerestruturaPorta = TextEditingController();
  TextEditingController controllerobservacoes = TextEditingController();
  TextEditingController controllerdobradicas = TextEditingController();
  TextEditingController controllerfechadura = TextEditingController();
  TextEditingController controllerpivotante = TextEditingController();
  TextEditingController controllernumeroCodRef = TextEditingController();
  TextEditingController controllerusuario = TextEditingController();
  bool result = false;
  var i = 0;
  pegarIndice() async {
    controllerData.text = medidasComodo[i].dataCadastro.substring(0, 10);
    controllerProprietario.text = DadosExcel.proprietario;
    controllercidade.text = DadosExcel.cidade;
    controllercomodo.text = medidasComodo[i].comodo;
    controlleraltura.text = medidasComodo[i].altura.toString();
    controllerlargura.text = medidasComodo[i].largura.toString();
    controllermarco.text = medidasComodo[i].marco.toString();
    controllerladoabertura.text = medidasComodo[i].ladoAbertura;
    controllerlocalizacao.text = medidasComodo[i].localizacao;
    controllercor.text = medidasComodo[i].cor;
    controllertipo.text = medidasComodo[i].tipoPorta;
    controllerestruturaPorta.text = medidasComodo[i].estruturaPorta;
    controllerobservacoes.text = medidasComodo[i].observacoes;
    controllerdobradicas.text = medidasComodo[i].nomeDobradica;
    controllerfechadura.text = medidasComodo[i].nomeFechadura;
    controllerpivotante.text = medidasComodo[i].nomePivotante;
    controllernumeroCodRef.text = medidasComodo[i].codigoReferenciaNum;
    controllerusuario.text = Usuario.nome;
    FeedbackForm feedbackForm = FeedbackForm(
        controllerData.text,
        controllerProprietario.text,
        controllercidade.text,
        controllercomodo.text,
        controlleraltura.text,
        controllerlargura.text,
        controllermarco.text,
        controllerladoabertura.text,
        controllerlocalizacao.text,
        controllercor.text,
        controllertipo.text,
        controllerestruturaPorta.text,
        controllerobservacoes.text,
        controllerdobradicas.text,
        controllerfechadura.text,
        controllerpivotante.text,
        controllernumeroCodRef.text,
        controllerusuario.text);
    FormController formController = FormController((String response) {
      if (response == FormController.STATUS_SUCCESS) {
        _mostrarSnackBar('Dados Enviados');
      } else {
        _mostrarSnackBar('Ocorreu um erro');
        return;
      }
    });
    _mostrarSnackBar('Enviando');
    var teste = await formController.submitForm(feedbackForm);
    if ((teste == 200) && (i < medidasComodo.length - 1)) {
      i++;
      pegarIndice();
    } else {
      print(teste);
    }
    desativarGrupo() {}
  }

  _mostrarSnackBar(String mensagem) {
    final snackbar = SnackBar(
      content: Text(mensagem),
    );
    _scaffoldKey.currentState.showSnackBar(snackbar);
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
      () => {pegarIndice(), Navigator.of(context).pop(), i = 0},
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
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Relatório dos Comodos'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.file_upload),
            onPressed: () {
              pegarIndice();
            },
            iconSize: 35,
            color: Colors.white,
          )
        ],
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
                                            Text('Cor: ',
                                                style: TextStyle(
                                                    fontSize: 25,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Text('${medidasComodo[index].cor}',
                                                style: TextStyle(fontSize: 25))
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
                                            Expanded(
                                              child: Text(
                                                  '${medidasComodo[index].nomeDobradica}',
                                                  style: TextStyle(
                                                    fontSize: 25,
                                                  )),
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
