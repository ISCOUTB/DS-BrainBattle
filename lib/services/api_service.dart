import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://localhost:8000/api';

  static Future<http.Response> registerUser(Map<String, dynamic> userData) async {
    final url = Uri.parse('$baseUrl/registerUser');
    userData['registration_date'] = "${DateTime.now().month}/${DateTime.now().year}"; // Formatear fecha
    return await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(userData),
    );
  }

  static Future<http.Response> loginUser(String username, String password) async {
    final url = Uri.parse('$baseUrl/login');
    return await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );
  }

  static Future<List<Map<String, dynamic>>> fetchPreguntas() async {
    final url = Uri.parse('$baseUrl/preguntas');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
      return data.map<Map<String, dynamic>>((item) => {
        'question': item['enunciado'],
        'options': [
          item['respuesta_correcta'],
          item['respuesta_incorrecta1'],
          item['respuesta_incorrecta2'],
          item['respuesta_incorrecta3'],
        ]..shuffle(),
        'correctAnswer': item['respuesta_correcta'],
        'categoria': item['categoria'],
      }).toList();
    } else {
      throw Exception('Error al cargar preguntas');
    }
  }
}
