import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:projeto_aberturas/Models/Models_GrupoMedidas.dart';
import 'package:projeto_aberturas/Models/Models_Usuario.dart';
import 'package:projeto_aberturas/Models/constantes.dart';
import 'package:projeto_aberturas/Static/Static_Usuario.dart';
import 'package:projeto_aberturas/Widget/MsgPopup.dart';

class Lixeira extends StatefulWidget {
  @override
  _LixeiraState createState() => _LixeiraState();
}

class _LixeiraState extends State<Lixeira> {
  //LISTA OS GRUPO COM ESTATUS DE REMOVIDO
  var grupoMedidas = new List<ModelGrupoMedidas>();
  Future listarDados() async {
    final response = await http.get(
      Uri.encodeFull(
          ListarGrupoComStatusRemovido +
          usuario.idUsuario.toString()),
      headers: {"authorization": ModelsUsuarios.tokenAuth},
    );
    if (mounted) {
      setState(() {
        Iterable lista = json.decode(response.body);

        grupoMedidas =
            lista.map((model) => ModelGrupoMedidas.fromJson(model)).toList();
      });
    }
    if (response.statusCode == 401) {
      Navigator.pushNamed(context, '/Login');
    }
  }

//POPUP EXCLUIR
  excluir(id) {
    MsgPopup().msgComDoisBotoes(
        context,
        'Deseja excluir permanentemente este grupo?',
        'NÃO',
        'SIM',
        () => {Navigator.pop(context)},
        () => {_deletarReg(id), Navigator.pop(context)});
  }

  // altera o STATUS PROCESSO do registro para CADASTRADO
  Future<dynamic> alterarStatus(idGrupo) async {
    var response = await http.put(
      AlterarStatusParaCadastrado + idGrupo.toString(),
      headers: {"authorization": ModelsUsuarios.tokenAuth},
    );
    if (response.statusCode == 401) {
      Navigator.pushNamed(context, '/Login');
    }
  }

//POPUP RESTAURAR
  restaurar(id) {
    print(id);
    MsgPopup().msgComDoisBotoes(
      context,
      'Deseja restaurar este Grupo de Medidas?',
      'Não',
      'Sim',
      () => {
        Navigator.pop(context),
      },
      () => {
        restaurarReg(id),
        alterarStatus(id),
        Navigator.pop(context),
      },
    );
  }

//MUDA O STATUS PARA RESTAURADO
  restaurarReg(id) async {
    http.Response state = await http.put(
      StatusNullGrupo + id.toString(),
      headers: {"authorization": ModelsUsuarios.tokenAuth},
    );
    if (state.statusCode == 201) {
      print('SUCESSO');
    } else {
      print('erro');
    }
    if (state.statusCode == 401) {
      Navigator.pushNamed(context, '/Login');
    }
  }

//Muda O STATUS PARA EXCLUIDO
  _deletarReg(id) async {
    print(id);
    http.Response state = await http.put(
      StatusExcluirGrupo + id.toString(),
      headers: {"authorization": ModelsUsuarios.tokenAuth},
    );
    if (state.statusCode == 201) {
      print('SUCESSO');
    } else {
      print('erro');
    }
    if (state.statusCode == 401) {
      Navigator.pushNamed(context, '/Login');
    }
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    Size size = mediaQuery.size;
    return Scaffold(
      body: Container(
        color: Colors.blue,
        width: size.width,
        height: size.height,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: size.width * 0.02,
                top: size.height * 0.035,
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 35,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: size.width * 0.02),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Grupo de medidas excluídos',
                        style: TextStyle(color: Colors.white, fontSize: 28),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: size.height * 0.02,
                  left: size.width * 0.02,
                  right: size.width * 0.02),
              child: Container(
                height: size.height * 0.82,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15)),
                child: FutureBuilder(
                  future: listarDados(),
                  builder: (BuildContext context, snapshot) {
                    return ListView.builder(
                      itemCount: grupoMedidas.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(
                            bottom: 2.0,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 4.0, left: 4, right: 4),
                            child: Container(
                              height: size.height * 0.20,
                              width: size.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  15,
                                ),
                                color: Color(0XFFD1D6DC),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 0, right: 10),
                                child: SingleChildScrollView(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Color(0XFFD1D6DC),
                                      borderRadius: BorderRadius.circular(
                                        15,
                                      ),
                                    ),
                                    child: ListTile(
                                      title: Text(
                                        'proprietario: ${grupoMedidas[index].proprietario}',
                                        style: TextStyle(
                                          fontSize: 20,
                                        ),
                                      ),
                                      subtitle: Text(
                                        'cidade: ${grupoMedidas[index].cidade}' +
                                            '\n'
                                                'bairro: ${grupoMedidas[index].bairro}' +
                                            '\n'
                                                'Endereço: ${grupoMedidas[index].endereco}' +
                                            '\n' +
                                            'N°: ${grupoMedidas[index].numEndereco}',
                                        style: TextStyle(
                                          fontSize: 20,
                                        ),
                                      ),
                                      // ===== Icone da esquerda =====
                                      leading: IconButton(
                                        icon: Icon(Icons.restore),
                                        iconSize: 36,
                                        color: Colors.green,
                                        onPressed: () => restaurar(
                                          grupoMedidas[index].idGrupoMedidas,
                                        ),
                                      ),
                                      // ====== Icone da direira ======
                                      trailing: IconButton(
                                        icon: Icon(
                                          Icons.delete_forever,
                                          color: Colors.red,
                                          size: 30,
                                        ),

                                        padding: EdgeInsets.only(
                                          left: 25,
                                          top: 30,
                                        ),

                                        // alignment: Alignment(20, 25), //centerRight,
                                        onPressed: () => {
                                          excluir(grupoMedidas[index]
                                              .idGrupoMedidas)
                                        },
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
