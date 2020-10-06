import 'package:flutter/material.dart';
import 'package:projeto_aberturas/Widget/Botao.dart';

class Configuracoes extends StatefulWidget {
  @override
  _ConfiguracoesState createState() => _ConfiguracoesState();
}

class _ConfiguracoesState extends State<Configuracoes> {
  TextEditingController codAdmin = TextEditingController();
  //tive que criar duas funções  iguais com nomes diferentes pois não consegui ajustar uma para enviar para rotas diferentes
  codAdmn() {
    // return showDialog(
    //     context: context,
    //     builder: (context) {
    //       return AlertDialog(
    //           title: Text('digite seu codigo de administrador'),
    //           actions: [
    //             Container(
    //               child: Center(
    //                   child: Column(
    //                       mainAxisAlignment: MainAxisAlignment.center,
    //                       crossAxisAlignment: CrossAxisAlignment.center,
    //                       children: [
    //                     Container(
    //                       width: 300,
    //                       child: TextField(
    //                         controller: codAdmin,
    //                         style: new TextStyle(
    //                           fontSize: 18,
    //                         ),
    //                         decoration: new InputDecoration(
    //                           prefixIcon: new Icon(Icons.code),
    //                           labelText: 'Codigo de administrador',
    //                           border: new OutlineInputBorder(
    //                             borderRadius: new BorderRadius.circular(
    //                               10,
    //                             ),
    //                           ),
    //                         ),
    //                       ),
    //                     ),
    //                     FlatButton(
    //                         onPressed: () {
    //                           verifCodAdmin();
    //                         },
    //                         child: Text(
    //                           'ok',
    //                           style: TextStyle(fontSize: 20),
    //                         )),
    //                     Text(
    //                       mensagemErro,
    //                       style: TextStyle(fontSize: 18, color: Colors.red),
    //                     )
    //                   ])),
    //             ),
    //           ]);
    //     },);
  }

  codAdmn2() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('digite seu codigo de administrador'),
          actions: [
            Container(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 300,
                      child: TextField(
                        controller: codAdmin,
                        style: new TextStyle(
                          fontSize: 18,
                        ),
                        decoration: new InputDecoration(
                          prefixIcon: new Icon(Icons.code),
                          labelText: 'Codigo de administrador',
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(
                              10,
                            ),
                          ),
                        ),
                      ),
                    ),
                    FlatButton(
                        onPressed: () {
                          verifCodAdmin2();
                        },
                        child: Text(
                          'ok',
                          style: TextStyle(fontSize: 20),
                        )),
                    Text(
                      mensagemErro,
                      style: TextStyle(fontSize: 18, color: Colors.red),
                    )
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  var codigoadminteste = '555';
  var mensagemErro = '';
  verifCodAdmin() {
    var admcode = codAdmin.text;
    if (admcode.isNotEmpty) {
      if (admcode == codigoadminteste) {
        Navigator.of(context).pushNamed('/usuariosLogados');
      } else {
        setState(() {
          mensagemErro = 'Codigo de administrador incorreto';
        });
        codAdmn();
      }
    } else {
      setState(() {
        mensagemErro = 'digite o codigo do admin';
      });
      codAdmn();
    }
  }

  gerarCode() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
                'Senha de acesso da empresa para que usuarios possam se cadastrar no aplicativo'),
            actions: [
              Container(
                  child: Center(
                      child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Codigo de acesso gerado:$codAcesso',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  FlatButton(
                      onPressed: () => Navigator.of(context).pushNamed('/Home'),
                      child: Text(
                        'ok',
                        style: TextStyle(fontSize: 20),
                      ))
                ],
              )))
            ],
          );
        });
  }

  var codAcesso = "KJSABFIUYSA";
  verifCodAdmin2() {
    var admcode = codAdmin.text;
    if (admcode.isNotEmpty) {
      if (admcode == codigoadminteste) {
        gerarCode();
      } else {
        setState(() {
          mensagemErro = 'Codigo de administrador incorreto';
        });
        codAdmn();
      }
    } else {
      setState(() {
        mensagemErro = 'digite o codigo do admin';
      });
      codAdmn();
    }
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
              'Mostrar Codigo',
              () {
                codAdmn2();
              },
              Color(0XFFD1D6DC),
            ),
            Botao().botaoPadrao(
              'Usuarios do Sistema',
              () {
                // codAdmn();
                Navigator.of(context).pushNamed('/usuariosLogados');
              },
              Color(0XFFD1D6DC),
            ),
          ],
        )),
      ),
    );
  }
}
