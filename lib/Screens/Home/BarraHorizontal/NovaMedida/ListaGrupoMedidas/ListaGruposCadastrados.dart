import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:projeto_aberturas/Models/Models_GrupoMedidas.dart';
import 'package:http/http.dart' as http;
import 'package:projeto_aberturas/Models/Models_Usuario.dart';
import 'package:projeto_aberturas/Models/constantes.dart';
import 'package:projeto_aberturas/Static/Static_GrupoMedidas.dart';
import 'package:projeto_aberturas/Static/Static_Usuario.dart';
import 'package:projeto_aberturas/Widget/Crud_DataBase.dart';
import 'package:projeto_aberturas/Widget/MsgPopup.dart';
import 'package:projeto_aberturas/Widget/ListFieldsDataBase.dart';
import 'ListadeComodosImovel.dart';

//TELA PARA LISTAR TODOS OS ENDEREÇOS CADASTRADOS
class ListaGrupoMedidas extends StatefulWidget {
  @override
  _ListaGrupoMedidasState createState() => _ListaGrupoMedidasState();

  static fromJson(model) {}
}

class _ListaGrupoMedidasState extends State<ListaGrupoMedidas> {
  TextEditingController controllerExcluirGrupo = TextEditingController();
  var dadosListagem = new List<ModelGrupoMedidas>();

//CONFIRMAÇÃO DE EXCLUSAO DO GRUPO
  confExcluir(id) {
    MsgPopup().msgComDoisBotoes(
      context,
      'Deseja excluir o grupo de medidas selecionado?',
      'Cancelar',
      'Confirmar',
      () => {
        Navigator.pop(context),
      },
      () => {
        _deletarReg(id),
        Navigator.pop(context),
      },
    );
  }

//DELETA O GRUPO DE MEDIDAS
  _deletarReg(id) async {
    print(id);
    ReqDataBase().requisicaoPut(StatusRemoverGrupo + id.toString());
    // var response = await http.put(
    //   (StatusRemoverGrupo + id.toString()),
    //   headers: {"authorization": ModelsUsuarios.tokenAuth},
    // );
    if (ReqDataBase.responseReq.statusCode == 401) {
      Navigator.pushNamed(context, '/Login');
    }
  }

  //FUNÇÃO PARA BUSCAR OS DADOS NA DB
  Future<dynamic> listarDados() async {
    final response = await http.get(
      Uri.encodeFull(
        ListarTodosGrupoMedidas + usuario.idUsuario.toString(),
      ),
      headers: {"authorization": ModelsUsuarios.tokenAuth},
    );

    if (response.statusCode == 401) {
      Navigator.pushNamed(context, '/Login');
    }
    //IF(MOUNTED) É nescessario para não recarregar a arvore apos retornar das outras listas
    if (mounted)
      setState(
        () {
          Iterable lista = json.decode(response.body);
          dadosListagem =
              lista.map((model) => ModelGrupoMedidas.fromJson(model)).toList();
        },
      );
  }

//FUNÇÃO PARA DELETAR OS DADOS DA DATABASE
  Future<dynamic> delete(int id) async {
    var response = await http.delete(
      DeletarGrupoMedidas + id.toString(),
      headers: {"authorization": ModelsUsuarios.tokenAuth},
    );
    if (response.statusCode == 401) {
      Navigator.pushNamed(context, '/Login');
    }
  }

