import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:projeto_aberturas/Funcoes/FuncoesParaDatas.dart';
import 'package:projeto_aberturas/Models/Models_Usuario.dart';
import 'package:projeto_aberturas/Models/constantes.dart';
import 'package:projeto_aberturas/Static/Static_GrupoMedidas.dart';
import 'package:projeto_aberturas/Widget/Botao.dart';
import 'package:projeto_aberturas/Static/Static_Usuario.dart';
import 'package:projeto_aberturas/Widget/Crud_DataBase.dart';
import 'package:projeto_aberturas/Widget/MsgPopup.dart';
import 'package:projeto_aberturas/Widget/TextField.dart';

//NESTA TELA E FEITO O CADASTRO DE ENDEREÇOS
class CadGrupoMedidas extends StatefulWidget {
  @override
  _CadGrupoMedidasState createState() => _CadGrupoMedidasState();
}

class _CadGrupoMedidasState extends State<CadGrupoMedidas> {
  TextEditingController controllerEndereco = TextEditingController();
  TextEditingController controllerTipoImovel = TextEditingController();
  TextEditingController controllerNumeroEnd = TextEditingController();
  TextEditingController controllerPropEnd = TextEditingController();
  TextEditingController controllerCidade = TextEditingController();
  TextEditingController controllerBairro = TextEditingController();
  List itensLista = List();
  int _selectedField;
//ESTA FUNÇÃO BUSCA A LISTA DOS TIPOS DE IMOVEIS
  Future fetchPost() async {
    final response = await http.get(
      Uri.encodeFull(ListarTodosImoveis),
      headers: {"authorization": ModelsUsuarios.tokenAuth},
    );
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      setState(() {
        itensLista = jsonData;
      });
    }
    if (response.statusCode == 401) {
      Navigator.pushNamed(context, '/Login');
    }
  }

// ===== Popop de escolha da tela que será aberta para cadastrar a medida
  escolhaTelaNovaMedida() {
    MsgPopup().msgComDoisBotoes(
      context,
      'Qual tipo de porta deseja medir?',
      'Específica',
      'Padrão',
      () {
        Navigator.of(context).pop(); // Fecha o popup de mensagem da escolha
        Navigator.of(context)
            .pop(); // Fecha o popup de do cadastro de grupo de medidas
        Navigator.pushNamed(context, '/CadDadosPorta');
      },
      () {
        Navigator.of(context).pop(); // Fecha o popup de mensagem da escolha
        Navigator.of(context)
            .pop(); // Fecha o popup de do cadastro de grupo de medidas
        Navigator.pushNamed(context, '/CadPortaPadrao');
      },
      corBotaoDir: Color(0XFF0099FF),
      corBotaoEsq: Color(0XFF0099FF),
      sairAoPressionar: true,
    );
  }

// popop que exibe mensagens de erros caso houver erro no cadastro
  _msgErroCadastro() {
    MsgPopup().msgFeedback(
      context,
      '\n' + mensagemErro,
      'Aviso',
    );
  }

  var mensagemErro = '';
  //VALIDA OS CAMPOS E REDIRECIONA PARA VER A LISTA DOS ENDERECOS CADASTRADOS
  validarCampos() async {
    var endereco = controllerEndereco.text;
    var numeroEnd = controllerNumeroEnd.text;
    var proprietarioEnd = controllerPropEnd.text;
    var cidade = controllerCidade.text;
    var bairro = controllerBairro.text;
    if (endereco.isEmpty) {
      mensagemErro = 'O campo "Endereço" não pode ficar em branco!';
      _msgErroCadastro();
    } else if (numeroEnd.isEmpty && numeroEnd.length < 1) {
      mensagemErro = 'O campo "Número" não pode ficar vazio';
      _msgErroCadastro();
    } else if (proprietarioEnd.isEmpty) {
      mensagemErro =
          'O campo "Proprietário" não pode conter números ou ficar vazio';
      _msgErroCadastro();
    } else if (cidade.isEmpty) {
      mensagemErro = 'O campo "cidade" não pode ficar vazio!';
      _msgErroCadastro();
    } else if (bairro.isEmpty) {
      mensagemErro = 'O campo "bairro" não pode ser vazio!';
      _msgErroCadastro();
    } else if (_selectedField == null) {
      mensagemErro = 'O campo "Tipo de imóvel" não pode ser vazio!';
      _msgErroCadastro();
    } else {
      mensagemErro = '';
      await salvarDadosBanco();
    }
  }

  @override
  void initState() {
    super.initState();
    this.fetchPost();
  }

