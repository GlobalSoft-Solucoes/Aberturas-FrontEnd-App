import 'package:flutter/material.dart';

class CampoText {
  textField(nomeController, textoCampo,
      {double largura,
      double altura,
      confPadding,
      tipoTexto,
      bool campoSenha,
      icone,
      double raioBorda,
      bool enabled,
      valorInicial,
      mascara}) {
    return Center(
      child: Container(
        width: largura,
        height: altura,
        padding: confPadding ??
            EdgeInsets.only(top: 5, left: 10, right: 10, bottom: 5),
        child: TextFormField(
          inputFormatters: [mascara],
          initialValue: valorInicial ?? null,
          enabled: enabled ?? true,
          keyboardType: tipoTexto ?? TextInputType.text,
          controller: nomeController,
          obscureText: campoSenha ?? false,
          style: new TextStyle(
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
          decoration: new InputDecoration(
            prefixIcon: new Icon(icone),
            labelText: textoCampo,
            border: new OutlineInputBorder(
              borderRadius: new BorderRadius.circular(
                raioBorda ?? 10,
              ),
            ),
          ),
          onChanged: (value) {},
        ),
      ),
    );
  }
}

// Container(
//   color: Colors.blue[300],
//    width: double.infinity,
//    height: 10,
// ),
