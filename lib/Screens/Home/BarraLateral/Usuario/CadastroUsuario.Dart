import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:projeto_aberturas/Funcoes/FuncoesParaDatas.dart';
import 'package:projeto_aberturas/Models/Models_Usuario.dart';
import 'package:projeto_aberturas/Models/constantes.dart';
import 'package:projeto_aberturas/Widget/Botao.dart';
import 'package:projeto_aberturas/Widget/Crud_DataBase.dart';
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
        if (senha.isNotEmpty && senha.length > 6) {
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
      'email': controllerEmail.text,
    });

    ReqDataBase().requisicaoPost(VerficarSeEmailEstaDisponivel, validaEmail);

    if (ReqDataBase.responseReq.statusCode == 200) {
      // respostajson = jsonDecode(result.body);
      // ModelsUsuarios.tokenAuth = 'Bearer ' + (respostajson['token']);
      _cadastrarUsuario();
    } else {
      emailJaEmUso();
    }
    if (ReqDataBase.responseReq.statusCode == 401) {
      Navigator.pushNamed(context, '/Login');
    }
  }

// ============== CADASTRO DO USUÁRIO NO BANCO DE DADOS ================
  _cadastrarUsuario() async {
    var bodyy = jsonEncode(
      {
        'idempresa': FieldsEmpresa.idEmpresa,
        'nome': controllerNome.text,
        'email': controllerEmail.text.trim(),
        'senha': controllerSenha.text,
        'adm': 0, 
        'data_cadastro': DataAtual().pegardata() as String,
      },
    );

    ReqDataBase().requisicaoPost(CadastrarUsuario, bodyy);

    if (ReqDataBase.responseReq.statusCode == 200) {
      cadSucesso();
    } else {
      erroCadastro();
    }
    if (ReqDataBase.responseReq.statusCode == 401) {
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
    MediaQueryData mediaQuery = MediaQuery.of(context);
    Size size = mediaQuery.size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: size.height,
          width: size.width,
          color: Color(0xFFBCE0F0),
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
                        padding: EdgeInsets.all(5),
                        child: IconButton(
                          icon: Icon(Icons.arrow_back),
                          onPressed: () => Navigator.pop(context),
                          iconSize: 35,
                          color: Colors.white,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: size.width * 0.1),
                        child: Text(
                          'Cadastro de usuário',
                          style: TextStyle(
                            fontSize: size.width * 0.065,
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
                  height: size.height * 0.82,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        //============== CAMPO PARA INSERIR O NOME ================
                        CampoText().textField(
                          controllerNome,
                          "Nome completo:",
                          confPadding:
                              EdgeInsets.only(left: 15, right: 15, top: size.height * 0.13),
                          raioBorda: 28,
                          tipoTexto: TextInputType.text,
                          icone: Icons.person,
                        ),
                        //============== CAMPO PARA INSERIR O E-MAIL ================
                        CampoText().textField(
                          controllerEmail,
                          "E-mail:",
                          confPadding:
                              EdgeInsets.only(left: 15, right: 15, top: size.height * 0.03),
                          raioBorda: 28,
                          tipoTexto: TextInputType.emailAddress,
                          icone: Icons.email,
                        ),
                        //============== CAMPO PARA INSERIR A SENHA ================
                        CampoText().textField(
                          controllerSenha,
                          "Senha:",
                          confPadding:
                              EdgeInsets.only(left: 15, right: 15, top: size.height * 0.03),
                          raioBorda: 28,
                          campoSenha: true,
                          icone: Icons.vpn_key,
                        ),
                        //============== CAMPO PARA CONFIRMAR SENHA ================
                        CampoText().textField(
                          controllerConfSenha,
                          "Confirmar senha karin:",
                          confPadding: EdgeInsets.only(
                              left: 15, right: 15, top: size.height * 0.03, bottom: size.height * 0.12),
                          raioBorda: 28,
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
                          fontWeight: FontWeight.w400,
                        ),
                        //----------------------------------------------------------------
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
