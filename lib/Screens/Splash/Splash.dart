import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:projeto_aberturas/Models/Models_Usuario.dart';
import 'package:projeto_aberturas/Models/constantes.dart';
import 'package:projeto_aberturas/Screens/EntradaApp/Entrada.dart';
import 'package:projeto_aberturas/Screens/Home/Home.Dart';
import 'package:projeto_aberturas/Static/Static_Empresa.dart';
import 'package:projeto_aberturas/Static/Static_Usuario.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  bool login = true;
  bool home = false;
  //faz a validação e busca dos dados do usuario para manter ele logado
  capturaIdUsuarioLogado() async {
    bool validou = false;
    List<ModelsUsuarios> dadosUsuario = [];

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getInt(
      'idusuario',
    );
    var token = prefs.getString('Token');
    if (id == null) {
      SystemChrome.setEnabledSystemUIOverlays([]);
      Future.delayed(Duration(seconds: 4)).then(
        (_) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => EntradaApp()));
        },
      );
    }
    final result = await http.get(
        Uri.encodeFull(
          BuscarUsuarioPorId + id.toString(),
        ),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'authorization': token,
        });
    print(result.body);
    if (result.statusCode == 401) {
      setState(
        () {
          home = false;
          login = true;
        },
      );
      //função responsavel pela splash screen
      SystemChrome.setEnabledSystemUIOverlays([]);
      Future.delayed(Duration(seconds: 4)).then(
        (_) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => EntradaApp()));
        },
      );
    }
    if (result.body != null) {
      Iterable lista = json.decode(result.body);
      dadosUsuario =
          lista.map((model) => ModelsUsuarios.fromJson(model)).toList();
      if (result.statusCode == 200) {
        validou = true;
        Iterable lista = json.decode(result.body);
        dadosUsuario =
            lista.map((model) => ModelsUsuarios.fromJson(model)).toList();
        UserLogado.idUsuario = dadosUsuario[0].idUsuario;
        ModelsUsuarios.tokenAuth = token;
        UserLogado.idEmpresa = dadosUsuario[0].idEmpresa;
        await DadosEmpresa().capturaDadosEmpresa();
        setState(
          () {
            UserLogado().capturaDadosUsuarioLogado();
            home = true;
            login = false;
          },
        );
        //função responsavel pela splash screen
        SystemChrome.setEnabledSystemUIOverlays([]);
        Future.delayed(Duration(seconds: 5)).then(
          (_) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => Home()));
          },
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    this.capturaIdUsuarioLogado();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    Size size = mediaQuery.size;
    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        color: Color(0xFFCCE9F5),
        child: Center(
          child: Text(
            'Aberturas',
            style: TextStyle(fontSize: 40),
          ),
        ),
      ),
    );
  }
}
