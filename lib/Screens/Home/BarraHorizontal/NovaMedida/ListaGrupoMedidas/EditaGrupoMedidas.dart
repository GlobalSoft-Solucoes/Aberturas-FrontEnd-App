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
import 'package:projeto_aberturas/Widget/TextField.dart';
import 'ListaGruposCadastrados.dart';

//NESTA TELA E FEITO O CADASTRO DE ENDEREÇOS
class EditaGrupoMedidas extends StatefulWidget {
  @override
  _EditaGrupoMedidasState createState() => _EditaGrupoMedidasState();
}
// Classe que gera um array de imóveis

class _EditaGrupoMedidasState extends State<EditaGrupoMedidas> {
  // ATRIBUI VALORES INICIAIS DO GRUPO SELECIONADO PARA CADA CONTROLLER
  TextEditingController controllerEndereco =
      TextEditingController(text: GrupoMedidas.endereco);
  TextEditingController controllerTipoImovel =
      TextEditingController(text: GrupoMedidas.idImovel.toString());
  TextEditingController controllerNumeroEnd =
      TextEditingController(text: GrupoMedidas.numEndereco.toString());
  TextEditingController controllerPropEnd =
      TextEditingController(text: GrupoMedidas.proprietario);
  TextEditingController controllerCidade =
      TextEditingController(text: GrupoMedidas.cidade);
  TextEditingController controllerBairro =
      TextEditingController(text: GrupoMedidas.bairro);
  List itensLista = List();
  int _selectedField = GrupoMedidas.idImovel;

//ESTA FUNÇÃO BUSCA A LISTA DOS TIPOS DE IMOVEIS
  Future fetchPost() async {
    final response = await http.get(
      Uri.encodeFull(ListarTodosImoveis),
      headers: {"authorization": ModelsUsuarios.tokenAuth},
    );
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      setState(
        () {
          itensLista = jsonData;
        },
      );
    }
    if (response.statusCode == 401) {
      Navigator.pushNamed(context, '/Login');
    }
  }

// ======== POPUP DE CONFIRMAÇÃO PARA ALTERAÇÃO DAS INFORMAÇÕES DO GRUPO =========
  _confirmarAlteracoes() {
    MsgPopup().msgComDoisBotoes(
      context,
      'Deseja salvar as alterações feitas?',
      'Não',
      'Sim',
      () {
        Navigator.pop(context); // Fecha o popup
        Navigator.pop(context); // Fecha a tela de edição do grupo
        Navigator.pushNamed(context, '/ListaGrupoMedidas');
      },
      () async {
        await editarDadosGrupo();
        Navigator.pop(context); // Fecha o popup
        Navigator.push(context, // Fecha a tela de edição do grupo
            MaterialPageRoute(builder: (BuildContext context) {
          return ListaGrupoMedidas();
        }));
      },
      corBotaoEsq: Color(0XFFF4485C),
      corBotaoDir: Color(0XFF0099FF),
      sairAoPressionar: true,
    );
  }

  //======== Salva os dados editados no banco de dados =========
  Future<dynamic> editarDadosGrupo() async {
    var imovelSelecionado = _selectedField;
    var bodyy = jsonEncode(
      {
        'idUsuario': usuario.idUsuario,
        'idImovel': imovelSelecionado,
        'cidade': controllerCidade.text,
        'bairro': controllerBairro.text,
        'endereco': controllerEndereco.text,
        'proprietario': controllerPropEnd.text,
        'num_endereco': controllerNumeroEnd.text
      },
    );

    var response = await http.put(
      EditarGrupoMedidas + GrupoMedidas.idGrupoMedidas.toString(),
      headers: {
        "Content-Type": "application/json",
        "authorization": ModelsUsuarios.tokenAuth
      },
      body: bodyy,
    );
    if (response.statusCode == 401) {
      Navigator.pushNamed(context, '/Login');
    }
  }

