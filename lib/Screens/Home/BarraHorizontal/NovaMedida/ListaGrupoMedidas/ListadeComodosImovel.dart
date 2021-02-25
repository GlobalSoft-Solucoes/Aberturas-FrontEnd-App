import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:http/http.dart' as http;
import 'package:projeto_aberturas/Models/Models_Usuario.dart';
import 'package:projeto_aberturas/Models/constantes.dart';
import 'package:projeto_aberturas/Static/Static_GrupoMedidas.dart';
import 'package:projeto_aberturas/Models/Models_MedidaUnt.dart';
import 'package:projeto_aberturas/Widget/ListFieldsDataBase.dart';
import 'package:projeto_aberturas/Widget/MsgPopup.dart';
import 'package:unicorndial/unicorndial.dart';
import 'package:flutter/material.dart';
import 'package:unicorndial/unicorndial.dart';
import 'ListaDadosComodo.dart';

//TELA QUE MOSTRA OS COMODOS CADASTRADOS EM CADA IMOVEL
class ListaComodoImoveis extends StatefulWidget {
  final int idGrupoMedidas;
  ListaComodoImoveis({Key key, @required this.idGrupoMedidas})
      : super(key: key);
  @override
  _ListaComodoImoveisState createState() =>
      _ListaComodoImoveisState(idGrupoMedidas: idGrupoMedidas);
}

class _ListaComodoImoveisState extends State<ListaComodoImoveis> {
  var dadosListagem = new List<ModelsMedidasUnt>();
  int idGrupoMedidas = GrupoMedidas.idGrupoMedidas;

  // MENSAGEM QUE DISPARA QUANDO CLICA EM FINALIZAR PROCESSO

  /* _finalizaProcesso() async {
    await MsgPopup().msgFeedback(
      context,
      '\n Este grupo de medidas foi finalizado!' +
          '\n Confira no histórico as medidas cadastradas e envie para a empresa.',
      'Grupo Finalizado.',
      sizeTitulo: 20,
      onPressed: () {
        Navigator.of(context).pop();
        // Navigator.pushNamed(context, '/ListaGrupoMedidas');
      },
    );
  }*/

  escolhaTelaNovaMedida() {
    MsgPopup().msgComDoisBotoes(
      context,
      'Escolha o tipo de Porta:',
      'Específica',
      'Padrão',
      () => {
        Navigator.of(context)
            .pop(), // Fecha o popup da escolha para medir a porta
        Navigator.pushNamed(context, '/CadDadosPorta'),
      },
      () => {
        Navigator.of(context)
            .pop(), // Fecha o popup da escolha para medir a porta
        Navigator.pushNamed(context, '/CadPortaPadrao'),
      },
      corBotaoEsq: Color(0XFF0099FF),
      sairAoPressionar: true,
    );
  }

  // altera o STATUS do registro para FINALIZADO
  Future<dynamic> alterarStatus() async {
    int idRegistro = GrupoMedidas.idGrupoMedidas;
    var response = await http.put(
      AlterarStatusParaFinalizado + idRegistro.toString(),
      headers: {"authorization": ModelsUsuarios.tokenAuth},
    );
    if (response.statusCode == 401) {
      Navigator.pushNamed(context, '/Login');
    }
  }

  _confirmarFinalizar() async {
    await MsgPopup().msgComDoisBotoes(
      context,
      'Deseja finalizar este grupo de medidas?',
      'Cancelar',
      'Confirmar',
      () => {
        Navigator.of(context).pop(),
      },
      () async {
        Navigator.of(context).pop();
        await alterarStatus();
        Navigator.pushNamed(context, '/ListaGrupoMedidas');
      },
      sairAoPressionar: true,
    );
  }

