import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:projeto_aberturas/Models/Models_Usuario.dart';
import 'package:projeto_aberturas/Models/constantes.dart';
import 'package:projeto_aberturas/Static/Static_GrupoMedidas.dart';
import 'package:projeto_aberturas/Static/Static_Usuario.dart';
import 'package:projeto_aberturas/Widget/Botao.dart';
import 'package:projeto_aberturas/Widget/MsgPopup.dart';
import 'package:projeto_aberturas/Widget/TextField.dart';
import 'package:http/http.dart' as http;

class CadPortaPadrao extends StatefulWidget {
  @override
  _CadPortaPadraoState createState() => _CadPortaPadraoState();
}

class _CadPortaPadraoState extends State<CadPortaPadrao> {
  TextEditingController controllerComodo = TextEditingController();
  var alturaPadrao = false;
  var lagura094 = false;
  var largura084 = false;
  var largura074 = false;
  var marco008 = false;
  var marco010 = false;
  var giro = false;
  var correr = false;
  var pivotante = false;
  var oca = false;
  var semioca = false;
  var solida = false;
  var laca = false;
  var verniz = false;
  var dentro = false;
  var fora = false;
  var wc = false;
  var interno = false;
  var externo = false;
  var lavanderia = false;
  var cor = '';
  var tipoPorta = '';
  double marco;
  var ladoAbertura = '';
  var estruturaPorta = '';
  var localizacao = '';
  var aberturaPorta = '';
  double largura;
  List itensLista = List();
  List itensLista1 = List();
  List itensLista2 = List();
  List itensLista3 = List();
  int idCodRef;
  int idFechadura;
  int idDobradica;
  int idRolPivotante;
  double altura;

//CHAMA AS FUNÇÕES QUANDO INICIAR A TELA
  @override
  void initState() {
    super.initState();
    this.buscardados();
    this.buscarDados1();
    this.buscarDados2();
    this.buscarDados3();
  }

  Future<dynamic> salvarDadosBanco() async {
    var bodyy = jsonEncode({
      'IdUsuario': Usuario.idUsuario,
      'IdGrupo_Medidas': GrupoMedidas.idGrupoMedidas,
      'IdCod_Referencia': idCodRef,
      'IdDobradica': idDobradica,
      'IdPivotante': idRolPivotante,
      'Altura': altura,
      'Lado_Abertura': aberturaPorta,
      'IdFechadura': idFechadura,
      'Tipo_Porta': tipoPorta,
      'Estrutura_Porta': estruturaPorta,
      'Largura': largura,
      'Localizacao': localizacao,
      'Cor': cor,
      'Marco_Parede': marco,
      'Comodo': controllerComodo.text,
      'Tipo_Medida': 'Padrao',
    });

    http.post(
      UrlServidor + CadastrarMedidaUnt,
      headers: {"authorization": ModelsUsuarios.tokenAuth},
      body: bodyy,
    );
  }

  var mensagemErro = '';
  validarCampos() {
    if (Usuario.idUsuario != null) {
      if (GrupoMedidas.idGrupoMedidas != null) {
        if (altura != 0) {
          if (aberturaPorta != '') {
            if (idFechadura != null) {
              if (tipoPorta != '') {
                if (estruturaPorta != '') {
                  if (largura != 0) {
                    if (localizacao != '') {
                      if (cor != '') {
                        if (marco != 0) {
                          if (controllerComodo.text.length > 3) {
                            if (idCodRef != null) {
                              salvarDadosBanco();
                              Navigator.pop(context);
                            } else {
                              mensagemErro = 'o codReferencia é nulo';
                              _mensagemErroCadastro();
                            }
                          } else {
                            mensagemErro = 'o comodo é curto ou esta vazio';
                            _mensagemErroCadastro();
                          }
                        } else {
                          mensagemErro = 'o marco não foi selecionado!';
                          _mensagemErroCadastro();
                        }
                      } else {
                        mensagemErro = 'A cor não foi selecionada!';
                        _mensagemErroCadastro();
                      }
                    } else {
                      mensagemErro =
                          'A localização da porta não foi selecionada!';
                      _mensagemErroCadastro();
                    }
                  } else {
                    mensagemErro = 'A largura da porta não foi selecionada!';
                    _mensagemErroCadastro();
                  }
                } else {
                  mensagemErro =
                      'O tipo de estrutura da porta não foi selecionado!';
                  _mensagemErroCadastro();
                }
              } else {
                mensagemErro = 'O tipo da porta não foi selecionado!';
                _mensagemErroCadastro();
              }
            } else {
              mensagemErro = 'A fechadura não foi selecionada!';
              _mensagemErroCadastro();
            }
          } else {
            mensagemErro = 'O lado de abertura da porta não foi selecionado!';
            _mensagemErroCadastro();
          }
        } else {
          mensagemErro = 'A altura não foi selecionada';
          _mensagemErroCadastro();
        }
      }
    }
  }

