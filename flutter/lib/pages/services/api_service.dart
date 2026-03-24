import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // Para emulador Android usar 10.0.2.2
  // Para iOS simulator usar localhost
  // Para dispositivo físico usar IP local de tu PC
  static const String baseUrl = "http://localhost:3000/api_v1";

  // ========== LOGIN ==========
  static Future<Map<String, dynamic>> login(String user, String pass) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/apiUserLogin'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "api_user": user,
          "api_password": pass,
        }),
      );

      print("LOGIN STATUS: ${response.statusCode}");
      print("LOGIN BODY: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // La estructura de la respuesta según Postman: { "json": { "token": "..." } }
        String? token = data['json']?['token'] ?? data['token'] ?? data['access_token'];

        if (token != null) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('auth_token', token);
          await prefs.setString('user_email', user);
          return {'success': true, 'message': 'Login exitoso'};
        } else {
          return {'success': false, 'message': 'Token no encontrado en la respuesta'};
        }
      } else {
        String errorMsg = 'Error $response.statusCode';
        try {
          final errorData = jsonDecode(response.body);
          errorMsg = errorData['message'] ?? errorData['error'] ?? errorMsg;
        } catch (_) {}
        return {'success': false, 'message': errorMsg};
      }
    } catch (e) {
      print("LOGIN ERROR: $e");
      return {'success': false, 'message': 'Error de conexión: $e'};
    }
  }

// ========== CREAR ROL ==========
static Future<Map<String, dynamic>> createRole(String name, String description) async {
  try {
    final response = await http.post(
      Uri.parse('$baseUrl/role'), // ⚠️ CAMBIA ESTO por la ruta real de tu API
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "name": name,
        "description": description,
      }),
    );

    print("CREATE ROLE STATUS: ${response.statusCode}");
    print("CREATE ROLE BODY: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      return {'success': true, 'message': 'Rol creado exitosamente'};
    } else {
      String errorMsg = 'Error $response.statusCode';
      try {
        final errorData = jsonDecode(response.body);
        errorMsg = errorData['message'] ?? errorData['error'] ?? errorMsg;
      } catch (_) {}
      return {'success': false, 'message': errorMsg};
    }
  } catch (e) {
    print("CREATE ROLE ERROR: $e");
    return {'success': false, 'message': 'Error de conexión: $e'};
  }
}

  // ========== GESTIÓN DE TOKEN / SESIÓN ==========
  static Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  static Future<String?> getUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_email');
  }

  static Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_email');
  }

  // ========== PETICIONES AUTENTICADAS (EJEMPLO GET) ==========
  static Future<http.Response> authenticatedGet(String endpoint) async {
    final token = await getToken();
    return await http.get(
      Uri.parse('$baseUrl/$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
  }
}