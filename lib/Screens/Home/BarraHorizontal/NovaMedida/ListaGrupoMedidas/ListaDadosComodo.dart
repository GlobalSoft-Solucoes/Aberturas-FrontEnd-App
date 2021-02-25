import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:projeto_aberturas/Models/Models_GrupoMedidas.dart';
import 'package:projeto_aberturas/Models/Models_MedidaUnt.dart';
import 'package:projeto_aberturas/Models/Models_Usuario.dart';
import 'package:projeto_aberturas/Models/constantes.dart';
import 'package:projeto_aberturas/Widget/Crud_DataBase.dart';
import 'package:projeto_aberturas/Widget/ListFieldsDataBase.dart';
import 'package:projeto_aberturas/Widget/MsgPopup.dart';

class ListaDadosComodo extends StatefulWidget {
  final int idMedidaUnt;
  ListaDadosComodo({Key key, @required this.idMedidaUnt}) : super(key: key);
  @override
  _ListaDadosComodoState createState() =>
      _ListaDadosComodoState(idMedidaUnt: idMedidaUnt);
}

class _ListaDadosComodoState extends State<ListaDadosComodo> {
  var dadosListagem = new List<ModelsMedidasUnt>();
  TextEditingController controllerEditDados = TextEditingController();
  final int idMedidaUnt;

  ModelGrupoMedidas classe = ModelGrupoMedidas();
  Future<dynamic> listarDados(int id) async {
    final response = await http.get(
      Uri.encodeFull(BuscarMedidaUntPorId + idMedidaUnt.toString()),
      headers: {
        "Content-Type": "application/json",
        "authorization": ModelsUsuarios.tokenAuth
      },
    );

    if (mounted) {
      setState(
        () {
          Iterable lista = json.decode(response.body);
          dadosListagem =
              lista.map((model) => ModelsMedidasUnt.fromJson(model)).toList();
        },
      );
    }
  }

  msgConfirmacaoDeletarPedido() {
    MsgPopup().msgComDoisBotoes(
      context,
      'Você deseja remover este pedido?',
      'Não',
      'Sim',
      () => Navigator.pop(context),
      () {
        deletar();
        Navigator.pop(context);
        Navigator.pop(context);
      },
    );
  }

