import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:projeto_aberturas/Models/Models_GrupoMedidas.dart';
import 'package:http/http.dart' as http;
import 'package:projeto_aberturas/Models/Models_Usuario.dart';
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

//CONFIRMAÇÃO DE EXCLUSAO DO GRUPO
  confExcluir(id) {
    MsgPopup().msgComDoisBotoes(
      context,
      'Deseja excluir o grupo de medidas selecionado?',
      'Cancelar',
      'Confirmar',
      () => {
        Navigator.pop(context),
      },
      () => {
        _deletarReg(id),
        Navigator.pop(context),
      },
    );
  }

//DELETA O GRUPO DE MEDIDAS
  _deletarReg(id) async {
    print(id);
    var response = await http.put(
      (UrlServidor + StatusRemoverGrupo + id.toString()),
      headers: {"authorization": ModelsUsuarios.tokenAuth},
    );
    if (response.statusCode == 401) {
      Navigator.pushNamed(context, '/Login');
    }
  }

  //FUNÇÃO PARA BUSCAR OS DADOS NA DB
  Future<dynamic> listarDados() async {
    final response = await http.get(
      Uri.encodeFull(UrlServidor.toString() +
          ListarTodosGrupoMedidas +
          Usuario.idUsuario.toString()),
      headers: {"authorization": ModelsUsuarios.tokenAuth},
    );
    if (response.statusCode == 401) {
      Navigator.pushNamed(context, '/Login');
    }
    //IF(MOUNTED) É nescessario para não recarregar a arvore apos retornar das outras listas
    if (mounted)
      setState(() {
        Iterable lista = json.decode(response.body);
        end = lista.map((model) => ModelGrupoMedidas.fromJson(model)).toList();
      });
  }

//FUNÇÃO PARA DELETAR OS DADOS DA DATABASE
  Future<dynamic> delete(int id) async {
    var response = await http.delete(
        UrlServidor.toString() + DeletarGrupoMedidas + id.toString(),
        headers: {"authorization": ModelsUsuarios.tokenAuth});
    if (response.statusCode == 401) {
      Navigator.pushNamed(context, '/Login');
    }
  }

  _ListaGrupoMedidasState() {
    listarDados();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    Size size = mediaQuery.size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Lista de grupos cadastrados',
          style: TextStyle(
            fontSize: 25,
          ),
        ),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pushNamed(context, '/Home')),
      ),
      body: FutureBuilder(
        future: listarDados(),
        builder: (BuildContext context, snapshot) {
          return ListView.builder(
            itemCount: end.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(
                  // bottom: 2,
                  top: 8,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 5, right: 4),
                  child: Container(
                    alignment: Alignment.center,
                    height: size.height * 0.20,
                    width: size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        15,
                      ),
                      color: Color(0XFFD1D6DC),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 0, right: 10),
                      child: GestureDetector(
                        onDoubleTap: () {
                          GrupoMedidas.idGrupoMedidas =
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
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Color(0XFFD1D6DC),
                              borderRadius: BorderRadius.circular(
                                15,
                              ),
                            ),
                            child: ListTile(
                              leading: Column(
                                children: <Widget>[
                                  Padding(padding: EdgeInsets.only(top: 26)),
                                  // se o registro estiver com status "Finalizado", um icone de confirmação
                                  // é mostrado para o registro
                                  end[index].statusProcesso == "Finalizado"
                                      ? Icon(Icons.check_circle,
                                          color: Colors.green, size: 30)
                                      : Padding(
                                          padding: EdgeInsets.only(left: 0),
                                        ),
                                ],
                              ),
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
                                    'N°: ${end[index].numEndereco}',
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
                                  size: 32,
                                ),
                                padding: EdgeInsets.only(
                                  left: 25,
                                  top: 30,
                                ),
                                // alignment: Alignment(20, 25), //centerRight,
                                onPressed: () => {
                                  confExcluir(end[index].idGrupoMedidas),
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
