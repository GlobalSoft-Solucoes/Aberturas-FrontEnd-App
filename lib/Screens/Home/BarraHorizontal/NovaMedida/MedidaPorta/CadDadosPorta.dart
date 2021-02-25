import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:projeto_aberturas/Funcoes/FuncoesParaDatas.dart';
import 'package:projeto_aberturas/Models/Models_Usuario.dart';
import 'package:projeto_aberturas/Models/constantes.dart';
import 'package:projeto_aberturas/Static/Static_GrupoMedidas.dart';
import 'package:projeto_aberturas/Static/Static_TipoPorta.dart';
import 'package:projeto_aberturas/Static/Static_Usuario.dart';
import 'package:projeto_aberturas/Widget/Botao.dart';
import 'package:projeto_aberturas/Widget/Crud_DataBase.dart';
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
    this.buscardadosFechadura();
    this.buscarDadosCodReferencia();
    this.buscarDadosDobradica();
    this.buscarDadosPivotante();
    this.buscarDadosTipoPorta();
  }

//CONTROLADORES DOS TEXTFIELDS
  TextEditingController controllerComodo = TextEditingController();
  TextEditingController controllerObservacoes = TextEditingController();
  TextEditingController controllerAlturaFolha = TextEditingController();
  TextEditingController controllerCor = TextEditingController();
  TextEditingController controllerLarguraFolha = TextEditingController();
  TextEditingController controllerMarco = TextEditingController();
  TextEditingController controllerNumeroPorta = TextEditingController();

  bool giro = false;
  bool correr = false;
  bool pivotante = false;
  bool vaiEVem = false;
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

  double totalAltura;
  double totalLargura;

  List itensListaFechadura = List();
  List itensListaCodReferencia = List();
  List itensListaDobradica = List();
  List itensListaPivotante = List();
  List itensListaTipoPorta = List();

  int idCodRef;
  int idFechadura;
  int idDobradica;
  int idRolPivotante;
  double altura;

  //verifica o check de lado da fechadura
  bool checkladoportafora = false;
  bool checkladoportadentro = false;
  String portaAbre = "";
  var branca = false;
  var verniz = false;
  var semPintura = false;
  var vernizDec = false;

//verifica o check de lado da porta
  var mensagemErro = '';

  _mensagemErroCadastro() {
    MsgPopup().msgFeedback(
      context,
      '\n' + mensagemErro,
      'Aviso',
    );
  }

  //Mascara dos campos
  var mascaraLargura = new MaskTextInputFormatter(
      mask: '#.#####', filter: {"#": RegExp(r'[0-9]')});
  var mascaraAltura = new MaskTextInputFormatter(
      mask: '*.*****', filter: {"*": RegExp(r'[0-9]')});
  var mascaraMarco = new MaskTextInputFormatter(
      mask: '#.#####', filter: {"#": RegExp(r'[0-9]')});

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
    final response = await http.get(Uri.encodeFull(ListarTodosCodReferencia),
        headers: {"authorization": ModelsUsuarios.tokenAuth});
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
    final response = await http.get(Uri.encodeFull(ListarTodosDobradica),
        headers: {"authorization": ModelsUsuarios.tokenAuth});
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
    final response = await http.get(Uri.encodeFull(ListarTodosPivotante),
        headers: {"authorization": ModelsUsuarios.tokenAuth});
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

  //BUSCA TODOS OS PIVOTANTES
  Future buscarDadosTipoPorta() async {
    final response = await http.get(Uri.encodeFull(ListarTodosTipoPorta),
        headers: {"authorization": ModelsUsuarios.tokenAuth});
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      setState(() {
        itensListaTipoPorta = jsonData;
      });
    }
    if (response.statusCode == 401) {
      Navigator.pushNamed(context, '/Login');
    }
  }

  // Future buscarDadosTipoPortaPorId() async {
  //   final response = await http.get(
  //       Uri.encodeFull(ListarTodosTipoPorta),
  //       headers: {"authorization": ModelsUsuarios.tokenAuth});
  //   if (response.statusCode == 200) {
  //     var jsonData = json.decode(response.body);
  //     setState(() {
  //       itensListaTipoPorta = jsonData;
  //     });
  //   }
  //   if (response.statusCode == 401) {
  //     Navigator.pushNamed(context, '/Login');
  //   }
  // }

  validarCampos() async {
    var comodo = controllerComodo.text;
    if (pivotante == true && idRolPivotante == null) {
      mensagemErro = 'o pivotante não foi selecionado';
      _mensagemErroCadastro();
    } else if ((giro == true || vaiEVem == true) && idDobradica == null) {
      mensagemErro = 'A dobradiça não foi selecionada';
      _mensagemErroCadastro();
    } else if (comodo.isEmpty) {
      mensagemErro = 'O comodo esta vazio!';
      _mensagemErroCadastro();
    } else if (controllerAlturaFolha.text.trim().isEmpty) {
      mensagemErro = 'A altura não foi preenchida!';
      _mensagemErroCadastro();
    } else if (controllerLarguraFolha.text.trim().isEmpty) {
      mensagemErro = 'A largura não foi preenchida';
      _mensagemErroCadastro();
    } else if (controllerMarco.text.trim().isEmpty) {
      mensagemErro = 'a espessura do marco não foi preenchido';
      _mensagemErroCadastro();
    } else if (tipoPorta.length < 1) {
      mensagemErro = 'O tipo da porta não foi escolhido!';
      _mensagemErroCadastro();
    } else if (estruturaPorta.length < 1) {
      mensagemErro = 'A estrutura que compõem a porta não foi escolhida!';
      _mensagemErroCadastro();
    } else if (localizacao.length < 1) {
      mensagemErro = 'A localização da porta não foi escolhida';
      _mensagemErroCadastro();
    } else if (portaAbre.length < 1) {
      mensagemErro = 'O lado de abertura da porta não foi escolhido!';
      _mensagemErroCadastro();
    } else if (cor.isEmpty) {
      mensagemErro = 'Você precisa preencher uma cor para a porta!';
      _mensagemErroCadastro();
    } else if (idFechadura == null) {
      mensagemErro = 'Você precisa escolher uma fechadura!';
      _mensagemErroCadastro();
    } else if (idCodRef == null) {
      mensagemErro = 'Você precisa selecionar um codigo de referência';
      _mensagemErroCadastro();
    } else {
      // Navigator.of(context).pop();
      await salvarDadosBanco();
    }
  }

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
                    items: itensListaPivotante.map(
                      (categoria) {
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
                          ),
                        );
                      },
                    ).toList(),
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
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
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

