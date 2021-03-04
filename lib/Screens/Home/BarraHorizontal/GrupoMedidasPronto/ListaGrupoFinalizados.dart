import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:projeto_aberturas/Models/Models_GrupoMedidas.dart';
import 'package:projeto_aberturas/Models/Models_Portas.dart';
import 'package:projeto_aberturas/Models/Models_Usuario.dart';
import 'package:projeto_aberturas/Models/constantes.dart';
import 'package:http/http.dart' as http;
import 'package:projeto_aberturas/Screens/Home/BarraHorizontal/GrupoMedidasPronto/RelatorioMedidaUnt.dart';
import 'package:projeto_aberturas/Static/Static_Usuario.dart';
import 'package:projeto_aberturas/Widget/ListFieldsDataBase.dart';

//ESTA E A PRIMEIRA TELA DO RELATORIO DE TODOS OS IMOVEIS CADASTRADOS NO BANCO
class ListaGruposFinalizados extends StatefulWidget {
  @override
  _ListaGruposFinalizadosState createState() => _ListaGruposFinalizadosState();
}

class _ListaGruposFinalizadosState extends State<ListaGruposFinalizados> {
  List<ModelGrupoMedidas> dadosListagem = [];
  //FUNÇÃO QUE BUSCA OS DADOS NO BANCO
  Future<dynamic> listarRegistros() async {
    final response = await http.get(
      Uri.encodeFull(
        ListarGruposFinalizados + UserLogado.idUsuario.toString(),
      ),
      headers: {"authorization": ModelsUsuarios.tokenAuth},
    );
    //IF(MOUNTED) É nescessario para não recarregar a arvore apos retornar das outras listas
    if (mounted)
      setState(() {
        Iterable lista = json.decode(response.body);
        dadosListagem =
            lista.map((model) => ModelGrupoMedidas.fromJson(model)).toList();
      });
    if (response.statusCode == 401) {
      Navigator.pushNamed(context, '/Login');
    }
  }

  // Controla para apenas um registro fiquei aberto para excluir ou editar
  final SlidableController slidableController = SlidableController();
  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    Size size = mediaQuery.size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: Color(0xFFBCE0F0),
          height: size.height,
          width: size.width,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    top: size.height * 0.035, bottom: size.height * 0.015),
                child: Center(
                  child: Text(
                    'Medidas concluídas',
                    style: TextStyle(
                      fontSize: size.width * 0.07,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: size.width * 0.02,
                  right: size.width * 0.02,
                  bottom: size.height * 0.01,
                ),
                child: Container(
                  padding: EdgeInsets.only(
                    top: 5,
                    bottom: 5,
                  ),
                  width: size.width,
                  height: size.height * 0.78,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white.withOpacity(0.6),
                  ),
                  child: FutureBuilder(
                    future: listarRegistros(),
                    builder: (BuildContext context, snapshot) {
                      return ListView.builder(
                        itemCount: dadosListagem.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.only(
                              left: size.width * 0.015,
                              right: size.width * 0.015,
                              top: size.width * 0.015,
                              bottom: size.width * 0.015,
                            ),
                            child: Container(
                              child: Slidable(
                                fastThreshold: 12,
                                actionPane: SlidableDrawerActionPane(),
                                closeOnScroll: false,
                                actionExtentRatio: 0.25,
                                controller: slidableController,
                                // actions: <Widget>[
                                //   IconSlideAction(
                                //     caption: 'Editar',
                                //     color: Colors.white, //(0XFFD1D6DC),
                                //     icon: Icons.edit_outlined,
                                //     onTap: () => null,
                                //   ),
                                // ],
                                // secondaryActions: <Widget>[
                                //   IconSlideAction(
                                //     caption: 'Deletar',
                                //     color: Colors.red,
                                //     icon: Icons.delete_forever,
                                //     onTap: () => null,
                                //   ),
                                // ],
                                child: GestureDetector(
                                  onDoubleTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            RelatorioMedidaUnt(
                                          idGrupoMedidas: dadosListagem[index]
                                              .idGrupoMedidas,
                                        ),
                                      ),
                                    );
                                    DadosExcel.cidade =
                                        dadosListagem[index].cidade;
                                    DadosExcel.proprietario =
                                        dadosListagem[index].proprietario;
                                  },
                                  child: Container(
                                    height: size.height * 0.17,
                                    width: size.width,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                        5,
                                      ),
                                      color: Color(0XFFD1D6DC),
                                    ),
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: SingleChildScrollView(
                                        child: Container(
                                          child: ListTile(
                                            title: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                FieldsDatabase()
                                                    .listaDadosBanco(
                                                  'Data: ',
                                                  dadosListagem[index]
                                                      .dataCadastro,
                                                  sizeCampoBanco: 20,
                                                  sizeTextoCampo: 20,
                                                ),
                                                SizedBox(height: 3),
                                                FieldsDatabase()
                                                    .listaDadosBanco(
                                                  'proprietário: ',
                                                  dadosListagem[index]
                                                      .proprietario,
                                                  sizeCampoBanco: 20,
                                                  sizeTextoCampo: 20,
                                                ),
                                                SizedBox(height: 3),
                                                FieldsDatabase()
                                                    .listaDadosBanco(
                                                  'Endereço: ',
                                                  dadosListagem[index].endereco,
                                                  sizeCampoBanco: 20,
                                                  sizeTextoCampo: 20,
                                                ),
                                                SizedBox(height: 3),
                                                FieldsDatabase()
                                                    .listaDadosBanco(
                                                  'N° Enderço: ',
                                                  dadosListagem[index]
                                                      .numEndereco
                                                      .toString(),
                                                  sizeCampoBanco: 20,
                                                  sizeTextoCampo: 20,
                                                ),
                                              ],
                                            ),
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
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
