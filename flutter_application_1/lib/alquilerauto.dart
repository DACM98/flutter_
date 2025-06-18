import 'package:flutter/material.dart';

// Suponiendo que tienes una clase MenuDrawerPerfil ya implementada
import 'menu_drawer_perfil.dart';
import 'calculadorapage.dart';
import 'registropage.dart';
import 'loginpage.dart';
import 'sumapage.dart';
import 'preferences.dart';

// Modelo de vehículo
class Vehiculo {
  final String imagen;
  final String marca;
  final String modelo;
  final double calificacion;
  final double precioPorDia;

  Vehiculo({
    required this.imagen,
    required this.marca,
    required this.modelo,
    required this.calificacion,
    required this.precioPorDia,
  });
}

// Widget principal con navegación inferior y menú lateral
class AlquilerAutoScreen extends StatefulWidget {
  @override
  _AlquilerAutoScreenState createState() => _AlquilerAutoScreenState();
}

class _AlquilerAutoScreenState extends State<AlquilerAutoScreen> {
  int _selectedIndex = 0; // Índice de la pestaña seleccionada
  String _busqueda = '';

  // Lista de vehículos de ejemplo
  final List<Vehiculo> _vehiculos = [
    Vehiculo(
      imagen: 'https://fastly.picsum.photos/id/26/4209/2769.jpg?hmac=vcInmowFvPCyKGtV7Vfh7zWcA_Z0kStrPDW3ppP0iGI',
      marca: 'Toyota',
      modelo: 'Corolla',
      calificacion: 4.5,
      precioPorDia: 45.0,
    ),
    Vehiculo(
      imagen: 'https://images.unsplash.com/photo-1511918984145-48de785d4c4e?w=400&h=300&fit=crop',
      marca: 'Honda',
      modelo: 'Civic',
      calificacion: 4.7,
      precioPorDia: 50.0,
    ),
    Vehiculo(
      imagen: 'https://images.unsplash.com/photo-1461632830798-3adb3034e4c8?w=400&h=300&fit=crop',
      marca: 'Ford',
      modelo: 'Focus',
      calificacion: 4.3,
      precioPorDia: 40.0,
    ),
    Vehiculo(
      imagen: 'https://images.unsplash.com/photo-1502877338535-766e1452684a?w=400&h=300&fit=crop',
      marca: 'Chevrolet',
      modelo: 'Camaro',
      calificacion: 4.8,
      precioPorDia: 60.0,
    ),
    Vehiculo(
      imagen: 'https://images.unsplash.com/photo-1519681393784-d120267933ba?w=400&h=300&fit=crop',
      marca: 'BMW',
      modelo: 'Serie 3',
      calificacion: 4.9,
      precioPorDia: 70.0,
    ),
    Vehiculo(
      imagen: 'https://images.unsplash.com/photo-1503736334956-4c8f8e92946d?w=400&h=300&fit=crop',
      marca: 'Audi',
      modelo: 'A4',
      calificacion: 4.6,
      precioPorDia: 65.0,
    ),
    Vehiculo(
      imagen: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=400&h=300&fit=crop',
      marca: 'Mercedes',
      modelo: 'Clase C',
      calificacion: 4.7,
      precioPorDia: 75.0,
    ),
  ];

