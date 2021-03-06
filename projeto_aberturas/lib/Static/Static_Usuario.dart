//
//  =========== ARQUIVO QUE CAPTURA OS DADOS DO USUARIO LOGADO =============

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:projeto_aberturas/Models/Models_Usuario.dart';
import 'package:projeto_aberturas/Models/constantes.dart';

class Usuario {
  static int idUsuario;
  static int idEmpresa;
  static String nome;
  static String email;
  static String senha;
  static String adm;
  static String token;
}

class DadosUserLogado {
  var listaUsuarios = new List<ModelsUsuarios>();

  Future<BuildContext> capturaDadosUsuarioLogado() async {
    var result = await http.get(
        Uri.encodeFull(
          UrlServidor.toString() +
              BuscarUsuarioPorId +
              Usuario.idUsuario.toString(),
        ),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'authorization': ModelsUsuarios.tokenAuth,
        });

    Iterable lista = json.decode(result.body);
    listaUsuarios =
        lista.map((model) => ModelsUsuarios.fromJson(model)).toList();
    Usuario.idEmpresa ??= listaUsuarios[0].idEmpresa;
    Usuario.nome = listaUsuarios[0].name;
    Usuario.email = listaUsuarios[0].email;
    Usuario.senha = listaUsuarios[0].senha;
    Usuario.adm = listaUsuarios[0].adm;
  }
}
