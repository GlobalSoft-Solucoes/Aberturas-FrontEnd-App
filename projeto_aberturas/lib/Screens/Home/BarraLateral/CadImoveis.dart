import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:projeto_aberturas/Models/Models_Imoveis.dart';
import 'package:projeto_aberturas/Models/Models_Usuario.dart';
import 'package:projeto_aberturas/Models/constantes.dart';
import 'package:projeto_aberturas/Widget/Botao.dart';
import 'package:projeto_aberturas/Widget/TextField.dart';
import 'package:projeto_aberturas/Widget/MsgPopup.dart';
import 'package:http/http.dart' as http;

class CadImoveis extends StatefulWidget {
  @override
  _CadImoveisState createState() => _CadImoveisState();
}

class _CadImoveisState extends State<CadImoveis> {
  var mensagemErro = '';
  TextEditingController controllerCampoImovel = TextEditingController();

  var imoveis = new List<Imoveis>();
  Future listaDados() async {
    final response = await http.get(
      Uri.encodeFull(UrlServidor + ListarTodosImoveis),
      headers: {"authorization": ModelsUsuarios.tokenAuth},
    );
    if (mounted) {
      setState(() {
        Iterable lista = json.decode(response.body);
        imoveis = lista.map((model) => Imoveis.fromJson(model)).toList();
      });
    } else if (response.statusCode == 401) {
      Navigator.pushNamed(context, '/Login');
    }
  }

  Future<dynamic> salvarDadosBanco() async {
    var imovel = controllerCampoImovel.text;

    var bodyy = jsonEncode({
      'Nome': imovel,
    });

    http.Response state = await http.post(
      UrlServidor + CadastrarImovel,
      headers: {
        "authorization": ModelsUsuarios.tokenAuth,
      },
      body: bodyy,
    );
    if (state.statusCode == 200) {
      popupconfirmacao();
    } else if (state.statusCode == 400) {
      popupConfirmacaoErro();
    } else if (state.statusCode == 401) {
      Navigator.pushNamed(context, '/Login');
    }
  }

  popupConfirmacaoErro() {
    MsgPopup().msgFeedback(
        context, 'Ocorreu um erro ao cadastrar. Verifique!', '',
        txtButton: 'OK!');
  }

  verificarDados() {
    if (controllerCampoImovel.text.isNotEmpty) {
      if (controllerCampoImovel.text.length > 3) {
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
        .delete(UrlServidor.toString() + DeletarImovel + id.toString());
    if (state.statusCode == 400) {
      mensagemErro =
          'O Imóvel está sendo usado e portanto não pode ser excluído.';
      _erroDeletarPivotante();
    } else if (state.statusCode == 401) {
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

// ======== chama um popup pedindo permissão para deletar o registro =========
  _deletarReg(int index) {
    MsgPopup().msgComDoisBotoes(
      context,
      'Confirmar exclusão do imóvel?',
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
    MsgPopup().msgFeedback(context, 'Imovel cadastrada com Sucesso', 'Imovel',
        txtButton: 'OK!');
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    Size size = mediaQuery.size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: size.width,
          height: size.height,
          color: Color(0XFF0099FF),
          child: Column(
            children: [
              //===========================================
              Padding(
                padding: EdgeInsets.only(
                  top: size.height * 0.05,
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
                          }),
                      Padding(
                        padding: EdgeInsets.only(left: size.width * 0.1),
                        child: Text(
                          'Cadastrar Imovel',
                          style: TextStyle(
                              fontSize: 30,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.none),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              //============== WIDGET DO CADASTRO =================
              Container(
                // Configurações do widget do cadastro
                height: size.height * 0.26,
                child: Padding(
                  padding: EdgeInsets.only(
                    top: size.width * 0.05,
                    left: size.width * 0.02,
                    right: size.width * 0.02,
                    bottom: size.height * 0.01,
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
                        //=======================================
                        Padding(
                          padding: EdgeInsets.only(
                            right: size.width * 0.02,
                            left: size.width * 0.02,
                            top: size.height * 0.02,
                          ),
                          child: CampoText().textField(
                            controllerCampoImovel,
                            'Imovel:',
                            altura: size.height * 0.10,
                            icone: Icons.home,
                            raioBorda: 10,
                          ),
                        ),
                        //=======================================
                        Container(
                          child: Padding(
                            padding: EdgeInsets.only(
                                right: size.width * 0.02,
                                left: size.width * 0.02,
                                top: size.height * 0.01),
                            child: Botao().botaoPadrao(
                              'Salvar',
                              () => {verificarDados(), print('enviou')},
                              Color(0XFFD1D6DC),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              //================== WIDGET DA LISTAGEM ==================
              Padding(
                // Configurações do widget da listagem
                padding: EdgeInsets.only(
                  left: size.width * 0.02,
                  right: size.width * 0.02,
                  top: size.height * 0.01,
                ),
                child: Container(
                  width: size.width,
                  height: size.height * 0.61,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: FutureBuilder(
                    future: listaDados(),
                    builder: (BuildContext context, snapshot) {
                      return ListView.builder(
                        itemCount: imoveis.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: Text(
                              '${index + 1}',
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            title: Text('${imoveis[index].name}'),
                            trailing: GestureDetector(
                              onTap: () {
                                _deletarReg(imoveis[index].id);
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
              //-----------------------------------------
            ],
          ),
        ),
      ),
    );
  }
}
