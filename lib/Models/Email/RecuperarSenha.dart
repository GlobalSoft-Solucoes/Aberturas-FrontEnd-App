import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:projeto_aberturas/Models/constantes.dart';
import 'package:projeto_aberturas/Widget/MsgPopup.dart';

class Email {
  String _username;
  var smtpServer;

  Email(String username, String password) {
    _username = username;
    smtpServer = gmail(_username, password);
  }

  //Envia um email para o destinatário, contendo a mensagem com o código
  Future<bool> sendMessage(
      String mensagem, String destinatario, String assunto) async {
    //Configurar a mensagem
    final message = Message()
      ..from = Address(_username, 'GlobalSoft_ST')
      ..recipients.add(destinatario)
      ..subject = assunto
      ..text = mensagem;

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
      return true;
    } on MailerException catch (e) {
      print('Message not sent.');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
      return false;
    }
  }
}

class RecuperarSenha {
  TextEditingController controllerInfoEmail = TextEditingController();
  TextEditingController controllerCodigoEnviadoEmail = TextEditingController();
  TextEditingController controllerNovaSenha = TextEditingController();
  TextEditingController controllerConfNovaSenha = TextEditingController();
  String msgAvisoAlterarSenha;
  String mensagemErro = "";
  BuildContext context;

  // ================== ENVIA O E-MAIL PARA RECUPERAÇÃO DE SENHA ==================
  String emailUsuario = '';
  String senhaUsuario = '';

  var email = Email('globalsoftsolucoes.tec@gmail.com', 'GlobalSoft.dev@st');
  void _sendEmail() async {
    await email.sendMessage(
      "Olá! Parece que você esqueceu sua senha. \n\n"
              "Seu código de verificação para alteração de senha é:  " +
          senhaUsuario,
      emailUsuario,
      'Aberturas - Recuperação de senha',
    );
  }

  // =========== GERAR UMA SENHA RANDOMICA PARA ENVIAR AO E-MAIL DE RECUPERAÇÃO ============
  gerarSenha() {
    var _random = Random.secure();
    var random = List<int>.generate(4, (i) => _random.nextInt(256));
    var verificador = base64Url.encode(random);
    verificador = verificador
        .replaceAll('+', '')
        .replaceAll('-', '')
        .replaceAll('/', '')
        .replaceAll('_', '')
        .replaceAll('=', '')
        .replaceAll(' ', '');

    return verificador.trim();
  }

// ======= VERIFICA SE O CÓDIGO INFORMADO É IGUAL AO CÓDIGO ENVIADO NO E-MAIL =========
  verificaCodigoEnviadoNoEmail() {
    if (senhaUsuario == controllerCodigoEnviadoEmail.text) {
      Navigator.of(context).pop();
      _codigoVerificacaoValido();
    } else {
      Navigator.of(context).pop();
      _codigoVerificacaoInvalido();
      controllerCodigoEnviadoEmail.text = '';
    }
  }

  // =========  TELA PARA O USUÁRIO INSERIR O CÓDIGO RECEBIDO NO E-MAIL PARA A RECUPERAÇÃO DE SENHA ===========
  inserirCodigoRecebino(BuildContext context) {
    this.context = context;
    MsgPopup().campoTextoComDoisBotoes(
      this.context = context,
      'Digite o código enviado no seu e-mail:',
      'Código:',
      'Cancelar',
      'Continuar',
      () => {
        Navigator.pop(context),
      },
      () => {
        verificaCodigoEnviadoNoEmail(),
      },
      controller: controllerCodigoEnviadoEmail,
      fontMsg: 22,
      fontText: 18,
      iconeText: Icons.code,
    );
  }

  // ============ POPUP DISPARADO CASO ALGUM ERRO ACONTEÇA AO TENTAR ALTERAR A SENHA ============
  popupValidaCampos() {
    MsgPopup().msgFeedback(
      context,
      "\n" + msgAvisoAlterarSenha,
      "Aviso",
      corMsg: Colors.red[800],
      txtButton: 'Ok, Entendi!',
    );
  }

  // ======== MENSAGEM DISPARADA CASO O USUÁRIO DIGITAR INCORRETAMENTE O CÓDIGO RECEBIDO =========
  msgSenhaAlterada() {
    MsgPopup().msgDirecionamento(
      context,
      "Sua senha foi alterada com sucesso!",
      "",
      () => {
        Navigator.of(context).pop(),
        Navigator.of(context).pushNamed('/Home'),
      },
      corMsg: Colors.green[900],
      txtButton: 'Legal!',
      fonteMsg: 21,
      fonteButton: 19,
      fontWeightButton: FontWeight.w600,
    );

  }

