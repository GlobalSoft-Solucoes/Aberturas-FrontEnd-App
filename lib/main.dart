import 'package:flutter/material.dart';
import 'package:projeto_aberturas/Screens/Home/BarraLateral/CadPivotantes.dart';
import 'package:projeto_aberturas/Screens/Home/BarraLateral/Lixeira.dart';
import 'package:projeto_aberturas/Screens/Home/BarraLateral/StatusGrupos/TelaStatusGrupos.dart';
import 'package:projeto_aberturas/Screens/Home/BarraLateral/Usuario/ListarUsuarios.dart';
import 'package:projeto_aberturas/Screens/Login/Login.dart';
import 'package:projeto_aberturas/Screens/EntradaApp/Entrada.dart';
import 'package:projeto_aberturas/Screens/Home/BarraLateral/Usuario/CadastroUsuario.Dart';
import 'package:projeto_aberturas/Screens/Home/MenuPrincipal.dart';
import 'package:projeto_aberturas/Screens/Home/Home.Dart';
import 'package:projeto_aberturas/Screens/Home/BarraLateral/CadImoveis.dart';
import 'package:projeto_aberturas/Screens/Splash/Splash.dart';
import 'package:projeto_aberturas/Static/Static_GrupoMedidas.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:projeto_aberturas/Screens/Home/BarraLateral/CadReferencias.dart';
import 'Screens/Home/BarraHorizontal/GrupoMedidasPronto/ListaGrupoFinalizados.dart';
import 'Screens/Home/BarraHorizontal/NovaMedida/CadastroGrupoMedidas/CadGrupoMedidas.dart';
import 'Screens/Home/BarraHorizontal/NovaMedida/ListaGrupoMedidas/EditaGrupoMedidas.dart';
import 'Screens/Home/BarraHorizontal/NovaMedida/ListaGrupoMedidas/ListaGruposCadastrados.dart';
import 'Screens/Home/BarraHorizontal/NovaMedida/ListaGrupoMedidas/ListadeComodosImovel.dart';
import 'Screens/Home/BarraHorizontal/NovaMedida/MedidaPorta/CadDadosPorta.dart';
import 'Screens/Home/BarraHorizontal/NovaMedida/MedidaPorta/CadPortaPadrao.dart';
import 'Screens/Home/BarraHorizontal/NovaMedida/TelaMenuMedidas.dart';
import 'Screens/Home/BarraLateral/CadDobradicas.dart';
import 'Screens/Home/BarraLateral/CadFechaduras.dart';
import 'Screens/Home/BarraLateral/CadTipoPorta.dart';
import 'Screens/Home/BarraLateral/StatusGrupos/ListaGrupoSelecionado.dart';
import 'Screens/Home/BarraLateral/Usuario/PerfilUser.dart';
import 'Screens/Home/BarraLateral/Usuario/teste.dart';
import 'Screens/Home/BarraLateral/Usuario/EditarUsuario.dart';

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
        '/CadDadosPorta': (context) => CadDadosPorta(),
        '/PerfilUsuario': (context) => PerfilUsuario(),
        '/CadImoveis': (context) => CadImoveis(),
        '/CadReferencias': (context) => CadReferencias(),
        '/CadPortaPadrao': (context) => CadPortaPadrao(),
        '/CadFechaduras': (context) => CadFechaduras(),
        '/CadDobradicas': (context) => CadDobradicas(),
        '/CadPivotante': (context) => CadPivotantes(),
        '/ListaComodosPorImovel': (context) =>
            ListaComodoImoveis(idGrupoMedidas: FieldsGrupoMedidas.idGrupoMedidas),
        '/Lixeira': (context) => Lixeira(),
        '/EditaGrupoMedidas': (context) => EditaGrupoMedidas(),
        '/ListaGruposFinalizados': (context) => ListaGruposFinalizados(),
        '/CadTipoPorta': (context) => CadastroTipoDaPorta(),
        '/StatusGrupos': (context) => StatusGrupo(),
        '/ListaUsuariosEmpresa': (context) => ListaUsuariosEmpresa(),
        '/TesteListagem': (context) => TesteListagem(),
        '/EditarDadosUsuario': (context) => EditarDadosUsuario(),
         '/ListaGrupoSelecionado': (context) => ListaGrupoSelecionado(),
      },
      home: Splash(),
    ),
  );
}
