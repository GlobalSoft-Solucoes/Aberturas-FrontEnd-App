import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:projeto_aberturas/Models/Models_Usuario.dart';
import 'package:projeto_aberturas/Models/constantes.dart';
import 'package:projeto_aberturas/Screens/Home/Home.Dart';
import 'package:projeto_aberturas/Static/Static_Usuario.dart';
import 'package:projeto_aberturas/Stores/Login_Store.dart';
import 'package:projeto_aberturas/Widget/Botao.dart';
import 'package:projeto_aberturas/Widget/Cabecalho.dart';
import 'package:projeto_aberturas/Widget/Crud_DataBase.dart';
import 'package:projeto_aberturas/Widget/MsgPopup.dart';
import 'package:projeto_aberturas/Widget/TextField.dart';
import 'package:http/http.dart' as http;

class PerfilUsuario extends StatefulWidget {
  PerfilUsuario({Key key}) : super(key: key);

  @override
  _PerfilUsuarioState createState() => _PerfilUsuarioState();
}

class _PerfilUsuarioState extends State<PerfilUsuario> {
  //
  // ========  ATRIBUI DIRETAMENTE PARA O CAMPO TEXTO, OS DADOS CAPTURADOS DO USUÁRIO ===========
  //
  TextEditingController controllerNome =
      TextEditingController(text: UserLogado.nome);
  TextEditingController controllerEmail =
      TextEditingController(text: UserLogado.email);
  TextEditingController controllerSenha =
      TextEditingController(text: UserLogado.senha);
  TextEditingController controllerCodigoAdm = TextEditingController();

  bool checklCodAdm = UserLogado.adm == '1' ? true : false; //false;
  bool valorcheck; //= usuario.adm == '1' ? true : false;

  String mensagemErro;
  String valorRetornoIdEmpresa;
  String valorRetornoCodAdm;
  String valorField;
  String valorAdm;
  String valorCampoAdmUser = UserLogado.adm;

  LoginStore loginStore = LoginStore();

// ============= VERIFICA SE HOUVE ALTERAÇÕES NO CADASTRO DO USUARIO ==============
  _verificaSeHouveAlteracoes() {
    if (controllerNome.text != UserLogado.nome ||
        controllerEmail.text != UserLogado.email ||
        controllerSenha.text != UserLogado.senha ||
        (valorAdm == '1' && checklCodAdm == false)) {
      _confirmarAlteracoes();
    } else {
      Navigator.pop(context);
    }
  }

// ===== VERIFICA SE O CHECKBOX ESTÁ MARCADO OU DESMARCADO PARA TRATAR O USUARIO COMO ADM ======
  _verificaValorAdmUser() {
    if (checklCodAdm == true) {
      valorAdm = "1";
    } else {
      valorAdm = "0";
    }
  }

// ==== caso o usuario desmarcar o ckeck, confirmar a alterações e clicar em cancelar as alterações,
// marca novamente o checkbox. =======
  _marcaDesmarcaCheckBox() {
    if (UserLogado.adm == '1' && checklCodAdm == false) {
      valorcheck = true;
      checklCodAdm = valorcheck;
    } else {
      valorcheck = false;
      checklCodAdm = valorcheck;
    }
  }
  
// ======== POPUP DE CONFIRMAÇÃO PARA ALTERAÇÃO DAS INFORMAÇÕES DO USUÁRIO =========

  _confirmarAlteracoes() {
    MsgPopup().msgComDoisBotoes(
      context,
      'Deseja salvar as alterações feitas?',
      'Não',
      'Sim',
      () async {
        await _marcaDesmarcaCheckBox();
        Navigator.pop(context);
        Navigator.pushNamed(context, '/Home');
      },
      () async {
        await editarDadosUsuario();
        Navigator.pop(context);
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) {
          return Home();
        }));
      },
      corBotaoEsq: Color(0XFFF4485C),
      corBotaoDir: Color(0XFF0099FF),
      sairAoPressionar: true,
    );
  }

  // ====== DISPARA UM POPUP PARA INFORMAR O CÓDIGO DA EMPRESA PARA O USUÁRIO PODER SER CADASTRADO =====
  _codAdministrador() {
    controllerCodigoAdm.selection;
    MsgPopup().campoTextoComDoisBotoes(
      context,
      'Digite o código de administrador da empresa:',
      'Código:',
      'Cancelar',
      'Continuar',
      () => {
        setState(() {
          valorcheck = false;
          checklCodAdm = valorcheck;
        }),
        controllerCodigoAdm.text = "",
        Navigator.pop(context),
      },
      () async {
        valorcheck = true;
        await _capturaIdEmpresa();
        validaCodEmp();
      },
      controller: controllerCodigoAdm,
      fontMsg: 20,
      bordaPopup: 20,
    );
  }

