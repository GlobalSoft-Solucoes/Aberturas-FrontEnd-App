import 'package:projeto_aberturas/Screens/Home/MenuPrincipal.dart';
import 'package:flutter/material.dart';
import 'package:projeto_aberturas/Widget/bottom_navy_bar.dart';
import 'BarraHorizontal/Configuracoes/Configuracoes.dart';
import 'BarraHorizontal/GrupoMedidasPronto/ListaGrupoFinalizados.dart';
import 'BarraHorizontal/NovaMedida/TelaMenuMedidas.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _indiceatual = 0;
  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    Size size = mediaQuery.size;
    List<Widget> telas = [
      MenuPrincipal(),
      MenuMedidas(),
      ListaGruposFinalizados(),
      Configuracoes()
    ];
    return Padding(
      padding: EdgeInsets.only(bottom: size.height*0.05),
      child: Container(
        width: size.width,
        height: size.height,
        child: Scaffold(
          backgroundColor: Colors.grey[200],
          body: 
          telas[_indiceatual],
          bottomNavigationBar: BottomNavyBar(
            selectedIndex: _indiceatual,
            showElevation: true,
            itemCornerRadius: 8,
            curve: Curves.easeInBack,
            onItemSelected: (index) => setState(() {
              _indiceatual = index;

            }),
            items: [
              BottomNavyBarItem(
                icon: Icon(Icons.apps),
                title: Text('Home'),
                activeColor: Colors.grey[600],
                textAlign: TextAlign.center,
              ),
              BottomNavyBarItem(
                icon: Icon(Icons.add),
                title: Text('Nova Medida'),
                activeColor: Colors.grey[600],
                textAlign: TextAlign.center,
              ),
              BottomNavyBarItem(
                icon: Icon(Icons.list),
                title: Text(
                  'Historico ',
                ),
                activeColor: Colors.grey[600],
                textAlign: TextAlign.center,
              ),
              BottomNavyBarItem(
                icon: Icon(Icons.settings),
                title: Text('Configurações',style: TextStyle(fontSize: 10),),
                activeColor: Colors.grey[600],
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
