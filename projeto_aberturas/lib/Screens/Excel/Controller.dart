import 'dart:convert' as convert;

import 'package:http/http.dart' as http;
import 'package:projeto_aberturas/Models/Excel.dart';

class FormController {
  final void Function(String) callback;

//aki vai a url do script do google
  static const String URL =
      "https://script.google.com/macros/s/AKfycbzZ20toYxxxDbcpqYoPd0Fz-7TwcMMdF1OmZJQeqcJ5IMNtSJU/exec";

  static const STATUS_SUCCESS = "SUCCESS";

  FormController(this.callback);

  void submitForm(FeedbackForm feedbackForm) async {
    try {
      await http.get(URL + feedbackForm.toParams()).then((response) {
        callback(convert.jsonDecode(response.body)['status']);
      });
    } catch (e) {
      print(e);
    }
  }
}
