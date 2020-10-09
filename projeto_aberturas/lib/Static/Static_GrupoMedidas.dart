//
//  =========== ARQUIVO QUE CAPTURA OS DADOS DO GRUPO DE MEDIDAS =============

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:projeto_aberturas/Models/Models_GrupoMedidas.dart';
import 'package:projeto_aberturas/Models/constantes.dart';

class GrupoMediddas {
  static int idGrupoMedidas;
  static String endereco;
  static String proprietario;
  static int numEndereco;
  static String cidade;
  static String bairro;
}

class DadosUserLogado {
  var listaDadosGrupo = new List<ModelGrupoMedidas>();

  Future<BuildContext> capturaDadosGrupoSelecionado() async {
    var result = await http.get(
      Uri.encodeFull(
        UrlServidor.toString() +
            BuscarUsuarioPorId +
            GrupoMediddas.idGrupoMedidas.toString(),
        // Usuario.idUsuario.toString(),
      ),
      headers: {"Content-Type": "application/json"},
    );

    Iterable lista = json.decode(result.body);
    listaDadosGrupo =
        lista.map((model) => ModelGrupoMedidas.fromJson(model)).toList();
    // Usuario.nome = 'testeusuario';
    GrupoMediddas.endereco = listaDadosGrupo[0].endereco;
    GrupoMediddas.proprietario = listaDadosGrupo[0].proprietario;
    GrupoMediddas.numEndereco = listaDadosGrupo[0].numEndereco;
    GrupoMediddas.cidade = listaDadosGrupo[0].cidade;
    GrupoMediddas.bairro = listaDadosGrupo[0].bairro;
  }
}
