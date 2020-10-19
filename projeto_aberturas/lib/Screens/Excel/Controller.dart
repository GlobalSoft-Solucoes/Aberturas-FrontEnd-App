import 'package:http/http.dart' as http;
import 'package:projeto_aberturas/Models/Excel.dart';

class FormController {
  final void Function(String) callback;

//aki vai a url do script do google
  static const String URL =
      "https://script.google.com/macros/s/AKfycbwSnH6VXazQPSHPINJXboiWV5aAE9iuRxY3Bwlc6fCGoU85DiM/exec";

  static const STATUS_SUCCESS = "SUCCESS";

  FormController(this.callback);

  Future<int> submitForm(FeedbackForm feedbackForm) async {
    print(URL + feedbackForm.toParams());
    try {
      http.Response retorno = await http.get(URL + feedbackForm.toParams());
      return retorno.statusCode;
    } catch (e) {
      print(e);
    }
  }
}

//https://script.google.com/macros/s/AKfycbwjUlaWsOh5ErUYmtTxVaoZmV69LNmxgOeP5NyskA/exec?dataCadastro=&proprietario=leo&cidade=pzo&comodo=quarto&altura=2.1&largura=1&marco=1&ladoAbertura=1&localizacao=1