  _ListaGrupoMedidasState() {
    listarDados();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    Size size = mediaQuery.size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: size.width,
          height: size.height,
          color: Color(0xFFBCE0F0),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: size.height * 0.02,
                  left: size.width * 0.015,
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      color: Colors.white,
                      iconSize: 35,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: size.width * 0.09),
                      child: Text(
                        'Endereços cadastrados',
                        style: TextStyle(
                          fontSize: size.width * 0.062,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: size.width * 0.02,
                    right: size.width * 0.02,
                    top: size.height * 0.01,
                    bottom: size.height * 0.01),
                child: Container(
                  width: size.width,
                  height: size.height * 0.88,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: FutureBuilder(
                    future: listarDados(),
                    builder: (BuildContext context, snapshot) {
                      return ListView.builder(
                        itemCount: dadosListagem.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onDoubleTap: () {
                              GrupoMedidas.idGrupoMedidas =
                                  dadosListagem[index].idGrupoMedidas;
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ListaComodoImoveis(
                                    idGrupoMedidas:
                                        dadosListagem[index].idGrupoMedidas,
                                  ),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 4, top: 4),
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 4, right: 4),
                                child: Container(
                                  alignment: Alignment.center,
                                  height: size.height * 0.16,
                                  width: size.width,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                      15,
                                    ),
                                    color: Color(0XFFD1D6DC),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      top: 0,
                                      left: 5,
                                      right: 10,
                                    ),
                                    child: SingleChildScrollView(
                                      child: Container(
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: Color(0XFFD1D6DC),
                                          borderRadius: BorderRadius.circular(
                                            15,
                                          ),
                                        ),
                                        child: ListTile(
                                          leading: Column(
                                            children: <Widget>[
                                              Padding(
                                                  padding:
                                                      EdgeInsets.only(top: 26)),
                                              // se o registro estiver com status "Finalizado", um icone de confirmação
                                              // é mostrado para o registro
                                              dadosListagem[index]
                                                          .statusProcesso ==
                                                      "Finalizado"
                                                  ? Icon(Icons.check_circle,
                                                      color: Colors.green,
                                                      size: 30)
                                                  : Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 0),
                                                    ),
                                            ],
                                          ),
                                          title: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              FieldsDatabase().listaDadosBanco(
                                                'proprietario: ',
                                                dadosListagem[index]
                                                    .proprietario,
                                                corCampoBanco: dadosListagem[
                                                                index]
                                                            .statusProcesso !=
                                                        "Finalizado"
                                                    ? Colors.blue[800]
                                                    : Colors.green[600],
                                              ),
                                              SizedBox(height: 3),
                                              FieldsDatabase().listaDadosBanco(
                                                'Cidade: ',
                                                dadosListagem[index].cidade,
                                                corCampoBanco: dadosListagem[
                                                                index]
                                                            .statusProcesso !=
                                                        "Finalizado"
                                                    ? Colors.blue[800]
                                                    : Colors.green[600],
                                              ),
                                              SizedBox(height: 3),
                                              FieldsDatabase().listaDadosBanco(
                                                'Bairro: ',
                                                dadosListagem[index].bairro,
                                                corCampoBanco: dadosListagem[
                                                                index]
                                                            .statusProcesso !=
                                                        "Finalizado"
                                                    ? Colors.blue[800]
                                                    : Colors.green[600],
                                              ),
                                              SizedBox(height: 3),
                                              FieldsDatabase().listaDadosBanco(
                                                'Endereço: ',
                                                dadosListagem[index].endereco,
                                                corCampoBanco: dadosListagem[
                                                                index]
                                                            .statusProcesso !=
                                                        "Finalizado"
                                                    ? Colors.blue[800]
                                                    : Colors.green[600],
                                              ),
                                              SizedBox(height: 3),
                                              FieldsDatabase().listaDadosBanco(
                                                'N°: ',
                                                dadosListagem[index]
                                                    .numEndereco
                                                    .toString(),
                                                corCampoBanco: dadosListagem[
                                                                index]
                                                            .statusProcesso !=
                                                        "Finalizado"
                                                    ? Colors.blue[600]
                                                    : Colors.green[500],
                                              ),
                                            ],
                                          ),
                                          trailing: IconButton(
                                            icon: Icon(
                                              Icons.delete_forever,
                                              color: Colors.red,
                                              size: 32,
                                            ),
                                            padding: EdgeInsets.only(
                                              left: 25,
                                              top: 30,
                                            ),
                                            onPressed: () => {
                                              confExcluir(dadosListagem[index]
                                                  .idGrupoMedidas),
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
