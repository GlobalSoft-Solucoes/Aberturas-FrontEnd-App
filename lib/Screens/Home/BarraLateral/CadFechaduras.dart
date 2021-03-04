import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:projeto_aberturas/Models/Models_Portas.dart';
import 'package:projeto_aberturas/Models/Models_Usuario.dart';
import 'package:projeto_aberturas/Models/constantes.dart';
import 'package:projeto_aberturas/Widget/Botao.dart';
import 'package:projeto_aberturas/Widget/Cabecalho.dart';
import 'package:projeto_aberturas/Widget/Crud_DataBase.dart';
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

  List<Fechaduras> fechaduras = [];
  var mensagemErro = '';

  Future listaDados() async {
    final response =
        await http.get(Uri.encodeFull(ListarTodosFechadura), headers: {
      "authorization": ModelsUsuarios.tokenAuth,
    });

    if (mounted) {
      setState(() {
        Iterable lista = json.decode(response.body);

        fechaduras = lista.map((model) => Fechaduras.fromJson(model)).toList();
      });
    }
    if (response.statusCode == 401) {
      Navigator.pushNamed(context, '/Login');
    }
  }

  popupConfirmacao() {
    MsgPopup().msgFeedback(
      context,
      'fechadura cadastrada com Sucesso',
      '',
      txtButton: 'OK!',
    );
  }

  Future<dynamic> salvarDadosBanco() async {
    var nomefechadura = controllFechaduras.text;
    var descricao = controllDescricao.text;
    var bodyy = jsonEncode({
      'nome': nomefechadura,
      'descricao': descricao,
    });

    ReqDataBase().requisicaoPost(CadastrarFechadura, bodyy);
    if (ReqDataBase.responseReq.statusCode == 201) {
      popupConfirmacao();
      controllFechaduras.text = " ";
      controllDescricao.text = " ";
    } else if (ReqDataBase.responseReq.statusCode == 400) {
      popupConfirmacaoErro();
    } else if (ReqDataBase.responseReq.statusCode == 401) {
      Navigator.pushNamed(context, '/Login');
    }
  }

  popupConfirmacaoErro() {
    MsgPopup().msgFeedback(
      context,
      'Ocorreu um erro ao cadastrar a fechadura',
      '',
      txtButton: 'OK!',
    );
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
    ReqDataBase().requisicaoDelete(DeletarFechadura + id.toString());
    if (ReqDataBase.responseReq.statusCode == 400) {
      mensagemErro =
          'A fechadura está sendo usada e portanto não pode ser excluída.';
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
      backgroundColor: Color(0xFFCCE9F5),
      body: SingleChildScrollView(
        child: Container(
          height: size.height,
          width: size.width,
          color: Color(0xFFBCE0F0),
          child: Column(
            children: [
              //===========================================
              Cabecalho().tituloCabecalho(context, 'Cadastro de fechaduras',
                  iconeVoltar: true),
              //============== WIDGET DO CADASTRO =================
              Container(
                width: size.width,
                height: size.height * 0.33,
                child: Padding(
                  padding: EdgeInsets.only(
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
                        CampoText().textField(
                          controllFechaduras,
                          'Nome da fechadura:',
                          altura: size.height * 0.10,
                          icone: Icons.edit_sharp,
                          raioBorda: 10,
                          confPadding: EdgeInsets.only(
                              right: size.width * 0.03,
                              left: size.width * 0.03,
                              top: size.height * 0.01),
                        ),
                        CampoText().textField(
                          controllDescricao,
                          'Descricao:',
                          altura: size.height * 0.10,
                          icone: Icons.comment_sharp,
                          raioBorda: 10,
                          confPadding: EdgeInsets.only(
                              right: size.width * 0.03,
                              left: size.width * 0.03,
                              top: size.height * 0.01),
                        ),
                        Container(
                          child: Padding(
                            padding: EdgeInsets.only(
                              right: size.width * 0.02,
                              left: size.width * 0.02,
                              top: size.width * 0.05,
                            ),
                            child: Botao().botaoPadrao(
                              'Salvar',
                              () => {
                                verificarDados(),
                              },
                              Color(0XFFD1D6DC),
                              fontWeight: FontWeight.w400,
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
                  height: size.height * 0.54,
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
