import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  var dadosListagem = new List<ModelGrupoMedidas>();
  //FUNÇÃO QUE BUSCA OS DADOS NO BANCO
  Future<dynamic> listarRegistros() async {
    final response = await http.get(
      Uri.encodeFull(
            ListarGruposFinalizados +
            usuario.idUsuario.toString(),
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
                padding: EdgeInsets.only(top: size.height * 0.03),
                child: Container(
                  width: size.width,
                  height: size.height * 0.06,
                  child: Padding(
                    padding: EdgeInsets.only(left: size.width * 0.19),
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
                  height: size.height * 0.795,
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
                          return GestureDetector(
                            onDoubleTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RelatorioMedidaUnt(
                                    idGrupoMedidas:
                                        dadosListagem[index].idGrupoMedidas,
                                  ),
                                ),
                              );
                              DadosExcel.cidade = dadosListagem[index].cidade;
                              DadosExcel.proprietario =
                                  dadosListagem[index].proprietario;
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                // bottom: 2,
                                top: 8,
                              ),
                              child: Container(
                                padding: const EdgeInsets.only(
                                  left: 4,
                                  right: 4,
                                ),
                                child: Container(
                                  height: size.height * 0.17,
                                  width: size.width,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                      15,
                                    ),
                                    color: Color(0XFFD1D6DC),
                                  ),
                                  child: Container(
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.only(
                                      top: 3,
                                      left: 0,
                                      right: 0,
                                    ),
                                    child: SingleChildScrollView(
                                      child: Container(
                                        child: ListTile(
                                          title: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              FieldsDatabase().listaDadosBanco(
                                                'Data: ',
                                                dadosListagem[index]
                                                    .dataCadastro,
                                                sizeCampoBanco: 20,
                                                sizeTextoCampo: 20,
                                              ),
                                              SizedBox(height: 3),
                                              FieldsDatabase().listaDadosBanco(
                                                'proprietário: ',
                                                dadosListagem[index]
                                                    .proprietario,
                                                sizeCampoBanco: 20,
                                                sizeTextoCampo: 20,
                                              ),
                                              SizedBox(height: 3),
                                              FieldsDatabase().listaDadosBanco(
                                                'Endereço: ',
                                                dadosListagem[index].endereco,
                                                sizeCampoBanco: 20,
                                                sizeTextoCampo: 20,
                                              ),
                                              SizedBox(height: 3),
                                              FieldsDatabase().listaDadosBanco(
                                                'N° Enderço: ',
                                                dadosListagem[index]
                                                    .numEndereco.toString(),
                                                sizeCampoBanco: 20,
                                                sizeTextoCampo: 20,
                                              ),
                                            ],
                                          ),
                                          trailing: IconButton(
                                            icon: Icon(
                                              Icons.delete_forever,
                                              size: 30,
                                              color: Colors.red,
                                            ),
                                            onPressed: () {},
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
