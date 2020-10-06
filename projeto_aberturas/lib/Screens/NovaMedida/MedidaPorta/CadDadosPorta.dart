import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:projeto_aberturas/Models/constantes.dart';
import 'package:projeto_aberturas/Static/Static_GrupoMedidas.dart';
import 'package:projeto_aberturas/Static/Static_Usuario.dart';
import 'package:projeto_aberturas/Widget/Botao.dart';
import 'package:projeto_aberturas/Widget/MsgPopup.dart';
import 'package:projeto_aberturas/Widget/TextField.dart';

//ESTA É A TELA PARA CADASTRO DE UMA NOVA MEDIDA DE PORTA!!
class CadDadosPorta extends StatefulWidget {
  @override
  _CadDadosPortaState createState() => _CadDadosPortaState();
}

class _CadDadosPortaState extends State<CadDadosPorta> {
  @override
  void initState() {
    super.initState();
    this.buscardados();
    this.buscarDados1();
    this.buscarDados2();
    this.buscarDados3();
  }

  _mensagemErroCadastro() {
    MsgPopup().msgFeedback(
      context,
      '\n' + mensagemErro,
      'Aviso',
    );
  }

//ESTA FUNÇÃO BUSCA A LISTA DOS TIPOS DE IMOVEIS
  Future buscardados() async {
    final response = await http.get(
      Uri.encodeFull(UrlServidor + 'Fechadura/ListarTodos'),
      headers: {"accept": "application/json"},
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
      headers: {"accept": "application/json"},
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
      headers: {"accept": "application/json"},
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
      headers: {"accept": "application/json"},
    );
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      setState(() {
        itensLista3 = jsonData;
      });
    }
  }

//CONTROLADORES DOS TEXTFIELDS
  TextEditingController controllerComodo = TextEditingController();
  TextEditingController controllerObservacoes = TextEditingController();
  TextEditingController controllerAltura = TextEditingController();
  TextEditingController controllerCor = TextEditingController();
  TextEditingController controllerLargura = TextEditingController();
  TextEditingController controllerMarco = TextEditingController();
  bool giro = false;
  bool correr = false;
  bool pivotante = false;
  bool oca = false;
  bool semioca = false;
  bool solida = false;
  bool dentro = false;
  bool fora = false;
  bool wc = false;
  bool interno = false;
  bool externo = false;
  bool lavanderia = false;
  String cor = '';
  String tipoPorta = '';
  double marco;
  String estruturaPorta = '';
  String localizacao = '';
  String aberturaPorta = '';
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
  //verifica o check de lado da fechadura
  bool checkladoportafora = false;
  bool checkladoportadentro = false;
  String portaAbre = "";
