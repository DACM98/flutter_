import 'dart:convert';
import 'package:http/http.dart' as http;

class AutosController {
  // URL base de tu API (ajusta según tu configuración)
  static const String baseUrl = 'http://localhost:3000/api'; // Cambia por tu URL real
  
  // Método para obtener autos disponibles
  static Future<List<Map<String, dynamic>>> obtenerAutosDisponibles() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/disponibles'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // Convertir la respuesta JSON a una lista de autos
        final List<dynamic> data = jsonDecode(response.body);
        
        // Mapear los datos a un formato más manejable
        return data.map((auto) {
          return {
            'id': auto['id'],
            'marca': auto['marca'],
            'modelo': auto['modelo'],
            'anio': auto['anio'],
            'placa': auto['placa'],
            'imagen': auto['imagen'],
            'valorAlquiler': auto['valorAlquiler'],
            'disponible': auto['disponible'],
            'descripcion': auto['descripcion'],
          };
        }).toList();
      } else {
        // Error en el servidor
        throw Exception('Error al obtener autos: ${response.statusCode}');
      }
    } catch (e) {
      // Error de conexión o excepción
      throw Exception('Error de conexión: $e');
    }
  }

  // Método para obtener un auto específico por ID
  static Future<Map<String, dynamic>> obtenerAutoPorId(int autoId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/autos/$autoId'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> auto = jsonDecode(response.body);
        return {
          'id': auto['id'],
          'marca': auto['marca'],
          'modelo': auto['modelo'],
          'anio': auto['anio'],
          'placa': auto['placa'],
          'imagen': auto['imagen'],
          'valorAlquiler': auto['valorAlquiler'],
          'disponible': auto['disponible'],
          'descripcion': auto['descripcion'],
        };
      } else {
        throw Exception('Error al obtener auto: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }
}
