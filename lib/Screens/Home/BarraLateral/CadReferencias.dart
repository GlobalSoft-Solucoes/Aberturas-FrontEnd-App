import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:projeto_aberturas/Models/Models_Portas.dart';
import 'package:projeto_aberturas/Models/Models_Usuario.dart';
import 'package:projeto_aberturas/Models/constantes.dart';
import 'package:projeto_aberturas/Widget/Botao.dart';
import 'package:projeto_aberturas/Widget/MsgPopup.dart';
import 'package:projeto_aberturas/Widget/TextField.dart';
import 'package:http/http.dart' as http;

class CadReferencias extends StatefulWidget {
  @override
  _CadReferenciasState createState() => _CadReferenciasState();
}

class _CadReferenciasState extends State<CadReferencias> {
  TextEditingController controlerRefs = TextEditingController();
  var referencias = new List<Referencias>();
  var mensagemErro = '';

  Future listarDados() async {
    final response = await http.get(
      Uri.encodeFull(UrlServidor + ListarTodosCodReferencias),
      headers: {"authorization": ModelsUsuarios.tokenAuth},
    );
    if (mounted) {
      setState(() {
        Iterable lista = json.decode(response.body);

        referencias =
            lista.map((model) => Referencias.fromJson(model)).toList();
      });
    }
    if (response.statusCode == 401) {
      Navigator.pushNamed(context, '/Login');
    }
  }

  popupconfirmacao() {
    MsgPopup().msgFeedback(
        context, 'Referencias cadastrada com Sucesso', 'Referencia',
        txtButton: 'OK!');
  }

  Future<dynamic> salvarDadosBanco() async {
    var referencias = controlerRefs.text;

    var bodyy = jsonEncode({
      'Codigo': referencias,
    });

    http.Response state = await http.post(
      UrlServidor + CadastrarCodReferencia,
      headers: {
        "Content-Type": "application/json",
        "authorization": ModelsUsuarios.tokenAuth
      },
      body: bodyy,
    );

    if (state.statusCode == 200) {
      popupconfirmacao();
    } else if (state.statusCode == 400) {
      popupconfirmacaoerro();
    }
    if (state.statusCode == 401) {
      Navigator.pushNamed(context, '/Login');
    }
  }

  popupconfirmacaoerro() {
    MsgPopup().msgFeedback(
        context, 'Ocorreu um erro ao cadastrar', 'CodReferencia',
        txtButton: 'OK!');
  }

  verificarDados() {
    if (controlerRefs.text.isNotEmpty) {
      if (controlerRefs.text.length >= 3) {
        salvarDadosBanco();
        mensagemErro = '';
      } else {
        setState(() {
          mensagemErro = 'a palavra e muito curta';
        });
      }
    } else
      setState(() {
        mensagemErro = 'O campo não pode ficar vazio';
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
    http.Response state = await http.delete(
        UrlServidor.toString() + DeletarCodReferencia + id.toString(),
        headers: {
          "Content-Type": "application/json",
          "authorization": ModelsUsuarios.tokenAuth
        });
    if (state.statusCode == 400) {
      mensagemErro =
          'A Referência está sendo usado e portanto não pode ser excluída.';
      _erroDeletarPivotante();
    }
    if (state.statusCode == 401) {
      Navigator.pushNamed(context, '/Login');
    }
  }

  _deletarReg(int index) {
    MsgPopup().msgComDoisBotoes(
      context,
      'Confirmar exclusão do código de referência?',
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
      body: SingleChildScrollView(
        child: Container(
          width: size.width,
          height: size.height,
          color: Color(0XFF0099FF),
          child: Column(
            children: [
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
                        'Cadastrar Codigo Referencia',
                        style: TextStyle(
                          fontSize: 28,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              //================ WIDGET DO CADASTRO ===================
              Container(
                width: size.width,
                height: size.height * 0.27,
                child: Padding(
                  padding: EdgeInsets.only(
                    top: size.width * 0.02,
                    left: size.width * 0.02,
                    right: size.width * 0.02,
                    bottom: size.height * 0.02,
                  ),
                  //-----------------------------------------
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
                        //------------------------------------------
                        Padding(
                          padding: EdgeInsets.only(
                            right: size.width * 0.02,
                            left: size.width * 0.02,
                            top: size.height * 0.02,
                          ),
                          child: CampoText().textField(
                            controlerRefs,
                            'Cod Ref:',
                            altura: size.height * 0.10,
                            icone: Icons.home,
                            raioBorda: 10,
                          ),
                        ),
                        //-------------------------------------------
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
                                Color(0XFFD1D6DC)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              //================ WIDGET DA LISTAGEM ===================
              Padding(
                padding: EdgeInsets.only(
                    left: size.width * 0.02, right: size.width * 0.02),
                child: Container(
                  width: size.width,
                  height: size.height * 0.60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: FutureBuilder(
                    future: listarDados(),
                    builder: (BuildContext context, snapshot) {
                      return ListView.builder(
                        itemCount: referencias.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: Text(
                              '${index + 1}',
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            title: Text('${referencias[index].codigo}'),
                            trailing: GestureDetector(
                              onTap: () {
                                _deletarReg(referencias[index].idCodReferencia);
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
