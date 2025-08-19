import 'package:flutter/material.dart';
import 'package:flutter_application_1/registropage.dart';
import 'package:flutter_application_1/controllers/cliente_controller.dart';
import 'package:flutter_application_1/preferences.dart';
import 'alquilerauto.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // Controladores y variables de estado para el formulario
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _numLicController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _correoController.dispose();
    _numLicController.dispose();
    super.dispose();
  }

  // Método para login del cliente usando ClienteService
  Future<void> _loginCliente() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Llamada al servicio para login del cliente
      final resultado = await ClienteService.loginCliente(
        correo: _correoController.text.trim(),
        numLicencia: _numLicController.text.trim(),
      );

      if (!mounted) return;

      if (resultado['success']) {
        // Login exitoso - guardar el ID del cliente
        if (resultado['data'] != null && resultado['data']['id'] != null) {
          await Preferences.saveClienteId(resultado['data']['id']);
        }
        
        // Mostrar mensaje de éxito
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(resultado['message']),
            backgroundColor: Colors.green,
          ),
        );
        
        // Navegar a la pantalla principal después del login exitoso
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AlquilerAutoScreen()),
        );
      } else {
        // Login fallido
        setState(() {
          _errorMessage = resultado['message'];
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Error inesperado: ${e.toString()}';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 103, 155, 7),
        foregroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => AlquilerAutoScreen()),
            );
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text(
          "Iniciar Sesión",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Icono de usuario
                const Icon(
                  Icons.account_circle,
                  size: 100,
                  color: Color.fromARGB(255, 0, 255, 64),
                ),
                const SizedBox(height: 32),
                
                // Mensaje de error
                if (_errorMessage != null)
                  Container(
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.red[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ),
                
                // Campo de correo
                TextFormField(
                  controller: _correoController,
                  keyboardType: TextInputType.emailAddress,
                  enabled: !_isLoading,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese su correo electrónico';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                      return 'Por favor ingrese un correo electrónico válido';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Correo electrónico',
                    prefixIcon: const Icon(Icons.email),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Campo de número de licencia
                TextFormField(
                  controller: _numLicController,
                  keyboardType: TextInputType.text,
                  enabled: !_isLoading,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese su número de licencia';
                    }
                    if (value.trim().length < 5) {
                      return 'El número de licencia debe tener al menos 5 caracteres';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Número de licencia',
                    prefixIcon: const Icon(Icons.card_membership),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                
                // Botón de iniciar sesión
                ElevatedButton(
                  onPressed: _isLoading ? null : _loginCliente,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 14, 120, 128),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Iniciar Sesión',
                          style: TextStyle(fontSize: 18),
                        ),
                ),
                const SizedBox(height: 16),
                
                // Botón para ir a registro
                TextButton(
                  onPressed: _isLoading
                      ? null
                      : () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const RegistroPage()),
                          );
                        },
                  child: const Text(
                    '¿No tienes cuenta? Regístrate',
                    style: TextStyle(color: Color.fromARGB(255, 60, 57, 190)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}