//verifica o check de lado da porta
  var mensagemErro = '';
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

  validarCampos() {
    var altura = controllerAltura.text;
    cor = controllerCor.text;
    var comodo = controllerComodo.text;
    if (comodo.isNotEmpty) {
      if (altura.isNotEmpty) {
        if (largura != 0) {
          if (marco != 0) {
            if (tipoPorta.length > 1) {
              if (estruturaPorta.length >= 3) {
                if (localizacao.length > 2) {
                  if (portaAbre.length > 3) {
                    if (cor.length > 1) {
                      if (idFechadura != null) {
                        if (idCodRef != null) {
                          Navigator.of(context).pop();
                          salvarDadosBanco();
                        } else {
                          mensagemErro = 'Voce não escolheu um codigo ref';
                          _mensagemErroCadastro();
                        }
                      } else {
                        mensagemErro = 'Voce não escolheu uma fechadura!';
                        _mensagemErroCadastro();
                      }
                    } else {
                      mensagemErro = 'Voce não preencheu a cor da porta!';
                      _mensagemErroCadastro();
                    }
                  } else {
                    mensagemErro =
                        'O lado de abertura da porta não foi escolhido!';
                    _mensagemErroCadastro();
                  }
                } else {
                  mensagemErro = 'A localização da porta não foi escolhida';
                  _mensagemErroCadastro();
                }
              } else {
                mensagemErro =
                    'A estrutura que compõem a porta não foi escolhida!';
                _mensagemErroCadastro();
              }
            } else {
              mensagemErro = 'O tipo da porta não foi escolhido!';
              _mensagemErroCadastro();
            }
          } else {
            mensagemErro = 'O marco da parede não foi preenchido';
            _mensagemErroCadastro();
          }
        } else {
          mensagemErro = 'A largura não foi preenchida';
          _mensagemErroCadastro();
        }
      } else {
        mensagemErro = 'A altura não foi preenchida!';
        _mensagemErroCadastro();
      }
    } else {
      mensagemErro = 'O comodo esta vaziu!';
      _mensagemErroCadastro();
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

//FUNÇÃO QUE ENVIA OS DADOS DE ENDEREÇO PARA NO BANCOs
  Future<dynamic> salvarDadosBanco() async {
    var altura = double.parse(controllerAltura.text);

    largura = double.parse(controllerLargura.text);
    marco = double.parse(controllerMarco.text);
    marco.toStringAsFixed(3);
    var obervacoes = controllerObservacoes.text;

    cor = controllerCor.text;
    var bodyy = jsonEncode({
      'IdUsuario': Usuario.idUsuario,
      'IdGrupo_Medidas': GrupoMediddas.idGrupoMedidas,
      'IdCod_Referencia': idCodRef,
      'IdPivotante': idRolPivotante,
      'IdDobradica': idDobradica,
      'IdFechadura': idFechadura,
      'Altura': altura,
      'Lado_Abertura': portaAbre,
      'Tipo_Porta': tipoPorta,
      'Estrutura_Porta': estruturaPorta,
      'Cor': cor,
      'Largura': largura,
      'Localizacao': localizacao,
      'Marco_Parede': marco,
      'Comodo': controllerComodo.text,
      'Observacoes': obervacoes,
      'Tipo_Medida': 'Especifica',
    });
    print(bodyy);
    http.post(
      UrlServidor + CadastrarMedidaUnt,
      headers: {"Content-Type": "application/json"},
      body: bodyy,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastrar dados para a porta'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          child: Column(
            children: [
              // CAMPO COMODO
              CampoText().textField(
                controllerComodo,
                'Comodo:',
                icone: Icons.assignment_late,
                confPadding:
                    EdgeInsets.only(top: 15, left: 10, right: 10, bottom: 5),
              ),
              CampoText().textField(
                controllerAltura,
                'Altura:',
                tipoTexto: TextInputType.number,
                icone: Icons.format_line_spacing,
              ),
              CampoText().textField(
                controllerLargura,
                'Largura:',
                tipoTexto: TextInputType.number,
                icone: Icons.format_line_spacing,
              ),
              CampoText().textField(
                controllerMarco,
                'Espessura do Marco:',
                tipoTexto: TextInputType.number,
                icone: Icons.format_line_spacing,
              ),
              Padding(
                padding: EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
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
                padding: EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
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
                padding: EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
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
                                              fontWeight: FontWeight.bold,
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
                                              fontWeight: FontWeight.bold,
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
                                              fontWeight: FontWeight.bold,
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
                                              fontWeight: FontWeight.bold,
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
                                            localizacao = 'Lavanderia';
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
                padding:
                    EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Porta abre para o lado:',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        Container(
                          alignment: Alignment.center,
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: CheckboxListTile(
                                    title: Text(
                                      'Direito',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                    key: Key('check1'),
                                    value: checkladoportadentro,
                                    onChanged: (bool valor) {
                                      setState(() {
                                        checkladoportadentro = valor;
                                        checkladoportafora = false;
                                        portaAbre = 'Direita';
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
                                    key: Key('check2'),
                                    activeColor: Colors.blue,
                                    value: checkladoportafora,
                                    onChanged: (bool valor) {
                                      setState(() {
                                        checkladoportafora = valor;
                                        checkladoportadentro = false;
                                        portaAbre = 'Esquedo';
                                      });
                                    }),
                              )
                            ],
                          ),
                        ),
                      ],
                    )),
              ),
              CampoText().textField(
                controllerCor,
                'Cor da porta',
                tipoTexto: TextInputType.text,
                icone: Icons.format_line_spacing,
              ),
              chamarWidgetDobradica(),
              chamarWidgetPivotante(),
              Padding(
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
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            'Tipo de Fechadura:',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border:
                                  Border.all(color: Colors.black, width: 1)),
                          child: DropdownButton(
                              hint: Text(
                                'Tipo de Fechadura',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              value: idFechadura,
                              items: itensLista.map((categoria) {
                                return DropdownMenuItem(
                                    value: (categoria['IdFechadura']),
                                    child: Row(
                                      children: [
                                        Text(
                                          categoria['IdFechadura'].toString(),
                                          style: TextStyle(fontSize: 18),
                                        ),
                                        Text(
                                          ' - ',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                        Text(
                                          categoria['nome'],
                                          style: TextStyle(fontSize: 18),
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
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            'Cod Referencia',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border:
                                  Border.all(color: Colors.black, width: 1)),
                          child: DropdownButton(
                              hint: Text(
                                'Cod Referencia',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              value: idCodRef,
                              items: itensLista1.map((categoria) {
                                return DropdownMenuItem(
                                    value: (categoria['IdCod_Referencia']),
                                    child: Row(
                                      children: [
                                        Text(
                                          ' R- ',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                        Text(
                                          categoria['Codigo'],
                                          style: TextStyle(fontSize: 18),
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
              // CAMPO OBSERVAÇÕES
              CampoText().textField(
                controllerObservacoes,
                'OBS:',
                tipoTexto: TextInputType.multiline,
                icone: Icons.format_line_spacing,
              ),
              //BOTAO PADRAO
              Botao().botaoPadrao(
                'Salvar Medidas',
                () {
                  validarCampos(); // fecha a tela de cadastro
                },
                Color(0XFFD1D6DC),
              )
            ],
          ),
        ),
      ),
    );
  }
}
