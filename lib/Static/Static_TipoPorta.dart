//
//  =========== ARQUIVO QUE CAPTURA OS DADOS DO USUARIO LOGADO =============

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:projeto_aberturas/Models/Models_TipoPorta.dart';
import 'package:projeto_aberturas/Models/Models_Usuario.dart';
import 'package:projeto_aberturas/Models/constantes.dart';

class TipoPorta {
  static int idTipoPorta;
  static String nome;
  static String descricao;
  static double descontoAltura;
  static double descontoLargura;
}

class DadosTipoPortaPorId {

  static int idTipoPorta;
  static String nome;
  static String descricao;
  static double descontoAltura;
  static double descontoLargura;

  var listaDadosTipoPorta = new List<ModelsTipoPorta>();

  Future<BuildContext> capturaDadosTipoPortaPorId(idTipoPorta) async {
    var result = await http.get(
        Uri.encodeFull(
              BuscaTipoPortaPorId + idTipoPorta.toString(),
        ),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'authorization': ModelsUsuarios.tokenAuth,
        });

    Iterable lista = json.decode(result.body);
    listaDadosTipoPorta =
        lista.map((model) => ModelsTipoPorta.fromJson(model)).toList();
    DadosTipoPortaPorId.idTipoPorta ??= listaDadosTipoPorta[0].idTipoPorta;
    DadosTipoPortaPorId.nome = listaDadosTipoPorta[0].nome;
    DadosTipoPortaPorId.descricao = listaDadosTipoPorta[0].descricao;
    DadosTipoPortaPorId.descontoAltura = listaDadosTipoPorta[0].descontoAltura;
    DadosTipoPortaPorId.descontoLargura = listaDadosTipoPorta[0].descontoLargura;
  }
}
