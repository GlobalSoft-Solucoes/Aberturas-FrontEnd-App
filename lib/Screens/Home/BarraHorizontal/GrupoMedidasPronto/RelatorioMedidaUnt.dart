import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:projeto_aberturas/Models/Models_GrupoMedidas.dart';
import 'package:projeto_aberturas/Models/Models_MedidaUnt.dart';
import 'package:projeto_aberturas/Models/Models_Portas.dart';
import 'package:projeto_aberturas/Models/Models_Usuario.dart';
import 'package:projeto_aberturas/Models/constantes.dart';
import 'package:projeto_aberturas/Static/Static_Usuario.dart';
import 'package:projeto_aberturas/Widget/ListFieldsDataBase.dart';
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

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var dadosListagem = new List<ModelsMedidasUnt>();
  var end = new List<ModelGrupoMedidas>();
  final int idGrupoMedidas;
  //BUSCA OS DADOS NO BANCO
  Future<dynamic> listarDados(int id) async {
    final response = await http.get(
      Uri.encodeFull(ListarMedidasPorGrupo + id.toString()),
      headers: {"authorization": ModelsUsuarios.tokenAuth},
    );
    //IF(MOUNTED) É nescessario para não recarregar a arvore apos retornar das outras listas
    if (mounted)
      setState(() {
        Iterable lista = json.decode(response.body);
        dadosListagem =
            lista.map((model) => ModelsMedidasUnt.fromJson(model)).toList();
      });
    if (response.statusCode == 401) {
      Navigator.pushNamed(context, '/Login');
    }
  }

  pegarIndice() async {
    controllerData.text = dadosListagem[i].dataCadastro.substring(0, 10);
    controllerProprietario.text = DadosExcel.proprietario;
    controllercidade.text = DadosExcel.cidade;
    controllercomodo.text = dadosListagem[i].comodo;
    controlleraltura.text = dadosListagem[i].altura_Folha.toString();
    controllerlargura.text = dadosListagem[i].largura_Folha.toString();
    controllermarco.text = dadosListagem[i].marco.toString();
    controllerladoabertura.text = dadosListagem[i].ladoAbertura;
    controllerlocalizacao.text = dadosListagem[i].localizacao;
    controllercor.text = dadosListagem[i].cor;
    controllertipo.text = dadosListagem[i].tipoPorta;
    controllerestruturaPorta.text = dadosListagem[i].estruturaPorta;
    controllerobservacoes.text = dadosListagem[i].observacoes;
    controllerdobradicas.text = dadosListagem[i].nomeDobradica;
    controllerfechadura.text = dadosListagem[i].nomeFechadura;
    controllerpivotante.text = dadosListagem[i].nomePivotante;
    controllernumeroCodRef.text = dadosListagem[i].codigoReferenciaNum;
    controllerusuario.text = usuario.nome;
  }

  // _mostrarSnackBar(String mensagem) {
  //   final snackbar = SnackBar(
  //     content: Text(mensagem),
  //   );
  //   _scaffoldKey.currentState.showSnackBar(snackbar);
  // }

  _RelatorioMedidaUntState({@required this.idGrupoMedidas}) {
    listarDados(idGrupoMedidas);
  }
  // popup para confirmação do envio ddas medidas para a empresa
  _popopConfirmarEnvio() {
    MsgPopup().msgComDoisBotoes(
      context,
      'Você confirma o envio deste grupo de medidas para a empresa?',
      'Não',
      'sim',
      () => {
        Navigator.of(context).pop(),
      },
      () => {
        pegarIndice(),
        alterarStatus(),
        Navigator.of(context).pop(),
        Navigator.pushNamed(context, '/ListaGruposFinalizados'),
        i = 0,
      },
      sairAoPressionar: true,
      corBotaoDir: Color(0XFF0099FF),
      corBotaoEsq: Color(0XFFF4485C),
    );
  }

  // altera o STATUS do registro para "ENVIADO"
  Future<dynamic> alterarStatus() async {
    // int idRegistro = GrupoMedidas.idGrupoMedidas;
    http.put(
      AlterarStatusParaEnviado + idGrupoMedidas.toString(),
      headers: {"authorization": ModelsUsuarios.tokenAuth},
    );
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    Size size = mediaQuery.size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: Color(0xFFBCE0F0), //Colors.green[200],
          width: size.width,
          height: size.height,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: size.height * 0.02),
                child: Container(
                  width: size.width,
                  height: size.height * 0.10,
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(3),
                        child: IconButton(
                          icon: Icon(Icons.arrow_back),
                          onPressed: () => Navigator.pop(context),
                          iconSize: 33,
                          color: Colors.white,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: size.width * 0.09),
                        child: Text(
                          'Relatório das medidas',
                          style: TextStyle(
                              fontSize: size.width * 0.065,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: size.width * 0.02,
                  right: size.width * 0.02,
                ),
                child: Column(
                  children: [
                    Container(
                      width: size.width,
                      height: size.height * 0.73,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white),
                      child: FutureBuilder(
                        future: listarDados(idGrupoMedidas),
                        builder: (BuildContext context, snapshot) {
                          return ListView.builder(
                            itemCount: dadosListagem.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                   bottom: 10, top: 5, left: 10, right: 10),
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.black, width: 2),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  height: size.height * 0.69,
                                  width: size.width,
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.only(
                                            top: 10, left: 12, right: 10),
                                        alignment: Alignment.center,
                                        child: Column(
                                          // mainAxisAlignment: MainAxisAlignment.end,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(height: 15),
                                            Row(
                                              children: [
                                                FieldsDatabase()
                                                    .listaDadosBanco(
                                                  'Data: ',
                                                  dadosListagem[index]
                                                      .dataCadastro,
                                                  sizeCampoBanco: 24,
                                                  sizeTextoCampo: 24,
                                                ),
                                                FieldsDatabase()
                                                    .listaDadosBanco(
                                                  '  -  Hora: ',
                                                  dadosListagem[index]
                                                      .horaCadastro
                                                      .substring(0, 5),
                                                  sizeCampoBanco: 24,
                                                  sizeTextoCampo: 24,
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 8),
                                            FieldsDatabase().listaDadosBanco(
                                              'Comodo: ',
                                              dadosListagem[index].comodo,
                                              sizeCampoBanco: 24,
                                              sizeTextoCampo: 24,
                                            ),
                                            SizedBox(height: 8),
                                            FieldsDatabase().listaDadosBanco(
                                              'Altura folha: ',
                                              dadosListagem[index]
                                                  .altura_Folha
                                                  .toString(),
                                              sizeCampoBanco: 24,
                                              sizeTextoCampo: 24,
                                            ),
                                            SizedBox(height: 8),
                                            FieldsDatabase().listaDadosBanco(
                                              'Largura folha: ',
                                              dadosListagem[index]
                                                  .largura_Folha
                                                  .toString(),
                                              sizeCampoBanco: 24,
                                              sizeTextoCampo: 24,
                                            ),
                                            SizedBox(height: 8),
                                            FieldsDatabase().listaDadosBanco(
                                              'Altura externa: ',
                                              dadosListagem[index]
                                                  .altura_Externa
                                                  .toString(),
                                              sizeCampoBanco: 24,
                                              sizeTextoCampo: 24,
                                            ),
                                            SizedBox(height: 8),
                                            FieldsDatabase().listaDadosBanco(
                                              'Largura externa: ',
                                              dadosListagem[index]
                                                  .largura_Externa
                                                  .toString(),
                                              sizeCampoBanco: 24,
                                              sizeTextoCampo: 24,
                                            ),
                                            SizedBox(height: 8),
                                            FieldsDatabase().listaDadosBanco(
                                              'Porta abre para o lado: ',
                                              dadosListagem[index]
                                                  .ladoAbertura
                                                  .toString(),
                                              sizeCampoBanco: 24,
                                              sizeTextoCampo: 24,
                                            ),
                                            SizedBox(height: 8),
                                            FieldsDatabase().listaDadosBanco(
                                              'Lacalizacao da porta: ',
                                              dadosListagem[index]
                                                  .localizacao
                                                  .toString(),
                                              sizeCampoBanco: 24,
                                              sizeTextoCampo: 24,
                                            ),
                                            SizedBox(height: 8),
                                            FieldsDatabase().listaDadosBanco(
                                              'Tipo da porta: ',
                                              dadosListagem[index]
                                                  .tipoPorta
                                                  .toString(),
                                              sizeCampoBanco: 24,
                                              sizeTextoCampo: 24,
                                            ),
                                            SizedBox(height: 8),
                                            FieldsDatabase().listaDadosBanco(
                                              'Estrutura da porta: ',
                                              dadosListagem[index]
                                                  .estruturaPorta
                                                  .toString(),
                                              sizeCampoBanco: 24,
                                              sizeTextoCampo: 24,
                                            ),
                                            SizedBox(height: 8),
                                            FieldsDatabase().listaDadosBanco(
                                              'Cor da porta: ',
                                              dadosListagem[index]
                                                  .cor
                                                  .toString(),
                                              sizeCampoBanco: 24,
                                              sizeTextoCampo: 24,
                                            ),
                                            SizedBox(height: 8),
                                            FieldsDatabase().listaDadosBanco(
                                              'Espessura marco: ',
                                              dadosListagem[index]
                                                  .marco
                                                  .toString(),
                                              sizeCampoBanco: 24,
                                              sizeTextoCampo: 24,
                                            ),
                                            if (dadosListagem[index]
                                                    .nomeFechadura !=
                                                null)
                                              SizedBox(height: 8),
                                            if (dadosListagem[index]
                                                    .nomeFechadura !=
                                                null)
                                              FieldsDatabase().listaDadosBanco(
                                                'Fechadura: ',
                                                dadosListagem[index]
                                                    .nomeFechadura
                                                    .toString(),
                                                sizeCampoBanco: 24,
                                                sizeTextoCampo: 24,
                                              ),
                                            if (dadosListagem[index]
                                                    .nomeDobradica !=
                                                null)
                                              SizedBox(height: 8),
                                            if (dadosListagem[index]
                                                    .nomeDobradica !=
                                                null)
                                              FieldsDatabase().listaDadosBanco(
                                                'Dobradiça: ',
                                                dadosListagem[index]
                                                    .nomeDobradica
                                                    .toString(),
                                                sizeCampoBanco: 24,
                                                sizeTextoCampo: 24,
                                              ),
                                            if (dadosListagem[index]
                                                    .nomePivotante !=
                                                null)
                                              SizedBox(height: 8),
                                            if (dadosListagem[index]
                                                    .nomePivotante !=
                                                null)
                                              FieldsDatabase().listaDadosBanco(
                                                'Pivotante: ',
                                                dadosListagem[index]
                                                    .nomePivotante
                                                    .toString(),
                                                sizeCampoBanco: 24,
                                                sizeTextoCampo: 24,
                                              ),
                                            SizedBox(height: 8),
                                            Padding(
                                              padding: EdgeInsets.only(top: 0),
                                              child: Row(
                                                children: [
                                                  Text('Cod. Referência: ',
                                                      style: TextStyle(
                                                          fontSize: 25,
                                                          fontWeight:
                                                              FontWeight.w500)),
                                                  Text(
                                                    '${dadosListagem[index].codigoReferenciaNum}',
                                                    style: TextStyle(
                                                      fontSize: 25,
                                                      color: Colors.blue[800],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            if (dadosListagem[index]
                                                    .observacoes !=
                                                null)
                                              SizedBox(height: 8),
                                            if (dadosListagem[index]
                                                    .observacoes !=
                                                null)
                                              FieldsDatabase().listaDadosBanco(
                                                'Observações: ',
                                                dadosListagem[index]
                                                    .observacoes
                                                    .toString(),
                                                sizeCampoBanco: 24,
                                                sizeTextoCampo: 24,
                                              ),
                                            SizedBox(height: 15),
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
                    // ============ BOTÃO PARA ENVIAR OS DADOS PARA A EMPRESA ============
                    Container(
                      width: size.width,
                      height: size.height * 0.14,
                      padding: EdgeInsets.only(
                          bottom: size.height * 0.04, left: 4, right: 4),
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
                                'Enviar medidas',
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
