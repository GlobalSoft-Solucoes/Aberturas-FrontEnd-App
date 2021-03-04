import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:projeto_aberturas/Models/Models_Usuario.dart';

class ReqDataBase {
  static dynamic responseReq;
  static final statusCode = ValueNotifier<int>(0);

  // =================== REQUISIÇÕES DO TIPO GET =================
  Future<dynamic> requisicaoGet(context, caminhoCompleto) async {
    final response = await http.get(
        Uri.encodeFull(
          caminhoCompleto,
        ),
        headers: {
          "Content-Type": "application/json",
          "authorization": ModelsUsuarios.tokenAuth
        });

    statusCode.value = response.statusCode;
    responseReq = response;
  }

  // =================== REQUISIÇÕES DO TIPO POST =================
  Future<dynamic> requisicaoPost(caminhoCompleto, body,
      {autorization}) async {
    http.Response responsePost = await http.post(
      caminhoCompleto,
      headers: {
        "Content-Type": "application/json",
        'Accept': 'application/json',
        autorization != null ? '' : "authorization": ModelsUsuarios.tokenAuth,
      },
      body: body,
    );
    statusCode.value = responsePost.statusCode;
    responseReq = responsePost;
  }

  // =================== REQUISIÇÕES DO TIPO DELETE =================
  Future<dynamic> requisicaoDelete(caminhoCompleto) async {
    http.Response response = await http.delete(
      caminhoCompleto,
      headers: {
        "Content-Type": "application/json",
        "authorization": ModelsUsuarios.tokenAuth
      },
    );

    statusCode.value = response.statusCode;
    responseReq = response;
  }

  // =================== REQUISIÇÕES DO TIPO PUT =================
  Future<dynamic> requisicaoPut(caminhoCompleto, {body}) async {
    http.Response response = await http.put(
      caminhoCompleto,
      headers: {
        "Content-Type": "application/json",
        "authorization": ModelsUsuarios.tokenAuth
      },
      body: body,
    );
    statusCode.value = response.statusCode;
    responseReq = response;
  }
}
