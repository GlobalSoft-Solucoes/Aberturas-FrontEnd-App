import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:projeto_aberturas/Models/Models_Portas.dart';
import 'package:projeto_aberturas/Models/constantes.dart';
import 'package:projeto_aberturas/Widget/Botao.dart';
import 'package:projeto_aberturas/Widget/MsgPopup.dart';
import 'package:projeto_aberturas/Widget/TextField.dart';
import 'package:http/http.dart' as http;

class CadFechaduras extends StatefulWidget {
  @override
  _CadFechadurasState createState() => _CadFechadurasState();
}

class _CadFechadurasState extends State<CadFechaduras> {
  TextEditingController controllFechaduras = TextEditingController();
  TextEditingController controllDescricao = TextEditingController();

  var fechaduras = new List<Fechaduras>();
  var mensagemErro = '';

  Future listaDados() async {
    final response = await http.get(
      Uri.encodeFull(UrlServidor + 'Fechadura/ListarTodos'),
      headers: {"accept": "application/json"},
    );
    if (mounted) {
      setState(() {
        Iterable lista = json.decode(response.body);

        fechaduras = lista.map((model) => Fechaduras.fromJson(model)).toList();
      });
    }
  }

  popupConfirmacao() {
    MsgPopup().msgFeedback(
        context, 'Fechadura cadastrada com Sucesso', 'Fechadura',
        txtButton: 'OK!');
  }

  Future<dynamic> salvarDadosBanco() async {
    var nomefechadura = controllFechaduras.text;
    var descricao = controllDescricao.text;
    var bodyy = jsonEncode({
      'Nome': nomefechadura,
      'Descricao': descricao,
    });

    print(bodyy);
    http.Response state = await http.post(
      UrlServidor + 'Fechadura/Cadastrar',
      headers: {"Content-Type": "application/json"},
      body: bodyy,
    );
    if (state.statusCode == 200) {
      popupConfirmacao();
    } else if (state.statusCode == 400) popupConfirmacaoErro();
  }

  popupConfirmacaoErro() {
    MsgPopup().msgFeedback(context, 'Ocorreu um erro ao cadastrar', 'Fechadura',
        txtButton: 'OK!');
  }

// MENSAGEM DE ERRO AO TENTAR CADASTRAR DE FORMA ERRADA
  verificarDados() {
    if (controllFechaduras.text.isNotEmpty) {
      if (controllFechaduras.text.length > 3) {
        salvarDadosBanco();
        mensagemErro = '';
      } else {
        setState(() {
          mensagemErro = 'a palavra e muito curta';
          _mensagemErroCadastro();
        });
      }
    } else
      setState(() {
        mensagemErro = 'O campo não pode ficar vazio';
        _mensagemErroCadastro();
      });
  }

// MENSAGEM DE ERRO AO TENTAR CADASTRAR DE FORMA ERRADA
  _mensagemErroCadastro() {
    MsgPopup().msgFeedback(
      context,
      '\n' + mensagemErro,
      'Aviso',
    );
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
    http.Response state = await http
        .delete(UrlServidor.toString() + DeletarFechadura + id.toString());
    if (state.statusCode == 400) {
      mensagemErro =
          'A Fechadura está sendo usada e portanto não pode ser excluída.';
      _erroDeletarPivotante();
    }
  }

  // ======== chama um popup pedindo permissão para deletar o registro =========
  _deletarReg(int index) {
    MsgPopup().msgComDoisBotoes(
      context,
      'Confirma a exclusão da fechadura?',
      'Não',
      'Sim',
      () => {Navigator.of(context).pop()},
      () => {
        deletar(index),
        listaDados(),
        Navigator.of(context).pop(),
      },
      corBotaoEsq: Color(0XFFF4485C),
      sairAoPressionar: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    Size size = mediaQuery.size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: size.height,
          width: size.width,
          color: Color(0XFF0099FF),
          child: Column(
            children: [
              //===========================================
              Padding(
                padding: EdgeInsets.only(
                  top: size.height * 0.06,
                  left: size.width * 0.02,
                ),
                child: Container(
                  alignment: Alignment.topLeft,
                  child: Row(
                    children: [
                      IconButton(
                          iconSize: 30,
                          color: Colors.white,
                          icon: Icon(Icons.arrow_back),
                          onPressed: () => Navigator.pop(context)),
                      Text(
                        'Cadastro de Fechaduras',
                        style: TextStyle(
                            fontSize: 28,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.none),
                      ),
                    ],
                  ),
                ),
              ),
              //============== WIDGET DO CADASTRO =================
              Container(
                width: size.width,
                height: size.height * 0.36,
                child: Padding(
                  padding: EdgeInsets.only(
                    top: size.width * 0.017,
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
                              controllFechaduras, 'Nome da Fechadura:',
                              altura: size.height * 0.10,
                              icone: Icons.home,
                              raioBorda: 10),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              right: size.width * 0.02,
                              left: size.width * 0.02,
                              top: size.height * 0.005),
                          child: CampoText().textField(
                              controllDescricao, 'Descricao:',
                              altura: size.height * 0.10,
                              icone: Icons.home,
                              raioBorda: 10),
                        ),
                        Container(
                          child: Padding(
                            padding: EdgeInsets.only(
                              right: size.width * 0.02,
                              left: size.width * 0.02,
                              top: size.width * 0.02,
                            ),
                            child: Botao().botaoPadrao(
                              'Salvar',
                              () => {
                                verificarDados(),
                              },
                              Color(0XFFD1D6DC),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              //============== WIDGET DA LISTAGEM =================
              Padding(
                padding: EdgeInsets.only(
                    left: size.width * 0.02, right: size.width * 0.02),
                child: Container(
                  width: size.width,
                  height: size.height * 0.50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: FutureBuilder(
                    future: listaDados(),
                    builder: (BuildContext context, snapshot) {
                      return ListView.builder(
                        itemCount: fechaduras.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: Text(
                              '${index + 1}',
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            title: Text('${fechaduras[index].nome}'),
                            subtitle: Text('${fechaduras[index].descricao}'),
                            trailing: GestureDetector(
                              onTap: () {
                                _deletarReg(fechaduras[index].idFechaduras);
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
              )
              //----------------------------------------
            ],
          ),
        ),
      ),
    );
  }
}
