import 'package:flutter/material.dart';
import 'package:projeto_aberturas/Static/Static_Usuario.dart';

class MenuPrincipal extends StatefulWidget {
  @override
  _MenuPrincipalState createState() => _MenuPrincipalState();
}

double tamanhoLetra = 35;

class _MenuPrincipalState extends State<MenuPrincipal> {
  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    Size size = mediaQuery.size;
    return Scaffold(
      backgroundColor: Color(0xFFCCE9F5),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Menu',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
          ),
        ),
        backgroundColor: Colors.blue[300],
        // backgroundColor: Color(0XFF0099FF),
      ),
      body: Container(
        height: size.height,
        width: size.width,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'GlobalSoft',
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.w300),
              ),
              Text(
                'Soluções Tecnologicas',
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.w300),
              )
            ],
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text(''),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text(
                'Perfil do usuário',
                style: TextStyle(fontSize: 18),
              ),
              contentPadding: EdgeInsets.only(top: 20, left: 20),
              dense: true,
              onTap: () {
                setState(() {
                  // Atualiza os dados do usuario no arquivo static onde eles são pegos
                  DadosUserLogado().capturaDadosUsuarioLogado();
                });
                Navigator.pushNamed(context, '/PerfilUsuario');
              },
            ),
            ListTile(
              title: Text(
                'Cadastrar Imovel',
                style: TextStyle(fontSize: 18),
              ),
              contentPadding: EdgeInsets.only(top: 20, left: 20),
              dense: true,
              onTap: () {
                Navigator.pushNamed(context, '/CadImoveis');
                // Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(
                'Cadastrar Referências',
                style: TextStyle(fontSize: 18),
              ),
              contentPadding: EdgeInsets.only(top: 20, left: 20),
              dense: true,
              onTap: () {
                Navigator.pushNamed(context, '/CadReferencias');
              },
            ),
            ListTile(
              title: Text(
                'Cadastrar Fechaduras',
                style: TextStyle(fontSize: 18),
              ),
              contentPadding: EdgeInsets.only(top: 20, left: 20),
              dense: true,
              onTap: () {
                Navigator.pushNamed(context, '/CadFechaduras');
              },
            ),
            ListTile(
              title: Text(
                'Cadastrar Dobradiças',
                style: TextStyle(fontSize: 18),
              ),
              contentPadding: EdgeInsets.only(top: 20, left: 20),
              dense: true,
              onTap: () {
                Navigator.pushNamed(context, '/CadDobradicas');
              },
            ),
            ListTile(
              title: Text(
                'Cadastrar RolPivotante',
                style: TextStyle(fontSize: 18),
              ),
              contentPadding: EdgeInsets.only(top: 20, left: 20),
              dense: true,
              onTap: () {
                Navigator.pushNamed(context, '/CadPivotante');
              },
            ),
            ListTile(
              title: Text(
                'Lixeira',
                style: TextStyle(fontSize: 18),
              ),
              contentPadding: EdgeInsets.only(top: 20, left: 20),
              dense: true,
              onTap: () {
                Navigator.pushNamed(context, '/Lixeira');
              },
            )
          ],
        ),
      ),
    );
  }
}
