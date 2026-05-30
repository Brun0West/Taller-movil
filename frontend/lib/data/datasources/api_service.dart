// ApiService es el único punto de acceso a la red.
// Encapsula las peticiones HTTP y maneja errores de conexión.


import 'dart:convert';
import 'package:http/http.dart' as http;


class ApiService {
  final http.Client _client;


  ApiService({http.Client? client}) : _client = client ?? http.Client();


  /// Realiza una petición GET y retorna el body decodificado como dynamic.
  Future<dynamic> get(String url) async {
    final response = await _client
        .get(Uri.parse(url))
        .timeout(const Duration(seconds: 10));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception('Error HTTP \${response.statusCode} en GET \$url');
  }


  /// Realiza una petición POST con body JSON.
  Future<dynamic> post(String url, Map<String, dynamic> body) async {
    final response = await _client
        .post(
          Uri.parse(url),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(body),
        )
        .timeout(const Duration(seconds: 10));
    return jsonDecode(response.body);
  }
}
