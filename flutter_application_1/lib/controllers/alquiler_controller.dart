import 'dart:convert';
import 'package:http/http.dart' as http;

class AlquilerController {
  // URL base de tu API (ajusta según tu configuración)
  static const String baseUrl = 'http://localhost:3000/api'; // Cambia por tu URL real
  
  // Método para registrar un nuevo alquiler
  static Future<Map<String, dynamic>> registrarAlquiler({
    required int clienteId,
    required int autoId,
    required DateTime fechaInicio,
    required DateTime fechaFin,
    required double valorTotal,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/alquileres'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'clienteId': clienteId,
          'autoId': autoId,
          'fechaInicio': fechaInicio.toIso8601String(),
          'fechaFin': fechaFin.toIso8601String(),
          'valorTotal': valorTotal,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Alquiler registrado exitosamente
        return {
          'success': true,
          'message': 'Alquiler registrado exitosamente',
          'data': jsonDecode(response.body),
        };
      } else {
        // Error en el servidor
        return {
          'success': false,
          'message': 'Error al registrar alquiler: ${response.statusCode}',
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

  // Método para obtener alquileres de un cliente
  static Future<List<Map<String, dynamic>>> obtenerAlquileresCliente(int clienteId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/alquileres/cliente/$clienteId'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((alquiler) {
          return {
            'id': alquiler['id'],
            'autoId': alquiler['autoId'],
            'fechaInicio': alquiler['fechaInicio'],
            'fechaFin': alquiler['fechaFin'],
            'valorTotal': alquiler['valorTotal'],
            'estado': alquiler['estado'],
            'auto': alquiler['auto'],
          };
        }).toList();
      } else {
        throw Exception('Error al obtener alquileres: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // Método para cancelar un alquiler
  static Future<Map<String, dynamic>> cancelarAlquiler(int alquilerId) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/alquileres/$alquilerId/cancelar'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'Alquiler cancelado exitosamente',
          'data': jsonDecode(response.body),
        };
      } else {
        return {
          'success': false,
          'message': 'Error al cancelar alquiler: ${response.statusCode}',
          'error': response.body,
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error de conexión: $e',
        'error': e.toString(),
      };
    }
  }
}
