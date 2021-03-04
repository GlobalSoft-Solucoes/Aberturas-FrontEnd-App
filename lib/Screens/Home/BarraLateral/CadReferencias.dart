import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:projeto_aberturas/Models/Models_Portas.dart';
import 'package:projeto_aberturas/Models/Models_Usuario.dart';
import 'package:projeto_aberturas/Models/constantes.dart';
import 'package:projeto_aberturas/Widget/Botao.dart';
import 'package:projeto_aberturas/Widget/Crud_DataBase.dart';
import 'package:projeto_aberturas/Widget/MsgPopup.dart';
import 'package:projeto_aberturas/Widget/TextField.dart';
import 'package:http/http.dart' as http;
import 'package:projeto_aberturas/Widget/Cabecalho.dart';

class CadReferencias extends StatefulWidget {
  @override
  _CadReferenciasState createState() => _CadReferenciasState();
}

class _CadReferenciasState extends State<CadReferencias> {
  TextEditingController controlerRefs = TextEditingController();
  List<Referencias> referencias = [];
  var mensagemErro = '';

  Future listarDados() async {
    final response = await http.get(
      Uri.encodeFull(ListarTodosCodReferencia),
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

  Future<dynamic> salvarDadosBanco() async {
    var referencias = controlerRefs.text;

    var bodyy = jsonEncode({
      'codigo': referencias,
    });

    ReqDataBase().requisicaoPost(CadastrarCodReferencia, bodyy);

    if (ReqDataBase.responseReq.statusCode == 200) {
      controlerRefs.text = " ";
    } else if (ReqDataBase.responseReq.statusCode == 400) {
      popupconfirmacaoerro();
    }
    if (ReqDataBase.responseReq.statusCode == 401) {
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
      if (controlerRefs.text.length > 3) {
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
    ReqDataBase().requisicaoDelete(DeletarCodReferencia + id.toString());
    if (ReqDataBase.responseReq.statusCode == 400) {
      mensagemErro =
          'A Referência está sendo usado e portanto não pode ser excluída.';
      _erroDeletarPivotante();
    }
    if (ReqDataBase.responseReq.statusCode == 401) {
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
      backgroundColor: Color(0xFFCCE9F5),
      body: SingleChildScrollView(
        child: Container(
          width: size.width,
          height: size.height,
          color: Color(0xFFBCE0F0),
          child: Column(
            children: [
              //===============================================
              Cabecalho().tituloCabecalho(context, 'Código referência',
                  iconeVoltar: true, marginLeft: 0.01),
              //================ WIDGET DO CADASTRO ===================
              Container(
                width: size.width,
                height: size.height * 0.23,
                child: Padding(
                  padding: EdgeInsets.only(
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
                        CampoText().textField(
                          controlerRefs,
                          'Codigo referência:',
                          altura: size.height * 0.10,
                          icone: Icons.edit_sharp,
                          raioBorda: 10,
                          confPadding: EdgeInsets.only(
                            right: size.width * 0.02,
                            left: size.width * 0.02,
                            top: size.height * 0.02,
                          ),
                        ),
                        //-------------------------------------------
                        Container(
                          child: Padding(
                            padding: EdgeInsets.only(
                              right: size.width * 0.02,
                              left: size.width * 0.02,
                              top: size.width * 0.07,
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
              //================ WIDGET DA LISTAGEM ===================
              Padding(
                padding: EdgeInsets.only(
                    left: size.width * 0.02, right: size.width * 0.02),
                child: Container(
                  width: size.width,
                  height: size.height * 0.61,
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
                                size: 27,
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
