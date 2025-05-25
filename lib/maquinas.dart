import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MaquinasScreen extends StatefulWidget {
  final FirebaseFirestore firestoreInstance;

  const MaquinasScreen({Key? key, required this.firestoreInstance}) : super(key: key);

  @override
  _MaquinasScreenState createState() => _MaquinasScreenState();
}

class _MaquinasScreenState extends State<MaquinasScreen> {
  static const String imagenMaquinaOcupada = "assets/maquinas/maquina-ocupada.png";
  static const String imagenMaquinaLibre = "assets/maquinas/maquina-libre.png";
  static const String imagenBicicletaEstaticaOcupada = "assets/maquinas/bicicleta-estatica-ocupada.png";
  static const String imagenBicicletaEstaticaLibre = "assets/maquinas/bicicleta-estatica-libre.png";

  String _getImageForMaquina(bool isAvailable) {
    return isAvailable ? imagenMaquinaLibre : imagenMaquinaOcupada;
  }

  String _getImageForBicicleta(bool isAvailable) {
    return isAvailable ? imagenBicicletaEstaticaLibre : imagenBicicletaEstaticaOcupada;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Máquinas y Bicicletas Disponibles'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: widget.firestoreInstance.collection('maquinasDeCorrer').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  // Return a non-empty widget, like a Text widget, if there's no data.
                  // This helps prevent layout issues if the stream is empty.
                  return Center(child: Text('No hay máquinas de correr disponibles'));
                }
                
                Map<String, Map<String, dynamic>> maquinasDeCorrer = {};
                for (var doc in snapshot.data!.docs) {
                  maquinasDeCorrer[doc.id] = {
                    'disponible': doc['disponible'],
                     // Ensure other fields used by SectionGrid or its children are included if necessary
                    'nombre': doc.id // Assuming doc.id is the name, or fetch from data
                  };
                }
                return SectionGrid(
                  title: 'Máquinas de Correr',
                  items: maquinasDeCorrer,
                  crossAxisCount: 3,
                  onItemTap: _toggleAvailabilityMaquina,
                  getImage: _getImageForMaquina,
                );
              },
            ),
            StreamBuilder<QuerySnapshot>(
              stream: widget.firestoreInstance.collection('bicicletasEstaticas').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                   // Return a non-empty widget, like a Text widget, if there's no data.
                  return Center(child: Text('No hay bicicletas estáticas disponibles'));
                }
                
                Map<String, Map<String, dynamic>> bicicletasEstaticas = {};
                for (var doc in snapshot.data!.docs) {
                  bicicletasEstaticas[doc.id] = {
                    'disponible': doc['disponible'],
                    'nombre': doc.id // Assuming doc.id is the name
                  };
                }
                return SectionGrid(
                  title: 'Bicicletas Estáticas',
                  items: bicicletasEstaticas,
                  crossAxisCount: 3,
                  onItemTap: _toggleAvailabilityBicicleta,
                  getImage: _getImageForBicicleta,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _toggleAvailabilityMaquina(String key, Map<String, dynamic> item) async {
    bool newValue = item['disponible'] != 1;
    await widget.firestoreInstance.collection('maquinasDeCorrer').doc(key).update({
      'disponible': newValue ? 1 : 0,
    });
  }

  void _toggleAvailabilityBicicleta(String key, Map<String, dynamic> item) async {
    bool newValue = item['disponible'] != 1;
    await widget.firestoreInstance.collection('bicicletasEstaticas').doc(key).update({
      'disponible': newValue ? 1 : 0,
    });
  }
}

class SectionGrid extends StatelessWidget {
  final String title;
  final Map<String, Map<String, dynamic>> items;
  final int crossAxisCount;
  final void Function(String, Map<String, dynamic>) onItemTap;
  final String Function(bool) getImage;

  const SectionGrid({
    required this.title,
    required this.items,
    required this.crossAxisCount,
    required this.onItemTap,
    required this.getImage,
    Key? key, // Added Key here
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) { // Handle case where items map is empty to avoid layout issues
        return Center(child: Text('No hay ${title.toLowerCase()} disponibles en este momento.'));
    }
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: 1,
          ),
          itemCount: items.length,
          itemBuilder: (BuildContext context, int index) {
            String key = items.keys.elementAt(index);
            Map<String, dynamic> item = items[key]!;
            // Ensure 'disponible' field exists and has a default if null
            bool isAvailable = item['disponible'] == 1; 
            
            // Construct the display name as used in the original code
            String displayName = '${title.split(' ')[0]} ${index + 1}';
            
            return InkWell(
              onTap: () {
                // Pass the actual document key (which is item['nombre'] or doc.id from Firestore)
                onItemTap(key, item); 
              },
              child: Card(
                color: isAvailable ? Color(0xFFBBF246) : Color(0xFFFF3C3C),
                child: Column(
                  children: [
                    Expanded(
                      child: Image.asset(
                        getImage(isAvailable),
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        displayName, // Use the generated display name
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
