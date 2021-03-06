import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projeto_aberturas/Models/Models_GrupoMedidas.dart';
import 'package:projeto_aberturas/Models/Models_Portas.dart';
import 'package:projeto_aberturas/Models/Models_Usuario.dart';
import 'package:projeto_aberturas/Models/constantes.dart';
import 'package:http/http.dart' as http;
import 'package:projeto_aberturas/Screens/HistoricoMedidas/RelatorioGrupoMedidasUnt/RelatorioMedidaUnt.dart';
import 'package:projeto_aberturas/Static/Static_Usuario.dart';

//ESTA E A PRIMEIRA TELA DO RELATORIO DE TODOS OS IMOVEIS CADASTRADOS NO BANCO
class Relatorio extends StatefulWidget {
  @override
  _RelatorioState createState() => _RelatorioState();
}

class _RelatorioState extends State<Relatorio> {
  var end = new List<ModelGrupoMedidas>();
  //FUNÇÃO QUE BUSCA OS DADOS NO BANCO
  Future<dynamic> listarRegistros() async {
    final response = await http.get(
      Uri.encodeFull(
        UrlServidor.toString() +
            ListarGruposFinalizados.toString() +
            Usuario.idUsuario.toString(),
      ), //ListarTodosGrupoMedidas),
      headers: {"authorization": ModelsUsuarios.tokenAuth},
    );
    //IF(MOUNTED) É nescessario para não recarregar a arvore apos retornar das outras listas
    if (mounted)
      setState(() {
        Iterable lista = json.decode(response.body);
        end = lista.map((model) => ModelGrupoMedidas.fromJson(model)).toList();
      });
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    Size size = mediaQuery.size;
    return Scaffold(
      backgroundColor: Color(0xFFCCE9F5),
      appBar: AppBar(
        title: Text('Lista das medidas concluídas'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            height: size.height * 0.720,
            width: size.width,
            child: FutureBuilder(
              future: listarRegistros(),
              builder: (BuildContext context, snapshot) {
                return ListView.builder(
                  itemCount: end.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(
                        bottom: 2,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 8,
                        ),
                        child: Container(
                          height: size.height * 0.20,
                          width: size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              15,
                            ),
                            color: Color(0xF5070D3),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 15, right: 15, bottom: 0),
                            child: GestureDetector(
                              onDoubleTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RelatorioMedidaUnt(
                                      idGrupoMedidas: end[index].idGrupoMedidas,
                                    ),
                                  ),
                                );
                                DadosExcel.cidade = end[index].cidade;
                                DadosExcel.proprietario =
                                    end[index].proprietario;
                              },
                              child: SingleChildScrollView(
                                child: Container(
                                  // alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Color(0XFFD1D6DC),
                                    borderRadius: BorderRadius.circular(
                                      15,
                                    ),
                                  ),
                                  child: Card(
                                    color: Colors.grey[200],
                                    child: Column(
                                      children: [
                                        Text(
                                          'data: ${end[index].dataCadastro.substring(0, 10)}',
                                          style: TextStyle(fontSize: 25),
                                        ),
                                        Text(
                                          'Proprietario: ${end[index].proprietario}',
                                          style: TextStyle(fontSize: 25),
                                        ),
                                        Text(
                                          'Endereço: ${end[index].endereco}',
                                          style: TextStyle(fontSize: 25),
                                        ),
                                        Text(
                                          'N°-Enderço: ${end[index].numEndereco}',
                                          style: TextStyle(fontSize: 25),
                                        )
                                      ],
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
        ],
      ),
    );
  }
}
