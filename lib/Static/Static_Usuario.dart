//
//  =========== ARQUIVO QUE CAPTURA OS DADOS DO USUARIO LOGADO =============

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:projeto_aberturas/Models/Models_Usuario.dart';
import 'package:projeto_aberturas/Models/constantes.dart';

class usuario {
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
          BuscarUsuarioPorId + usuario.idUsuario.toString(),
        ),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'authorization': ModelsUsuarios.tokenAuth,
        });

    Iterable lista = json.decode(result.body);
    listaUsuarios =
        lista.map((model) => ModelsUsuarios.fromJson(model)).toList();
    usuario.idEmpresa ??= listaUsuarios[0].idEmpresa;
    usuario.nome = listaUsuarios[0].name;
    usuario.email = listaUsuarios[0].email;
    usuario.senha = listaUsuarios[0].senha;
    usuario.adm = listaUsuarios[0].adm;
  }
}
