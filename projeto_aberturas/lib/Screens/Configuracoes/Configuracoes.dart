import 'package:flutter/material.dart';
import 'package:projeto_aberturas/Static/Static_Empresa.dart';
import 'package:projeto_aberturas/Widget/Botao.dart';
import 'package:projeto_aberturas/Static/Static_Usuario.dart';
import 'package:projeto_aberturas/Widget/MsgPopup.dart';

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

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    Size size = mediaQuery.size;
    return Scaffold(
      backgroundColor: Color(0xFFCCE9F5),
      appBar: AppBar(
        title: Text('Configurações'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Container(
        width: size.width,
        height: size.height,
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Botao().botaoPadrao(
              'Ver código de acesso',
              () async => {
                Usuario.adm == '1'
                    ? {
                        setState(() {
                          DadosEmpresa().capturaDadosEmpresa();
                        }),
                        Navigator.of(context).pushNamed('/CodigoAcesso')
                      }
                    : _mensagemErroAcesso()
              },
              Color(0XFFD1D6DC),
            ),
            Botao().botaoPadrao(
              'Usuarios do Sistema',
              () {
                Usuario.adm == '1'
                    ? Navigator.of(context).pushNamed('/usuariosLogados')
                    : _mensagemErroAcesso();
              },
              Color(0XFFD1D6DC),
            ),
          ],
        )),
      ),
    );
  }
}
