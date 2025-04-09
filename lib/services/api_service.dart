import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/salud_model.dart';

class ApiService {
  final String apiUrl = 'https://rosaprueba.onrender.com/api/predecir-obesidad-apk/';

  Future<Map<String, dynamic>> realizarPrediccion(SaludModel saludModel) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(saludModel.toJson()),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al realizar la predicción');
    } 
  }
}