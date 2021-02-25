import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:http/http.dart' as http;
import 'package:projeto_aberturas/Models/Models_Usuario.dart';
import 'package:projeto_aberturas/Models/constantes.dart';
import 'package:projeto_aberturas/Models/email/RecuperarSenha.dart';
import 'package:projeto_aberturas/Static/Static_Empresa.dart';
import 'package:projeto_aberturas/Widget/Crud_DataBase.dart';
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
  var dadosUsuarios = new List<ModelsUsuarios>();
  var respostajson;

// ========== VERIFICA SE O E-MAIL E SENHA INFORMADOS EXISTEM NO BANCO DE DADOS =============
  var dados;
  var dadosUsuario = new List<ModelsUsuarios>();
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
        usuario.idUsuario = dadosUsuario[0].idUsuario;
        usuario.idEmpresa = dadosUsuario[0].idEmpresa;

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
    }else {
        _erroLogin();
      }

    prefs.setInt('idusuario', usuario.idUsuario);
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
                      Container(
                        alignment: Alignment.topLeft,
                        padding: EdgeInsets.only(
                          left: size.width * 0.025,
                          bottom: size.height * 0.13,
                        ),
                        child: Container(
                          color: Color(0xFFCCE9F5), //Colors.lightBlue[500],
                          width: size.width * 0.12,
                          child: Row(
                            children: [
                              IconButton(
                                iconSize: 35,
                                color: Colors.black,
                                icon: Icon(Icons.arrow_back),
                                onPressed: () =>
                                    Navigator.pushNamed(context, '/EntradaApp'),
                              ),
                              // Text(
                              //   ' Voltar',
                              //   style: TextStyle(
                              //     fontSize: 23,
                              //     color: Colors.black,
                              //     fontWeight: FontWeight.w400,
                              //     decoration: TextDecoration.none,
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ),
                      new Column(
                        children: [
                          // Padding(padding: EdgeInsets.only(top: 240)),
                          //   width: 150,
                          //   height: 50,
                          //   child: FlatButton.icon(
                          //     onPressed: () =>
                          //         Navigator.pushNamed(context, '/EntradaApp'),
                          //     icon: Icon(Icons.arrow_back),
                          //     label: Text('voltar'),
                          //     padding: new EdgeInsets.only(bottom: 15, right: 150),
                          //   ),
                          // ),
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
                                style:
                                    TextStyle(color: Colors.red, fontSize: 20),
                              ),
                            ),
                          ),

                          //----------------------E-mail Usuário--------------------//

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
                                      labelText: 'E-mail:',
                                      border: new OutlineInputBorder(
                                        borderRadius: new BorderRadius.circular(
                                          90,
                                        ),
                                      ),
                                      helperText:
                                          "seuemail@seuprovedor.com.br"),
                                );
                              },
                            ),
                          ),

                          //---------------------senha---------------------//

                          new Padding(
                            padding: new EdgeInsets.only(
                              top: size.height * 0.03,
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
                          // new Padding(
                          //   padding: new EdgeInsets.only(
                          //     top: 10,
                          //     right: 0,
                          //   ),
                          //   child: GestureDetector(
                          //     onTap: () => RecuperarSenha().inserirEmailEnvio(
                          //         context), //inserirCodigoRecebino(context),
                          //     child: Padding(
                          //       padding: const EdgeInsets.all(8.0),
                          //       child: Text(
                          //         'Esqueci minha senha',
                          //         style: TextStyle(
                          //           fontSize: 15,
                          //           color: Colors.black,
                          //         ),
                          //       ),
                          //     ),
                          //   ),
                          // ),

                          //--------------------Botão Conectar----------------------//

                          new Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              new Padding(
                                padding: new EdgeInsets.only(
                                  top: size.height * 0.07,
                                  left: 30,
                                  right: 30,
                                  bottom: 50,
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
                                      fontSize: 25,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
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
