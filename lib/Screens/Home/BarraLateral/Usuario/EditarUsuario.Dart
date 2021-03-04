import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:projeto_aberturas/Models/constantes.dart';
import 'package:projeto_aberturas/Static/Static_Empresa.dart';
import 'package:projeto_aberturas/Static/Static_Usuario.dart';
import 'package:projeto_aberturas/Stores/Login_Store.dart';
import 'package:projeto_aberturas/Widget/Botao.dart';
import 'package:projeto_aberturas/Widget/Cabecalho.dart';
import 'package:projeto_aberturas/Widget/Crud_DataBase.dart';
import 'package:projeto_aberturas/Widget/MsgPopup.dart';
import 'package:projeto_aberturas/Widget/TextField.dart';

class EditarDadosUsuario extends StatefulWidget {
  EditarDadosUsuario({Key key}) : super(key: key);
  @override
  _CadastroUsuarioState createState() => _CadastroUsuarioState();
}

class _CadastroUsuarioState extends State<EditarDadosUsuario> {
  TextEditingController controllerSenha =
      TextEditingController(text: FieldsUsuario.senha);
  TextEditingController controllerConfSenha =
      TextEditingController(text: FieldsUsuario.senha);
  TextEditingController controllerEmail =
      TextEditingController(text: FieldsUsuario.email);
  TextEditingController controllerNome =
      TextEditingController(text: FieldsUsuario.nome);
  String mensagemErro = "";

  int idUsuarioSelecionado = FieldsUsuario.idUsuario;

  LoginStore loginStore = LoginStore();

  // VALIDAÇÃO DOS CAMPOS PARA O CADASTRO
  _validarCampos() {
    String nome = controllerNome.text;
    String email = controllerEmail.text;
    String senha = controllerSenha.text;
    String confSenha = controllerConfSenha.text;

    if (nome.isEmpty) {
      mensagemErro = "O nome precisa ter mais que 3 letras";
      erroValidarCampos();
    } else if (email.isEmpty && email.contains("@")) {
      mensagemErro = "Preencha o email corretamente";
      erroValidarCampos();
    } else if (senha.isEmpty && senha.length < 6) {
      mensagemErro = "senha incorreta! a senha precisa ter mais que 8 letras";
      erroValidarCampos();
    } else if (confSenha != senha) {
      mensagemErro = "As senhas não coencidem";
      erroValidarCampos();
    } else if (controllerConfSenha.text == senha) {
      mensagemErro = '';
      if (FieldsUsuario.email != controllerEmail.text) {
        validarEmailRegistrado();
      } else {
        _editarUsuario();
      }
    }
  }

// VERIFICA SE O E-MAIL ESTÁ DISPONÍVEL PARA SER CADASTRADO
  validarEmailRegistrado() async {
    var email = jsonEncode({
      'email': controllerEmail.text,
    });

    await ReqDataBase().requisicaoPost(VerficarSeEmailEstaDisponivel, email);

    print(ReqDataBase.responseReq.statusCode);
    if (ReqDataBase.responseReq.statusCode == 200) {
      await _editarUsuario();
    } else {
      emailJaEmUso();
    }
    if (ReqDataBase.responseReq.statusCode == 401)
      Navigator.pushNamed(context, '/login');
  }

// ======= FAZ O CADASTRO DO USUÁRIO NO BANCO DE DADOS =========
  _editarUsuario() async {
    var boddy = jsonEncode(
      {
        'idempresa': FieldsEmpresa.idEmpresa,
        'nome': controllerNome.text.trim(),
        'email': controllerEmail.text.trim(),
        'senha': controllerSenha.text.trim(),
        'adm': 0,
      },
    );

    await ReqDataBase().requisicaoPut(
        EditarUsuario + FieldsUsuario.idUsuario.toString(),
        body: boddy);

    if (ReqDataBase.responseReq.statusCode == 200) {
      await editadoSucesso();
      // Navigator.pop(context);
    }
    if (ReqDataBase.responseReq.statusCode == 401)
      Navigator.pushNamed(context, '/login');
  }

// ====== MENSAGEM DISPARADA CASO O CADASTRO SEJA CONCLUÍDO ========
  editadoSucesso() async {
    await MsgPopup().msgFeedback(
      context,
      'Usuário editado com sucesso!',
      '',
      fontMsg: 20,
      corMsg: Colors.green[600],
    );
    Navigator.of(context).pop(); // fecha a tela de cadastro do usuário
  }

// DISPARA MENSAGEM AVISANDO QUE O E-MAIL ESTÁ SENDO USADO POR OUTRO USUÁRIO
  emailJaEmUso() {
    MsgPopup().msgFeedback(
      context,
      'Já existe uma conta de usuário cadastrado com este e-mail. Verifique!',
      '',
      fontMsg: 20,
    );
  }

// ======= MENSAGEM DE ERRO AO CADASTRAR O USUÁRO ========
  erroValidarCampos() {
    MsgPopup().msgFeedback(
      context,
      mensagemErro,
      '',
      fontMsg: 20,
    );
  }

  void initState() {
    super.initState();
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
                  Cabecalho().tituloCabecalho(context, 'Edição do usuário',
                      iconeVoltar: true),
                  //=================== NOME DO USUÁRIO ======================
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
                        top: 10, left: 10, right: 10, bottom: 0),
                    child: Observer(
                      builder: (_) {
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
                      },
                    ),
                  ),
                  // ================ CONFIRMAR SENHA DO USUÁRIO =================
                  Container(
                    child: Text(
                      'Confirmar senha:',
                      style:
                          TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
                    ),
                    padding: EdgeInsets.only(right: size.width * 0.6, top: 30),
                  ),
                  CampoText().textField(
                    controllerConfSenha,
                    " ",
                    // raioBorda: 12,
                    confPadding: EdgeInsets.only(
                      top: 10,
                      left: 15,
                      right: 15,
                      bottom: 80,
                    ),
                    campoSenha: true,
                    icone: Icons.vpn_key,
                  ),
                  //==============================================
                  Botao().botaoPadrao(
                    'Salvar',
                    () async {
                      await _validarCampos();
                    },
                    Color(0XFFD1D6DC),
                    fontWeight: FontWeight.w400,
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