// ============== VALIDAÇÃO DO CÓDIGO DO ADMINISTRADOR INFORMADO ==============
  validaCodEmp() {
    String codAcessoEmp = controllerCodigoAdm.text;
    if (codAcessoEmp.isEmpty) {
      mensagemErro = '\n O codigo não pode ficar vazio!';
      _msgCodigoIncorreto();
    } else {
      _verificaCodigoAdm();
    }
  }

  // ======= MENSAGEM DISPARADA CASO O CÓDIGO INFORMADO ESTEJA ERRADO ========
  _msgCodigoIncorreto() {
    Navigator.of(context).pop();
    MsgPopup().msgDirecionamento(
      context,
      mensagemErro,
      'Aviso',
      () => {
        Navigator.of(context).pop(),
        _codAdministrador(),
      },
    );
  }

  // ======= MENSAGEM DISPARADA SE O CÓDIGO INFORMADO ESTIVER CORRETO ========
  _msgCodigoAdmCorreto() {
    Navigator.of(context).pop();
    MsgPopup().msgDirecionamento(
      context,
      'Agora você é um administrador!',
      '',
      () => {
        Navigator.of(context).pop(),
        valorAdm = '1',
        editarAdmUsuario(valorAdm),
      },
      corMsg: Colors.green[500],
      fonteMsg: 21,
    );
  }

// ============== BUSCA O IDEMPRESA ATRAVÉS DO IDUSUARIO LOGADO ================
  _capturaIdEmpresa() async {
    var result = await http.get(
      Uri.encodeFull(
        BuscaEmpresaPorUsuario + UserLogado.idUsuario.toString(),
      ),
      headers: {"authorization": ModelsUsuarios.tokenAuth},
    );

    // Captura o valor vindo do body da requisição
    String retorno = result.body;

    valorRetornoIdEmpresa = refatoraValorApi(retorno);
  }

  // ============== BUSCA O IDEMPRESA ATRAVÉS DO IDUSUARIO LOGADO ================
  _verificaCodAdmUsuario() async {
    var result = await http.get(
      Uri.encodeFull(
        VerificaCodAdm.toString() + UserLogado.idUsuario.toString(),
      ),
      headers: {"Content-Type": "application/json"},
    );

    // Captura o valor vindo do body da requisição
    String retorno = result.body;

    valorAdm = refatoraValorApi(retorno);
  }

  // ========= A FUNCAO SERVE PARA REFATORAR UM VALOR VINDO DA API, DEIXANDO SOMENTE O VALOR, SEM
  // O CAMPO DA TABELA EM QUE LE PERTENCE ==========

  refatoraValorApi(resultBody) {
    String retorno = resultBody;
    // caso o retorno do Body for diferente de vazio("[]"), continua a execução
    if (retorno != "[]") {
      // Repara para mostra apenas o valor da chave primária
      String valorRetorno = retorno
          .substring(retorno.indexOf(':'), retorno.indexOf('}'))
          .replaceAll(':', '')
          .replaceAll('"', '');

      return valorRetorno;
    }
  }