//FUNÇÃO QUE ENVIA OS DADOS DE ENDEREÇO PARA NO BANCOs
  Future<dynamic> salvarDadosBanco() async {
    altura = double.tryParse(controllerAlturaFolha.text);
    largura = double.tryParse(controllerLarguraFolha.text);
    marco = double.tryParse(controllerMarco.text);
    var obervacoes = controllerObservacoes.text;

    var bodyy = jsonEncode(
      {
        'idusuario': usuario.idUsuario,
        'idgrupo_medidas': GrupoMedidas.idGrupoMedidas,
        'idcod_referencia': idCodRef,
        'idpivotante': idRolPivotante,
        'iddobradica': idDobradica,
        'idfechadura': idFechadura,
        'data_cadastro': DataAtual().pegardata() as String,
        'hora_cadastro': DataAtual().pegarHora() as String,
        'altura_folha': totalAltura.toStringAsPrecision(4),
        'largura_folha': totalLargura.toStringAsPrecision(4),
        'altura_externa': 4,
        // double.tryParse(controllerAlturaFolha.text).toStringAsPrecision(4),
        'largura_externa': 4,
        // double.tryParse(controllerLarguraFolha.text).toStringAsPrecision(4),
        'lado_abertura': portaAbre,
        'tipo_porta': tipoPorta,
        'estrutura_porta': estruturaPorta,
        'cor': cor,
        'localizacao': localizacao,
        'marco_parede': marco,
        'comodo': controllerComodo.text,
        'observacoes': obervacoes,
        'tipo_medida': 'Especifica',
        'numero_porta': controllerNumeroPorta.text,
      },
    );

    ReqDataBase().requisicaoPost(CadastrarMedidaUnt, bodyy);
    
    if (ReqDataBase.responseReq.statusCode == 200) {
      Navigator.pop(context);
    }
    else if (ReqDataBase.responseReq.statusCode == 401) {
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
                        padding: EdgeInsets.only(left: size.width * 0.17),
                        child: Text(
                          'Porta específica',
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
                    // ========= campo número ==========
                    CampoText().textField(
                      controllerNumeroPorta,
                      'Número da porta:',
                      icone: Icons.confirmation_number,//confirmation_number, //confirmation_num,
                      confPadding: EdgeInsets.only(
                           left: 10, right: 10, bottom: 5),
                      tipoTexto: TextInputType.number,
                    ),
                    // CAMPO COMODO
                    CampoText().textField(
                      controllerComodo,
                      'Comodo:',
                      icone: Icons.assignment_late,
                    ),
                    CampoText().textFieldComMascara(
                      controllerAlturaFolha,
                      'Altura:',
                      tipoTexto: TextInputType.number,
                      icone: Icons.height, //format_line_spacing,
                      mascara: mascaraAltura,
                    ),
                    CampoText().textFieldComMascara(
                      controllerLarguraFolha,
                      'Largura:',
                      tipoTexto: TextInputType.number,
                      icone: Icons.horizontal_rule_outlined,//west_outlined,
                      mascara: mascaraLargura,
                    ),
                    CampoText().textFieldComMascara(
                      controllerMarco,
                      'Espessura do marco:',
                      tipoTexto: TextInputType.number,
                      icone: Icons.format_line_spacing,
                      mascara: mascaraMarco,
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
                              'Tipo de Porta',
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
                                          key: Key('check1'),
                                          value: giro,
                                          onChanged: (bool valor) {
                                            setState(
                                              () {
                                                giro = valor;
                                                correr = false;
                                                pivotante = false;
                                                vaiEVem = false;
                                                tipoPorta = 'Giro';
                                                totalAltura = double.tryParse(
                                                        controllerAlturaFolha
                                                            .text) -
                                                    0.03; //altura - 0.3;
                                                totalLargura = double.tryParse(
                                                        controllerLarguraFolha
                                                            .text) -
                                                    0.04; //largura - 0.4;
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
                                                totalAltura = double.tryParse(
                                                        controllerAlturaFolha
                                                            .text) -
                                                    0.08;
                                                totalLargura = double.tryParse(
                                                        controllerLarguraFolha
                                                            .text) +
                                                    0.02;
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
                                                totalAltura = double.tryParse(
                                                        controllerAlturaFolha
                                                            .text) -
                                                    0.042;
                                                totalLargura = double.tryParse(
                                                        controllerLarguraFolha
                                                            .text) -
                                                    0.07;
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
                                                totalAltura = double.tryParse(
                                                        controllerAlturaFolha
                                                            .text) -
                                                    0.042;
                                                totalLargura = double.tryParse(
                                                        controllerLarguraFolha
                                                            .text) -
                                                    0.032;
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
                              'Estrutura da porta',
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
                                            estruturaPorta = 'Semi-oca';
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
                                        setState(
                                          () {
                                            solida = valor;
                                            oca = false;
                                            semioca = false;
                                            estruturaPorta = 'Solida';
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
                                            setState(
                                              () {
                                                interno = valor;
                                                externo = false;
                                                wc = false;
                                                lavanderia = false;
                                                localizacao = 'Interna';
                                              },
                                            );
                                          },
                                        ),
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
                              'Porta abre para o lado:',
                              style: TextStyle(
                                fontSize: 20,
                              ),
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
                                        setState(
                                          () {
                                            checkladoportafora = valor;
                                            checkladoportadentro = false;
                                            portaAbre = 'Esquedo';
                                          },
                                        );
                                      },
                                    ),
                                  )
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
                              'Cor da porta',
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
                                                semPintura = false;
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
                                                semPintura = false;
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
                                                semPintura = false;
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
                                          value: semPintura,
                                          onChanged: (bool valor) {
                                            setState(
                                              () {
                                                verniz = false;
                                                branca = false;
                                                vernizDec = false;
                                                semPintura = valor;
                                                cor = 'Sem Pintura';
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
                    chamarWidgetDobradica(),
                    chamarWidgetPivotante(),
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
                                  items: itensListaFechadura.map(
                                    (categoria) {
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
                                        ),
                                      );
                                    },
                                  ).toList(),
                                  onChanged: (value) {
                                    setState(
                                      () {
                                        idFechadura = value;
                                      },
                                    );
                                  },
                                ),
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
                                  items: itensListaCodReferencia.map(
                                    (categoria) {
                                      return DropdownMenuItem(
                                        value: (categoria['idcod_referencia']),
                                        child: Row(
                                          children: [
                                            Text(
                                              ' R- ',
                                              style: TextStyle(fontSize: 18),
                                            ),
                                            Text(
                                              categoria['codigo'],
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
                                        idCodRef = value;
                                      },
                                    );
                                  },
                                ),
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
                      icone: Icons.comment_sharp,
                    ),
                    //BOTAO PADRAO
                    Container(
                      padding: EdgeInsets.only(top: 30, bottom: 40),
                      child: Botao().botaoPadrao(
                        'Salvar medida',
                        () {
                          validarCampos(); // fecha a tela de cadastro
                        },
                        Color(0XFFD1D6DC),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
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
