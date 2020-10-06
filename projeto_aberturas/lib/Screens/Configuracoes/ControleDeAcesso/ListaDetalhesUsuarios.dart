import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:projeto_aberturas/Models/Models_Usuario.dart';
import 'package:projeto_aberturas/Models/constantes.dart';
import 'package:http/http.dart' as http;

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
      headers: {"accept": "application/json"},
    );

    //IF(MOUNTED) É nescessario para não recarregar a arvore apos retornar das outras listas
    if (mounted)
      setState(() {
        Iterable lista = json.decode(response.body);
        listaUsuarios =
            lista.map((model) => ModelsUsuarios.fromJson(model)).toList();
      });
  }

// =========== DELETA O REGISTRO DO BANCO DE DADOS
  _deletarReg(int index) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return new AlertDialog(
          content: new Padding(
            padding: EdgeInsets.only(left: 15),
            child: new Text(
              'Confirmar exclusão do usuário?',
              style: new TextStyle(color: Colors.green[300], fontSize: 22),
            ),
          ),
          actions: <Widget>[
            new Row(
              children: <Widget>[
                new FloatingActionButton.extended(
                  backgroundColor: Colors.green,
                  label: Text(
                    'Sim',
                    style: new TextStyle(fontSize: 17),
                    textAlign: TextAlign.center,
                  ),
                  onPressed: () {
                    delete(index);
                    Navigator.of(context).pop();
                    listaDadosUser(id);
                  },
                ),
                //----------------------------------------
                new FloatingActionButton.extended(
                  backgroundColor: Colors.red,
                  label: Text(
                    'Não',
                    style: new TextStyle(fontSize: 17),
                    textAlign: TextAlign.center,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Future<dynamic> delete(int id) async => await http
      .delete(UrlServidor.toString() + DeletarUsuario + id.toString());

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
                  top: size.height * 0.05,
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
                      padding: EdgeInsets.only(left: size.width * 0.1),
                      child: Text(
                        'Dados do usuario',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
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
                                padding:
                                    const EdgeInsets.only(left: 15, right: 15),
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
                                                fontSize: 40,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          subtitle: Text(
                                            'Nome:${listaUsuarios[index].name}' +
                                                '\n'
                                                    'email:${listaUsuarios[index].email}'
                                                    '\n' +
                                                'Cpf:${listaUsuarios[index].cpf}',
                                            style: TextStyle(
                                                fontSize: 40,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black),
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.delete_forever),
                                        onPressed: () => {
                                          _deletarReg(
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