// ============== VERIFICAR SE O CÓDIGO DE ADMINISTRADOR DA EMPRESA É IGUAL AO INFORMADO ================
  _verificaCodigoAdm() async {
    var result = await http.get(
      Uri.encodeFull(
        BuscarCodigoAdm.toString() + valorRetornoIdEmpresa.toString(),
      ),
      headers: {"Content-Type": "application/json"},
    );

    // Captura o valor vindo do body da requisição
    String retorno = result.body;

    String valorRetorno = refatoraValorApi(retorno);

    if (valorRetorno == '') {
      controllerCodigoAdm.text = "";
      mensagemErro =
          '\n Ops.. o código de administrador informado está incorreto!';
      _msgCodigoIncorreto();
    }

    // caso haja valor na variável, quer dizer que contém um registro
    if (valorRetorno.length > 0) {
      valorRetornoCodAdm = valorRetorno;

      if (valorRetornoCodAdm == controllerCodigoAdm.text) {
        _msgCodigoAdmCorreto();
        controllerCodigoAdm.text = "";
      } else {
        mensagemErro =
            '\n Ops.. o código de administrador informado não existe. Verifique!';
        _msgCodigoIncorreto();
      }
    }
  }

  //======== Salva os dados editados no banco de dados =========
  Future<dynamic> editarDadosUsuario() async {
    _verificaValorAdmUser();
    var bodyy = jsonEncode({
      "nome": controllerNome.text,
      "email": controllerEmail.text,
      "senha": controllerSenha.text,
      "adm": valorAdm,
    });
    ReqDataBase().requisicaoPut(
        EditarUsuario + UserLogado.idUsuario.toString(),
        body: bodyy);

    // atualiza a lista com os dados alterados do usuário logado
    UserLogado().capturaDadosUsuarioLogado();
    print(bodyy);
    print(ReqDataBase.responseReq.statusCode);
  }

  Future<dynamic> editarAdmUsuario(valorAdm) async {
    var bodyy = jsonEncode({
      "adm": valorAdm,
    });

    http.put(
      EditarUsuario + UserLogado.idUsuario.toString(),
      headers: {"authorization": ModelsUsuarios.tokenAuth},
      body: bodyy,
    );
    print(bodyy);
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    Size size = mediaQuery.size;
    return Scaffold(
      body: Material(
        child: Container(
          alignment: Alignment.topCenter,
          color: Color(0xFFBCE0F0),
          child: Padding(
            padding: EdgeInsets.only(
              top: size.height * 0.0,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Cabecalho().tituloCabecalho(context, 'Perfil do usuário',
                      iconeVoltar: true),
                  //==============================================================
                  Container(
                    child: Text(
                      'Nome do usuário:',
                      style:
                          TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
                    ),
                    padding: EdgeInsets.only(
                        right: size.width * 0.6, top: size.height * 0.06),
                  ),
                  CampoText().textField(
                    controllerNome,
                    '',
                    icone: Icons.person,
                    confPadding: EdgeInsets.only(top: 10, left: 8, right: 8),
                  ),

                  // ================== E-MAIL DO USUÁRIO =====================
                  Container(
                    child: Text(
                      'E-mail do usuário:',
                      style:
                          TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
                    ),
                    padding: EdgeInsets.only(right: size.width * 0.6, top: 30),
                  ),
                  CampoText().textField(
                    controllerEmail,
                    '',
                    icone: Icons.email,
                    tipoTexto: TextInputType.emailAddress,
                    confPadding: EdgeInsets.only(top: 10, left: 8, right: 8),
                  ),

                  // =================== SENHA DO USUÁRIO ====================
                  Container(
                    child: Text(
                      'Senha do usuário:',
                      style:
                          TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
                    ),
                    padding: EdgeInsets.only(right: size.width * 0.6, top: 30),
                  ),
                  new Padding(
                    padding: new EdgeInsets.only(
                        top: 10, left: 10, right: 10, bottom: 60),
                    child: Observer(builder: (_) {
                      return new TextFormField(
                        controller: controllerSenha,
                        style: new TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                        ),
                        obscureText: loginStore.senhamostrar,
                        decoration: new InputDecoration(
                          suffixIcon: InkWell(
                            child: loginStore.senhamostrar
                                ? Icon(Icons.visibility)
                                : Icon(Icons.visibility_off),
                            onTap: () {
                              loginStore.mostrarSenha();
                            },
                          ),
                          prefixIcon: new Icon(Icons.vpn_key),
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(
                              12,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                  // ================== CAMPO DO ADMINISTRADOR ===================
                  Container(
                    child: Text(
                      'Privilégios de administrador:',
                      style:
                          TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
                    ),
                    padding: EdgeInsets.only(right: size.width * 0.42, top: 30),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 10,
                      right: size.width * 0.45,
                      top: 10,
                      bottom: size.height * 0.08,
                    ),
                    child: Container(
                      width: size.width * 0.6,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.black),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: CheckboxListTile(
                              selected: true,
                              title: Text(
                                'Administrador',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              key: Key('check1'),
                              value: checklCodAdm,
                              onChanged: (valorcheck) async {
                                setState(
                                  () {
                                    checklCodAdm = valorcheck;
                                  },
                                );
                                // se o usuario não for adm, abre um popup para informar o codigo da empresa
                                // e se tornar um adm
                                await _verificaCodAdmUsuario();
                                valorAdm == "0" ? _codAdministrador() : null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  //==============================================
                  Botao().botaoPadrao(
                    'Confirmar',
                    () async {
                      await _verificaSeHouveAlteracoes();
                      _verificaValorAdmUser();
                      setState(() {
                        // Atualiza os dados do usuario no arquivo static onde eles são pegos
                        UserLogado().capturaDadosUsuarioLogado();
                      });
                    },
                    Color(0XFFD1D6DC),
                    fontWeight: FontWeight.w500,
                  )
                  //==============================================
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
