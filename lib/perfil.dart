import 'package:flutter/material.dart';

class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Encabezado con imagen y título
            AspectRatio(
              aspectRatio: 2.75 / 1, // Relación de aspecto deseada (ejemplo: 16:9)
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'assets/perfil/perfil.jpg', // Ruta de tu imagen
                    fit: BoxFit.cover, // Ajusta la imagen para cubrir el área disponible
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.5), // Lado izquierdo con opacidad
                          Colors.transparent, // Lado derecho completamente transparente
                        ],
                        begin: Alignment.centerLeft, // El gradiente comienza desde la izquierda
                        end: Alignment.centerRight, // El gradiente termina en la derecha
                      ),
                    ),
                  ),
                  const Positioned(
                    left: 16.0, // Espaciado desde el borde izquierdo
                    bottom: 20.0, // Ajusta el espaciado desde el fondo
                    child: Text(
                      'Editar \nPerfil',
                      style: TextStyle(
                        fontSize: 35, // Ajusta el tamaño del texto
                        fontWeight: FontWeight.bold, // Opcional: agregar peso al texto
                        color: Colors.white, // Texto blanco
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Nueve cajas para los datos del perfil
                  _buildProfileDataBox('Nombre'),
                  const SizedBox(height: 20),
                  _buildProfileDataBox('Talla'),
                  const SizedBox(height: 20),
                  _buildProfileDataBox('Peso'),
                  const SizedBox(height: 20),
                  _buildProfileDataBox('% Grasa'),
                  const SizedBox(height: 20),
                  _buildProfileDataBox('Cuello'),
                  const SizedBox(height: 20),
                  _buildProfileDataBox('Pecho'),
                  const SizedBox(height: 20),
                  _buildProfileDataBox('Muslo'),
                  const SizedBox(height: 20),
                  _buildProfileDataBox('Brazo'),
                  const SizedBox(height: 20),
                  _buildProfileDataBox('Antebrazo'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileDataBox(String title) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10.0),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 2,
            child: TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Ingresar dato',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
