import 'package:flutter/material.dart';
import 'package:projeto_aberturas/Static/Static_Empresa.dart';
import 'package:projeto_aberturas/Widget/Botao.dart';
import 'package:projeto_aberturas/Static/Static_Usuario.dart';
import 'package:projeto_aberturas/Widget/MsgPopup.dart';
import 'package:projeto_aberturas/Widget/TextField.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Configuracoes extends StatefulWidget {
  @override
  _ConfiguracoesState createState() => _ConfiguracoesState();
}

class _ConfiguracoesState extends State<Configuracoes> {
  TextEditingController codAdmin = TextEditingController();

  var mensagemErro = '';

  _mensagemErroAcesso() {
    MsgPopup().msgFeedback(
      context,
      '\n Somente administradores podem acessar!',
      'aviso',
    );
  }

  deslogarUser() async {
    SharedPreferences user = await SharedPreferences.getInstance();
    user.remove('Token');
    user.remove('idusuario');
    Navigator.pushNamed(context, '/Login');
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
          color: Color(0xFFCCE9F5),
          child: Column(
            children: [
              //===========================================
              Padding(
                padding: EdgeInsets.only(
                  top: size.height * 0.04,
                  left: size.width * 0.28,
                ),
                child: Container(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Configurações',
                    style: TextStyle(
                        fontSize: size.width * 0.07,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.none),
                  ),
                ),
              ),
              //============== WIDGET DO CADASTRO =================
            Padding(
                  padding: EdgeInsets.only(
                    top: size.height * 0.3,
                    left: size.width * 0.02,
                    right: size.width * 0.02,
                    bottom: size.height * 0.02,
                  ),
                  child: Container(
                    alignment: Alignment.topCenter,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      // color: Colors.white,
                    ),
                    width: size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Botao().botaoPadrao(
                          'Ver código de acesso',
                          () async => {
                            usuario.adm == '1'
                                ? {
                                    setState(() {
                                      DadosEmpresa().capturaDadosEmpresa();
                                    }),
                                    Navigator.of(context)
                                        .pushNamed('/CodigoAcesso')
                                  }
                                : _mensagemErroAcesso()
                          },
                          Color(0XFFD1D6DC),
                          tamanhoLetra: size.width * 0.06,
                          fontWeight: FontWeight.w400
                        ),
                        Botao().botaoPadrao(
                          'Usuarios do Sistema',
                          () {
                            // se usuário for igual a "1" ele é um administrador e pode acessar
                            usuario.adm == '1'
                                ? Navigator.of(context)
                                    .pushNamed('/usuariosLogados')
                                : _mensagemErroAcesso();
                          },
                          Color(0XFFD1D6DC),
                          tamanhoLetra: size.width * 0.06,
                          fontWeight: FontWeight.w400
                        ),
                        Botao().botaoPadrao(
                          'Deslogar',
                          () => {deslogarUser()},
                          Color(0XFFD1D6DC),
                          tamanhoLetra: size.width * 0.06,
                          fontWeight: FontWeight.w400
                        )
                      ],
                    ),
                  ),
                ),
              
              //----------------------------------------
            ],
          ),
        ),
      ),
    );
  }
}