  //FUNÇÃO PARA BUSCAR E LISTAR OS DADOS NA DB
  Future<dynamic> listaComodosImovel(id) async {
    final response = await http.get(
      Uri.encodeFull(
        ListarMedidasPorGrupo.toString() + id.toString(),
      ),
      headers: {
        "Content-Type": "application/json",
        "authorization": ModelsUsuarios.tokenAuth
      },
    );
    // print(response.statusCode);
    //IF(MOUNTED) É nescessario para não recarregar a arvore apos retornar das outras listas
    if (mounted)
      setState(
        () {
          Iterable lista = json.decode(response.body);
          dadosListagem =
              lista.map((model) => ModelsMedidasUnt.fromJson(model)).toList();
        },
      );
  }

// ==== MENSAGEM QUE DISPARA PARA EDITAR O GRUPO DE MEDIDAS =====
  popupEdicaoGrupoMedidas() {
    MsgPopup().msgComDoisBotoes(
      context,
      'Deseja Editar o Grupo selecionado?',
      'Não',
      'Sim',
      () {
        Navigator.of(context).pop();
      },
      () async {
        // captura os cados do grupo e manda para um arquivo static
        await DadosGrupoSelecionado().capturaDadosGrupoSelecionado();
        Navigator.of(context).pop(); // fecha o popup
        Navigator.of(context).pop(); // fecha a lista dos comodos
        Navigator.pushNamed(context, '/EditaGrupoMedidas');
      },
      sairAoPressionar: true,
      corBotaoDir: Color(0XFF0099FF),
      corBotaoEsq: Color(0XFFF4485C),
    );
  }

  _ListaComodoImoveisState({@required this.idGrupoMedidas}) {
    listaComodosImovel(idGrupoMedidas);
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    Size size = mediaQuery.size;

    return Scaffold(
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        animatedIconTheme: IconThemeData(size: 30),
        // this is ignored if animatedIcon is non null
        child: Icon(Icons.add),
        visible: true,
        curve: Curves.bounceIn,
        overlayColor: Colors.white,
        overlayOpacity: 0.6,
        // onOpen: () => print('OPENING DIAL'),
        // onClose: () => print('DIAL CLOSED'),
        tooltip: 'Speed Dial',
        heroTag: 'speed-dial-hero-tag',
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 8.0,
        shape: CircleBorder(),
        children: [
          SpeedDialChild(
            child: Icon(Icons.check_circle, size: 30),
            backgroundColor: Colors.green,
            label: 'Finalizar grupo',
            labelStyle: TextStyle(fontSize: 20),
            onTap: () => _confirmarFinalizar(),
            // onLongPress: () => print('FIRST CHILD LONG PRESS'),
          ),
          SpeedDialChild(
            child: Icon(Icons.add, size: 30),
            backgroundColor: Colors.blue,
            label: 'Adicionar medida',
            labelStyle: TextStyle(fontSize: 20),
            onTap: () => {
              escolhaTelaNovaMedida(),
            },
            // onLongPress: () => print('SECOND CHILD LONG PRESS'),
          ),
        ],
      ),
      body: Container(
        width: size.width,
        height: size.height,
        color: Color(0xFFBCE0F0),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  left: size.width * 0.01,
                  right: size.width * 0.02,
                  top: size.height * 0.025,
                  bottom: size.height * 0.02),
              child: Container(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      iconSize: 33,
                      color: Colors.white,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: size.width * 0.11),
                      child: Text(
                        'Medidas cadastradas',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: size.width * 0.065,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: size.width * 0.015, right: size.width * 0.015),
              child: Container(
                height: size.height * 0.75,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white),
                child: FutureBuilder(
                  future: listaComodosImovel(GrupoMedidas.idGrupoMedidas),
                  builder: (BuildContext context, snapshot) {
                    return ListView.builder(
                      itemCount: dadosListagem.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(
                            bottom: 2.0,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 4.0, left: 4, right: 4),
                            child: Container(
                              height: size.height * 0.14,
                              width: size.width,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  10,
                                ),
                                color: Color(0XFFD1D6DC),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 15, right: 15),
                                child: GestureDetector(
                                  onDoubleTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ListaDadosComodo(
                                          idMedidaUnt:
                                              dadosListagem[index].idMedidaUnt,
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
                                        title: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(height: 5),
                                            FieldsDatabase().listaDadosBanco(
                                                'Número da porta: ',
                                                dadosListagem[index]
                                                    .numeroPorta
                                                    .toString(),
                                                sizeCampoBanco: 20,
                                                sizeTextoCampo: 20),
                                            SizedBox(height: 4),
                                            FieldsDatabase().listaDadosBanco(
                                                'Tipo medida: ',
                                                dadosListagem[index].tipoMedida,
                                                sizeCampoBanco: 20,
                                                sizeTextoCampo: 20),
                                            SizedBox(height: 4),
                                            FieldsDatabase().listaDadosBanco(
                                                'Comodo: ',
                                                dadosListagem[index].comodo,
                                                sizeCampoBanco: 20,
                                                sizeTextoCampo: 20),
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
            ),
          ],
        ),
      ),
    );
  }
}
