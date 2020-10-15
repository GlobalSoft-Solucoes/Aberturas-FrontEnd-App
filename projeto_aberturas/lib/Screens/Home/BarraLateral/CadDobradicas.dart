import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:projeto_aberturas/Models/Models_Portas.dart';
import 'package:projeto_aberturas/Models/Models_Usuario.dart';
import 'package:projeto_aberturas/Models/constantes.dart';

import 'package:projeto_aberturas/Widget/Botao.dart';
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

  var dobradicas = new List<Dobradicas>();
  var mensagemErro = '';
  Future listaDados() async {
    final response = await http
        .get(Uri.encodeFull(UrlServidor + 'Dobradica/ListarTodos/'), headers: {
      "authorization": ModelsUsuarios.tokenAuth,
    });

    if (mounted) {
      setState(() {
        Iterable lista = json.decode(response.body);

        dobradicas = lista.map((model) => Dobradicas.fromJson(model)).toList();
      });
    }
  }

  Future<dynamic> salvarDadosBanco() async {
    var nomedobradica = controllDobradicas.text;
    var descricao = controllDescricao.text;
    var bodyy = jsonEncode({
      'Nome': nomedobradica,
      'Descricao': descricao,
    });

    print(bodyy);
    http.Response state = await http.post(
      UrlServidor + 'Dobradica/Cadastrar/',
      headers: {
        "authorization": ModelsUsuarios.tokenAuth,
      },
      body: bodyy,
    );
    if (state.statusCode == 200) {
      popupconfirmacao();
    } else if (state.statusCode == 400) popupconfirmacaoerro();
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
    http.Response state = await http
        .delete(UrlServidor.toString() + DeletarDobradica + id.toString());
    if (state.statusCode == 400) {
      mensagemErro =
          'A Dobradiça está sendo usado e portanto não pode ser excluída.';
      _erroDeletarPivotante();
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
        context, 'Dobradica cadastrada com Sucesso', 'Dobradica',
        txtButton: 'OK!');
  }

  popupconfirmacaoerro() {
    MsgPopup().msgFeedback(context, 'Ocorreu um erro ao cadastrar', 'Dobradica',
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
              //===============================================
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
                        onPressed: () => Navigator.pop(context),
                      ),
                      Text(
                        'Cadastro de Dobradiças',
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
                // Configurações do primeiro widget que faz o cadastro
                width: size.width,
                height: size.height * 0.37,
                child: Padding(
                  padding: EdgeInsets.only(
                    top: size.width * 0.02,
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
                        Padding(
                          padding: EdgeInsets.only(
                            right: size.width * 0.02,
                            left: size.width * 0.02,
                            top: size.height * 0.02,
                          ),
                          child: CampoText().textField(
                              controllDobradicas, 'Dobradiça:',
                              altura: size.height * 0.10,
                              icone: Icons.home,
                              raioBorda: 10),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              right: size.width * 0.02,
                              left: size.width * 0.02,
                              top: size.height * 0.01),
                          child: CampoText().textField(
                            controllDescricao,
                            'Descricao:',
                            altura: size.height * 0.10,
                            icone: Icons.home,
                            raioBorda: 10,
                          ),
                        ),
                        Container(
                          child: Padding(
                            padding: EdgeInsets.only(
                              right: size.width * 0.02,
                              left: size.width * 0.02,
                              top: size.width * 0.025,
                            ),
                            child: Botao().botaoPadrao('Salvar',
                                () => {verificarDados()}, Color(0XFFD1D6DC)),
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
                  height: size.height * 0.49,
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
