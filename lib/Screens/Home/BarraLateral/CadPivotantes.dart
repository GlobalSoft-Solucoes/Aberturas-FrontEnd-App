import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:projeto_aberturas/Models/Models_Portas.dart';
import 'package:projeto_aberturas/Models/Models_Usuario.dart';
import 'package:projeto_aberturas/Models/constantes.dart';
import 'package:projeto_aberturas/Widget/Botao.dart';
import 'package:projeto_aberturas/Widget/Crud_DataBase.dart';
import 'package:projeto_aberturas/Widget/MsgPopup.dart';
import 'package:projeto_aberturas/Widget/TextField.dart';

class CadPivotantes extends StatefulWidget {
  @override
  _CadPivotantesState createState() => _CadPivotantesState();
}

class _CadPivotantesState extends State<CadPivotantes> {
  TextEditingController controllPivotantes = TextEditingController();
  TextEditingController controllDescricao = TextEditingController();

  var pivotantes = new List<Pivotantes>();
  var mensagemErro = '';

  Future listarDados() async {
    // ReqDataBase().requisicaoGet(
    //   context,
    //   ListarTodosPivotante,
    // );
    final response = await http.get(
        Uri.encodeFull(ListarTodosPivotante),
        headers: {"authorization": ModelsUsuarios.tokenAuth});
    if (mounted) {
      setState(() {
        Iterable lista = json.decode(response.body);

        pivotantes = lista.map((model) => Pivotantes.fromJson(model)).toList();
      });
    }
    if (response.statusCode == 401) {
      Navigator.pushNamed(context, '/Login');
    }
  }

  popupMsgCadastroSucesso() {
    MsgPopup().msgFeedback(
      context,
      'pivotante cadastrado com Sucesso!',
      '',
      txtButton: 'OK!',
      corMsg: Colors.green[600],
      fontMsg: 20,
    );
  }

  Future<dynamic> salvarDadosBanco() async {
    var nomerolete = controllPivotantes.text;
    var descricao = controllDescricao.text;
    var bodyy = jsonEncode({
      'nome': nomerolete,
      'descricao': descricao,
    });

    ReqDataBase().requisicaoPost(CadastrarPivotante, bodyy);

    if (ReqDataBase.responseReq.statusCode == 200) {
      popupMsgCadastroSucesso();
      controllPivotantes.text = " ";
      controllDescricao.text = " ";
    } else if (ReqDataBase.responseReq.statusCode == 400) {
      mensagemErro = 'Ocorreu um erro ao cadastrar o pivotante.';
      _mensagemErroCadastro();
    }
    if (ReqDataBase.responseReq.statusCode == 401) {
      Navigator.pushNamed(context, '/Login');
    }
  }

// MENSAGEM DE ERRO AO TENTAR CADASTRAR DE FORMA ERRADA
  _mensagemErroCadastro() {
    MsgPopup().msgFeedback(
      context,
      '\n' + mensagemErro,
      'Aviso',
    );
  }

  verificarDados() {
    if (controllPivotantes.text.isEmpty) {
      mensagemErro = 'O campo não pode ficar vazio';
      _mensagemErroCadastro();
    } else if (controllPivotantes.text.length < 3) {
      mensagemErro = 'A palavra e muito curta';
      _mensagemErroCadastro();
    } else {
      salvarDadosBanco();
      mensagemErro = '';
    }
  }

// === MENSAGEM DISPARADA CASO ALGUM PIVOTANTE ESTIVER SENDO USADO E O USUARIO TENTAR EXCLUIR O MESMO ====
  _erroDeletarPivotante() {
    MsgPopup().msgFeedback(
      context,
      '\n' + mensagemErro,
      'Aviso',
    );
  }

// ======== FUNÇÃO QUE DELETA O PIVOTANTE DO BANCO DE DADOS ==========
  Future<dynamic> deletar(int id) async {

    ReqDataBase().requisicaoDelete(DeletarPivotante + id.toString());
    
    if (ReqDataBase.responseReq.statusCode == 400) {
      mensagemErro =
          'O pivotante está sendo usado e portanto não pode ser excluído.';
      _erroDeletarPivotante();
    }
    if (ReqDataBase.responseReq.statusCode == 401) {
      Navigator.pushNamed(context, '/Login');
    }
  }

// ======== chama um popup pedindo permissão para deletar o registro =========
  _deletarReg(int index) {
    MsgPopup().msgComDoisBotoes(
      context,
      'Confirmar exclusão do Rolete pivotante?',
      'Não',
      'Sim',
      () => {Navigator.of(context).pop()},
      () => {
        deletar(index),
        listarDados(),
        Navigator.of(context).pop(),
      },
      corBotaoEsq: Color(0XFFF4485C),
    );
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    Size size = mediaQuery.size;
    return Scaffold(
      backgroundColor: Color(0xFFCCE9F5),
      body: SingleChildScrollView(
        child: Container(
          width: size.width,
          height: size.height,
          color: Color(0xFFBCE0F0),
          child: Column(
            children: [
              //===========================================
              Padding(
                padding: EdgeInsets.only(
                  top: size.height * 0.02,
                  left: size.width * 0.02,
                ),
                child: Container(
                  alignment: Alignment.topLeft,
                  child: Row(
                    children: [
                      IconButton(
                        color: Colors.white,
                        icon: Icon(Icons.arrow_back),
                        iconSize: 30,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: size.width * 0.03),
                        child: Text(
                          'Cadastro de Rol. Pivotantes',
                          style: TextStyle(
                              fontSize: 28,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.none),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              //================= WIDGET DO CADASTRO ===================
              Container(
                  width: size.width,
                  height: size.height * 0.34,
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: size.width * 0.02,
                      left: size.width * 0.02,
                      right: size.width * 0.02,
                      bottom: size.height * 0.02,
                    ),
                    child: Container(
                      alignment: Alignment.topCenter,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      width: size.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                right: size.width * 0.02,
                                left: size.width * 0.02,
                                top: size.height * 0.015),
                            child: CampoText().textField(
                                controllPivotantes, 'Rol. pivotante:',
                                altura: size.height * 0.10,
                                icone: Icons.home,
                                raioBorda: 10),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              right: size.width * 0.02,
                              left: size.width * 0.02,
                            ),
                            child: CampoText().textField(
                                controllDescricao, 'descricao:',
                                altura: size.height * 0.10,
                                icone: Icons.home,
                                raioBorda: 10),
                          ),
                          Container(
                            child: Padding(
                              padding: EdgeInsets.only(
                                right: size.width * 0.02,
                                left: size.width * 0.02,
                                top: size.height * 0.011,
                              ),
                              child: Botao().botaoPadrao('Salvar',
                                  () => {verificarDados()}, Color(0XFFD1D6DC)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
              Padding(
                padding: EdgeInsets.only(
                    left: size.width * 0.02, right: size.width * 0.02),
                child: Container(
                  width: size.width,
                  height: size.height * 0.56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: FutureBuilder(
                    future: listarDados(),
                    builder: (BuildContext context, snapshot) {
                      return ListView.builder(
                        itemCount: pivotantes.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: Text(
                              '${index + 1}',
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            title: Text('${pivotantes[index].nome}'),
                            subtitle: Text('${pivotantes[index].descricao}'),
                            trailing: GestureDetector(
                              onTap: () {
                                print(index);
                                _deletarReg(pivotantes[index].idPivotante);
                              },
                              child: Icon(
                                Icons.delete_forever,
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
      ),
    );
  }
}
