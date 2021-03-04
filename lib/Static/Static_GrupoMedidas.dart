//
//  =========== ARQUIVO QUE CAPTURA OS DADOS DO GRUPO DE MEDIDAS =============

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:projeto_aberturas/Models/Models_GrupoMedidas.dart';
import 'package:projeto_aberturas/Models/Models_Usuario.dart';
import 'package:projeto_aberturas/Models/constantes.dart';

class FieldsGrupoMedidas {
  static int idGrupoMedidas;
  static int idImovel;
  static String endereco;
  static String proprietario;
  static int numEndereco;
  static String cidade;
  static String bairro;
  static String statusGProcesso;

  List<ModelGrupoMedidas> listaDadosGrupo = [];

  // Future<BuildContext> capturaDadosGrupoPorId(
  void capturaDadosGrupoPorId(idGrupoMedidasSelecionado) async {
    var result = await http.get(
      Uri.encodeFull(
        BuscarGrupoPorId + idGrupoMedidasSelecionado.toString(),
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
    idGrupoMedidas = listaDadosGrupo[0]?.idGrupoMedidas;
    endereco = listaDadosGrupo[0]?.endereco;
    proprietario = listaDadosGrupo[0]?.proprietario;
    numEndereco = listaDadosGrupo[0]?.numEndereco;
    cidade = listaDadosGrupo[0]?.cidade;
    bairro = listaDadosGrupo[0]?.bairro;
    idImovel = listaDadosGrupo[0]?.idImovel;
    statusGProcesso = listaDadosGrupo[0].statusProcesso;
  }
}
