import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:projeto_aberturas/Models/Models_TipoPorta.dart';
import 'package:projeto_aberturas/Models/Models_Usuario.dart';
import 'package:projeto_aberturas/Models/constantes.dart';
import 'package:projeto_aberturas/Widget/Botao.dart';
import 'package:projeto_aberturas/Widget/Crud_DataBase.dart';
import 'package:projeto_aberturas/Widget/MsgPopup.dart';
import 'package:projeto_aberturas/Widget/TextField.dart';
import 'package:projeto_aberturas/Widget/ListFieldsDataBase.dart';

class CadastroTipoDaPorta extends StatefulWidget {
  @override
  _CadastroTipoDaPortaState createState() => _CadastroTipoDaPortaState();
}

class _CadastroTipoDaPortaState extends State<CadastroTipoDaPorta> {
  TextEditingController controllerNome = TextEditingController();
  TextEditingController controllerDescricao = TextEditingController();
  TextEditingController controllerDescontoLargura = TextEditingController();
  TextEditingController controllerDescontoAltura = TextEditingController();

  List<ModelsTipoPorta> dadosListagem = [];
  Future<dynamic> listarDados() async {
    final response = await http.get(
      Uri.encodeFull(ListarTodosTipoPorta),
      headers: {
        "Content-Type": "application/json",
        "authorization": ModelsUsuarios.tokenAuth
      },
    );
    if (response.statusCode == 401) {
      Navigator.pushNamed(context, '/Login');
    }
    //IF(MOUNTED) É nescessario para não recarregar a arvore apos retornar das outras listas
    if (mounted)
      setState(() {
        Iterable lista = json.decode(response.body);
        dadosListagem =
            lista.map((model) => ModelsTipoPorta.fromJson(model)).toList();
      });
  }

  Future<dynamic> delete(int id) async {
    ReqDataBase().requisicaoDelete(DeletarTipoPorta + id.toString());
    if (ReqDataBase.responseReq.statusCode == 401) {
      Navigator.pushNamed(context, '/Login');
    }
  }

  var mascaraLargura = new MaskTextInputFormatter(
      mask: '##.###.##', filter: {"#": RegExp(r'[^0-9]')});
  var mascaraAltura = new MaskTextInputFormatter(
      mask: '**.***.**', filter: {"#": RegExp(r'[^0-9]')});

  confExcluir(id) {
    MsgPopup().msgComDoisBotoes(
      context,
      'Deseja excluir a porta selecionada?',
      'Cancelar',
      'Confirmar',
      () => {
        Navigator.pop(context),
      },
      () => {
        delete(id),
        Navigator.pop(context),
      },
    );
  }

// Salva os dados no banco
  salvarBanco() async {
    var bodyy = jsonEncode(
      {
        'nome': controllerNome.text,
        'descricao': controllerDescricao.text,
        'desconto_altura': double.tryParse(controllerDescontoAltura.text),
        'desconto_largura': double.tryParse(controllerDescontoLargura.text),
      },
    );

    ReqDataBase().requisicaoPost(CadastrarTipoPorta, bodyy);

    if (ReqDataBase.responseReq.statusCode == 200) {
      Navigator.pushNamed(context, '/Home');
    } else if (ReqDataBase.responseReq.statusCode == 401) {
      Navigator.pushNamed(context, '/Login');
    }
  }

//valida os campos
  validarCampos() {
    if (controllerNome.text.isNotEmpty) {
      salvarBanco();
    } else {
      MsgPopup()
          .msgFeedback(context, 'O campo Modelo não foi preenchido', 'Erro');
    }
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
          color: Color(0xFFCCE9F5),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: size.height * 0.01),
                child: Container(
                  width: size.width,
                  height: size.height * 0.09,
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: IconButton(
                          icon: Icon(Icons.arrow_back),
                          onPressed: () => Navigator.pop(context),
                          iconSize: 35,
                          color: Colors.white,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: size.width * 0.08),
                        child: Text(
                          'Cadastro de portas',
                          style: TextStyle(
                              fontSize: 30,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // =================== CADASTRO DA PORTA =====================
              Padding(
                padding: EdgeInsets.only(
                  left: size.width * 0.02,
                  right: size.width * 0.02,
                ),
                child: Container(
                  width: size.width,
                  height: size.height * 0.32,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: size.height * 0.01),
                          child: CampoText().textField(
                            controllerNome,
                            'nome:',
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: size.height * 0.005),
                          child: CampoText().textField(
                            controllerDescricao,
                            'descricao:',
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: size.height * 0.005),
                          child: CampoText().textField(
                            controllerDescontoLargura,
                            'Desconto Largura:',
                            tipoTexto: TextInputType.number,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: size.height * 0.005),
                          child: CampoText().textField(
                            controllerDescontoAltura,
                            'Desconto Altura:',
                            tipoTexto: TextInputType.number,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: size.height * 0.02),
                          child: Botao().botaoPadrao(
                            'Salvar',
                            () => validarCampos(),
                            Colors.blue[300],
                            corFonte: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: size.width * 0.02,
                    right: size.width * 0.02,
                    top: size.height * 0.01),
                child: Container(
                  width: size.width,
                  height: size.height * 0.555,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: FutureBuilder(
                    future: listarDados(),
                    builder: (BuildContext context, snapshot) {
                      return ListView.builder(
                        itemCount: dadosListagem.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(
                              // bottom: 2,
                              top: 8,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 4, right: 4),
                              child: Container(
                                alignment: Alignment.center,
                                height: size.height * 0.14,
                                width: size.width,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    15,
                                  ),
                                  color: Color(0XFFD1D6DC),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    left: 5,
                                    right: 10,
                                  ),
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
                                            FieldsDatabase().listaDadosBanco(
                                                'Nome da porta: ',
                                                dadosListagem[index].nome),
                                            FieldsDatabase().listaDadosBanco(
                                                'Descricao: ',
                                                dadosListagem[index].descricao),
                                            FieldsDatabase().listaDadosBanco(
                                                'Desc Altura: ',
                                                dadosListagem[index]
                                                    .descontoAltura
                                                    .toString()),
                                            FieldsDatabase().listaDadosBanco(
                                                'Desc Largura: ',
                                                dadosListagem[index]
                                                    .descontoLargura
                                                    .toString()),
                                          ],
                                        ),
                                        trailing: IconButton(
                                          alignment: Alignment.bottomCenter,
                                          icon: Icon(
                                            Icons.delete_forever,
                                            color: Colors.red,
                                            size: 32,
                                          ),
                                          padding: EdgeInsets.only(
                                            left: 25,
                                            top: 0,
                                          ),
                                          onPressed: () => {
                                            confExcluir(
                                              dadosListagem[index].idTipoPorta,
                                            ),
                                          },
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
