import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:projeto_aberturas/Models/Models_Portas.dart';
import 'package:projeto_aberturas/Models/Models_Usuario.dart';
import 'package:projeto_aberturas/Models/constantes.dart';
import 'package:projeto_aberturas/Widget/Botao.dart';
import 'package:projeto_aberturas/Widget/MsgPopup.dart';
import 'package:projeto_aberturas/Widget/TextField.dart';

class StatusGrupo extends StatefulWidget {
  @override
  _StatusGruposState createState() => _StatusGruposState();
}

class _StatusGruposState extends State<StatusGrupo> {
  TextEditingController controllPivotantes = TextEditingController();
  TextEditingController controllDescricao = TextEditingController();

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    Size size = mediaQuery.size;
    return Scaffold(
      backgroundColor: Color(0xFFCCE9F5),
      body: SingleChildScrollView(
        child: Container(
          width: size.width,
          height: size.height,
          color: Colors.blue[400],
          child: Column(
            children: [
              //===========================================
              Padding(
                padding: EdgeInsets.only(
                  top: size.height * 0.02,
                  left: size.width * 0.02,
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
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: size.width * 0.05),
                        child: Text(
                          'Status dos endereços',
                          style: TextStyle(
                              fontSize: 32,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.none),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              //=================================================
              Container(
                padding: EdgeInsets.only(
                  top: size.width * 0.05,
                  left: size.width * 0.02,
                  right: size.width * 0.02,
                ),
                child: Container(
                  width: size.width,
                  height: size.height * 0.15,
                  decoration: BoxDecoration(
                    color: Color(0xFF7ebde7),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        //=================================================
                        Container(
                          padding: EdgeInsets.only(
                            left: size.width * 0.0,
                            top: size.height * 0.05,
                          ),
                          child: Text(
                            'Cadastrados',
                            style: TextStyle(
                                fontSize: 32,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.none),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              //=================================================
              Container(
                padding: EdgeInsets.only(
                  top: size.width * 0.05,
                  left: size.width * 0.02,
                  right: size.width * 0.02,
                ),
                child: Container(
                  width: size.width,
                  height: size.height * 0.15,
                  decoration: BoxDecoration(
                    color: Color(0xFFf4f2bc),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.only(
                        left: size.width * 0.0,
                        top: size.height * 0.05,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Finalizados',
                        style: TextStyle(
                            fontSize: 34,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.none),
                      ),
                    ),
                  ),
                ),
              ),
              //=====================================================
              Container(
                padding: EdgeInsets.only(
                  top: size.width * 0.05,
                  left: size.width * 0.02,
                  right: size.width * 0.02,
                ),
                child: Container(
                  width: size.width,
                  height: size.height * 0.15,
                  decoration: BoxDecoration(
                    color: Color(0xFFd1d1d1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            left: size.width * 0.0,
                            top: size.height * 0.05,
                          ),
                          child: Text(
                            'Enviados para a empresa',
                            style: TextStyle(
                                fontSize: 32,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.none),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              //=====================================================
              Container(
                padding: EdgeInsets.only(
                  top: size.width * 0.05,
                  left: size.width * 0.02,
                  right: size.width * 0.02,
                ),
                child: Container(
                  width: size.width,
                  height: size.height * 0.15,
                  decoration: BoxDecoration(
                    color: Color(0xFF81e17a),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            left: size.width * 0.0,
                            top: size.height * 0.05,
                          ),
                          child: Text(
                            'Em produção',
                            style: TextStyle(
                                fontSize: 32,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.none),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              //=====================================================
            ],
          ),
        ),
      ),
    );
  }
}
