import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:projeto_aberturas/Models/Models_Usuario.dart';
import 'package:projeto_aberturas/Models/constantes.dart';
import 'package:projeto_aberturas/Widget/Botao.dart';
import 'package:projeto_aberturas/Widget/MsgPopup.dart';
import 'package:projeto_aberturas/Widget/TextField.dart';
import 'package:projeto_aberturas/Static/Static_Empresa.dart';

class CadastroUsuario extends StatefulWidget {
  CadastroUsuario({Key key}) : super(key: key);

  @override
  _CadastroUsuarioState createState() => _CadastroUsuarioState();
}

class _CadastroUsuarioState extends State<CadastroUsuario> {
  TextEditingController controllerSenha = TextEditingController();
  TextEditingController controllerConfSenha = TextEditingController();
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerNome = TextEditingController();
  TextEditingController controllerAdm = TextEditingController();
  TextEditingController controllerIdEmpresa = TextEditingController();
  var respostajson;
  String mensagemErro = "";

// ========= VERIFICAÇÃO DOS VALORES INFORMADOS NOS CAMPOS PARA O CADASTRO ===========
  _validarCampos() {
    String nome = controllerNome.text;
    String email = controllerEmail.text;
    String senha = controllerSenha.text;
    String confSenha = controllerConfSenha.text;

    if (nome.isNotEmpty) {
      if (email.isNotEmpty && email.contains("@")) {
        if (senha.isNotEmpty && senha.length >= 6) {
          if (confSenha == senha) {
            if (controllerConfSenha.text == senha) {
              setState(
                () {
                  mensagemErro = '';
                },
              );
              _validarEmailRegistrado();
            }
          } else {
            setState(
              () {
                mensagemErro = "\n As senhas não coencidem";
                _msgErroCadastro();
              },
            );
          }
        } else {
          setState(
            () {
              mensagemErro =
                  "\n senha incorreta! a senha precisa ter mais que 6 caracteres";
              _msgErroCadastro();
            },
          );
        }
      } else {
        setState(
          () {
            mensagemErro = "\n Preencha o email corretamente";
            _msgErroCadastro();
          },
        );
      }
    } else {
      setState(
        () {
          mensagemErro = "\n O nome precisa ter mais que 3 letras";
          _msgErroCadastro();
        },
      );
    }
  }

  // =========== MENSAGEM CASO O USUARIO ESQUECER ALGUM CAMPO VAZIO =============
  _msgErroCadastro() {
    MsgPopup().msgFeedback(
      context,
      mensagemErro,
      'Aviso',
      sizeTitulo: 20,
      fontMsg: 20,
    );
  }

// ============== VERIFICAR SE O E-MAIL INFORMADO JÁ ESTÁ CADASTRADO NO BANCO DE DADOS ================
  _validarEmailRegistrado() async {
    var validaEmail = jsonEncode({
      'Email': controllerEmail.text,
    });

    var result = await http.post(
        Uri.encodeFull(
            UrlServidor.toString() + VerficarSeEmailEstaDisponivel.toString()),
        headers: {"Content-Type": "application/json"},
        body: validaEmail);

    if (result.statusCode == 200) {
      respostajson = jsonDecode(result.body);
      ModelsUsuarios.tokenAuth = 'Bearer ' + (respostajson['token']);
      _cadastrarUsuario();
    } else {
      emailJaEmUso();
    }
    if (result.statusCode == 401) {
      Navigator.pushNamed(context, '/Login');
    }
  }

// ============== CADASTRO DO USUÁRIO NO BANCO DE DADOS ================
  _cadastrarUsuario() async {
    var boddy = jsonEncode(
      {
        'IdEmpresa': Empresa.idEmpresa,
        'Nome': controllerNome.text,
        'Email': controllerEmail.text.trim(),
        'Senha': controllerSenha.text,
        'Adm': 0 //controllerAdm.text
      },
    );

    var result = await http.post(
        Uri.encodeFull(UrlServidor.toString() + CadastrarUsuario.toString()),
        headers: {"Content-Type": "application/json"},
        body: boddy);
    if (result.statusCode == 201) {
      cadSucesso();
    } else {
      erroCadastro();
    }
    if (result.statusCode == 401) {
      Navigator.pushNamed(context, '/Login');
    }
  }

// ============ MENSAGEM CASO O CADASTRO SEJA REALIZADO ==============
  cadSucesso() {
    MsgPopup().msgDirecionamento(
      context,
      'Usuário cadastrado com sucesso!',
      '',
      () => {
        Navigator.of(context).pop(), // Fecha a mensagem do popup
        Navigator.of(context).pop(), // Fecha a tela de cadastro
        Navigator.of(context).pushNamed('/Home'),
      },
      corMsg: Colors.green[600],
      txtButton: 'Confirmar',
    );
  }

// ============ MENSAGEM CASO ACONTECER ALGUM ERRO INTERNO E NÃO SER POSSÍVEL CADASTRAR ==============
  erroCadastro() {
    MsgPopup().msgDirecionamento(
      context,
      'Por causa de problemas internos, não foi possível efetuar seu cadastro.' +
          '\n\n Aguarde um momento e tente novamente.',
      '',
      () => {
        Navigator.of(context).pop(),
      },
      txtButton: 'Confirmar',
    );
  }

// =========== MENSAGEM DE AVISO CASO O E-MAIL JÁ ESTEJA SENDO UTILIZADO ==========
  emailJaEmUso() {
    MsgPopup().msgDirecionamento(
      context,
      'Ops.. Já existe uma conta de usuário cadastrado com este email!',
      '',
      () => {
        Navigator.of(context).pop(),
      },
      txtButton: 'Confirmar',
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Color(0xFFCCE9F5),
      //----------------------------------------------------------------------
      appBar: new AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue,
        title: new Text('Cadastro de usuário'),
      ),

      //----------------------------------------------------------------------
      body: new Form(
        child: new SingleChildScrollView(
          child: new Container(
            alignment: Alignment(-12, -12),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.center, //stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                //============== CAMPO PARA INSERIR O NOME ================

                CampoText().textField(
                  controllerNome,
                  "Nome completo:",
                  confPadding: EdgeInsets.only(left: 15, right: 15, top: 0),
                  raioBorda: 32,
                  tipoTexto: TextInputType.text,
                  icone: Icons.person,
                ),

                //============== CAMPO PARA INSERIR O E-MAIL ================

                CampoText().textField(
                  controllerEmail,
                  "Email:",
                  confPadding: EdgeInsets.only(left: 15, right: 15, top: 20),
                  raioBorda: 32,
                  tipoTexto: TextInputType.emailAddress,
                  icone: Icons.email,
                ),

                //============== CAMPO PARA INSERIR A SENHA ================

                CampoText().textField(
                  controllerSenha,
                  "Senha:",
                  confPadding: EdgeInsets.only(left: 15, right: 15, top: 20),
                  raioBorda: 32,
                  campoSenha: true,
                  icone: Icons.vpn_key,
                ),

                //============== CAMPO PARA CONFIRMAR SENHA ================
                CampoText().textField(
                  controllerConfSenha,
                  "Confirmar senha:",
                  confPadding:
                      EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 40),
                  raioBorda: 32,
                  campoSenha: true,
                  icone: Icons.vpn_key,
                ),

                //--------------------------------------------------------------
                Botao().botaoPadrao(
                  'Salvar',
                  () {
                    _validarCampos();
                  },
                  Color(0XFFD1D6DC),
                ),

                //----------------------------------------------------------------
              ],
            ),
          ),
        ),
      ),
    );
  }
}
