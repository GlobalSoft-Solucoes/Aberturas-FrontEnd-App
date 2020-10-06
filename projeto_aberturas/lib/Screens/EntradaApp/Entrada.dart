import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:projeto_aberturas/Models/constantes.dart';
import 'package:projeto_aberturas/Screens/EntradaApp/CarouselEntrada.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:projeto_aberturas/Widget/MsgPopup.dart';
import 'package:projeto_aberturas/Static/Static_Empresa.dart';

//========================= BOTÕES ============================

class EntradaApp extends StatefulWidget {
  EntradaApp({Key key}) : super(key: key);

  @override
  _EntradaAppState createState() => _EntradaAppState();
}

class _EntradaAppState extends State<EntradaApp> {
  TextEditingController controllerCodEmpresa = TextEditingController();

  String mensagemErro = "";

  validaCodEmp() {
    String codAcessoEmp = controllerCodEmpresa.text;
    if (codAcessoEmp.isEmpty) {
      mensagemErro = '\n O codigo não pode ficar vazio!';
      _msgCodigoIncorreto();
    } else {
      _verificaCodigoEmpresa();
    }
  }

  void initState() {
    super.initState();
  }

// ============== VERIFICAR SE O CÓDIGO DA EMPRESA EXISTE NO BANCO DE DADOS ================
  _verificaCodigoEmpresa() async {
    // recebe o valor do
    var codAcessoEmp = controllerCodEmpresa.text;

    var result = await http.post(
      Uri.encodeFull(
          UrlServidor.toString() + BuscarCodigoAcessoEmp + codAcessoEmp),
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
        print(valorRetorno);
        Empresa.idEmpresa = int.parse(valorRetorno);
        // se houver resultado, permite que o cadastro seja feito
        controllerCodEmpresa.text = "";
        Navigator.of(context).pop(); // Apaga o popup anterior
        Navigator.of(context).pushNamed('/CadastroUsuario');
      }
    } else {
      mensagemErro = '\n Ops.. o código da empresa informado está incorreto!';
      _msgCodigoIncorreto();
    }
  }

// =========== MENSAGEM DISPARADA CASO O CÓDIGO INFORMADO ESTEJA ERRADO ==============
  _msgCodigoIncorreto() {
    Navigator.of(context).pop();
    MsgPopup().msgDirecionamento(
      context,
      mensagemErro,
      'Aviso',
      () => {Navigator.of(context).pop(), codEmp()},
    );
  }

// =========== DISPARA UM POPUP PARA INFORMAR O CÓDIGO DA EMPRESA PARA O USUÁRIO PODER SER CADASTRADO =====
  codEmp() {
    MsgPopup().campoTextoComDoisBotoes(
      context,
      'Digite o codigo da empresa:',
      'Código:',
      'Cancelar',
      'Continuar',
      () => {
        controllerCodEmpresa.text = "",
        Navigator.pop(context),
      },
      () => {
        validaCodEmp(),
      },
      controller: controllerCodEmpresa,
      fontMsg: 20,
      bordaPopup: 20,
    );
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    Size size = mediaQuery.size;
    return Scaffold(
      backgroundColor: Color(0xFFCCE9F5),
      body: Container(
        height: size.height,
        width: size.width,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // ========================== RETANGULO ==========================
              Padding(
                padding: EdgeInsets.only(
                  top: 70,
                  left: 20,
                  right: 20,
                ),
                child: Column(
                  children: <Widget>[
                    CarouselSlider(
                      options: CarouselOptions(
                        autoPlay: true,
                        aspectRatio: 2.0,
                        enlargeCenterPage: true,
                      ),
                      items: imageSliders,
                    ),
                  ],
                ),
              ),

              // ======================= BOTÕES ========================

              Padding(
                padding: EdgeInsets.only(
                  top: 150,
                  left: 20,
                  right: 20,
                ),
                child: FloatingActionButton.extended(
                  heroTag: 'btn2',
                  backgroundColor: Color(0XFFD1D6DC),
                  onPressed: () => Navigator.pushNamed(context, '/Login'),
                  label: Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 28,
                    ),
                  ),
                ),
              ),
              //-------------------------------------------------------
              Padding(
                padding: EdgeInsets.only(
                  top: 30,
                  left: 20,
                  right: 20,
                ),
                child: FloatingActionButton.extended(
                  heroTag: 'btn3',
                  backgroundColor: Color(0XFFD1D6DC),
                  onPressed: () {
                    codEmp();
                  },
                  label: Text(
                    'Cadastre-se',
                    style: TextStyle(
                      fontSize: 28,
                    ),
                  ),
                ),
              ),
              //-------------------------------------------------------
              Padding(
                padding: EdgeInsets.only(
                  top: 30,
                  left: 20,
                  right: 20,
                ),
                child: FloatingActionButton.extended(
                  heroTag: 'btn4',
                  backgroundColor: Color(0XFFF4485C),
                  onPressed: () => exit(0),
                  label: Text(
                    'Sair',
                    style: TextStyle(
                      fontSize: 28,
                    ),
                  ),
                ),
              ),
              //----------------------------------------------------
            ],
          ),
        ),
      ),
    );
  }
}
