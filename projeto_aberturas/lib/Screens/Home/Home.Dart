import 'package:projeto_aberturas/Screens/HistoricoMedidas/RelatorioGrupoMedidas/ListaGrupoFinalizados.dart';
import 'package:projeto_aberturas/Screens/NovaMedida/TelaMenuMedidas.dart';
import 'package:projeto_aberturas/Screens/Home/MenuPrincipal.dart';
import 'package:flutter/material.dart';
import 'package:projeto_aberturas/Screens/Configuracoes/Configuracoes.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _indiceatual = 0;
  @override
  Widget build(BuildContext context) {
    List<Widget> telas = [
      MenuPrincipal(),
      MenuMedidas(),
      Relatorio(),
      Configuracoes()
    ];
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: telas[_indiceatual],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indiceatual,
        onTap: (indice) {
          setState(() {
            _indiceatual = indice;
          });
        },
        type: BottomNavigationBarType.fixed,
        fixedColor: Colors.black,
        backgroundColor: Colors.white,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('Home')),
          BottomNavigationBarItem(
              icon: Icon(Icons.new_releases), title: Text('Nova medida')),
          BottomNavigationBarItem(
              icon: Icon(Icons.create), title: Text('Historico de medidas')),
          BottomNavigationBarItem(
              icon: Icon(Icons.history), title: Text('Configurações')),
        ],
      ),
    );
  }
}