  _mensagemErroCadastro() {
    MsgPopup().msgFeedback(
      context,
      '\n' + mensagemErro,
      'Aviso',
    );
  }

//CHAMA O WIDGET PIVOTANTE
  chamarWidgetPivotante() {
    if (pivotante == true) {
      return Padding(
        padding: EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Colors.black, width: 1)),
          child: Column(
            children: [
              new Padding(
                padding: const EdgeInsets.all(8.0),
                child: new Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  child: Text(
                    'Rol Pivotante',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black, width: 1)),
                  child: DropdownButton(
                      hint: Text(
                        'Rol Pivotante',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      value: idRolPivotante,
                      items: itensLista3.map((categoria) {
                        return DropdownMenuItem(
                            value: (categoria['IdPivotante']),
                            child: Row(
                              children: [
                                Text(
                                  categoria['IdPivotante'].toString(),
                                  style: TextStyle(fontSize: 18),
                                ),
                                Text(
                                  ' - ',
                                  style: TextStyle(fontSize: 18),
                                ),
                                Text(
                                  categoria['Nome'],
                                  style: TextStyle(fontSize: 18),
                                )
                              ],
                            ));
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          idRolPivotante = value;
                          idDobradica = null;
                        });
                      }),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Container();
    }
  }

//CHAMA O WIDGET DOBRADICA
  chamarWidgetDobradica() {
    if (giro == true) {
      return Padding(
        padding: EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Colors.black, width: 1)),
          child: Column(
            children: [
              new Padding(
                padding: const EdgeInsets.all(8.0),
                child: new Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  child: Text(
                    'Dobradiça',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black, width: 1)),
                  child: DropdownButton(
                      hint: Text(
                        'Dobradiça',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      value: idDobradica,
                      items: itensLista2.map((categoria) {
                        return DropdownMenuItem(
                            value: (categoria['IdDobradica']),
                            child: Row(
                              children: [
                                Text(
                                  categoria['IdDobradica'].toString(),
                                  style: TextStyle(fontSize: 18),
                                ),
                                Text(
                                  ' - ',
                                  style: TextStyle(fontSize: 18),
                                ),
                                Text(
                                  categoria['Nome'],
                                  style: TextStyle(fontSize: 18),
                                )
                              ],
                            ));
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          idDobradica = value;
                          idRolPivotante = null;
                        });
                      }),
                ),
              ),
            ],
          ),
        ),
      );
    } else
      return Container();
  }

//ESTA FUNÇÃO BUSCA A LISTA DOS TIPOS DE IMOVEIS
  Future buscardados() async {
    final response = await http.get(
      Uri.encodeFull(UrlServidor + 'Fechadura/ListarTodos'),
      headers: {"authorization": ModelsUsuarios.tokenAuth},
    );
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      setState(() {
        itensLista = jsonData;
      });
    }
  }

//BUSCA TODOS OS COD REFERENCIA
  Future buscarDados1() async {
    final response = await http.get(
      Uri.encodeFull(UrlServidor + 'CodReferencia/ListarTodos'),
      headers: {"authorization": ModelsUsuarios.tokenAuth},
    );
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      setState(() {
        itensLista1 = jsonData;
      });
    }
  }

