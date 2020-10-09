import 'package:flutter/material.dart';
import 'package:projeto_aberturas/Screens/Home/BarraLateral/CadPivotantes.dart';
import 'package:projeto_aberturas/Screens/NovaMedida/CadastroGrupoMedidas/CadGrupoMedidas.dart';
import 'package:projeto_aberturas/Screens/NovaMedida/ListaGrupoMedidas/ListaGrupoMedidas.dart';
import 'package:projeto_aberturas/Screens/NovaMedida/ListaGrupoMedidas/ListadeComodosImovel.dart';
import 'package:projeto_aberturas/Screens/NovaMedida/ListaGrupoMedidas/EditaGrupoMedidas.dart';
import 'package:projeto_aberturas/Screens/NovaMedida/TelaMenuMedidas.dart';
import 'package:projeto_aberturas/Screens/NovaMedida/MedidaPorta/CadDadosPorta.dart';
import 'package:projeto_aberturas/Screens/Configuracoes/ControleDeAcesso/ListaUsuariosSistema.dart';
import 'package:projeto_aberturas/Screens/Configuracoes/LiberarAcesso/CodigoAcesso.dart';
import 'package:projeto_aberturas/Screens/Login/Login.dart';
import 'package:projeto_aberturas/Screens/EntradaApp/Entrada.dart';
import 'package:projeto_aberturas/Screens/Cadastro/CadastroUsuario.Dart';
import 'package:projeto_aberturas/Screens/Home/MenuPrincipal.dart';
import 'package:projeto_aberturas/Screens/Home/Home.Dart';
import 'package:projeto_aberturas/Screens/Home/BarraLateral/PerfilUser.dart';
import 'package:projeto_aberturas/Screens/Home/BarraLateral/CadImoveis.dart';
import 'package:projeto_aberturas/Static/Static_GrupoMedidas.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:projeto_aberturas/Screens/Home/BarraLateral/CadReferencias.dart';
import 'Screens/Home/BarraLateral/CadDobradicas.dart';
import 'Screens/Home/BarraLateral/CadFechaduras.dart';
import 'Screens/NovaMedida/MedidaPorta/CadPortaPadrao.dart';

void main() {
  runApp(
    //estancia o valor da classe model pra todo o app
    MaterialApp(
      builder: (context, widget) => ResponsiveWrapper.builder(
        BouncingScrollWrapper.builder(context, widget),
        maxWidth: 1200,
        minWidth: 450,
        defaultScale: true,
        breakpoints: [
          ResponsiveBreakpoint.resize(450, name: MOBILE),
          ResponsiveBreakpoint.autoScale(800, name: TABLET),
          ResponsiveBreakpoint.autoScale(1000, name: TABLET),
          ResponsiveBreakpoint.resize(1200, name: DESKTOP),
          ResponsiveBreakpoint.autoScale(2460, name: "4K"),
        ],
      ),
      theme: ThemeData.light(),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',

      // Cadastrar rotas de telas do App
      routes: {
        '/EntradaApp': (context) => EntradaApp(),
        '/Login': (context) => Login(),
        '/CadastroUsuario': (context) => CadastroUsuario(),
        '/MenuPrincipal': (context) => MenuPrincipal(),
        '/Home': (context) => Home(),
        '/MenuMedidas': (context) => MenuMedidas(),
        '/CadGrupoMedidas': (context) => CadGrupoMedidas(),
        '/ListaGrupoMedidas': (context) => ListaGrupoMedidas(),
        '/CodigoAcesso': (context) => CodigoAcesso(),
        '/usuariosLogados': (context) => ListaUsuCadastrados(),
        '/CadDadosPorta': (context) => CadDadosPorta(),
        '/PerfilUsuario': (context) => PerfilUsuario(),
        '/CadImoveis': (context) => CadImoveis(),
        '/CadReferencias': (context) => CadReferencias(),
        '/CadPortaPadrao': (context) => CadPortaPadrao(),
        '/CadFechaduras': (context) => CadFechaduras(),
        '/CadDobradicas': (context) => CadDobradicas(),
        '/CadPivotante': (context) => CadPivotantes(),
        '/ListaComodosPorImovel': (context) => ListaComodoImoveis(
              idGrupoMedidas: GrupoMediddas.idGrupoMedidas,
            ),
        '/EditaGrupoMedidas': (context) => EditaGrupoMedidas(),
      },
      home: EntradaApp(),
    ),
  );
}
