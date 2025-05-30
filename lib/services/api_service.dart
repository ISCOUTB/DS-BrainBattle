import 'dart:convert';
import 'package:flutter/services.dart'; // <-- Import necesario para rootBundle
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
    final String data = await rootBundle.loadString('assets/preguntas.json');
    final jsonResult = json.decode(data);
    final List<dynamic> preguntas = jsonResult['questions'];
    return preguntas.map<Map<String, dynamic>>((item) => {
      'question': item['question'],
      'options': [
        item['correctAnswer'],
        item['RespuestaIncorrecta1'],
        item['RespuestaIncorrecta2'],
        item['RespuestaIncorrecta3'],
      ]..shuffle(),
      'correctAnswer': item['correctAnswer'],
      'categoria': item['categoria'],
    }).toList();
  }
}
