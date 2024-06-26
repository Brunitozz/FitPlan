import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MaquinasScreen extends StatefulWidget {
  const MaquinasScreen({Key? key}) : super(key: key);

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
              stream: FirebaseFirestore.instance.collection('maquinasDeCorrer').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No data found'));
                }
                
                Map<String, Map<String, dynamic>> maquinasDeCorrer = {};
                for (var doc in snapshot.data!.docs) {
                  maquinasDeCorrer[doc.id] = {
                    'disponible': doc['disponible'],
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
              stream: FirebaseFirestore.instance.collection('bicicletasEstaticas').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No data found'));
                }
                
                Map<String, Map<String, dynamic>> bicicletasEstaticas = {};
                for (var doc in snapshot.data!.docs) {
                  bicicletasEstaticas[doc.id] = {
                    'disponible': doc['disponible'],
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
    await FirebaseFirestore.instance.collection('maquinasDeCorrer').doc(key).update({
      'disponible': newValue ? 1 : 0,
    });
  }

  void _toggleAvailabilityBicicleta(String key, Map<String, dynamic> item) async {
    bool newValue = item['disponible'] != 1;
    await FirebaseFirestore.instance.collection('bicicletasEstaticas').doc(key).update({
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
  });

  @override
  Widget build(BuildContext context) {
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
            bool isAvailable = item['disponible'] == 1;
            return InkWell(
              onTap: () {
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
                        '${title.split(' ')[0]} ${index + 1}',
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