  // ======= VALIDAÇÃO DOS CAMPOS PARA A NOVA SENHA =========

  _validarCamposNovaSenha() {
    String novaSenha = controllerNovaSenha.text;
    String confSenha = controllerConfNovaSenha.text;
    if (novaSenha.length >= 6) {
      if (confSenha == novaSenha) {
        if (controllerConfNovaSenha.text == novaSenha) {
          edicaoSenhaUsuario();
        }
      } else {
        msgAvisoAlterarSenha = "As senhas não coincidem. Verifique!";
        popupValidaCampos();
      }
    } else {
      msgAvisoAlterarSenha = "A senha precisa ter mais que 6 caracteres.";
      popupValidaCampos();
    }
  }

  // ======== TELA PARA O USUÁRIO CRIAR UMA NOVA SENHA ==========
  _codigoVerificacaoValido() {
    controllerConfNovaSenha.text = '';
    controllerNovaSenha.text = '';

    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          title: Text(
            'Agora, crie uma nova senha para seu login:',
            textAlign: TextAlign.center,
            style: new TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),
          // ======= email =========
          actions: <Widget>[
            new Container(
              padding: EdgeInsets.only(
                top: 0,
              ),
              width: 450,
              child: TextField(
                controller: controllerNovaSenha,
                obscureText: true,
                style: new TextStyle(
                  fontSize: 18,
                ),
                decoration: new InputDecoration(
                  prefixIcon: new Icon(Icons.code),
                  labelText: 'Nova senha:',
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(
                      10,
                    ),
                  ),
                ),
              ),
            ),
            new Container(
              // alignment: Alignment(0, 0),
              padding: EdgeInsets.only(top: 15, bottom: 0),
              width: 450,
              child: TextField(
                controller: controllerConfNovaSenha,
                obscureText: true,
                style: new TextStyle(
                  fontSize: 18,
                ),
                decoration: new InputDecoration(
                  prefixIcon: new Icon(Icons.code),
                  labelText: 'Confirmar senha:',
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(
                      10,
                    ),
                  ),
                ),
              ),
            ),
            // ========== Botões ==========
            new Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 80),
                ),
                Container(
                  child: new FloatingActionButton.extended(
                    backgroundColor: Colors.red,
                    label: new Text(
                      'Cancelar',
                      style: TextStyle(fontSize: 20),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  padding: EdgeInsets.only(
                    top: 10,
                    left: MediaQuery.of(context).size.width * 0.054,
                  ),
                ),
                Container(
                  child: new FloatingActionButton.extended(
                    backgroundColor: Colors.green,
                    label: Text(
                      'Salvar',
                      style: new TextStyle(fontSize: 20),
                    ),
                    onPressed: () {
                      _validarCamposNovaSenha();
                    },
                  ),
                  padding: EdgeInsets.only(
                      top: 10, left: MediaQuery.of(context).size.width * 0.045),
                  width: 145,
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  // ======== MENSAGEM DISPARADA CASO O USUÁRIO DIGITAR INCORRETAMENTE O CÓDIGO RECEBIDO =========
  _codigoVerificacaoInvalido() {
    MsgPopup().msgDirecionamento(
      context,
      "\n O código informado não coincide com o código que enviamos ao seu e-mail. Verifique!",
      "Aviso",
      () => {
        Navigator.of(context).pop(),
        inserirCodigoRecebino(context),
      },
      corMsg: Colors.red,
      txtButton: 'Ok, Entendi!',
      fonteMsg: 17,
      fonteButton: 20,
      fontWeightMsg: FontWeight.w400,
      fontWeightButton: FontWeight.w600,
    );
  }

  // ================== MENSAGEM DE CONFIRMAÇÃO DO E-MAIL ENVIADO ===============
  _emailEnviado() {
    MsgPopup().msgDirecionamento(
      context,
      "\n Verifique seu e-mail, enviamos um e-mail com um código para recuperação da sua senha.",
      "Aviso",
      () => {
        Navigator.of(context).pop(),
        inserirCodigoRecebino(context),
      },
      corMsg: Colors.green,
      txtButton: 'Beleza!',
    );
  }

  // =============== CASO O E-MAIL COM SENHA NÃO SEJA ENVIADO =============
  _emailNaoEnviado() {
    MsgPopup().msgFeedback(
        context,
        "\n Não foi possível enviar o \n e-mail para recuperação da senha.\n\n"
            "Verifique o e-mail informado e tente novamente.",
        "Aviso",
        corMsg: Colors.red);
  }

  // ===========  VALIDAÇÃO PARA VER SE O E-MAIL JÁ ESTÁ CADASTRADO =============
  _verificaSeEmailInseridoExiste() async {
    var email = jsonEncode({'email': controllerInfoEmail.text});

    var result = await http.post(
      Uri.encodeFull(
          // 'http://globalsoft-st-com-br.umbler.net/usuario/ValidarEmail/'),
          VerficarSeEmailEstaDisponivel.toString()),
      headers: {"Content-Type": "application/json"},
      body: email,
    );
    print(result.statusCode);

    if (result.statusCode == 200) {
      // Se o e-mail digitado não existir no banco
      _emailNaoEnviado();
    } else if (result.statusCode == 400) {
      // se o email digitado Existir no banco de dados
      emailUsuario = controllerInfoEmail.text.trim();
      senhaUsuario = gerarSenha() as String;
      Navigator.of(context).pop(); // Apaga o popup anterior
      _emailEnviado(); // Mensagem de confirmção do e-mail enviado
      _sendEmail(); // Função que faz o envio do e-mail
    } else {
      var mensagem = "Ocorreu um erro no servidor!";
      var titulo = "Erro!";
      emailNaoEnviado(mensagem, titulo);
    }
  }

  // =============== CASO O E-MAIL COM SENHA NÃO SEJA ENVIADO =============
  emailNaoEnviado(mensagem, titulo) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => new CupertinoAlertDialog(
        title: new Text(titulo),
        content: new Text(
          mensagem,
          style: TextStyle(
              fontSize: 18, color: Colors.red, fontWeight: FontWeight.w800),
        ),
        actions: <Widget>[
          FloatingActionButton(
            child: Text('Ok',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }

  // =========  TELA PARA O USUÁRIO INSERIR O E-MAIL PARA SER ENVIADA A SENHA DE RECUPERAÇÃO =============

  inserirEmailEnvio(BuildContext context) {
    controllerInfoEmail.text = '';
    this.context = context;
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          title: Text(
            'Digite seu e-mail cadastrado',
            textAlign: TextAlign.center,
            style: new TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),
          // ======= email =========
          actions: <Widget>[
            new Container(
              alignment: Alignment(0, 0),
              width: 450,
              child: TextField(
                controller: controllerInfoEmail,
                style: new TextStyle(
                  fontSize: 18,
                ),
                decoration: new InputDecoration(
                  prefixIcon: new Icon(Icons.email),
                  labelText: 'E-mail:',
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(
                      10,
                    ),
                  ),
                ),
              ),
            ),
            // ===== Botões ======
            new Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 100),
                ),
                Container(
                  child: new FloatingActionButton.extended(
                    backgroundColor: Colors.red,
                    label: new Text(
                      'Cancelar',
                      style: TextStyle(fontSize: 20),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  padding: EdgeInsets.only(
                      top: 20,
                      left: MediaQuery.of(context).size.width * 0.05,
                      bottom: 0),
                  width: MediaQuery.of(context).size.width * 0.35,
                ),
                Container(
                  child: new FloatingActionButton.extended(
                    backgroundColor: Colors.green,
                    label: Text(
                      'Continuar',
                      style: new TextStyle(fontSize: 20),
                    ),
                    onPressed: () {
                      _verificaSeEmailInseridoExiste();
                    },
                  ),
                  padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.05,
                    top: 20,
                  ),
                  width: MediaQuery.of(context).size.width * 0.36,
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  // ============= JSON PARA EDIÇÃO DA SENHA NO BANCO DE DADOS ================
  edicaoSenhaUsuario() async {
    String email = controllerInfoEmail.text.toLowerCase();
    var boddy = jsonEncode(
      {
        'senha': controllerNovaSenha.text,
      },
    );

    var result = await http.put(
        Uri.encodeFull(
            RecuperarSenhaUsuario.toString() +
            email.toString()),
        headers: {"Content-Type": "application/json"},
        body: boddy);
    if (result.statusCode == 201) {
      Navigator.of(context).pop();
      msgSenhaAlterada();
    }
  }
}
