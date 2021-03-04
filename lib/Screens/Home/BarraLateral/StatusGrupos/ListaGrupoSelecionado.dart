import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:projeto_aberturas/Models/Models_GrupoMedidas.dart';
import 'package:http/http.dart' as http;
import 'package:projeto_aberturas/Models/Models_Usuario.dart';
import 'package:projeto_aberturas/Models/constantes.dart';
import 'package:projeto_aberturas/Screens/Home/BarraHorizontal/NovaMedida/ListaGrupoMedidas/ListadeComodosImovel.dart';
import 'package:projeto_aberturas/Static/Static_GrupoMedidas.dart';
import 'package:projeto_aberturas/Static/Static_StatusGrupo.dart';
import 'package:projeto_aberturas/Static/Static_Usuario.dart';
import 'package:projeto_aberturas/Widget/Crud_DataBase.dart';
import 'package:projeto_aberturas/Widget/MsgPopup.dart';
import 'package:projeto_aberturas/Widget/ListFieldsDataBase.dart';
import 'package:projeto_aberturas/Widget/Cabecalho.dart';

//TELA PARA LISTAR TODOS OS ENDEREÇOS CADASTRADOS
class ListaGrupoSelecionado extends StatefulWidget {
  @override
  _ListaGrupoSelecionadoState createState() => _ListaGrupoSelecionadoState();

  static fromJson(model) {}
}

class _ListaGrupoSelecionadoState extends State<ListaGrupoSelecionado> {
  TextEditingController controllerExcluirGrupo = TextEditingController();
  List<ModelGrupoMedidas> dadosListagem = [];

  Future<dynamic> listarDados() async {
    final response = await http.get(
      Uri.encodeFull(
        StatusGrupos.escolhaStatus + UserLogado.idUsuario.toString(),
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


// ==== MENSAGEM QUE DISPARA PARA EDITAR O GRUPO DE MEDIDAS =====
  popupEdicaoGrupoMedidas(idGrupoMedidas) {
    MsgPopup().msgComDoisBotoes(
      context,
      'Deseja editar o grupo selecionado?',
      'Não',
      'Sim',
      () {
        Navigator.of(context).pop();
      },
      () async {
        // captura os cados do grupo e manda para um arquivo static
        await FieldsGrupoMedidas().capturaDadosGrupoPorId(idGrupoMedidas);
        Navigator.of(context).pop(); // fecha o popup
        Navigator.pushNamed(context, '/EditaGrupoMedidas');
      },
      sairAoPressionar: true,
      corBotaoDir: Color(0XFF0099FF),
      corBotaoEsq: Color(0XFFF4485C),
    );
  }

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

  void listaGrupoMedidasState() {
    listarDados();
  }

  // Controla para apenas um registro fiquei aberto para excluir ou editar
  final SlidableController slidableController = SlidableController();
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
               Cabecalho().tituloCabecalho(
                context,
               StatusGrupos.tituloTela,
                iconeVoltar: true,
                sizeTextTitulo: 0.065,
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: size.width * 0.02,
                    right: size.width * 0.02,
                    bottom: size.height * 0.01),
                child: Container(
                  width: size.width,
                  height: size.height * 0.83,
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
                          return Padding(
                            padding: EdgeInsets.only(
                              left: size.width * 0.015,
                              right: size.width * 0.015,
                              top: size.width * 0.015,
                              bottom: size.width * 0.015,
                            ),
                            child: Container(
                              child: Slidable(
                                fastThreshold: 12,
                                actionPane: SlidableDrawerActionPane(),
                                closeOnScroll: false,
                                actionExtentRatio: 0.25,
                                controller: slidableController,
                                actions: <Widget>[
                                  IconSlideAction(
                                    caption: 'Editar',
                                    color: Colors.white, //(0XFFD1D6DC),
                                    icon: Icons.edit_outlined,
                                    onTap: () => popupEdicaoGrupoMedidas(dadosListagem[index].idGrupoMedidas),
                                  ),
                                ],
                                secondaryActions: <Widget>[
                                  IconSlideAction(
                                    caption: 'Excluir',
                                    color: Colors.red,
                                    icon: Icons.delete_forever,
                                    onTap: () => confExcluir(
                                        dadosListagem[index].idGrupoMedidas),
                                  ),
                                ],
                                child: GestureDetector(
                                  onDoubleTap: () async{
                                    await FieldsGrupoMedidas().capturaDadosGrupoPorId(dadosListagem[index].idGrupoMedidas);
                                    FieldsGrupoMedidas.idGrupoMedidas =
                                        dadosListagem[index].idGrupoMedidas;
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ListaComodoImoveis(
                                          idGrupoMedidas: dadosListagem[index]
                                              .idGrupoMedidas,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 0, top: 0),
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: size.height * 0.16,
                                      width: size.width,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          0,
                                        ),
                                        color: Color(0XFFD1D6DC),
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
                                                    padding: EdgeInsets.only(
                                                        top: 26)),
                                                dadosListagem[index]
                                                            .statusProcesso ==
                                                        "Finalizado"
                                                    ? Icon(Icons.check_circle,
                                                        color: Colors.green,
                                                        size: 30)
                                                    : Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 0),
                                                      ),
                                              ],
                                            ),
                                            title: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                FieldsDatabase()
                                                    .listaDadosBanco(
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
                                                FieldsDatabase()
                                                    .listaDadosBanco(
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
                                                FieldsDatabase()
                                                    .listaDadosBanco(
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
                                                FieldsDatabase()
                                                    .listaDadosBanco(
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
                                                FieldsDatabase()
                                                    .listaDadosBanco(
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
