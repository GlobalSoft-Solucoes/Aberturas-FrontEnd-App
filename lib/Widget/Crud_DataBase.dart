import 'package:http/http.dart' as http;
import 'package:projeto_aberturas/Models/Models_Usuario.dart';

class ReqDataBase {
  static dynamic statusCode;
  static dynamic responseReq;
  // =================== REQUISIÇÕES DO TIPO GET =================
  Future<dynamic> requisicaoGet(context, caminhoCompleto) async {
    responseReq = null;
    final response = await http.get(
        Uri.encodeFull(
          caminhoCompleto,
        ),
        headers: {
          "Content-Type": "application/json",
          "authorization": ModelsUsuarios.tokenAuth
        });

    statusCode = response.statusCode;
    responseReq = response;
  }

  // =================== REQUISIÇÕES DO TIPO POST =================
  Future<dynamic> requisicaoPost(caminhoCompleto, body) async {
    responseReq = null;
    http.Response response = await http.post(
      caminhoCompleto,
      headers: {
        "Content-Type": "application/json",
        "authorization": ModelsUsuarios.tokenAuth,
      },
      body: body,
    );
    statusCode = response.statusCode;
    responseReq = response;
  }

  // =================== REQUISIÇÕES DO TIPO DELETE =================
  Future<dynamic> requisicaoDelete(caminhoCompleto) async {
    responseReq = null;
    http.Response response = await http.delete(
      caminhoCompleto,
      headers: {
        "Content-Type": "application/json",
        "authorization": ModelsUsuarios.tokenAuth
      },
    );

    statusCode = response.statusCode;
    responseReq = response;
  }

  // =================== REQUISIÇÕES DO TIPO PUT =================
  Future<dynamic> requisicaoPut(caminhoCompleto, {body}) async {
    responseReq = null;
    http.Response response = await http.put(
      caminhoCompleto,
      headers: {
        "Content-Type": "application/json",
        "authorization": ModelsUsuarios.tokenAuth
      },
      body: body,
    );
    statusCode = response.statusCode;
    responseReq = response;
  }
}
