import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:http/http.dart' as http;
import 'package:projeto_aberturas/Models/constantes.dart';
import 'package:projeto_aberturas/Models/Email/RecuperarSenha.dart';
import 'package:projeto_aberturas/Static/Static_Empresa.dart';
import 'package:projeto_aberturas/Static/Static_GrupoMedidas.dart';
import 'package:projeto_aberturas/Stores/Login_Store.dart';
import 'package:projeto_aberturas/Widget/MsgPopup.dart';
import 'package:projeto_aberturas/Static/Static_Usuario.dart';
import 'package:projeto_aberturas/Screens/Home/BarraLateral/ListaDadosUsuario.dart';

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

// ========== VERIFICA SE O E-MAIL E SENHA INFORMADOS EXISTEM NO BANCO DE DADOS =============

  validarDadosLogin(String email, senha) async {
    var boddy = jsonEncode(
      {
        'Email': email,
        'Senha': senha,
      },
    );

    http.Response state = await http.post(
      Uri.encodeFull(UrlServidor.toString() + LoginUsuario.toString()),
      headers: {"Content-Type": "application/json"},
      body: boddy,
    );

    setState(
      () {
        if (state.statusCode == 200) {
          _capturaIdUsuarioLogado();
          Navigator.of(context)
              .pop(); // FECHA A TELA DE LOGIN E NÃO PERMITE QUE VOLTE PARA ELA
          Navigator.of(context).pushNamed('/Home');

          // atualiza os dados da empresa
          setState(
            () {
              DadosEmpresa().capturaDadosEmpresa();
            },
          );
        } else
          _erroLogin();
      },
    );
  }

  // =========== CAPTURA O ID DO USUARIO ATRAVÉS DO E-MAIL DELE ===============
  _capturaIdUsuarioLogado() async {
    // recebe o valor do
    var emailUsuario = controllerEmail.text.trim();

    var result = await http.get(
      Uri.encodeFull(
          UrlServidor.toString() + BuscaIdUsuarioLogado + emailUsuario),
      headers: {"Content-Type": "application/json"},
    );

    // Captura o valor vindo do body da requisição
    String retorno = result.body;
    // caso o retorno do Body for diferente de vazio("[]"), continua a execução
    if (retorno != "[]") {
      // Repara para mostra apenas o valor da chave primária
      String valorRetorno = retorno
          .substring(retorno.indexOf(':'), retorno.indexOf('}'))
          .replaceAll(':', '');

      // caso haja valor na variável, quer dizer que contém um registro
      if (valorRetorno.length > 0) {
        Usuario.idUsuario = int.parse(valorRetorno);
        // carrega os dados do usuário logado
        await DadosUserLogado().capturaDadosUsuarioLogado();
        // carrega os dados da empresa do usuário
        await DadosEmpresa().capturaDadosEmpresa();
      }
    }
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

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    Size size = mediaQuery.size;
    return new Scaffold(
      backgroundColor: Color(0xFFCCE9F5),
      body: new Form(
        child: new Stack(
          children: <Widget>[
            //Panel campos de entrada..
            new Positioned(
              child: new SingleChildScrollView(
                child: new Container(
                  height: size.height * 0.800,
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      // ----------------------- SETA PARA VOLTAR ---------------------

                      new Container(
                        child: FlatButton.icon(
                          onPressed: () =>
                              Navigator.pushNamed(context, '/EntradaApp'),
                          icon: Icon(Icons.arrow_back),
                          label: Text('voltar'),
                          padding: new EdgeInsets.all(15.0),
                        ),
                        // alignment: Alignment.topLeft,
                        alignment: Alignment(
                          -1,
                          -16,
                        ),
                      ),
                      //----------------------Imagem de login--------------------//

                      new Padding(
                        padding: new EdgeInsets.only(
                          left: 10,
                          right: 10,
                        ),
                        child: new Image.asset(
                          'Assets/iconUser.png',
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                      new Padding(
                        padding: EdgeInsets.only(
                          top: 10,
                          bottom: 5,
                        ),
                        child: Center(
                          child: Text(
                            mensagemErro,
                            style: TextStyle(color: Colors.red, fontSize: 20),
                          ),
                        ),
                      ),

                      //----------------------Usuário--------------------//

                      new Padding(
                        padding: new EdgeInsets.only(
                          left: 15,
                          right: 15,
                        ),
                        child: Observer(
                          builder: (_) {
                            return new TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              controller: controllerEmail,
                              style: new TextStyle(
                                fontSize: 18,
                              ),
                              decoration: new InputDecoration(
                                  prefixIcon: new Icon(Icons.email),
                                  labelText: 'Email:',
                                  border: new OutlineInputBorder(
                                    borderRadius: new BorderRadius.circular(
                                      90,
                                    ),
                                  ),
                                  helperText: "seuemail@seuprovedor.com.br"),
                            );
                          },
                        ),
                      ),

                      //---------------------Senha---------------------//

                      new Padding(
                        padding: new EdgeInsets.only(
                          top: 15,
                          left: 15,
                          right: 15,
                        ),
                        child: Observer(builder: (_) {
                          return new TextFormField(
                            controller: controllerSenha,
                            style: new TextStyle(
                              fontSize: 18,
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
                              labelText: 'Senha:',
                              border: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(
                                  32,
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                      new Padding(
                        padding: new EdgeInsets.only(
                          top: 10,
                          right: 0,
                        ),
                        child: GestureDetector(
                          onTap: () => RecuperarSenha().inserirEmailEnvio(
                              context), //inserirCodigoRecebino(context),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Esqueci minha senha',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),

                      //--------------------Botão Conectar----------------------//

                      new Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new Padding(
                            padding: new EdgeInsets.only(
                              top: 30,
                              left: 30,
                              right: 30,
                            ),
                            child: new FloatingActionButton.extended(
                              heroTag: "btn1",
                              backgroundColor: Color(0XFFD1D6DC),
                              onPressed: () {
                                _validarCampos();
                              },
                              // Navigator.pushNamed(context, '/Home'),
                              label: new Text(
                                'Entrar',
                                style: new TextStyle(
                                  fontSize: 24,
                                ),
                              ),
                            ),
                          ),

                          // ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