// ============= VERIFICA SE HOUVE ALTERAÇÕES NO CADASTRO DO GRUPO ==============
  _verificaSeHouveAlteracoes() {
    if (controllerEndereco.text != GrupoMedidas.endereco ||
        controllerCidade.text != GrupoMedidas.cidade ||
        controllerBairro.text != GrupoMedidas.bairro ||
        controllerNumeroEnd.text != GrupoMedidas.numEndereco.toString() ||
        controllerPropEnd.text != GrupoMedidas.proprietario ||
        _selectedField != GrupoMedidas.idImovel) {
      _confirmarAlteracoes();
    } else {
      Navigator.pop(context); // Fecha a tela de edição do grupo
      Navigator.pushNamed(context, '/ListaGrupoMedidas');
    }
  }

  _popupMensagemErro() {
    MsgPopup().msgFeedback(context, mensagemErro, '');
  }

  var mensagemErro = '';
  //VALIDA OS CAMPOS E REDIRECIONA PARA VER A LISTA DOS ENDERECOS CADASTRADOS
  validarCampos() async {
    var endereco = controllerEndereco.text;
    var numeroEnd = controllerNumeroEnd.text;
    var proprietarioEnd = controllerPropEnd.text;
    var cidade = controllerCidade.text;
    var bairro = controllerBairro.text;

    if (endereco.isEmpty) {
      mensagemErro = 'O endereço não pode ficar em branco!';
      _popupMensagemErro();
    } else if (numeroEnd.isEmpty && numeroEnd.length < 1) {
      mensagemErro = 'Campo número não pode ficar em branco!';
      _popupMensagemErro();
    } else if (proprietarioEnd.isEmpty) {
      mensagemErro = 'O proprietário não pode ficar vazio';
      _popupMensagemErro();
    } else if (cidade.isEmpty) {
      mensagemErro = 'Campo cidade não pode ficar vazio!';
      _popupMensagemErro();
    } else if (bairro.isEmpty) {
      mensagemErro = 'Campo bairro não pode estar vazio!';
      _popupMensagemErro();
    } else {
      mensagemErro = '';
      _verificaSeHouveAlteracoes();
    }
  }

  @override
  void initState() {
    super.initState();
    this.fetchPost();
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: new Scaffold(
        appBar: AppBar(
          title: Text('Edição do Grupo de Medidas'),
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
                      left: 10,
                      right: 10,
                      top: 35,
                      bottom: 5,
                    ),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.black),
                      ),
                      child: new Column(
                        children: <Widget>[
                          // ================== CAMPO CIDADE ====================
                          CampoText().textField(
                            controllerCidade,
                            'cidade:',
                            icone: Icons.location_city,
                            fontSize: 18,
                            confPadding:
                                EdgeInsets.only(top: 30, left: 10, right: 10),
                          ),
                          // ================= CAMPO BAIRRO ==================
                          CampoText().textField(
                            controllerBairro,
                            'bairro:',
                            icone: Icons.business,
                            fontSize: 18,
                            confPadding:
                                EdgeInsets.only(top: 25, left: 10, right: 10),
                          ),
                          // ================= CAMPO ENDEREÇO ==================
                          CampoText().textField(
                            controllerEndereco,
                            'Endereço:',
                            icone: Icons.account_balance,
                            fontSize: 18,
                            confPadding:
                                EdgeInsets.only(top: 25, left: 10, right: 10),
                          ),
                          // ================= CAMPO NÚMERO ==================
                          CampoText().textField(
                            controllerNumeroEnd,
                            'Número:',
                            tipoTexto: TextInputType.number,
                            icone: Icons.format_list_numbered,
                            fontSize: 18,
                            confPadding:
                                EdgeInsets.only(top: 25, left: 10, right: 10),
                          ),
                          // ============= CAMPO PROPRIETÁRIO ==============
                          CampoText().textField(
                            controllerPropEnd,
                            'Proprietário:',
                            icone: Icons.account_circle,
                            fontSize: 18,
                            confPadding:
                                EdgeInsets.only(top: 25, left: 10, right: 10),
                          ),
                          // =================== TIPO DE IMÓVEL ====================
                          new Padding(
                            padding: const EdgeInsets.only(
                                top: 25, left: 10, right: 10),
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
                                  'Tipo de imovel',
                                  style: TextStyle(fontSize: 18),
                                ),
                                value: _selectedField,
                                items: itensLista.map(
                                  (categoria) {
                                    return DropdownMenuItem(
                                      value: (categoria['idimovel']),
                                      child: Row(
                                        children: [
                                          Text(
                                            categoria['idimovel'].toString(),
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
                                      _selectedField = value;
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                          //--------------------------------------------------
                          Padding(
                            padding: EdgeInsets.only(top: 40, bottom: 15),
                            child: Botao().botaoPadrao(
                              'Confirmar',
                              () => {
                                validarCampos(),
                              },
                              Color(0XFFD1D6DC),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          //--------------------------------------------------
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
