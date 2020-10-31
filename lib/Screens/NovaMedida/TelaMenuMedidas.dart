import 'package:flutter/material.dart';

import 'package:projeto_aberturas/Widget/Botao.dart';

class MenuMedidas extends StatefulWidget {
  @override
  _MenuMedidasState createState() => _MenuMedidasState();
}

double tamanhoLetra;

class _MenuMedidasState extends State<MenuMedidas> {
  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    Size size = mediaQuery.size;
    if (size.width > 800) {
      setState(() {
        tamanhoLetra = 35;
      });
    } else if (size.width < 450) {
      setState(() {
        tamanhoLetra = 25;
      });
    }
    return Scaffold(
      backgroundColor: Color(0xFFCCE9F5),
      appBar: AppBar(
        title: Text('Cadastrar nova medida'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Botao().botaoPadrao(
                'Cadastrar Endereco',
                () => Navigator.pushNamed(context, '/CadGrupoMedidas'),
                Color(0XFFD1D6DC),
                tamanhoLetra: tamanhoLetra),
            Botao().botaoPadrao(
                'Lista de Endereço',
                () => Navigator.pushNamed(context, '/ListaGrupoMedidas'),
                Color(0XFFD1D6DC),
                tamanhoLetra: tamanhoLetra),
            // Botao().botaoPadrao(
            //     'Cadastrar porta padrão',
            //     () => Navigator.pushNamed(context, '/CadPortaPadrao'),
            //     Color(0XFFD1D6DC),
            //     tamanhoLetra: tamanhoLetra)
          ],
        ),
      ),
    );
  }
}
