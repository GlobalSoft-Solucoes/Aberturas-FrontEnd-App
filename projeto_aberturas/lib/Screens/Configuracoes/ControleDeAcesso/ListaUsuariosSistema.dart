import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projeto_aberturas/Models/Models_Usuario.dart';
import 'package:projeto_aberturas/Models/constantes.dart';
import 'package:projeto_aberturas/Screens/Configuracoes/ControleDeAcesso/ListaDetalhesUsuarios.dart';
import 'package:http/http.dart' as http;
import 'package:projeto_aberturas/Static/Static_Empresa.dart';

class ListaUsuCadastrados extends StatefulWidget {
  @override
  _ListaUsuCadastradosState createState() => _ListaUsuCadastradosState();
}

class _ListaUsuCadastradosState extends State<ListaUsuCadastrados> {
  var listaUsuarios = new List<ModelsUsuarios>();
  Future<dynamic> fetchPost() async {
    final response = await http.get(
        Uri.encodeFull(
          UrlServidor + ListarUsuariosPorEmpresa + Empresa.idEmpresa.toString(),
        ),
        headers: {"authorization": ModelsUsuarios.tokenAuth});
    //IF(MOUNTED) É nescessario para não recarregar a arvore apos retornar das outras listas
    if (mounted)
      setState(() {
        Iterable lista = json.decode(response.body);
        listaUsuarios =
            lista.map((model) => ModelsUsuarios.fromJson(model)).toList();
      });
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
            Padding(
              padding: EdgeInsets.only(
                  left: size.width * 0.02,
                  right: size.width * 0.02,
                  top: size.height * 0.05,
                  bottom: size.height * 0.02),
              child: Container(
                alignment: Alignment.centerLeft,
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
                        'Lista de Usuario Cadastrados',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Container(
                height: size.height * 0.84,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white),
                child: FutureBuilder(
                  future: fetchPost(),
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
                              height: size.height * 0.10,
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
                                child: GestureDetector(
                                  onDoubleTap: () {
                                    //IdGrupoMediddas.idGrupoMedidas =
                                    //  listaUsuarios[index].id;
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ListaDetUsu(
                                          id: listaUsuarios[index].idUsuario,
                                        ),
                                      ),
                                    );
                                  },
                                  child: SingleChildScrollView(
                                    child: Container(
                                      // alignment: Alignment.center,
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
                                        subtitle: Text(
                                          'Nome: ${listaUsuarios[index].name}' +
                                              '\n'
                                                  'E-mail: ${listaUsuarios[index].email}',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
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
    );
  }
}
