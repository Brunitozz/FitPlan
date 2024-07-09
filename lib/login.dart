import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usuarioController = TextEditingController();
  final TextEditingController _contrasenaController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _iniciarSesion() async {
    try {
      final String usuario = _usuarioController.text.trim();
      final String contrasena = _contrasenaController.text.trim();

      if (usuario.isNotEmpty && contrasena.isNotEmpty) {
        // Consultar la colección "usuario" en Firestore
        QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
            .collection('usuario')
            .where('usuario', isEqualTo: usuario)
            .where('contrasena', isEqualTo: contrasena)
            .get();

        // Verificar si hay algún documento que coincida
        if (querySnapshot.docs.isNotEmpty) {
          // Si hay coincidencia, el inicio de sesión es exitoso
          String userId = querySnapshot.docs.first.id;

          // Obtener el ID del documento de datos
          DocumentSnapshot<Map<String, dynamic>> datosSnapshot = await _firestore
              .collection('usuario')
              .doc(userId)
              .collection('datos')
              .get()
              .then((snapshot) => snapshot.docs.first);

          String datosId = datosSnapshot.id;

          // Guardar userId y datosId en SharedPreferences
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('userId', userId);
          await prefs.setString('datosId', datosId);

          Navigator.pushReplacementNamed(context, '/home');
        } else {
          // Si no hay coincidencia, mostrar un mensaje de error
          _mostrarError('Credenciales incorrectas');
        }
      } else {
        _mostrarError('Por favor ingrese usuario y contraseña');
      }
    } catch (e) {
      _mostrarError('Error: $e');
    }
  }


  void _mostrarError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(mensaje),
      duration: const Duration(seconds: 5),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          // Fondo con imagen
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('login/gimnasio.jpg'), // Ruta de tu imagen de fondo
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Contenido de inicio de sesión
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                // Logo
                Image.asset(
                  'login/logo.png', // Ruta de tu imagen de logo
                  height: 70, // Altura del logo
                  width: 70, // Ancho del logo
                ),
                const SizedBox(height: 60.0),
                // Usuario
                Container(
                  width: MediaQuery.of(context).size.width * 0.8, // Ancho ajustado al 80% del ancho de la pantalla
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  child: TextField(
                    controller: _usuarioController,
                    style: TextStyle(fontSize: 16.0), // Tamaño de texto ajustado
                    decoration: const InputDecoration(
                      labelText: 'Usuario',
                      labelStyle: TextStyle(
                        color: Colors.white, // Color del texto del label
                        fontWeight: FontWeight.bold, // Texto del label en negrita
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                // Contraseña
                Container(
                  width: MediaQuery.of(context).size.width * 0.8, // Ancho ajustado al 80% del ancho de la pantalla
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  child: TextField(
                    controller: _contrasenaController,
                    style: TextStyle(fontSize: 16.0), // Tamaño de texto ajustado
                    decoration: const InputDecoration(
                      labelText: 'Contraseña',
                      labelStyle: TextStyle(
                        color: Colors.white, // Color del texto del label
                        fontWeight: FontWeight.bold, // Texto del label en negrita
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                      border: InputBorder.none,
                    ),
                    obscureText: true,
                  ),
                ),
                const SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: _iniciarSesion,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.red, // Color del botón
                  ),
                  child: const Text('Iniciar Sesión'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
