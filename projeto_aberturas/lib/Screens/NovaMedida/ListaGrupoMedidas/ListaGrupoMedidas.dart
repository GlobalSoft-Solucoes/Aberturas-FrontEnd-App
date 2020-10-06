import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:projeto_aberturas/Models/Models_GrupoMedidas.dart';
import 'package:http/http.dart' as http;
import 'package:projeto_aberturas/Models/constantes.dart';
import 'package:projeto_aberturas/Static/Static_GrupoMedidas.dart';
import 'package:projeto_aberturas/Screens/NovaMedida/ListaGrupoMedidas/ListadeComodosImovel.dart';
import 'package:projeto_aberturas/Static/Static_Usuario.dart';
import 'package:projeto_aberturas/Widget/MsgPopup.dart';

//TELA PARA LISTAR TODOS OS ENDEREÇOS CADASTRADOS
class ListaGrupoMedidas extends StatefulWidget {
  @override
  _ListaGrupoMedidasState createState() => _ListaGrupoMedidasState();

  static fromJson(model) {}
}

class _ListaGrupoMedidasState extends State<ListaGrupoMedidas> {
  TextEditingController controllerExcluirGrupo = TextEditingController();
  var end = new List<ModelGrupoMedidas>();

// ======== CASO A PALAVRA DIGITADA PARA EXCLUIR O GRUPO ESTIVER ERRADA, O POPUP É DISPARADO ==========
  _palavraIncorreta() {
    MsgPopup().msgFeedback(
        context,
        'Digite a palavra corretamente, conforme a mensagem informa.',
        'Palavra incorreta!\n');
  }

  // ========= POPUP QUE DELETAR O REGISTRO DO GRUPO DE MEDIDAS ============
  _deletarReg(int index) {
    controllerExcluirGrupo.text = '';
    MsgPopup().campoTextoComDoisBotoes(
      context,
      'Digite "Excluir" para apagar o grupo de medidas selecionado.',
      'Digite aqui',
      'Cancelar',
      'Confirmar',
      () => {
        Navigator.of(context).pop(),
      },
      () => {
        if (controllerExcluirGrupo.text.toUpperCase() == 'EXCLUIR')
          {
            delete(index),
            Navigator.of(context).pop(),
            listarDados(),
            controllerExcluirGrupo.text = '',
          }
        else
          {_palavraIncorreta()}
      },
      controller: controllerExcluirGrupo,
      iconeText: Icons.textsms,
    );
  }

  //FUNÇÃO PARA BUSCAR OS DADOS NA DB
  Future<dynamic> listarDados() async {
    final response = await http.get(
      Uri.encodeFull(UrlServidor.toString() +
          ListarTodosGrupoMedidas +
          Usuario.idUsuario.toString()),
      headers: {"accept": "application/json"},
    );
    //IF(MOUNTED) É nescessario para não recarregar a arvore apos retornar das outras listas
    if (mounted)
      setState(() {
        Iterable lista = json.decode(response.body);
        end = lista.map((model) => ModelGrupoMedidas.fromJson(model)).toList();
      });
  }

//FUNÇÃO PARA DELETAR OS DADOS DA DATABASE
  Future<dynamic> delete(int id) async => await http
      .delete(UrlServidor.toString() + DeletarGrupoMedidas + id.toString());

  _ListaGrupoMedidasState() {
    listarDados();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    Size size = mediaQuery.size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Lista de Grupos cadastrados',
          style: TextStyle(
            fontSize: 18,
          ),
        ),
      ),
      body: FutureBuilder(
        future: listarDados(),
        builder: (BuildContext context, snapshot) {
          return ListView.builder(
            itemCount: end.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(
                  bottom: 2.0,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 4.0, left: 4, right: 4),
                  child: Container(
                    height: size.height * 0.20,
                    width: size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        10,
                      ),
                      color: Color(0XFFD1D6DC),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 0, right: 10),
                      child: GestureDetector(
                        onDoubleTap: () {
                          GrupoMediddas.idGrupoMedidas =
                              end[index].idGrupoMedidas;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ListaComodoImoveis(
                                idGrupoMedidas: end[index].idGrupoMedidas,
                              ),
                            ),
                          );
                        },
                        child: SingleChildScrollView(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(0XFFD1D6DC),
                              borderRadius: BorderRadius.circular(
                                15,
                              ),
                            ),
                            child: ListTile(
                              // contentPadding: EdgeInsets.only(top: 40),
                              leading: Column(children: <Widget>[
                                // Padding(padding: EdgeInsets.only(top: 30)),
                                Icon(Icons.more_vert),
                                // Padding(padding: EdgeInsets.only(bottom: 10)),
                                end[index].statusProcesso == "Finalizado"
                                    ? Icon(Icons.check_circle,
                                        color: Colors.green, size: 30)
                                    : Padding(
                                        padding: EdgeInsets.only(left: 0)),
                              ])
                              //   '${index + 1}',
                              //   style: TextStyle(
                              //     fontSize: 20,
                              //   ),
                              ,
                              title: Text(
                                'Proprietario: ${end[index].proprietario}',
                                style: TextStyle(
                                  fontSize: 20,
                                  color:
                                      end[index].statusProcesso != "Finalizado"
                                          ? Colors.blue[600]
                                          : Colors.green[500],
                                ),
                              ),
                              subtitle: Text(
                                'Cidade: ${end[index].cidade}' +
                                    '\n'
                                        'Bairro: ${end[index].bairro}' +
                                    '\n'
                                        'Endereço: ${end[index].endereco}' +
                                    '\n' +
                                    'Num:${end[index].numEndereco}',
                                style: TextStyle(
                                  fontSize: 20,
                                  color:
                                      end[index].statusProcesso != "Finalizado"
                                          ? Colors.blue[600]
                                          : Colors.green[600],
                                ),
                              ),
                              trailing: IconButton(
                                icon: Icon(
                                  Icons.delete_forever,
                                  color: Colors.red,
                                  size: 30,
                                ),
                                alignment: Alignment.centerRight,
                                onPressed: () => {
                                  _deletarReg(end[index].idGrupoMedidas),
                                },
                              ),
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
    );
  }
}
