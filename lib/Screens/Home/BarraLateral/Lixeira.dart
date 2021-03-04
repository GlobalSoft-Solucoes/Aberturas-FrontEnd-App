import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:http/http.dart' as http;
import 'package:projeto_aberturas/Models/Models_GrupoMedidas.dart';
import 'package:projeto_aberturas/Models/Models_Usuario.dart';
import 'package:projeto_aberturas/Models/constantes.dart';
import 'package:projeto_aberturas/Static/Static_Usuario.dart';
import 'package:projeto_aberturas/Widget/Cabecalho.dart';
import 'package:projeto_aberturas/Widget/ListFieldsDataBase.dart';
import 'package:projeto_aberturas/Widget/MsgPopup.dart';

class Lixeira extends StatefulWidget {
  @override
  _LixeiraState createState() => _LixeiraState();
}

class _LixeiraState extends State<Lixeira> {
  //LISTA OS GRUPO COM ESTATUS DE REMOVIDO
  List<ModelGrupoMedidas> dadosListagem = [];
  Future listarDados() async {
    final response = await http.get(
      Uri.encodeFull(
          ListarGrupoComStatusRemovido + UserLogado.idUsuario.toString()),
      headers: {"authorization": ModelsUsuarios.tokenAuth},
    );
    if (mounted) {
      setState(() {
        Iterable lista = json.decode(response.body);

        dadosListagem =
            lista.map((model) => ModelGrupoMedidas.fromJson(model)).toList();
      });
    }
    if (response.statusCode == 401) {
      Navigator.pushNamed(context, '/Login');
    }
  }

//POPUP EXCLUIR
  excluir(id) {
    MsgPopup().msgComDoisBotoes(
        context,
        'Deseja excluir permanentemente este grupo?',
        'NÃO',
        'SIM',
        () => {Navigator.pop(context)},
        () => {_deletarReg(id), Navigator.pop(context)});
  }

  // altera o STATUS PROCESSO do registro para CADASTRADO
  Future<dynamic> alterarStatus(idGrupo) async {
    var response = await http.put(
      AlterarStatusParaCadastrado + idGrupo.toString(),
      headers: {"authorization": ModelsUsuarios.tokenAuth},
    );
    if (response.statusCode == 401) {
      Navigator.pushNamed(context, '/Login');
    }
  }

//POPUP RESTAURAR
  restaurar(id) {
    print(id);
    MsgPopup().msgComDoisBotoes(
      context,
      'Deseja restaurar este Grupo de Medidas?',
      'Não',
      'Sim',
      () => {
        Navigator.pop(context),
      },
      () => {
        restaurarReg(id),
        alterarStatus(id),
        Navigator.pop(context),
      },
    );
  }

//MUDA O STATUS PARA RESTAURADO
  restaurarReg(id) async {
    http.Response state = await http.put(
      StatusNullGrupo + id.toString(),
      headers: {"authorization": ModelsUsuarios.tokenAuth},
    );
    if (state.statusCode == 201) {
      print('SUCESSO');
    } else {
      print('erro');
    }
    if (state.statusCode == 401) {
      Navigator.pushNamed(context, '/Login');
    }
  }

//Muda O STATUS PARA EXCLUIDO
  _deletarReg(id) async {
    print(id);
    http.Response state = await http.put(
      StatusExcluirGrupo + id.toString(),
      headers: {"authorization": ModelsUsuarios.tokenAuth},
    );
    if (state.statusCode == 201) {
      print('SUCESSO');
    } else {
      print('erro');
    }
    if (state.statusCode == 401) {
      Navigator.pushNamed(context, '/Login');
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
        color: Color(0xFFBCE0F0),
        width: size.width,
        height: size.height,
        child: Column(
          children: [
            Cabecalho().tituloCabecalho(context, 'Grupos removidos',
                iconeVoltar: true),
            Padding(
              padding: EdgeInsets.only(
                  left: size.width * 0.02, right: size.width * 0.02),
              child: Container(
                height: size.height * 0.82,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15)),
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
                                  caption: 'Restaurar',
                                  color: Colors.green, //(0XFFD1D6DC),
                                  icon: Icons.restore,
                                  onTap: () => restaurar(
                                      dadosListagem[index].idGrupoMedidas),
                                ),
                              ],
                              secondaryActions: <Widget>[
                                IconSlideAction(
                                  caption: 'Excluir',
                                  color: Colors.red,
                                  icon: Icons.delete_forever,
                                  onTap: () => excluir(
                                      dadosListagem[index].idGrupoMedidas),
                                ),
                              ],
                              child: Container(
                                alignment: Alignment.center,
                                height: size.height * 0.17,
                                width: size.width,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    5,
                                  ),
                                  color: Color(0XFFD1D6DC),
                                ),
                                child: SingleChildScrollView(
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: Color(0XFFD1D6DC),
                                      borderRadius: BorderRadius.circular(
                                        5,
                                      ),
                                    ),
                                    child: ListTile(
                                      title: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          FieldsDatabase().listaDadosBanco(
                                            'Proprietario: ',
                                            dadosListagem[index].proprietario,
                                          ),
                                          SizedBox(height: 3),
                                          FieldsDatabase().listaDadosBanco(
                                            'Cidade: ',
                                            dadosListagem[index].cidade,
                                          ),
                                          SizedBox(height: 3),
                                          FieldsDatabase().listaDadosBanco(
                                            'Bairro: ',
                                            dadosListagem[index].bairro,
                                          ),
                                          SizedBox(height: 3),
                                          FieldsDatabase().listaDadosBanco(
                                            'Endereço: ',
                                            dadosListagem[index].endereco,
                                          ),
                                          SizedBox(height: 3),
                                          FieldsDatabase().listaDadosBanco(
                                            'N°: ',
                                            dadosListagem[index]
                                                .numEndereco
                                                .toString(),
                                          ),
                                        ],
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
    );
  }
}
