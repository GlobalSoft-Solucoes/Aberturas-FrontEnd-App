import 'package:flutter/material.dart';
import 'package:projeto_aberturas/Static/Static_Empresa.dart';
import 'package:http/http.dart' as http;

class CodigoAcesso extends StatefulWidget {
  @override
  _CodigoAcessoState createState() => _CodigoAcessoState();
}

class _CodigoAcessoState extends State<CodigoAcesso> {
  var mensagemErro = '';
  TextEditingController controllerCampoImovel =
      TextEditingController(text: Empresa.cod_Acesso);

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    Size size = mediaQuery.size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: size.width,
          height: size.height,
          color: Color(0XFF0099FF),
          child: Column(
            children: [
              //===========================================
              Padding(
                padding: EdgeInsets.only(
                  top: size.height * 0.05,
                  left: size.width * 0.04,
                ),
                child: Container(
                  alignment: Alignment.topLeft,
                  child: Row(
                    children: [
                      IconButton(
                          color: Colors.white,
                          icon: Icon(Icons.arrow_back),
                          iconSize: 30,
                          onPressed: () {
                            Navigator.pop(context);
                          }),
                      Padding(
                        padding: EdgeInsets.only(left: size.width * 0.17),
                        child: Text(
                          'Código de acesso',
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              //============== WIDGET DO CADASTRO =================
              Container(
                // Configurações do widget do cadastro
                height: size.height * 0.50,
                child: Padding(
                  padding: EdgeInsets.only(
                    top: size.width * 0.1,
                    left: size.width * 0.02,
                    right: size.width * 0.02,
                    bottom: size.height * 0.01,
                  ),
                  child: Container(
                    alignment: Alignment.topCenter,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    width: size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        //=======================================
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 30,
                            left: 8,
                            right: 8,
                            bottom: 8,
                          ),
                          child: new Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10)),
                            child: Text(
                              'Código da empresa para cadastrar novos usuários',
                              style: TextStyle(fontSize: 20),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        //=======================================
                        Padding(
                          padding: EdgeInsets.only(
                            right: size.width * 0.02,
                            left: size.width * 0.02,
                            top: size.height * 0.08,
                          ),
                          child: new Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10)),
                            child: Text(
                              'Código:  ' + Empresa.cod_Acesso.toString(),
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        //-------------------------------------
                      ],
                    ),
                  ),
                ),
              ),
              //-----------------------------------------
            ],
          ),
        ),
      ),
    );
  }
}
