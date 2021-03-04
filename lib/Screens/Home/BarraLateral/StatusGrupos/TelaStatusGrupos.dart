import 'package:flutter/material.dart';
import 'package:projeto_aberturas/Models/constantes.dart';
import 'package:projeto_aberturas/Static/Static_StatusGrupo.dart';

class StatusGrupo extends StatefulWidget {
  StatusGrupo({Key key}) : super(key: key);

  @override
  _StatusGrupoState createState() => _StatusGrupoState();
}

class _StatusGrupoState extends State<StatusGrupo> {
  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    Size size = mediaQuery.size;
    return Scaffold(
      backgroundColor: Color(0xFFb1b1b1),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/postit11.jpg"),
              fit: BoxFit.cover),
        ),
        child: Column(
          children: [
            Container(
              alignment: Alignment.bottomLeft,
              padding: EdgeInsets.only(top: size.height * 0.03, left: 10),
              child: Container(
                color: Colors.black38,
                width: size.width * 0.13,
                height: size.height * 0.06,
                child: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                  iconSize: 35,
                  color: Colors.white,
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      stops: [0.1, 0.3, 0.7, 1],
                      colors: [
                        Color(0xFF747474).withOpacity(0.8),
                        Color(0xFFb9b9b9).withOpacity(0.8),
                        Color(0xFFb9b9b9).withOpacity(0.8),
                        Color(0xFF747474).withOpacity(0.8),
                      ],
                    ),
                  ),
                  width: size.width * 0.1,
                  height: size.width * 0.3,
                  margin: EdgeInsets.only(
                      left: 15, right: 15, top: size.height * 0.09),
                  child: GestureDetector(
                    onTap: () {
                      StatusGrupos.escolhaStatus = ListarGruposCadastrados.toString();
                      StatusGrupos.tituloTela = 'Endereços cadastrados';
                      Navigator.pushNamed(context, '/ListaGrupoSelecionado');
                    },
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        'Cadastrados',
                        style: TextStyle(
                          fontSize: size.width * 0.07,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      stops: [0.1, 0.3, 0.7, 1],
                      colors: [
                        Color(0xFF747474).withOpacity(0.8),
                        Color(0xFFb9b9b9).withOpacity(0.8),
                        Color(0xFFb9b9b9).withOpacity(0.8),
                        Color(0xFF747474).withOpacity(0.8),
                      ],
                    ),
                  ),
                  height: size.width * 0.3,
                  margin: EdgeInsets.only(left: 15, right: 15),
                  child: GestureDetector(
                    onTap: () {
                      StatusGrupos.escolhaStatus = ListarGruposFinalizados.toString();
                      StatusGrupos.tituloTela = 'Endereços finalizados';
                      Navigator.pushNamed(context, '/ListaGrupoSelecionado');
                    },
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        'Finalizados',
                        style: TextStyle(
                          fontSize: size.width * 0.07,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      stops: [0.1, 0.3, 0.7, 1],
                      colors: [
                        Color(0xFF747474).withOpacity(0.8),
                        Color(0xFFb9b9b9).withOpacity(0.8),
                        Color(0xFFb9b9b9).withOpacity(0.8),
                        Color(0xFF747474).withOpacity(0.8),
                      ],
                    ),
                  ),
                  height: size.width * 0.3,
                  margin: EdgeInsets.only(left: 15, right: 15),
                  child: GestureDetector(
                    onTap: () {
                      StatusGrupos.escolhaStatus = ListarGruposEnviados.toString();
                      StatusGrupos.tituloTela = 'Endereços enviados';
                      Navigator.pushNamed(context, '/ListaGrupoSelecionado');
                    },
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        'Enviados para empresa',
                        style: TextStyle(
                          fontSize: size.width * 0.07,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      stops: [0.1, 0.3, 0.7, 1],
                      colors: [
                        Color(0xFF747474).withOpacity(0.8),
                        Color(0xFFb9b9b9).withOpacity(0.8),
                        Color(0xFFb9b9b9).withOpacity(0.8),
                        Color(0xFF747474).withOpacity(0.8),
                      ],
                    ),
                  ),
                  height: size.width * 0.3,
                  margin: EdgeInsets.only(left: 15, right: 15),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/ListarDespesas');
                    },
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        'Em produção',
                        style: TextStyle(
                          fontSize: size.width * 0.07,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                //=================================================
              ],
            ),
          ],
        ),
      ),
    );
  }
}
