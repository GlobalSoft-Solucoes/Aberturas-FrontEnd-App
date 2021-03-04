import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:projeto_aberturas/Models/Models_Usuario.dart';
import 'package:projeto_aberturas/Models/constantes.dart';
import 'package:projeto_aberturas/Static/Static_Empresa.dart';
import 'package:projeto_aberturas/Widget/Botao.dart';
import 'package:projeto_aberturas/Widget/TextField.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:projeto_aberturas/Stores/Login_Store.dart';
import 'package:projeto_aberturas/Widget/MsgPopup.dart';
import 'package:projeto_aberturas/Static/Static_Usuario.dart';
import 'package:projeto_aberturas/Screens/Home/Home.Dart';

class Login extends StatefulWidget {
  Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerSenha = TextEditingController();
  String mensagemErro = "";
  LoginStore loginStore = LoginStore();
  List<ModelsUsuarios> dadosUsuarios = [];
  var respostajson;

// ========== VERIFICA SE O E-MAIL E SENHA INFORMADOS EXISTEM NO BANCO DE DADOS =============
  var dados;
  List<ModelsUsuarios> dadosUsuario = [];
  validarDadosLogin(String email, senha) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var boddy = jsonEncode(
      {
        'email': email,
        'senha': senha,
      },
    );

// ReqDataBase().requisicaoPost(LoginUsuario.toString(), boddy);

    http.Response response = await http.post(
      Uri.encodeFull(LoginUsuario.toString()),
      headers: {"Content-Type": "application/json"},
      body: boddy,
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> respostajson = jsonDecode(response.body);
      ModelsUsuarios.tokenAuth = 'Bearer ' + (respostajson['token']);
      var result = respostajson['result'];
      print(result);
      if (mounted) {
        setState(() {
          //faz outro map, no result para poder capturar os dados do usuario
          Iterable lista = result;
          dadosUsuario =
              lista.map((model) => ModelsUsuarios.fromJson(model)).toList();
        });

        //passa o id do usuario para o usuario
        UserLogado.idUsuario = dadosUsuario[0].idUsuario;
        UserLogado.idEmpresa = dadosUsuario[0].idEmpresa;

        await DadosEmpresa().capturaDadosEmpresa();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Home(),
          ),
        );
      } else {
        _erroLogin();
      }
    } else {
      _erroLogin();
    }

    prefs.setInt('idusuario', UserLogado.idUsuario);
    prefs.setString('Token', ModelsUsuarios.tokenAuth);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Home()));
  }

// VALIDA OS CAMPOS INFORMADOS PARA REALIZAR O LOGIN
  _validarCampos() {
    String email = controllerEmail.text.trim();
    String senha = controllerSenha.text.trim();

    if (email.isNotEmpty && email.contains("@")) {
      if (senha.isNotEmpty) {
        if (senha.isNotEmpty) {
          setState(
            () {
              mensagemErro = "";
              validarDadosLogin(email, senha);
            },
          );
        }
      } else {
        setState(
          () {
            mensagemErro = "senha incorreta!";
          },
        );
      }
    } else {
      setState(
        () {
          mensagemErro = "Preencha o email corretamente";
        },
      );
    }
  }

  _erroLogin() {
    MsgPopup().msgFeedback(
      context,
      'Usuário ou senha estão incorretos. Verifique!',
      '',
      corMsg: Colors.red,
    );
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    Size size = mediaQuery.size;
    return new Scaffold(
      backgroundColor: Colors.grey[600],
      body: SingleChildScrollView(
        child: Container(
          width: size.width * 1,
          height: size.height * 1,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/login04.png"),
              fit: BoxFit.fitWidth,
            ),
          ),
          child: Column(
            children: <Widget>[
              Container(
                alignment: Alignment.bottomLeft,
                padding: EdgeInsets.only(top: size.height * 0.03, left: 10),
                child: Container(
                  color: Colors.black38,
                  width: size.width * 0.13,
                  height: size.height * 0.06,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                    iconSize: 35,
                    color: Colors.white,
                  ),
                ),
              ),
              new SingleChildScrollView(
                child: new Container(
                  alignment: Alignment.topCenter,
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      //----------------------Usuário--------------------//
                      CampoText().textField(
                        controllerEmail,
                        "E-mail:",
                        raioBorda: 20,
                        confPadding: EdgeInsets.only(
                          left: 15,
                          right: 15,
                          top: size.height * 0.28,
                        ),
                        icone: Icons.email,
                        fontWeigth: FontWeight.w700,
                        fontLabel: 22,
                        backgroundColor: Colors.white.withOpacity(0.5),
                        tipoTexto: TextInputType.emailAddress,
                      ),
                      //---------------------senha---------------------//
                      CampoText().textField(
                        controllerSenha,
                        "Senha:",
                        raioBorda: 20,
                        confPadding:
                            EdgeInsets.only(left: 15, right: 15, top: 25),
                        icone: Icons.vpn_key,
                        fontWeigth: FontWeight.w700,
                        campoSenha: true,
                        fontLabel: 22,
                        backgroundColor: Colors.white.withOpacity(0.5),
                      ),
                      // --------------------Botão Conectar----------------------//
                      new Container(
                        padding: new EdgeInsets.only(
                          top: size.height * 0.12,
                        ),
                        child: Botao().botaoPadrao(
                          'Conectar',
                          () => _validarCampos(),
                          Colors.blue.withOpacity(0.7),
                          corFonte: Colors.white,
                          tamanhoLetra: size.width * 0.06,
                          comprimento: 270,
                          altura: 55,
                        ),
                      ),
                    ],
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
