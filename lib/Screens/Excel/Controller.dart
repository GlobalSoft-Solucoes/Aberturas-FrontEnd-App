import 'package:http/http.dart' as http;
import 'package:projeto_aberturas/Models/Excel.dart';

class FormController {
  final void Function(String) callback;

//aki vai a url do script do google
  static const String URL =
      // LINK DA PLANILHA DO CLIENTE
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
