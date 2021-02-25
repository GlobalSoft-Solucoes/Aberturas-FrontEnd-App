import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:projeto_aberturas/Funcoes/FuncoesParaDatas.dart';
import 'package:projeto_aberturas/Models/Models_Usuario.dart';
import 'package:projeto_aberturas/Models/constantes.dart';
import 'package:projeto_aberturas/Static/Static_GrupoMedidas.dart';
import 'package:projeto_aberturas/Static/Static_Usuario.dart';
import 'package:projeto_aberturas/Widget/Botao.dart';
import 'package:projeto_aberturas/Widget/Crud_DataBase.dart';
import 'package:projeto_aberturas/Widget/MsgPopup.dart';
import 'package:projeto_aberturas/Widget/TextField.dart';
import 'package:http/http.dart' as http;

class CadPortaPadrao extends StatefulWidget {
  @override
  _CadPortaPadraoState createState() => _CadPortaPadraoState();
}

class _CadPortaPadraoState extends State<CadPortaPadrao> {
  TextEditingController controllerComodo = TextEditingController();
  TextEditingController controllerNumeroPorta = TextEditingController();

  var alturaPadrao = false;
  var largura094 = false;
  var largura084 = false;
  var largura074 = false;
  var marco008 = false;
  var marco010 = false;
  var giro = false;
  var correr = false;
  var pivotante = false;
  var vaiEVem = false;
  var oca = false;
  var semioca = false;
  var solida = false;
  var branca = false;
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

  double larguraFolha;
  double larguraExterna;

  List itensListaFechadura = List();
  List itensListaCodReferencia = List();
  List itensListaDobradica = List();
  List itensListaPivotante = List();

  int idCodRef;
  int idFechadura;
  int idDobradica;
  int idRolPivotante;
  double alturaExterna;
  double alturaFolha;

  var vernizDec = false;
  var sempintura = false;
//CHAMA AS FUNÇÕES QUANDO INICIAR A TELA
  @override
  void initState() {
    super.initState();
    this.buscardadosFechadura();
    this.buscarDadosCodReferencia();
    this.buscarDadosDobradica();
    this.buscarDadosPivotante();
  }

  Future<dynamic> salvarDadosBanco() async {
    var bodyy = jsonEncode({
      'idusuario': usuario.idUsuario,
      'idgrupo_medidas': GrupoMedidas.idGrupoMedidas,
      'idcod_referencia': idCodRef,
      'idpivotante': idRolPivotante,
      'iddobradica': idDobradica,
      'altura_folha': alturaFolha.toStringAsPrecision(4),
      'largura_folha': larguraFolha.toStringAsPrecision(4),
      'altura_externa': alturaExterna.toStringAsPrecision(4),
      'largura_externa': larguraExterna.toStringAsPrecision(4),
      'lado_abertura': aberturaPorta,
      'idfechadura': idFechadura,
      'tipo_porta': tipoPorta,
      'estrutura_porta': estruturaPorta,
      'localizacao': localizacao,
      'cor': cor,
      'marco_parede': marco,
      'comodo': controllerComodo.text,
      'tipo_medida': 'Padrao',
      'numero_porta': controllerNumeroPorta.text,
      'data_cadastro': DataAtual().pegardata() as String,
      'hora_cadastro': DataAtual().pegarHora() as String,
    });
    ReqDataBase().requisicaoPost(CadastrarMedidaUnt, bodyy);

    print(ReqDataBase.responseReq.statusCode);
    if (ReqDataBase.responseReq.statusCode == 200) {
      Navigator.pop(context);
    } else if (ReqDataBase.responseReq.statusCode == 401) {
      Navigator.pushNamed(context, '/Login');
    }
  }

