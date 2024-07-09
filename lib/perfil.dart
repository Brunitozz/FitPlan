import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  _PerfilScreenState createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  Future<Map<String, String?>> _getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');
    String? datosId = prefs.getString('datosId');
    return {'userId': userId, 'datosId': datosId};
  }

  Map<String, dynamic> profileData = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Map<String, String?>>(
        future: _getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data == null || snapshot.data!['userId'] == null || snapshot.data!['datosId'] == null) {
            return Center(child: Text('No hay datos disponibles'));
          }

          String userId = snapshot.data!['userId']!;
          String datosId = snapshot.data!['datosId']!;

          return FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('usuario')
                .doc(userId)
                .collection('datos')
                .doc(datosId)
                .get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data == null) {
                return Center(child: Text('No hay datos disponibles'));
              }

              profileData = snapshot.data!.data() as Map<String, dynamic>;
              final nombre = profileData['Nombre'] ?? '';
              final talla = profileData['Talla'] ?? '';
              final peso = profileData['Peso'] ?? '';
              final grasa = profileData['Grasa_porc'] ?? '';

              return SingleChildScrollView(
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
                          _buildProfileDataBox(context, 'Nombre', nombre, userId, datosId),
                          const SizedBox(height: 20),
                          _buildProfileDataBox(context, 'Talla', talla.toString(), userId, datosId),
                          const SizedBox(height: 20),
                          _buildProfileDataBox(context, 'Peso', peso.toString(), userId, datosId),
                          const SizedBox(height: 20),
                          _buildProfileDataBox(context, '% Grasa', grasa.toString(), userId, datosId),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildProfileDataBox(BuildContext context, String title, String value, String userId, String datosId) {
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
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () => _editField(context, title, value, userId, datosId),
          ),
        ],
      ),
    );
  }

  Future<void> _editField(BuildContext context, String title, String currentValue, String userId, String datosId) async {
    TextEditingController controller = TextEditingController(text: currentValue);

    bool isUpdated = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Editar $title'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: title,
            ),
          ),
          actions: [
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: Text('Guardar'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    ) ?? false;

    if (isUpdated) {
      String newValue = controller.text.trim();
      if (newValue.isNotEmpty && newValue != currentValue) {
        await FirebaseFirestore.instance
            .collection('usuario')
            .doc(userId)
            .collection('datos')
            .doc(datosId)
            .update({title: newValue});

        setState(() {
          profileData[title] = newValue;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Campo $title editado'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }
}
