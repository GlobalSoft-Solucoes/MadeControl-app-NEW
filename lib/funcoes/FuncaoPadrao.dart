import 'package:http/http.dart' as http;
import 'package:madecontrol_desenvolvimento/models/Models_Usuario.dart';

class PostJson {
  Future<int> post(urlServidor, route, corpo) async {
    http.Response response = await http.post(
      urlServidor + route,
      headers: {
        "Content-Type": "application/json",
        "token": ModelsUsuarios.tokenAuth.toString()
      },
      body: corpo,
    );
    return response.statusCode;
  }
}

class PutJson {
  Future<int> put(urlServidor, route, corpo, email, {id}) async {
    http.Response response = await http.put(
      Uri.parse(urlServidor + id),
      headers: {
        "Content-Type": "application/json",
        "token": ModelsUsuarios.tokenAuth.toString()
      },
      body: corpo,
    );
    return response.statusCode;
  }
}