//FUNÇÃO QUE ENVIA OS DADOS DE ENDEREÇO PARA O BANCOs
  Future<dynamic> salvarDadosBanco() async {
    var endereco = controllerEndereco.text;
    var numeroend = int.parse(controllerNumeroEnd.text);
    var proprietarioend = controllerPropEnd.text;
    var cidade = controllerCidade.text;
    var bairro = controllerBairro.text;
    var imovelSelecionado = _selectedField;
    var bodyy = jsonEncode({
      'idusuario': usuario.idUsuario,
      'idimovel': imovelSelecionado,
      'data_cadastro': DataAtual().pegardata() as String,
      'hora_cadastro': DataAtual().pegarHora() as String,
      'cidade': cidade,
      'bairro': bairro,
      'endereco': endereco,
      'proprietario': proprietarioend,
      'num_endereco': numeroend,
      'status_processo': "Cadastrado"
    });

    ReqDataBase().requisicaoPost(CadastrarGrupoMedidas, bodyy);

    print(bodyy);

    if (ReqDataBase.responseReq.statusCode == 200) {
      Navigator.pop(context);
    }
    if (ReqDataBase.responseReq.statusCode == 401) {
      Navigator.pushNamed(context, '/Login');
    }
  }

// ======== CAPTURA O ID DO ÚLTIMO GRUPO CADASTRADO ========
  Future<dynamic> buscarIdUltimoGrupoCadastrado() async {
    final response = await http.get(
      Uri.encodeFull(ListarUltimoIdGrupoCadastrado),
      headers: {"authorization": ModelsUsuarios.tokenAuth},
    );
    if (response.statusCode == 401) {
      Navigator.pushNamed(context, '/Login');
    }
    //IF(MOUNTED) É nescessario para não recarregar a arvore apos retornar das outras listas
    if (mounted)
      setState(
        () {
          var lista = json.decode(response.body);
          String retorno = lista.toString();
          // caso o retorno do Body for diferente de vazio("[]"), continua a execução
          if (retorno != "[]") {
            // Repara para mostra apenas o valor da chave primária
            String valorRetorno = retorno
                .substring(retorno.indexOf(':'), retorno.indexOf('}'))
                .replaceAll(':', '');

            // caso haja valor na variável, quer dizer que contém um registro
            if (valorRetorno.length > 0) {
              GrupoMedidas.idGrupoMedidas = int.parse(valorRetorno);
              escolhaTelaNovaMedida();
            }
          }
        },
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
          color: Color(0xFFBCE0F0), //Colors.green[200],
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: size.height * 0.01),
                child: Container(
                  width: size.width,
                  height: size.height * 0.08,
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: size.height * 0.00),
                        child: IconButton(
                          icon: Icon(Icons.arrow_back),
                          onPressed: () => Navigator.pop(context),
                          iconSize: 33,
                          color: Colors.white,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: size.width * 0.01),
                        child: Text(
                          'Cadastro do Grupo de Medidas',
                          style: TextStyle(
                            fontSize: size.width * 0.06,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: size.width * 0.02,
                    right: size.width * 0.02,
                    bottom: size.height * 0.01),
                child: Container(
                  width: size.width,
                  height: size.height * 0.80,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        //======================================================
                        Padding(
                          padding: EdgeInsets.only(top: size.height * 0.01),
                          child: CampoText().textField(
                            controllerCidade,
                            'Cidade:',
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: size.height * 0.01),
                          child: CampoText().textField(
                            controllerBairro,
                            'Bairro:',
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: size.height * 0.01),
                          child: CampoText().textField(
                            controllerEndereco,
                            'Endereço:',
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: size.height * 0.01),
                          child: CampoText().textField(
                              controllerNumeroEnd, 'Número: ',
                              tipoTexto: TextInputType.number),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: size.height * 0.01),
                          child: CampoText().textField(
                              controllerPropEnd, 'Proprietário: ',
                              tipoTexto: TextInputType.number),
                        ),
                        // =================== TIPO DE IMÓVEL ====================
                        new Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: new Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10)),
                            child: Text(
                              'Tipo de imovel:',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border:
                                    Border.all(color: Colors.black, width: 1)),
                            child: DropdownButton(
                                hint: Text(
                                  'Tipo de imovel',
                                  style: TextStyle(fontSize: 18),
                                ),
                                value: _selectedField,
                                items: itensLista.map((categoria) {
                                  return DropdownMenuItem(
                                      value: (categoria['idimovel']),
                                      child: Row(
                                        children: [
                                          Text(
                                            categoria['idimovel'].toString(),
                                            style: TextStyle(fontSize: 18),
                                          ),
                                          Text(
                                            ' - ',
                                            style: TextStyle(fontSize: 18),
                                          ),
                                          Text(
                                            categoria['nome'],
                                            style: TextStyle(fontSize: 18),
                                          )
                                        ],
                                      ));
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedField = value;
                                  });
                                }),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: size.height * 0.04, bottom: 0),
                          child: Botao().botaoPadrao(
                            'Iniciar medição',
                            () async {
                              Navigator.pop(context);
                              await validarCampos();
                              buscarIdUltimoGrupoCadastrado();
                            },
                            Color(0XFFD1D6DC),
                            fontWeight: FontWeight.w400
                          ),
                        ),

                        Padding(
                          padding: EdgeInsets.only(top: 5, bottom: 5),
                          child: Botao().botaoPadrao(
                            'Salvar endereço',
                            () async {
                              await validarCampos();
                              Navigator.pop(context);
                              Navigator.pushNamed(
                                  context, '/ListaGrupoMedidas');
                            },
                            Color(0XFFD1D6DC),
                            fontWeight: FontWeight.w400
                          ),
                        )
                      ],
                    ),
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