  Future<dynamic> deletar() async {
    ReqDataBase().requisicaoDelete(DeletarMedidaUnt + idMedidaUnt.toString());
    print(ReqDataBase.responseReq.statusCode);
    if (ReqDataBase.responseReq.statusCode == 401) {
      Navigator.pushNamed(context, '/login');
    } else if (ReqDataBase.responseReq.statusCode == 200) {
      Navigator.pop(context);
    }
  }

// ======== DEIXA OBRIGATORIO O RECEBIMENTO DO ID PARA LISTAGEM CORRETA =========
  _ListaDadosComodoState({@required this.idMedidaUnt}) {
    listarDados(idMedidaUnt);
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    Size size = mediaQuery.size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: Color(0xFFBCE0F0), 
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
                        padding: EdgeInsets.all(1),
                        child: IconButton(
                          icon: Icon(Icons.arrow_back),
                          onPressed: () => Navigator.pop(context),
                          iconSize: 40,
                          color: Colors.white,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: size.width * 0.09),
                        child: Text(
                          'Detalhes do pedido',
                          style: TextStyle(
                              fontSize: size.width * 0.07,
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
                        future: listarDados(idMedidaUnt),
                        builder: (BuildContext context, snapshot) {
                          return ListView.builder(
                            itemCount: dadosListagem.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.only(left: 4, right: 4),
                                child: Container(
                                  width: size.width,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                      15,
                                    ),
                                  ),
                                  child: Container(
                                    alignment: Alignment.center,
                                    // padding: const EdgeInsets.only(
                                    //     left: 0, right: 10),
                                    child: Container(
                                      // alignment: Alignment.center,
                                      padding: EdgeInsets.only(left: 5),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          15,
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // SizedBox(height: 15),
                                          Row(
                                            children: [
                                              FieldsDatabase().listaDadosBanco(
                                                'Data: ',
                                                dadosListagem[index]
                                                    .dataCadastro,
                                                sizeCampoBanco: 24,
                                                sizeTextoCampo: 24,
                                              ),
                                              FieldsDatabase().listaDadosBanco(
                                                '  -  Hora: ',
                                                dadosListagem[index]
                                                    .horaCadastro
                                                    .substring(0, 5),
                                                sizeCampoBanco: 24,
                                                sizeTextoCampo: 24,
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 15),
                                          FieldsDatabase().listaDadosBanco(
                                            'Comodo: ',
                                            dadosListagem[index].comodo,
                                            sizeCampoBanco: 24,
                                            sizeTextoCampo: 24,
                                          ),
                                          SizedBox(height: 15),
                                          FieldsDatabase().listaDadosBanco(
                                            'Altura folha: ',
                                            dadosListagem[index]
                                                .altura_Folha
                                                .toString(),
                                            sizeCampoBanco: 24,
                                            sizeTextoCampo: 24,
                                          ),
                                          SizedBox(height: 15),
                                          FieldsDatabase().listaDadosBanco(
                                            'Largura folha: ',
                                            dadosListagem[index]
                                                .largura_Folha
                                                .toString(),
                                            sizeCampoBanco: 24,
                                            sizeTextoCampo: 24,
                                          ),
                                          SizedBox(height: 15),
                                          FieldsDatabase().listaDadosBanco(
                                            'Altura externa: ',
                                            dadosListagem[index]
                                                .altura_Externa
                                                .toString(),
                                            sizeCampoBanco: 24,
                                            sizeTextoCampo: 24,
                                          ),
                                          SizedBox(height: 15),
                                          FieldsDatabase().listaDadosBanco(
                                            'Largura externa: ',
                                            dadosListagem[index]
                                                .largura_Externa
                                                .toString(),
                                            sizeCampoBanco: 24,
                                            sizeTextoCampo: 24,
                                          ),
                                          SizedBox(height: 15),
                                          FieldsDatabase().listaDadosBanco(
                                            'Porta abre para o lado: ',
                                            dadosListagem[index]
                                                .ladoAbertura
                                                .toString(),
                                            sizeCampoBanco: 24,
                                            sizeTextoCampo: 24,
                                          ),
                                          SizedBox(height: 15),
                                          FieldsDatabase().listaDadosBanco(
                                            'Lacalizacao da porta: ',
                                            dadosListagem[index]
                                                .localizacao
                                                .toString(),
                                            sizeCampoBanco: 24,
                                            sizeTextoCampo: 24,
                                          ),
                                          SizedBox(height: 15),
                                          FieldsDatabase().listaDadosBanco(
                                            'Tipo da porta: ',
                                            dadosListagem[index]
                                                .tipoPorta
                                                .toString(),
                                            sizeCampoBanco: 24,
                                            sizeTextoCampo: 24,
                                          ),
                                          SizedBox(height: 15),
                                          FieldsDatabase().listaDadosBanco(
                                            'Estrutura da porta: ',
                                            dadosListagem[index]
                                                .estruturaPorta
                                                .toString(),
                                            sizeCampoBanco: 24,
                                            sizeTextoCampo: 24,
                                          ),
                                          SizedBox(height: 15),
                                          FieldsDatabase().listaDadosBanco(
                                            'Cor da porta: ',
                                            dadosListagem[index].cor.toString(),
                                            sizeCampoBanco: 24,
                                            sizeTextoCampo: 24,
                                          ),
                                          SizedBox(height: 15),
                                          FieldsDatabase().listaDadosBanco(
                                            'Marco da parede: ',
                                            dadosListagem[index]
                                                .marco
                                                .toString(),
                                            sizeCampoBanco: 24,
                                            sizeTextoCampo: 24,
                                          ),
                                          SizedBox(height: 15),
                                          FieldsDatabase().listaDadosBanco(
                                            'Observações: ',
                                            dadosListagem[index]
                                                .observacoes
                                                .toString(),
                                            sizeCampoBanco: 24,
                                            sizeTextoCampo: 24,
                                          ),
                                          if (dadosListagem[index]
                                                  .nomeDobradica !=
                                              null)
                                            SizedBox(height: 15),
                                          if (dadosListagem[index]
                                                  .nomeDobradica !=
                                              null)
                                            FieldsDatabase().listaDadosBanco(
                                              'Tipo de dobradiça: ',
                                              dadosListagem[index]
                                                  .nomeDobradica
                                                  .toString(),
                                              sizeCampoBanco: 24,
                                              sizeTextoCampo: 24,
                                            ),
                                          if (dadosListagem[index]
                                                  .nomeFechadura !=
                                              null)
                                            SizedBox(height: 15),
                                          if (dadosListagem[index]
                                                  .nomeFechadura !=
                                              null)
                                            FieldsDatabase().listaDadosBanco(
                                              'Tipo de fechadura: ',
                                              dadosListagem[index]
                                                  .nomeFechadura
                                                  .toString(),
                                              sizeCampoBanco: 24,
                                              sizeTextoCampo: 24,
                                            ),
                                          if (dadosListagem[index]
                                                  .nomePivotante !=
                                              null)
                                            SizedBox(height: 15),
                                          if (dadosListagem[index]
                                                  .nomePivotante !=
                                              null)
                                            FieldsDatabase().listaDadosBanco(
                                              'Tipo de pivotante: ',
                                              dadosListagem[index]
                                                  .nomePivotante
                                                  .toString(),
                                              sizeCampoBanco: 24,
                                              sizeTextoCampo: 24,
                                            ),
                                          SizedBox(height: 15),
                                          FieldsDatabase().listaDadosBanco(
                                            'Cod Referência: ',
                                            dadosListagem[index]
                                                .codigoReferenciaNum
                                                .toString(),
                                            sizeCampoBanco: 24,
                                            sizeTextoCampo: 24,
                                          ),
                                          SizedBox(height: 25),
                                          //========================================================
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: size.height * 0.02),
                      child: Row(
                        children: [
                          Expanded(
                              child: Padding(
                            padding:
                                EdgeInsets.only(bottom: size.height * 0.02),
                            child: IconButton(
                              icon: Icon(Icons.delete_forever),
                              onPressed: () => {msgConfirmacaoDeletarPedido()},
                              iconSize: 40,
                              color: Colors.red,
                            ),
                          ))
                        ],
                      ),
                    )
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
