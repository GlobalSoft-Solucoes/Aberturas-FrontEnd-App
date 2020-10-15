import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:projeto_aberturas/Models/Models_Usuario.dart';
import 'package:projeto_aberturas/Models/constantes.dart';
import 'package:http/http.dart' as http;
import 'package:projeto_aberturas/Widget/MsgPopup.dart';

class ListaDetUsu extends StatefulWidget {
  final int id;
  ListaDetUsu({Key key, @required this.id}) : super(key: key);
  @override
  _ListaDetUsuState createState() => _ListaDetUsuState(id: id);
}

class _ListaDetUsuState extends State<ListaDetUsu> {
  final int id;
  var listaUsuarios = new List<ModelsUsuarios>();
  _ListaDetUsuState({@required this.id}) {
    listaDadosUser(id);
  }

  Future<dynamic> listaDadosUser(int id) async {
    final response = await http.get(
      Uri.encodeFull(UrlServidor + BuscarUsuarioPorId + id.toString()),
      headers: {"authorization": ModelsUsuarios.tokenAuth},
    );

    //IF(MOUNTED) É nescessario para não recarregar a arvore apos retornar das outras listas
    if (mounted) {
      setState(() {
        Iterable lista = json.decode(response.body);
        listaUsuarios =
            lista.map((model) => ModelsUsuarios.fromJson(model)).toList();
      });
    } else if (response.statusCode == 401) {
      Navigator.pushNamed(context, '/Login');
    }
  }

// =========== DELETA O REGISTRO DO BANCO DE DADOS
  deletarReg(index) {
    MsgPopup().msgComDoisBotoes(
        context,
        'Deseja Excluir este usuario?',
        'NÃO',
        'SIM',
        () => {Navigator.pop(context)},
        () => {delete(index), Navigator.pop(context)});
  }

  Future<dynamic> delete(index) async {
    var response = await http
        .delete(UrlServidor.toString() + DeletarUsuario + index.toString());
    if (response.statusCode == 401) {
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
        color: Colors.blue,
        child: Column(
          children: [
            // ================================================
            Padding(
              padding: EdgeInsets.only(
                  left: size.width * 0.02,
                  right: size.width * 0.02,
                  top: size.height * 0.04,
                  bottom: size.height * 0.02),
              child: Container(
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      iconSize: 30,
                      color: Colors.white,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: size.width * 0.15),
                      child: Text(
                        'Dados do usuario',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            // =============================================
            Padding(
              padding: EdgeInsets.only(
                  left: size.width * 0.02,
                  right: size.width * 0.02,
                  bottom: size.height * 0.02),
              child: Container(
                width: size.width,
                height: size.height * 0.84,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white),
                child: FutureBuilder(
                  future: listaDadosUser(id),
                  builder: (BuildContext context, snapshot) {
                    return ListView.builder(
                      itemCount: listaUsuarios.length,
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
                                        child: ListTile(
                                          title: Text(
                                            'ID: ${listaUsuarios[index].idUsuario}',
                                            style: TextStyle(
                                                fontSize: 26,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          subtitle: Text(
                                            'Nome: ${listaUsuarios[index].name}' +
                                                '\n'
                                                    'E-mail: ${listaUsuarios[index].email}'
                                                    '\n',
                                            style: TextStyle(
                                                fontSize: 26,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black),
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.delete_forever,
                                          color: Colors.red,
                                        ),
                                        onPressed: () => {
                                          deletarReg(
                                              listaUsuarios[index].idUsuario),
                                        },
                                        iconSize: 40,
                                      ),
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
