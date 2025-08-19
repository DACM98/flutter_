import 'dart:convert';
import 'package:http/http.dart' as http;

class ClienteService {
  // URL base de tu API (ajusta según tu configuración)
  static const String baseUrl = 'http://localhost:3000/api'; // Cambia por tu URL real
  
  // Método para registrar un nuevo cliente
  static Future<Map<String, dynamic>> registrarCliente({
    required String nombre,
    required String correo,
    required String numLicencia,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/clientes'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'nombre': nombre,
          'correo': correo,
          'numLicencia': numLicencia,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Registro exitoso
        return {
          'success': true,
          'message': 'Cliente registrado exitosamente',
          'data': jsonDecode(response.body),
        };
      } else {
        // Error en el servidor
        return {
          'success': false,
          'message': 'Error al registrar cliente: ${response.statusCode}',
          'error': response.body,
        };
      }
    } catch (e) {
      // Error de conexión o excepción
      return {
        'success': false,
        'message': 'Error de conexión: $e',
        'error': e.toString(),
      };
    }
  }

  // Método para login del cliente
  static Future<Map<String, dynamic>> loginCliente({
    required String correo,
    required String numLicencia,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/clientes/login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'correo': correo,
          'numLicencia': numLicencia,
        }),
      );

      if (response.statusCode == 200) {
        // Login exitoso
        return {
          'success': true,
          'message': 'Login exitoso',
          'data': jsonDecode(response.body),
        };
      } else {
        // Error de autenticación
        return {
          'success': false,
          'message': 'Credenciales inválidas',
          'error': response.body,
        };
      }
    } catch (e) {
      // Error de conexión o excepción
      return {
        'success': false,
        'message': 'Error de conexión: $e',
        'error': e.toString(),
      };
    }
  }
}
