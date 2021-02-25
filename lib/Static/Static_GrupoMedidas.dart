//
//  =========== ARQUIVO QUE CAPTURA OS DADOS DO GRUPO DE MEDIDAS =============

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:projeto_aberturas/Models/Models_GrupoMedidas.dart';
import 'package:projeto_aberturas/Models/Models_Usuario.dart';
import 'package:projeto_aberturas/Models/constantes.dart';

class GrupoMedidas {
  static int idGrupoMedidas;
  static int idImovel;
  static String endereco;
  static String proprietario;
  static int numEndereco;
  static String cidade;
  static String bairro;
}

class DadosGrupoSelecionado {
  var listaDadosGrupo = new List<ModelGrupoMedidas>();

  Future<BuildContext> capturaDadosGrupoSelecionado() async {
    var result = await http.get(
      Uri.encodeFull(
            BuscarGrupoPorId +
            GrupoMedidas.idGrupoMedidas.toString(),
        // usuario.idUsuario.toString(),
      ),
      headers: {
        "authorization": ModelsUsuarios.tokenAuth,
        "Content-Type": "application/json"
      },
    );

    Iterable lista = json.decode(result.body);
    listaDadosGrupo =
        lista.map((model) => ModelGrupoMedidas.fromJson(model)).toList();
    // usuario.nome = 'testeusuario';
    GrupoMedidas.endereco = listaDadosGrupo[0]?.endereco;
    GrupoMedidas.proprietario = listaDadosGrupo[0]?.proprietario;
    GrupoMedidas.numEndereco = listaDadosGrupo[0]?.numEndereco;
    GrupoMedidas.cidade = listaDadosGrupo[0]?.cidade;
    GrupoMedidas.bairro = listaDadosGrupo[0]?.bairro;
    GrupoMedidas.idImovel = listaDadosGrupo[0]?.idImovel;
  }
}
