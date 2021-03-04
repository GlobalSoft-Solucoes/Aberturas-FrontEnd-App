//
//  =========== ARQUIVO QUE CAPTURA OS DADOS DO USUARIO LOGADO =============

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:projeto_aberturas/Models/Models_Usuario.dart';
import 'package:projeto_aberturas/Models/constantes.dart';

class UserLogado {
  static int idUsuario;
  static int idEmpresa;
  static String nome;
  static String email;
  static String senha;
  static String adm;
  static String token;

  List<ModelsUsuarios> listaUsuarios = [];

  // Future<BuildContext> capturaDadosUsuarioLogado() async {
  void capturaDadosUsuarioLogado() async {
    var result = await http.get(
        Uri.encodeFull(
          BuscarUsuarioPorId + UserLogado.idUsuario.toString(),
        ),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'authorization': ModelsUsuarios.tokenAuth,
        });

    Iterable lista = json.decode(result.body);
    listaUsuarios =
        lista.map((model) => ModelsUsuarios.fromJson(model)).toList();
    UserLogado.idUsuario ??= listaUsuarios[0].idUsuario;
    UserLogado.idEmpresa ??= listaUsuarios[0].idEmpresa;
    UserLogado.nome = listaUsuarios[0].name;
    UserLogado.email = listaUsuarios[0].email;
    UserLogado.senha = listaUsuarios[0].senha;
    UserLogado.adm = listaUsuarios[0].adm;
  }
}

class FieldsUsuario {
  static int idUsuario;
  static int idEmpresa;
  static String nome;
  static String email;
  static String senha;
  static String adm;
  static String token;

  List<ModelsUsuarios> listaUsuarios = [];

  Future<BuildContext> capturaDadosUsuariosPorId(idUsuarioSelecionado) async {
    var result = await http.get(
      Uri.encodeFull(
        BuscarUsuarioPorId + idUsuarioSelecionado.toString(),
      ),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'authorization': ModelsUsuarios.tokenAuth,
      },
    );

    Iterable lista = json.decode(result.body);
    listaUsuarios =
        lista.map((model) => ModelsUsuarios.fromJson(model)).toList();
    FieldsUsuario.idUsuario =
        idUsuarioSelecionado; //listaUsuarios[0].idUsuario;
    FieldsUsuario.idEmpresa ??= listaUsuarios[0].idEmpresa;
    FieldsUsuario.nome = listaUsuarios[0].name;
    FieldsUsuario.email = listaUsuarios[0].email;
    FieldsUsuario.senha = listaUsuarios[0].senha;
    FieldsUsuario.adm = listaUsuarios[0].adm;
  }
}