//BUSCA TODAS AS DOBRADICAS
  Future buscarDados2() async {
    final response = await http.get(
      Uri.encodeFull(UrlServidor + 'Dobradica/ListarTodos/'),
      headers: {"authorization": ModelsUsuarios.tokenAuth},
    );
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      setState(() {
        itensLista2 = jsonData;
      });
    }
  }

//BUSCA TODOS OS PIVOTANTES
  Future buscarDados3() async {
    final response = await http.get(
      Uri.encodeFull(UrlServidor + ListarTodosPivotante),
      headers: {"authorization": ModelsUsuarios.tokenAuth},
    );
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      setState(() {
        itensLista3 = jsonData;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    Size size = mediaQuery.size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: size.width,
          height: size.height,
          color: Colors.blue,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    top: size.height * 0.02, left: size.width * 0.05),
                child: Container(
                  height: size.height * 0.10,
                  width: size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.horizontal(
                          right: Radius.circular(5), left: Radius.circular(5))),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: () => Navigator.pop(context),
                        color: Colors.white,
                        iconSize: 30,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: size.width * 0.05),
                        child: Text(
                          'Porta Padrão',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    right: size.width * 0.02,
                    left: size.width * 0.02,
                    top: size.height * 0.01),
                child: Container(
                  height: size.height * .85,
                  width: size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              left: size.width * 0.01,
                              right: size.width * 0.01,
                              top: 5,
                              bottom: 3),
                          child: CampoText().textField(
                              controllerComodo, 'Comodo:',
                              icone: Icons.home, tipoTexto: TextInputType.text),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 5, right: 5, top: 5, bottom: 5),
                          child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.black),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    'Altura',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: CheckboxListTile(
                                              title: Text(
                                                '2,13',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18),
                                              ),
                                              key: Key('check1'),
                                              value: alturaPadrao,
                                              onChanged: (bool valor) {
                                                setState(() {
                                                  alturaPadrao = valor;
                                                  altura = 2.13;
                                                });
                                              }),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 5, right: 5, top: 5, bottom: 5),
                          child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.black),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    'Largura',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: CheckboxListTile(
                                              title: Text(
                                                '0.94',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18),
                                              ),
                                              key: Key('check1'),
                                              value: lagura094,
                                              onChanged: (bool valor) {
                                                setState(() {
                                                  largura084 = false;
                                                  largura074 = false;
                                                  lagura094 = valor;
                                                  largura = 0.94;
                                                  print(largura);
                                                });
                                              }),
                                        ),
                                        Expanded(
                                          child: CheckboxListTile(
                                              title: Text(
                                                '0.84',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18),
                                              ),
                                              key: Key('check1'),
                                              value: largura084,
                                              onChanged: (bool valor) {
                                                setState(() {
                                                  largura084 = valor;
                                                  largura074 = false;
                                                  lagura094 = false;
                                                  largura = 0.84;
                                                  print(largura);
                                                });
                                              }),
                                        ),
                                        Expanded(
                                          child: CheckboxListTile(
                                              title: Text(
                                                '0.74',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18),
                                              ),
                                              key: Key('check2'),
                                              value: largura074,
                                              onChanged: (bool valor) {
                                                setState(() {
                                                  largura084 = false;
                                                  largura074 = valor;
                                                  lagura094 = false;
                                                  largura = 0.74;
                                                  print(largura);
                                                });
                                              }),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 5, right: 5, top: 5, bottom: 5),
                          child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.black),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    'Marco Parede',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: CheckboxListTile(
                                              title: Text(
                                                '0.08',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18),
                                              ),
                                              key: Key('check3'),
                                              value: marco008,
                                              onChanged: (bool valor) {
                                                setState(() {
                                                  marco008 = valor;
                                                  marco010 = false;
                                                  marco = 0.08;
                                                });
                                              }),
                                        ),
                                        Expanded(
                                          child: CheckboxListTile(
                                              title: Text(
                                                '0.10',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18),
                                              ),
                                              key: Key('check4'),
                                              value: marco010,
                                              onChanged: (bool valor) {
                                                setState(() {
                                                  marco010 = valor;
                                                  marco008 = false;
                                                  marco = 0.10;
                                                });
                                              }),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 5, right: 5, top: 5, bottom: 5),
                          child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.black),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    'Tipo de Porta',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: CheckboxListTile(
                                              title: Text(
                                                'Giro',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18),
                                              ),
                                              key: Key('check5'),
                                              value: giro,
                                              onChanged: (bool valor) {
                                                setState(() {
                                                  giro = valor;
                                                  correr = false;
                                                  pivotante = false;
                                                  tipoPorta = 'Giro';
                                                });
                                              }),
                                        ),
                                        Expanded(
                                          child: CheckboxListTile(
                                              title: Text(
                                                'Correr',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18),
                                              ),
                                              key: Key('check6'),
                                              value: correr,
                                              onChanged: (bool valor) {
                                                setState(() {
                                                  correr = valor;
                                                  giro = false;
                                                  pivotante = false;
                                                  tipoPorta = 'Correr';
                                                });
                                              }),
                                        ),
                                        Expanded(
                                          child: CheckboxListTile(
                                              title: Text(
                                                'Pivotante',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18),
                                              ),
                                              key: Key('check7'),
                                              value: pivotante,
                                              onChanged: (bool valor) {
                                                setState(() {
                                                  pivotante = valor;
                                                  giro = false;
                                                  correr = false;
                                                  tipoPorta = 'Pivotante';
                                                });
                                              }),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 5, right: 5, top: 5, bottom: 5),
                          child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.black),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    'Localização',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: CheckboxListTile(
                                                  title: Text(
                                                    'Interno',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18),
                                                  ),
                                                  key: Key('check11'),
                                                  value: interno,
                                                  onChanged: (bool valor) {
                                                    setState(() {
                                                      interno = valor;
                                                      externo = false;
                                                      wc = false;
                                                      lavanderia = false;
                                                      localizacao = 'Interna';
                                                    });
                                                  }),
                                            ),
                                            Expanded(
                                              child: CheckboxListTile(
                                                  title: Text(
                                                    'Externo',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18),
                                                  ),
                                                  key: Key('check12'),
                                                  value: externo,
                                                  onChanged: (bool valor) {
                                                    setState(() {
                                                      externo = valor;
                                                      interno = false;
                                                      wc = false;
                                                      lavanderia = false;
                                                      localizacao = 'Externa';
                                                    });
                                                  }),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: CheckboxListTile(
                                                  title: Text(
                                                    'WC',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18),
                                                  ),
                                                  key: Key('check12'),
                                                  value: wc,
                                                  onChanged: (bool valor) {
                                                    setState(() {
                                                      wc = valor;
                                                      interno = false;
                                                      externo = false;
                                                      lavanderia = false;
                                                      localizacao = 'Banheiro';
                                                    });
                                                  }),
                                            ),
                                            Expanded(
                                              child: CheckboxListTile(
                                                  title: Text(
                                                    'Lavanderia',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18),
                                                  ),
                                                  key: Key('check12'),
                                                  value: lavanderia,
                                                  onChanged: (bool valor) {
                                                    setState(() {
                                                      lavanderia = valor;
                                                      interno = false;
                                                      externo = false;
                                                      wc = false;
                                                      localizacao =
                                                          'Lavanderia';
                                                    });
                                                  }),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              )),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 5, right: 5, top: 5, bottom: 5),
                          child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.black),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    'Porta',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: CheckboxListTile(
                                              title: Text(
                                                'Oca',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18),
                                              ),
                                              key: Key('check8'),
                                              value: oca,
                                              onChanged: (bool valor) {
                                                setState(() {
                                                  oca = valor;
                                                  semioca = false;
                                                  solida = false;
                                                  estruturaPorta = 'Oca';
                                                });
                                              }),
                                        ),
                                        Expanded(
                                          child: CheckboxListTile(
                                              title: Text(
                                                'Semi-Oca',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18),
                                              ),
                                              key: Key('check9'),
                                              value: semioca,
                                              onChanged: (bool valor) {
                                                setState(() {
                                                  semioca = valor;
                                                  oca = false;
                                                  solida = false;
                                                  estruturaPorta = 'semi-oca';
                                                });
                                              }),
                                        ),
                                        Expanded(
                                          child: CheckboxListTile(
                                              title: Text(
                                                'Solida',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18),
                                              ),
                                              key: Key('check10'),
                                              value: solida,
                                              onChanged: (bool valor) {
                                                setState(() {
                                                  solida = valor;
                                                  oca = false;
                                                  semioca = false;
                                                  estruturaPorta = 'solida';
                                                });
                                              }),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 5, right: 5, top: 5, bottom: 5),
                          child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.black),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    'Cor da Porta',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: CheckboxListTile(
                                              title: Text(
                                                'Laca',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18),
                                              ),
                                              key: Key('check11'),
                                              value: laca,
                                              onChanged: (bool valor) {
                                                setState(() {
                                                  laca = valor;
                                                  verniz = false;
                                                  cor = 'Laca';
                                                });
                                              }),
                                        ),
                                        Expanded(
                                          child: CheckboxListTile(
                                              title: Text(
                                                'Verniz',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18),
                                              ),
                                              key: Key('check12'),
                                              value: verniz,
                                              onChanged: (bool valor) {
                                                setState(() {
                                                  verniz = valor;
                                                  laca = false;
                                                  cor = 'Verniz';
                                                });
                                              }),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 5, right: 5, top: 5, bottom: 5),
                          child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.black),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    'Abertura da porta',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: CheckboxListTile(
                                              title: Text(
                                                'Direito',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18),
                                              ),
                                              key: Key('check13'),
                                              value: dentro,
                                              onChanged: (bool valor) {
                                                setState(() {
                                                  dentro = valor;
                                                  fora = false;
                                                  aberturaPorta = 'Direito';
                                                });
                                              }),
                                        ),
                                        Expanded(
                                          child: CheckboxListTile(
                                              title: Text(
                                                'Esquerdo',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18),
                                              ),
                                              key: Key('check14'),
                                              value: fora,
                                              onChanged: (bool valor) {
                                                setState(() {
                                                  fora = valor;
                                                  dentro = false;
                                                  aberturaPorta = 'Esqueda';
                                                });
                                              }),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 5, right: 5, top: 5, bottom: 5),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border:
                                    Border.all(color: Colors.black, width: 1)),
                            child: Column(
                              children: [
                                new Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: new Container(
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Text(
                                      'Tipo de Fechadura:',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            color: Colors.black, width: 1)),
                                    child: DropdownButton(
                                        hint: Text(
                                          'Tipo de Fechadura',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        value: idFechadura,
                                        items: itensLista.map((categoria) {
                                          return DropdownMenuItem(
                                              value: (categoria['IdFechadura']),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    categoria['IdFechadura']
                                                        .toString(),
                                                    style:
                                                        TextStyle(fontSize: 18),
                                                  ),
                                                  Text(
                                                    ' - ',
                                                    style:
                                                        TextStyle(fontSize: 18),
                                                  ),
                                                  Text(
                                                    categoria['nome'],
                                                    style:
                                                        TextStyle(fontSize: 18),
                                                  )
                                                ],
                                              ));
                                        }).toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            idFechadura = value;
                                          });
                                        }),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 5, right: 5, top: 5, bottom: 5),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border:
                                    Border.all(color: Colors.black, width: 1)),
                            child: Column(
                              children: [
                                new Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: new Container(
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Text(
                                      'Cod Referencia',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            color: Colors.black, width: 1)),
                                    child: DropdownButton(
                                        hint: Text(
                                          'Cod Referencia',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        value: idCodRef,
                                        items: itensLista1.map((categoria) {
                                          return DropdownMenuItem(
                                              value: (categoria[
                                                  'IdCod_Referencia']),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    ' - ',
                                                    style:
                                                        TextStyle(fontSize: 18),
                                                  ),
                                                  Text(
                                                    'R-' + categoria['Codigo'],
                                                    style:
                                                        TextStyle(fontSize: 18),
                                                  )
                                                ],
                                              ));
                                        }).toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            idCodRef = value;
                                          });
                                        }),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        chamarWidgetDobradica(),
                        chamarWidgetPivotante(),
                        Padding(
                            padding: EdgeInsets.all(5),
                            child: Botao().botaoPadrao('Salvar', () {
                              validarCampos();
                            }, Colors.blue))
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