  var mensagemErro = '';
  validarCampos() {
    if (pivotante == true && idRolPivotante == null) {
      mensagemErro = 'o pivotante não foi selecionado';
      _mensagemErroCadastro();
    } else if ((giro == true || vaiEVem == true) && idDobradica == null) {
      mensagemErro = 'A dobradiça não foi selecionada';
      _mensagemErroCadastro();
    } else if (alturaExterna == 0) {
      mensagemErro = 'A altura não foi selecionada';
      _mensagemErroCadastro();
    } else if (aberturaPorta == '') {
      mensagemErro = 'O lado de abertura da porta não foi selecionado!';
      _mensagemErroCadastro();
    } else if (idFechadura == null) {
      mensagemErro = 'A fechadura não foi selecionada!';
      _mensagemErroCadastro();
    } else if (idCodRef == null) {
      mensagemErro = 'o codReferencia é nulo';
      _mensagemErroCadastro();
    } else if (tipoPorta == '') {
      mensagemErro = 'O tipo da porta não foi selecionado!';
      _mensagemErroCadastro();
    } else if (estruturaPorta == '') {
      mensagemErro = 'O tipo de estrutura da porta não foi selecionado!';
      _mensagemErroCadastro();
    } else if (larguraExterna == 0) {
      mensagemErro = 'A largura da porta não foi selecionada!';
      _mensagemErroCadastro();
    } else if (localizacao == '') {
      mensagemErro = 'A localização da porta não foi selecionada!';
      _mensagemErroCadastro();
    } else if (cor == '') {
      mensagemErro = 'A cor não foi selecionada!';
      _mensagemErroCadastro();
    } else if (marco == 0) {
      mensagemErro = 'o marco não foi selecionado!';
      _mensagemErroCadastro();
    } else if (controllerComodo.text.length < 3) {
      mensagemErro = 'o comodo é curto ou esta vazio';
      _mensagemErroCadastro();
    } else {
      salvarDadosBanco();
      Navigator.pop(context);
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
                    'Rol pivotante',
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
                      'Rol pivotante',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    value: idRolPivotante,
                    items: itensListaPivotante.map((categoria) {
                      return DropdownMenuItem(
                          value: (categoria['idpivotante']),
                          child: Row(
                            children: [
                              Text(
                                categoria['idpivotante'].toString(),
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
                      setState(
                        () {
                          idRolPivotante = value;
                          idDobradica = null;
                        },
                      );
                    },
                  ),
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
    if (giro == true || vaiEVem == true) {
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
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    value: idDobradica,
                    items: itensListaDobradica.map(
                      (categoria) {
                        return DropdownMenuItem(
                          value: (categoria['iddobradica']),
                          child: Row(
                            children: [
                              Text(
                                categoria['iddobradica'].toString(),
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
                          ),
                        );
                      },
                    ).toList(),
                    onChanged: (value) {
                      setState(
                        () {
                          idDobradica = value;
                          idRolPivotante = null;
                        },
                      );
                    },
                  ),
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
  Future buscardadosFechadura() async {
    final response = await http.get(
      Uri.encodeFull(ListarTodosFechadura),
      headers: {"authorization": ModelsUsuarios.tokenAuth},
    );
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      setState(() {
        itensListaFechadura = jsonData;
      });
    }
    if (response.statusCode == 401) {
      Navigator.pushNamed(context, '/Login');
    }
  }

//BUSCA TODOS OS COD REFERENCIA
  Future buscarDadosCodReferencia() async {
    final response = await http.get(
      Uri.encodeFull(ListarTodosCodReferencia),
      headers: {"authorization": ModelsUsuarios.tokenAuth},
    );
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      setState(() {
        itensListaCodReferencia = jsonData;
      });
    }
    if (response.statusCode == 401) {
      Navigator.pushNamed(context, '/Login');
    }
  }

//BUSCA TODAS AS DOBRADICAS
  Future buscarDadosDobradica() async {
    final response = await http.get(
      Uri.encodeFull(ListarTodosDobradica),
      headers: {"authorization": ModelsUsuarios.tokenAuth},
    );
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      setState(() {
        itensListaDobradica = jsonData;
      });
    }
    if (response.statusCode == 401) {
      Navigator.pushNamed(context, '/Login');
    }
  }

//BUSCA TODOS OS PIVOTANTES
  Future buscarDadosPivotante() async {
    final response = await http.get(
      Uri.encodeFull(ListarTodosPivotante),
      headers: {"authorization": ModelsUsuarios.tokenAuth},
    );
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      setState(() {
        itensListaPivotante = jsonData;
      });
    }
    if (response.statusCode == 401) {
      Navigator.pushNamed(context, '/Login');
    }
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    Size size = mediaQuery.size;
    return Scaffold(
      body: Container(
        color: Color(0xFFBCE0F0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    left: size.width * 0.01,
                    right: size.width * 0.02,
                    top: size.height * 0.025,
                    bottom: size.height * 0.02),
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        iconSize: 33,
                        color: Colors.white,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: size.width * 0.22),
                        child: Text(
                          'Porta padrão',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: size.width * 0.065,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    // ========= CAMPO NÚMERO DA PORTA =========
                    Container(
                      padding: EdgeInsets.only(
                        left: 0,
                        right: 0,
                        top: 5,
                      ),
                      child: CampoText().textField(
                        controllerNumeroPorta,
                        'Número da porta:',
                        icone: Icons.confirmation_number,
                        tipoTexto: TextInputType.number,
                      ),
                    ),
                    // ========= CAMPO COMODO =========
                    Container(
                      padding: EdgeInsets.only(
                        left: 0,
                        right: 0,
                        top: 5,
                        bottom: 3,
                      ),
                      child: CampoText().textField(controllerComodo, 'comodo:',
                          icone: Icons.home, tipoTexto: TextInputType.text),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.black),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Altura externa',
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
                                        setState(
                                          () {
                                            alturaPadrao = valor;
                                            alturaExterna = 2.13;
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.black),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Largura externa',
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
                                      value: largura094,
                                      onChanged: (bool valor) {
                                        setState(
                                          () {
                                            largura084 = false;
                                            largura074 = false;
                                            largura094 = valor;
                                            larguraExterna = 0.94;
                                            print(larguraExterna);
                                          },
                                        );
                                      },
                                    ),
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
                                            largura094 = false;
                                            larguraExterna = 0.84;
                                            print(larguraExterna);
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
                                        setState(
                                          () {
                                            largura084 = false;
                                            largura074 = valor;
                                            largura094 = false;
                                            larguraExterna = 0.74;
                                            print(larguraExterna);
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.black),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Marco parede',
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
                                        setState(
                                          () {
                                            marco010 = valor;
                                            marco008 = false;
                                            marco = 0.10;
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // ===========================================================
                    Padding(
                      padding:
                          EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.black),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Tipo de porta',
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
                                            'Giro',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18),
                                          ),
                                          key: Key('check5'),
                                          value: giro,
                                          onChanged: (bool valor) {
                                            setState(
                                              () {
                                                giro = valor;
                                                correr = false;
                                                pivotante = false;
                                                vaiEVem = false;
                                                tipoPorta = 'Giro';
                                                alturaFolha =
                                                    alturaExterna - 0.03;
                                                larguraFolha =
                                                    larguraExterna - 0.04;
                                              },
                                            );
                                          },
                                        ),
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
                                            setState(
                                              () {
                                                correr = valor;
                                                giro = false;
                                                pivotante = false;
                                                vaiEVem = false;
                                                tipoPorta = 'Correr';
                                                alturaFolha =
                                                    alturaExterna - 0.08;
                                                larguraFolha =
                                                    larguraExterna + 0.02;
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: CheckboxListTile(
                                          title: Text(
                                            'pivotante',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18),
                                          ),
                                          key: Key('check7'),
                                          value: pivotante,
                                          onChanged: (bool valor) {
                                            setState(
                                              () {
                                                pivotante = valor;
                                                giro = false;
                                                correr = false;
                                                vaiEVem = false;
                                                tipoPorta = 'pivotante';
                                                alturaFolha =
                                                    alturaExterna - 0.042;
                                                larguraFolha =
                                                    larguraExterna - 0.07;
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                      Expanded(
                                        child: CheckboxListTile(
                                          title: Text(
                                            'Vai e Vem',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18),
                                          ),
                                          key: Key('check8'),
                                          value: vaiEVem,
                                          onChanged: (bool valor) {
                                            setState(
                                              () {
                                                pivotante = false;
                                                giro = false;
                                                correr = false;
                                                vaiEVem = valor;
                                                tipoPorta = 'Vai e Vem';
                                                alturaFolha =
                                                    alturaExterna - 0.042;
                                                larguraFolha =
                                                    larguraExterna - 0.032;
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // ===========================================================
                    Padding(
                      padding:
                          EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
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
                                            setState(
                                              () {
                                                externo = valor;
                                                interno = false;
                                                wc = false;
                                                lavanderia = false;
                                                localizacao = 'Externa';
                                              },
                                            );
                                          },
                                        ),
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
                                            setState(
                                              () {
                                                wc = valor;
                                                interno = false;
                                                externo = false;
                                                lavanderia = false;
                                                localizacao = 'Banheiro';
                                              },
                                            );
                                          },
                                        ),
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
                                            setState(
                                              () {
                                                lavanderia = valor;
                                                interno = false;
                                                externo = false;
                                                wc = false;
                                                localizacao = 'Lavanderia';
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
                      child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.black),
                          ),
                          child: Column(
                            children: [
                              Text(
                                'Estrutura porta',
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
                                          setState(
                                            () {
                                              oca = valor;
                                              semioca = false;
                                              solida = false;
                                              estruturaPorta = 'Oca';
                                            },
                                          );
                                        },
                                      ),
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
                      padding:
                          EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
                      child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.black),
                          ),
                          child: Column(
                            children: [
                              Text(
                                'cor da Porta',
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
                                                'Branca',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18),
                                              ),
                                              key: Key('check11'),
                                              value: branca,
                                              onChanged: (bool valor) {
                                                setState(() {
                                                  branca = valor;
                                                  verniz = false;
                                                  vernizDec = false;
                                                  sempintura = false;
                                                  cor = 'branca';
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
                                                  branca = false;
                                                  vernizDec = false;
                                                  sempintura = false;
                                                  cor = 'Verniz';
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
                                                'Verniz Decorado',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18),
                                              ),
                                              key: Key('check11'),
                                              value: vernizDec,
                                              onChanged: (bool valor) {
                                                setState(() {
                                                  branca = false;
                                                  verniz = false;
                                                  vernizDec = valor;
                                                  sempintura = false;
                                                  cor = 'Verniz Decorado';
                                                });
                                              }),
                                        ),
                                        Expanded(
                                          child: CheckboxListTile(
                                              title: Text(
                                                'Sem Pintura',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18),
                                              ),
                                              key: Key('check12'),
                                              value: sempintura,
                                              onChanged: (bool valor) {
                                                setState(() {
                                                  verniz = false;
                                                  branca = false;
                                                  vernizDec = false;
                                                  sempintura = valor;
                                                  cor = 'Sem Pintura';
                                                });
                                              }),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
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
                      padding:
                          EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
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
                                  'Tipo de fechadura:',
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
                                      'Tipo de fechadura',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    value: idFechadura,
                                    items: itensListaFechadura.map((categoria) {
                                      return DropdownMenuItem(
                                          value: (categoria['idfechadura']),
                                          child: Row(
                                            children: [
                                              Text(
                                                categoria['idfechadura']
                                                    .toString(),
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
                      padding:
                          EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
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
                                    items: itensListaCodReferencia
                                        .map((categoria) {
                                      return DropdownMenuItem(
                                          value:
                                              (categoria['idcod_referencia']),
                                          child: Row(
                                            children: [
                                              Text(
                                                ' - ',
                                                style: TextStyle(fontSize: 18),
                                              ),
                                              Text(
                                                'R-' + categoria['codigo'],
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
                    chamarWidgetDobradica(),
                    chamarWidgetPivotante(),
                    Padding(
                      padding: EdgeInsets.all(25),
                      child: Botao().botaoPadrao(
                        'Salvar',
                        () {
                          validarCampos();
                        },
                        Color(0XFFD1D6DC),
                        // Colors.blue[300],
                        corFonte: Colors.black,
                        fontWeight: FontWeight.w400,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
