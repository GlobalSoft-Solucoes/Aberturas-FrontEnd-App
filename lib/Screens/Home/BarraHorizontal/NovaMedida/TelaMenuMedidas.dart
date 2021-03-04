import 'package:flutter/material.dart';

import 'package:projeto_aberturas/Widget/Botao.dart';

class MenuMedidas extends StatefulWidget {
  @override
  _MenuMedidasState createState() => _MenuMedidasState();
}

class _MenuMedidasState extends State<MenuMedidas> {
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
                ),
                child: Center(
                  child: Text(
                    'Cadastrar nova medida',
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
                          'Cadastrar endereço',
                          () =>
                              Navigator.pushNamed(context, '/CadGrupoMedidas'),
                          Color(0XFFD1D6DC),
                          tamanhoLetra: size.width * 0.06,
                          corFonte: Colors.black,
                          fontWeight: FontWeight.w400),
                      Botao().botaoPadrao(
                          'Lista de endereços',
                          () => Navigator.pushNamed(
                              context, '/ListaGrupoMedidas'),
                          Color(0XFFD1D6DC), //Color(0XFFD1D6DC),
                          tamanhoLetra: size.width * 0.06,
                          corFonte: Colors.black,
                          fontWeight: FontWeight.w400),
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
