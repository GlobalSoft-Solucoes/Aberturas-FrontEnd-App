import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:projeto_aberturas/Models/Models_Usuario.dart';
import 'package:projeto_aberturas/Models/constantes.dart';
import 'package:http/http.dart' as http;
import 'package:projeto_aberturas/Widget/Cabecalho.dart';
import 'package:projeto_aberturas/Widget/Crud_DataBase.dart';
import 'package:projeto_aberturas/Widget/MsgPopup.dart';
import 'package:projeto_aberturas/Widget/ListFieldsDataBase.dart';

class ListaDadosUsuario extends StatefulWidget {
  final int id;
  ListaDadosUsuario({Key key, @required this.id}) : super(key: key);
  @override
  _ListaDetUsuState createState() => _ListaDetUsuState(id: id);
}

class _ListaDetUsuState extends State<ListaDadosUsuario> {
  final int id;
  List<ModelsUsuarios> dadosListagem = [];
  _ListaDetUsuState({@required this.id}) {
    listaDadosUser(id);
  }

  Future<dynamic> listaDadosUser(int id) async {
    final response = await http.get(
      Uri.encodeFull(BuscarUsuarioPorId + id.toString()),
      headers: {"authorization": ModelsUsuarios.tokenAuth},
    );

    //IF(MOUNTED) É nescessario para não recarregar a arvore apos retornar das outras listas
    if (mounted)
      setState(() {
        Iterable lista = json.decode(response.body);
        dadosListagem =
            lista.map((model) => ModelsUsuarios.fromJson(model)).toList();
      });
    if (response.statusCode == 401) {
      Navigator.pushNamed(context, '/Login');
    }
  }

// =========== DELETA O REGISTRO DO BANCO DE DADOS
  deletarReg(index) {
    MsgPopup().msgComDoisBotoes(
        context,
        'Deseja Excluir este usuário?',
        'NÃO',
        'SIM',
        () => {Navigator.pop(context)},
        () => {delete(index), Navigator.pop(context)});
  }

  Future<dynamic> delete(index) async {
    ReqDataBase().requisicaoDelete(DeletarUsuario + id.toString());
    // var response = await http.delete(
    //   DeletarUsuario + index.toString(),
    //   headers: {"authorization": ModelsUsuarios.tokenAuth},
    // );
    if (ReqDataBase.responseReq.statusCode == 200) {
      Navigator.pop(context);
    } else if (ReqDataBase.responseReq.statusCode == 401) {
      Navigator.pushNamed(context, '/Login');
    }
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    Size size = mediaQuery.size;
    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        color: Color(0xFFBCE0F0),
        child: Column(
          children: [
            // ================================================
            Cabecalho().tituloCabecalho(context, 'Dados do usuário',
                iconeVoltar: true),
            // ==================================================
            Padding(
              padding: EdgeInsets.only(
                  left: size.width * 0.02,
                  right: size.width * 0.02,
                  bottom: size.height * 0.02),
              child: Container(
                width: size.width,
                height: size.height * 0.82,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white),
                child: FutureBuilder(
                  future: listaDadosUser(id),
                  builder: (BuildContext context, snapshot) {
                    return ListView.builder(
                      itemCount: dadosListagem.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(
                            bottom: 2.0,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 4.0, left: 4, right: 4),
                            child: Container(
                              height: size.height * 0.50,
                              width: size.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  10,
                                ),
                                color: Color(0XFFD1D6DC),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 15, right: 15, top: 40),
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Color(0XFFD1D6DC),
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
                                                FieldsDatabase()
                                                    .listaDadosBanco(
                                                  'Data do cadastro: ',
                                                  dadosListagem[index]
                                                      .dataCadastro,
                                                  sizeCampoBanco: 24,
                                                  sizeTextoCampo: 24,
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 15),
                                            FieldsDatabase().listaDadosBanco(
                                              'Nome: ',
                                              dadosListagem[index].name,
                                              sizeCampoBanco: 24,
                                              sizeTextoCampo: 24,
                                            ),
                                            SizedBox(height: 15),
                                            FieldsDatabase().listaDadosBanco(
                                              'E-mail: ',
                                              dadosListagem[index]
                                                  .email
                                                  .toString(),
                                              sizeCampoBanco: 24,
                                              sizeTextoCampo: 24,
                                            ),
                                            SizedBox(height: 15),
                                            FieldsDatabase().listaDadosBanco(
                                              'Senha: ',
                                              dadosListagem[index]
                                                  .senha
                                                  .toString(),
                                              sizeCampoBanco: 24,
                                              sizeTextoCampo: 24,
                                            ),
                                            SizedBox(height: 25),
                                            //========================================================
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: size.height * 0.18),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    bottom: size.height * 0.02),
                                                child: IconButton(
                                                  icon: Icon(
                                                      Icons.delete_forever),
                                                  onPressed: () => {
                                                    deletarReg(
                                                        dadosListagem[index]
                                                            .idUsuario)
                                                  },
                                                  iconSize: 40,
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              // -----------------------------------------
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
    );
  }
}
