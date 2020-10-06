import 'package:flutter/material.dart';

//BOTAO PADRÃO PARA UTILIZAÇÃO GERAL
class Botao {
  botaoPadrao(label, ontap(), Color color, {tamanhoLetra}) {
    return GestureDetector(
        onTap: () {
          ontap();
        },
        child: Center(
          child: Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: Container(
              alignment: Alignment.center,
              height: 45,
              width: 320,
              decoration: BoxDecoration(
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      offset: Offset(3.0, 5.0),
                      blurRadius: 7)
                ],
                color: color,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.transparent,
                  width: 2,
                ),
              ),
              child: GestureDetector(
                onTap: () {
                  ontap();
                },
                child: Text(
                  label,
                  style: TextStyle(
                      fontSize: tamanhoLetra ?? 28,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                ),
              ),
            ),
          ),
        ));
  }
}
