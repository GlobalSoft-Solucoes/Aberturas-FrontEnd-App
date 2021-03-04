import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:projeto_aberturas/Models/Models_Usuario.dart';
import 'package:projeto_aberturas/Models/constantes.dart';
import 'package:http/http.dart' as http;
import 'package:projeto_aberturas/Static/Static_Empresa.dart';
import 'package:projeto_aberturas/Static/Static_Usuario.dart';
import 'package:projeto_aberturas/Widget/Botao.dart';
import 'package:projeto_aberturas/Widget/Cabecalho.dart';
import 'package:projeto_aberturas/Widget/Crud_DataBase.dart';
import 'package:projeto_aberturas/Widget/ListFieldsDataBase.dart';
import 'package:projeto_aberturas/Widget/MsgPopup.dart';
import 'package:projeto_aberturas/Screens/Home/BarraLateral/Usuario/ListaDadosUsuario.dart';

class ListaUsuariosEmpresa extends StatefulWidget {
  @override
  _ListaUsuariosEmpresaState createState() => _ListaUsuariosEmpresaState();
}

class _ListaUsuariosEmpresaState extends State<ListaUsuariosEmpresa> {
  var mensagemErro = '';

  List<ModelsUsuarios> dadosListagem = [];

  Future<dynamic> fetchPost() async {
    final response = await http.get(
        Uri.encodeFull(
          ListarUsuariosPorEmpresa + FieldsEmpresa.idEmpresa.toString(),
        ),
        headers: {"authorization": ModelsUsuarios.tokenAuth});
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

  // ======== chama um popup pedindo permissão para deletar o registro =========
  _deletarReg(int index) {
    MsgPopup().msgComDoisBotoes(
      context,
      'Confirma a exclusão da cargo selecionado?',
      'Não',
      'Sim',
      () => {Navigator.of(context).pop()},
      () => {
        deletar(index),
        Navigator.of(context).pop(),
      },
      corBotaoEsq: Color(0XFFF4485C),
      sairAoPressionar: true,
    );
  }

  // ======== FUNÇÃO QUE DELETA O PIVOTANTE DO BANCO DE DADOS ==========
  Future<dynamic> deletar(int id) async {
    ReqDataBase().requisicaoDelete(DeletarUsuario + id.toString());

    if (ReqDataBase.responseReq.statusCode == 400) {
      MsgPopup().msgFeedback(
        context,
        '\nO cargo selecionado está sendo usado e portanto não pode ser excluído.',
        'Aviso',
      );
    }
  }

  // Controla para apenas um registro fiquei aberto para excluir ou editar
  final SlidableController slidableController = SlidableController();
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
            Cabecalho().tituloCabecalho(context, 'Usuários cadastrados',
                iconeVoltar: true),
            Padding(
              padding: EdgeInsets.only(
                  left: size.width * 0.015, right: size.width * 0.015),
              child: Container(
                height: size.height * 0.72,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white),
                child: FutureBuilder(
                  future: fetchPost(),
                  builder: (BuildContext context, snapshot) {
                    return ListView.builder(
                      itemCount: dadosListagem.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(
                            left: size.width * 0.015,
                            right: size.width * 0.015,
                            top: size.width * 0.015,
                            bottom: 2,
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
                                  color: Colors.white,
                                  icon: Icons.edit_outlined,
                                  onTap: () async {
                                    await FieldsUsuario()
                                        .capturaDadosUsuariosPorId(
                                            dadosListagem[index].idUsuario);
                                    Navigator.pushNamed(
                                        context, '/EditarDadosUsuario');
                                  },
                                ),
                              ],
                              secondaryActions: <Widget>[
                                IconSlideAction(
                                  caption: 'Excluir',
                                  color: Colors.red,
                                  icon: Icons.delete_forever,
                                  onTap: () => _deletarReg(
                                      dadosListagem[index].idUsuario),
                                ),
                              ],
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 0, left: 0, right: 0),
                                child: Container(
                                  height: size.height * 0.15,
                                  width: size.width,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                      0,
                                    ),
                                    color: Color(0XFFD1D6DC),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15, right: 15),
                                    child: GestureDetector(
                                      onDoubleTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ListaDadosUsuario(
                                              id: dadosListagem[index]
                                                  .idUsuario,
                                            ),
                                          ),
                                        );
                                      },
                                      child: SingleChildScrollView(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Color(0XFFD1D6DC),
                                            borderRadius: BorderRadius.circular(
                                              15,
                                            ),
                                          ),
                                          child: ListTile(
                                            title: Text(
                                              'N°${index + 1}',
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            subtitle: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(height: 5),
                                                FieldsDatabase()
                                                    .listaDadosBanco(
                                                        'Nome: ',
                                                        dadosListagem[index]
                                                            .name,
                                                        sizeCampoBanco: 20,
                                                        sizeTextoCampo: 20),
                                                SizedBox(height: 4),
                                                FieldsDatabase()
                                                    .listaDadosBanco(
                                                        'E-mail: ',
                                                        dadosListagem[index]
                                                            .email,
                                                        sizeCampoBanco: 20,
                                                        sizeTextoCampo: 20),
                                                SizedBox(height: 4),
                                                FieldsDatabase()
                                                    .listaDadosBanco(
                                                        'Cadastrado em: ',
                                                        dadosListagem[index]
                                                            .dataCadastro,
                                                        sizeCampoBanco: 20,
                                                        sizeTextoCampo: 20),
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
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: size.height * 0.03),
              child: Botao().botaoPadrao(
                'Cadastrar usuário',
                () => Navigator.pushNamed(context, '/CadastroUsuario'),
                Colors.white,
                border: BorderRadius.circular(25),
                altura: size.height * 0.065,
                comprimento: size.height * 0.3,
              ),
            )
          ],
        ),
      ),
    );
  }
}