  // Pestaña de bienvenida con imagen de fondo y accesos rápidos
  Widget _buildInicio() {
    return Stack(
      children: [
        // Imagen de fondo
        Positioned.fill(
          child: Image.network(
            'https://fastly.picsum.photos/id/26/4209/2769.jpg?hmac=vcInmowFvPCyKGtV7Vfh7zWcA_Z0kStrPDW3ppP0iGI',
            fit: BoxFit.cover,
          ),
        ),
        // Capa de color para oscurecer la imagen
        Container(
          color: Colors.black.withOpacity(0.4),
        ),
        // Botones de expansión
        Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Acceso rápido a Suma
                  ExpansionTile(
                    title: const Text('Suma', style: TextStyle(color: Colors.white)),
                    leading: const Icon(Icons.add, color: Colors.white),
                    trailing: const Icon(Icons.radio_button_checked, color: Colors.white),
                    children: <Widget>[
                      ListTile(
                        title: const Text('haz clic para sumar'),
                        onTap: () => _navigateTo(context, const SumaPage()),
                      ),
                    ],
                  ),
                  // Acceso rápido a Calculadora
                  ExpansionTile(
                    title: const Text('Calculadora', style: TextStyle(color: Colors.white)),
                    leading: const Icon(Icons.calculate, color: Colors.white),
                    trailing: const Icon(Icons.radio_button_checked, color: Colors.white),
                    children: <Widget>[
                      ListTile(
                        title: const Text('haz clic para Calculadora'),
                        onTap: () => _navigateTo(context, const CalculadoraPage()),
                      ),
                    ],
                  ),
                  // Acceso rápido a Registro
                  ExpansionTile(
                    title: const Text('Registro', style: TextStyle(color: Colors.white)),
                    leading: const Icon(Icons.app_registration, color: Colors.white),
                    trailing: const Icon(Icons.radio_button_checked, color: Colors.white),
                    children: <Widget>[
                      ListTile(
                        title: const Text('haz click para Registro'),
                        onTap: () => _navigateTo(context, const RegistroPage()),
                      ),
                    ],
                  ),
                  // Acceso rápido a Login
                  ExpansionTile(
                    title: const Text('Login', style: TextStyle(color: Colors.white)),
                    leading: const Icon(Icons.login, color: Colors.white),
                    trailing: const Icon(Icons.radio_button_checked, color: Colors.white),
                    children: <Widget>[
                      ListTile(
                        title: const Text('haz click para Login'),
                        onTap: () => _navigateTo(context, const Login()),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Pestaña de alquiler: muestra todos los autos disponibles y permite buscar
  Widget _buildAlquiler() {
    // Filtrar vehículos según búsqueda
    final vehiculosFiltrados = _vehiculos.where((v) {
      final query = _busqueda.toLowerCase();
      return v.marca.toLowerCase().contains(query) ||
          v.modelo.toLowerCase().contains(query);
    }).toList();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: TextField(
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Buscar vehículo',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onChanged: (valor) {
              setState(() {
                _busqueda = valor;
              });
            },
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: vehiculosFiltrados.length,
            itemBuilder: (context, index) {
              final vehiculo = vehiculosFiltrados[index];
              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      vehiculo.imagen,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(Icons.car_rental, size: 60, color: Colors.grey);
                      },
                    ),
                  ),
                  title: Text('${vehiculo.marca} Modelo ${vehiculo.modelo}'),
                  subtitle: Text('Año: 2022 - \$99.99/día'),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // Pestaña de usuario: muestra el perfil y opciones
  Widget _buildUsuario() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 32),
          // Foto de perfil
          const CircleAvatar(
            radius: 48,
            backgroundImage: NetworkImage('https://randomuser.me/api/portraits/men/1.jpg'),
          ),
          const SizedBox(height: 16),
          // Nombre de usuario
          const Text(
            'Nombre de Usuario',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          // Correo electrónico
          const Text(
            'correo@ejemplo.com',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 24),
          // Número de licencia
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: ListTile(
              leading: Icon(Icons.badge, color: Colors.blueAccent),
              title: Text('Número de licencia'),
              subtitle: Text('123456789'),
            ),
          ),
          // Cambiar contraseña
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: ListTile(
              leading: Icon(Icons.lock, color: Colors.orange),
              title: Text('Cambiar contraseña'),
              onTap: () {},
            ),
          ),
          // Revisar alquileres
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: ListTile(
              leading: Icon(Icons.search, color: Colors.deepOrange),
              title: Text('Revisar Alquileres'),
              onTap: () {},
            ),
          ),
          const SizedBox(height: 24),
          // Botón para salir de la app (cerrar sesión)
          ElevatedButton.icon(
            onPressed: () async {
              await Preferences.clearUserData();
              if (context.mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const Login()),
                  (route) => false,
                );
              }
            },
            icon: Icon(Icons.exit_to_app),
            label: Text('Salir'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 203, 255, 82),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Navegación a otras pantallas
  void _navigateTo(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  // Lista de pantallas para la navegación inferior
  List<Widget> _screens() => [
    _buildInicio(),
    _buildAlquiler(),
    _buildUsuario(),
  ];

  @override
  Widget build(BuildContext context) {
    // Títulos para el AppBar según la pestaña seleccionada
    final appBarTitles = ['Bienvenido', 'Alquiler de Autos', 'Perfil de Usuario'];
    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitles[_selectedIndex]),
        backgroundColor: const Color.fromARGB(255, 255, 68, 183),
      ),
      drawer: MenuDrawerPerfil(), // Menú lateral
      body: _screens()[_selectedIndex], // Contenido según la pestaña
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromARGB(255, 68, 255, 152),
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_car),
            label: 'Alquiler',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Usuario',
          ),
        ],
      ),
    );
  }
}