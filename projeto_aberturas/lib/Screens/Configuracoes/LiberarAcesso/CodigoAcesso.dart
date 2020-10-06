import 'package:flutter/material.dart';

class CodigoAcesso extends StatefulWidget {
  @override
  _CodigoAcessoState createState() => _CodigoAcessoState();
}

class _CodigoAcessoState extends State<CodigoAcesso> {
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
                      onPressed: () => Navigator.pop(context),
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

  codAdmn() {
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
                            style: new TextStyle(
                              fontSize: 18,
                            ),
                            decoration: new InputDecoration(
                              prefixIcon: new Icon(Icons.code),
                              labelText: 'Codigo:',
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
                              gerarCode();
                            },
                            child: Text(
                              'ok',
                              style: TextStyle(fontSize: 20),
                            )),
                      ])),
                ),
              ]);
        });
  }

  var codAcesso = "KJSABFIUYSA";
  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: new Container(
                  alignment: Alignment.center,
                  height: 40,
                  width: 300,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.black,
                      width: 2,
                    ),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      codAdmn();
                    },
                    child: Text(
                      'Gerar Codigo de acesso',
                      style: TextStyle(
                          fontSize: 27,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
