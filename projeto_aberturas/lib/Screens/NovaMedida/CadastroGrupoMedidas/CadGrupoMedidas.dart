import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:projeto_aberturas/Models/Models_Usuario.dart';
import 'package:projeto_aberturas/Models/constantes.dart';
import 'package:projeto_aberturas/Static/Static_GrupoMedidas.dart';
import 'package:projeto_aberturas/Widget/Botao.dart';
import 'package:projeto_aberturas/Static/Static_Usuario.dart';
import 'package:projeto_aberturas/Widget/MsgPopup.dart';

//NESTA TELA E FEITO O CADASTRO DE ENDEREÇOS
class CadGrupoMedidas extends StatefulWidget {
  @override
  _CadGrupoMedidasState createState() => _CadGrupoMedidasState();
}
// Classe que gera um array de imóveis

class _CadGrupoMedidasState extends State<CadGrupoMedidas> {
  TextEditingController controllerEndereco = TextEditingController();
  TextEditingController controllerTipoImovel = TextEditingController();
  TextEditingController controllerNumeroEnd = TextEditingController();
  TextEditingController controllerPropEnd = TextEditingController();
  TextEditingController controllerCidade = TextEditingController();
  TextEditingController controllerBairro = TextEditingController();
  List itensLista = List();
  int _selectedField;
//ESTA FUNÇÃO BUSCA A LISTA DOS TIPOS DE IMOVEIS
  Future fetchPost() async {
    final response = await http.get(
      Uri.encodeFull(UrlServidor + ListarTodosImoveis),
      headers: {"authorization": ModelsUsuarios.tokenAuth},
    );
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      setState(() {
        itensLista = jsonData;
      });
    }
  }

  escolhaTelaNovaMedida() {
    MsgPopup().msgComDoisBotoes(
      context,
      'Qual tipo de porta deseja medir?',
      'Porta Especifica',
      'Porta Padrão',
      () {
        Navigator.of(context).pop(); // Fecha o popup de mensagem da escolha
        Navigator.of(context)
            .pop(); // Fecha o popup de do cadastro de grupo de medidas
        Navigator.pushNamed(context, '/CadDadosPorta');
      },
      () {
        Navigator.of(context).pop(); // Fecha o popup de mensagem da escolha
        Navigator.of(context)
            .pop(); // Fecha o popup de do cadastro de grupo de medidas
        Navigator.pushNamed(context, '/CadPortaPadrao');
      },
      corBotaoDir: Color(0XFFD1D6DC),
      corBotaoEsq: Color(0XFFD1D6DC),
      sairAoPressionar: true,
    );
  }

  var mensagemErro = '';
  //VALIDA OS CAMPOS E REDIRECIONA PARA VER A LISTA DOS ENDERECOS CADASTRADOS
  validarCampos() async {
    var endereco = controllerEndereco.text;
    var numeroEnd = controllerNumeroEnd.text;
    var proprietarioEnd = controllerPropEnd.text;
    var cidade = controllerCidade.text;
    var bairro = controllerBairro.text;
    if (endereco.isNotEmpty && endereco is String) {
      if (numeroEnd.isNotEmpty && numeroEnd.length > 1) {
        if (proprietarioEnd.isNotEmpty && proprietarioEnd is String) {
          if (cidade.isNotEmpty) {
            if (bairro.isNotEmpty) {
              setState(() {
                mensagemErro = '';
              });
              salvarDadosBanco();
            } else {
              setState(() {
                mensagemErro = 'O Bairro esta vazio!';
              });
            }
          } else {
            setState(() {
              mensagemErro = 'a Cidade esta vazia!';
            });
          }
        } else {
          setState(() {
            mensagemErro =
                'O proprietario não pode conter numeros ou ficar vazio';
          });
        }
      } else {
        setState(() {
          mensagemErro = 'O numero da casa/apartamento não pode ficar vazio';
        });
      }
    } else {
      setState(() {
        mensagemErro = 'O endereço não pode ficar em branco!';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    this.fetchPost();
  }

//FUNÇÃO QUE ENVIA OS DADOS DE ENDEREÇO PARA O BANCOs
  Future<dynamic> salvarDadosBanco() async {
    var endereco = controllerEndereco.text;
    var numeroend = controllerNumeroEnd.text;
    var proprietarioend = controllerPropEnd.text;
    var cidade = controllerCidade.text;
    var bairro = controllerBairro.text;
    var imovelSelecionado = _selectedField;
    var bodyy = jsonEncode({
      'idUsuario': Usuario.idUsuario,
      'idImovel': imovelSelecionado,
      'Cidade': cidade,
      'Bairro': bairro,
      'Endereco': endereco,
      'Proprietario': proprietarioend,
      'Num_Endereco': numeroend
    });

    await http.post(
      UrlServidor + CadastrarGrupoMedidas,
      headers: {"Content-Type": "application/json"},
      body: bodyy,
    );
    buscarIdGrupoMedidas();
  }

  Future<dynamic> buscarIdGrupoMedidas() async {
    final response = await http.get(
      Uri.encodeFull(UrlServidor + ListarUltimoIdGrupoCadastrado),
      headers: {"accept": "application/json"},
    );
    //IF(MOUNTED) É nescessario para não recarregar a arvore apos retornar das outras listas
    if (mounted)
      setState(
        () {
          var lista = json.decode(response.body);
          String retorno = lista.toString();
          // caso o retorno do Body for diferente de vazio("[]"), continua a execução
          if (retorno != "[]") {
            // Repara para mostra apenas o valor da chave primária
            String valorRetorno = retorno
                .substring(retorno.indexOf(':'), retorno.indexOf('}'))
                .replaceAll(':', '');

            // caso haja valor na variável, quer dizer que contém um registro
            if (valorRetorno.length > 0) {
              GrupoMedidas.idGrupoMedidas = int.parse(valorRetorno);
              escolhaTelaNovaMedida();
            }
          }
        },
      );
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: new Scaffold(
        appBar: AppBar(
          title: Text('Cadastro do Grupo de Medidas'),
          centerTitle: true,
          automaticallyImplyLeading: false,
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context)),
        ),
        body: SingleChildScrollView(
          child: Container(
            alignment: Alignment.center,
            child: Center(
              child: Column(
                children: [
                  //------------------------------------------------------------
                  Padding(
                    padding: EdgeInsets.only(
                        left: 10, right: 10, top: 25, bottom: 5),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.black),
                      ),
                      child: new Column(
                        children: <Widget>[
                          // ================== CAMPO CIDADE ====================
                          Material(
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: TextFormField(
                                  controller: controllerCidade,
                                  style: new TextStyle(
                                      fontSize: 18,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                  decoration: new InputDecoration(
                                      prefixIcon: new Icon(Icons.edit_location),
                                      labelText: 'Cidade:',
                                      border: new OutlineInputBorder(
                                          borderRadius:
                                              new BorderRadius.circular(
                                        10,
                                      )))),
                            ),
                          ),
                          // ================= CAMPO BAIRRO ==================
                          Material(
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: TextFormField(
                                  controller: controllerBairro,
                                  style: new TextStyle(
                                      fontSize: 18,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                  decoration: new InputDecoration(
                                      prefixIcon: new Icon(Icons.edit_location),
                                      labelText: 'Bairro:',
                                      border: new OutlineInputBorder(
                                          borderRadius:
                                              new BorderRadius.circular(
                                        10,
                                      )))),
                            ),
                          ),
                          // ================= CAMPO ENDEREÇO ==================
                          Material(
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: TextFormField(
                                  controller: controllerEndereco,
                                  style: new TextStyle(
                                      fontSize: 18,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                  decoration: new InputDecoration(
                                      prefixIcon: new Icon(Icons.edit_location),
                                      labelText: 'Endereço:',
                                      border: new OutlineInputBorder(
                                          borderRadius:
                                              new BorderRadius.circular(
                                        10,
                                      )))),
                            ),
                          ),

                          // ================= CAMPO NÚMERO ==================
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: TextFormField(
                                keyboardType: TextInputType.number,
                                controller: controllerNumeroEnd,
                                style: new TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                                decoration: new InputDecoration(
                                    prefixIcon:
                                        new Icon(Icons.format_list_numbered),
                                    labelText: 'Numero:',
                                    border: new OutlineInputBorder(
                                        borderRadius: new BorderRadius.circular(
                                      10,
                                    )))),
                          ),
                          // ============= CAMPO PROPRIETÁRIO ==============
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: TextFormField(
                                controller: controllerPropEnd,
                                style: new TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                                decoration: new InputDecoration(
                                    prefixIcon: new Icon(Icons.account_circle),
                                    labelText: 'Proprietário:',
                                    border: new OutlineInputBorder(
                                        borderRadius: new BorderRadius.circular(
                                      10,
                                    )))),
                          ),
                          // =================== TIPO DE IMÓVEL ====================
                          new Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: new Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Text(
                                'Tipo de imovel:',
                                style: TextStyle(fontSize: 18),
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
                                    'Tipo de Imovel',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  value: _selectedField,
                                  items: itensLista.map((categoria) {
                                    return DropdownMenuItem(
                                        value: (categoria['IdImovel']),
                                        child: Row(
                                          children: [
                                            Text(
                                              categoria['IdImovel'].toString(),
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
                                      _selectedField = value;
                                    });
                                  }),
                            ),
                          ),
                          //--------------------------------------------------
                          new Container(
                            padding: EdgeInsets.all(10),
                            child: Center(
                              child: Text(
                                mensagemErro,
                                style:
                                    TextStyle(color: Colors.red, fontSize: 20),
                              ),
                            ),
                          ),
                          //--------------------------------------------------

                          Padding(
                            padding: EdgeInsets.only(top: 5, bottom: 5),
                            child: Botao().botaoPadrao(
                              'Iniciar Medição',
                              () => {
                                // Navigator.of(context)
                                //     .pop(), // Fecha a tela de cadastro do grupo ao iniciar medição
                                validarCampos(),
                                Navigator.pushNamed(
                                    context, '/ListaGrupoMedidas'),
                              },
                              Color(0XFFD1D6DC),
                            ),
                          ),

                          Padding(
                            padding: EdgeInsets.only(top: 5, bottom: 5),
                            child: Botao().botaoPadrao(
                              'Salvar endereço',
                              () => {
                                Navigator.of(context)
                                    .pop(), // Fecha a tela de cadastro do grupo ao iniciar medição
                                validarCampos(),
                              },
                              Color(0XFFD1D6DC),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
