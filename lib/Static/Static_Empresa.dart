//
//  =========== ARQUIVO QUE CAPTURA OS DADOS DA EMPRESA REFERENTE AO USU�RIO LOGADO =============

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:projeto_aberturas/Models/Models_Empresa.dart';
import 'package:projeto_aberturas/Models/Models_Usuario.dart';
import 'package:projeto_aberturas/Models/constantes.dart';
import 'package:projeto_aberturas/Static/Static_Usuario.dart';

class FieldsEmpresa {
  static int idEmpresa;
  static String nome;
  static String cnpj;
  static String codAcesso;
  static String codAdm;
  static String email;
  static String senha;
}

class DadosEmpresa {
  List<ModelsEmpresa> listaDadosEmpresa = [];

  Future<BuildContext> capturaDadosEmpresa() async {
    var result = await http.get(
        Uri.encodeFull(
              BuscarEmpresaPorId.toString() +
              UserLogado.idEmpresa.toString(),
        ),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': ModelsUsuarios.tokenAuth,
        });

    Iterable lista = json.decode(result.body);
    listaDadosEmpresa =
        lista.map((model) => ModelsEmpresa.fromJson(model)).toList();

    FieldsEmpresa.idEmpresa = listaDadosEmpresa[0].idEmpresa;
    FieldsEmpresa.nome = listaDadosEmpresa[0].nome;
    FieldsEmpresa.email = listaDadosEmpresa[0].email;
    FieldsEmpresa.senha = listaDadosEmpresa[0].senha;
    FieldsEmpresa.codAcesso = listaDadosEmpresa[0].codAcesso;
    FieldsEmpresa.codAdm = listaDadosEmpresa[0].codAdm;
    json.encoder;
  }
}
