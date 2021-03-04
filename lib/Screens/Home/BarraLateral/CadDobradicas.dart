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

class CadDobradicas extends StatefulWidget {
  @override
  _CadDobradicasState createState() => _CadDobradicasState();
}

class _CadDobradicasState extends State<CadDobradicas> {
  TextEditingController controllDobradicas = TextEditingController();
  TextEditingController controllDescricao = TextEditingController();

  List<Dobradicas> dobradicas = [];
  var mensagemErro = '';

  Future listaDados() async {
    final response =
        await http.get(Uri.encodeFull(ListarTodosDobradica), headers: {
      "authorization": ModelsUsuarios.tokenAuth,
    });

    if (mounted) {
      setState(() {
        Iterable lista = json.decode(response.body);

        dobradicas = lista.map((model) => Dobradicas.fromJson(model)).toList();
      });
    }
    if (response.statusCode == 401) {
      Navigator.pushNamed(context, '/Login');
    }
  }

  Future<dynamic> salvarDadosBanco() async {
    var nomedobradica = controllDobradicas.text;
    var descricao = controllDescricao.text;
    var bodyy = jsonEncode({
      'nome': nomedobradica,
      'descricao': descricao,
    });

    ReqDataBase().requisicaoPost(CadastrarDobradica, bodyy);
    if (ReqDataBase.responseReq.statusCode == 200) {
      popupconfirmacao();
      controllDobradicas.text = " ";
      controllDescricao.text = " ";
    } else if (ReqDataBase.responseReq.statusCode == 400) {
      popupconfirmacaoerro();
    } else if (ReqDataBase.responseReq.statusCode == 401) {
      Navigator.pushNamed(context, '/Login');
    }
  }

  verificarDados() {
    if (controllDobradicas.text.isNotEmpty) {
      if (controllDobradicas.text.length > 3) {
        salvarDadosBanco();
        mensagemErro = '';
      } else {
        setState(() {
          mensagemErro = 'a palavra é muito curta';
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
    ReqDataBase().requisicaoDelete(DeletarDobradica + id.toString());
    if (ReqDataBase.responseReq.statusCode == 400) {
      mensagemErro =
          'A Dobradiça está sendo usado e portanto não pode ser excluída.';
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
      'Confirma a exclusão da dobradiça?',
      'Não',
      'Sim',
      () => {Navigator.of(context).pop()},
      () => {
        deletar(index),
        listaDados(),
        Navigator.of(context).pop(),
      },
      corBotaoEsq: Color(0XFFF4485C),
    );
  }

  popupconfirmacao() {
    MsgPopup().msgFeedback(
      context,
      'Dobradica cadastrada com Sucesso',
      '',
      txtButton: 'OK!',
      corMsg: Colors.green[600],
      fontMsg: 20,
    );
  }

  popupconfirmacaoerro() {
    MsgPopup().msgFeedback(
      context,
      'Ocorreu um erro ao cadastrar a dobradiça',
      '',
      txtButton: 'OK!',
      fontMsg: 20,
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
              //===============================================
              Cabecalho().tituloCabecalho(context, 'Cadastro de dobradiça',
                  iconeVoltar: true),
              //============== WIDGET DO CADASTRO =================
              Container(
                // Configurações do primeiro widget que faz o cadastro
                width: size.width,
                height: size.height * 0.32,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: size.width * 0.02,
                    right: size.width * 0.02,
                    bottom: size.height * 0.015,
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
                          controllDobradicas,
                          'Dobradiça:',
                          altura: size.height * 0.10,
                          icone: Icons.edit_sharp,
                          raioBorda: 10,
                          confPadding: EdgeInsets.only(
                            right: size.width * 0.04,
                            left: size.width * 0.04,
                            top: size.height * 0.015,
                          ),
                        ),
                        CampoText().textField(
                          controllDescricao,
                          'descricao:',
                          altura: size.height * 0.10,
                          icone: Icons.comment_sharp,
                          raioBorda: 10,
                          confPadding: EdgeInsets.only(
                            right: size.width * 0.04,
                            left: size.width * 0.04,
                            top: size.height * 0.015,
                          ),
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
                              () => {verificarDados()},
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
              //=============== WIDGET DA LISTAGEM ==================
              Padding(
                // Configurações do widget da listagem
                padding: EdgeInsets.only(
                  left: size.width * 0.02,
                  right: size.width * 0.02,
                ),
                child: Container(
                  width: size.width,
                  height: size.height * 0.52,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: FutureBuilder(
                    future: listaDados(),
                    builder: (BuildContext context, snapshot) {
                      return ListView.builder(
                        itemCount: dobradicas.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: Text(
                              '${index + 1}',
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            title: Text('${dobradicas[index].nome}'),
                            subtitle: Text('${dobradicas[index].descricao}'),
                            trailing: GestureDetector(
                              onTap: () {
                                print(index);
                                _deletarReg(dobradicas[index].idDobradica);
                              },
                              child: Icon(
                                Icons.delete_forever,
                                size: 27,
                                // color: Colors.red,
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
