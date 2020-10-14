//
//  =========== ARQUIVO QUE CAPTURA OS DADOS DA EMPRESA REFERENTE AO USUÁRIO LOGADO =============

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:projeto_aberturas/Models/Models_Empresa.dart';
import 'package:projeto_aberturas/Models/constantes.dart';
import 'package:projeto_aberturas/Static/Static_Usuario.dart';

class Empresa {
  static int idEmpresa;
  static String nome;
  static String cnpj;
  static String cod_Acesso;
  static String cod_Adm;
  static String email;
  static String senha;
}

class DadosEmpresa {
  var listaDadosEmpresa = new List<ModelsEmpresa>();

  Future<BuildContext> capturaDadosEmpresa() async {
    var result = await http.get(
      Uri.encodeFull(
        UrlServidor.toString() +
            BuscarEmpresaPorId.toString() +
            Usuario.idEmpresa.toString(),
      ),
      headers: {"Content-Type": "application/json"},
    );

    Iterable lista = json.decode(result.body);
    listaDadosEmpresa =
        lista.map((model) => ModelsEmpresa.fromJson(model)).toList();

    var index = 0;

    Empresa.idEmpresa = listaDadosEmpresa[index].idEmpresa;
    Empresa.nome = listaDadosEmpresa[index].nome;
    Empresa.email = listaDadosEmpresa[index].email;
    Empresa.senha = listaDadosEmpresa[index].senha;
    Empresa.cod_Acesso = listaDadosEmpresa[index].cod_Acesso;
    Empresa.cod_Adm = listaDadosEmpresa[index].cod_Adm;

    json.encoder;
  }
}
