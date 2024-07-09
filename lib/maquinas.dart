import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class MaquinasScreen extends StatefulWidget {
  const MaquinasScreen({Key? key}) : super(key: key);

  @override
  _MaquinasScreenState createState() => _MaquinasScreenState();
}

class _MaquinasScreenState extends State<MaquinasScreen> {
  DatabaseReference _movementRef =
  FirebaseDatabase.instance.ref().child('movimiento').child('detect');

  bool? movementDetected;

  @override
  void initState() {
    super.initState();
    _movementRef.onValue.listen((event) {
      var snapshot = event.snapshot;
      setState(() {
        movementDetected = snapshot.value == 1;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SectionGrid(
              title: 'Máquinas de Correr',
              items: {
                'maquina_con_firebase': {
                  'imagenLibre': 'assets/maquinas/maquina-libre.png',
                  'imagenOcupada': 'assets/maquinas/maquina-ocupada.png',
                  'disponible': null, // Inicialmente desconocido
                },
                // Aquí van las otras máquinas de correr
              },
              crossAxisCount: 3,
              movementDetected: movementDetected,
            ),
            SectionGrid(
              title: 'Bicicletas Estáticas',
              items: {
                'bicicleta_1': {
                  'imagen': 'assets/maquinas/bicicleta-estatica-libre.png',
                  'disponible': true,
                },
                'bicicleta_2': {
                  'imagen': 'assets/maquinas/bicicleta-estatica-libre.png',
                  'disponible': true,
                },
                // Agrega más bicicletas estáticas si es necesario
              },
              crossAxisCount: 3,
              movementDetected: null, // No detecta movimiento
            ),
          ],
        ),
      ),
    );
  }
}

class SectionGrid extends StatelessWidget {
  final String title;
  final Map<String, Map<String, dynamic>> items;
  final int crossAxisCount;
  final bool? movementDetected;

  const SectionGrid({
    required this.title,
    required this.items,
    required this.crossAxisCount,
    required this.movementDetected,
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
            Color cardColor;
            String imagen;

            if (movementDetected != null) {
              // Para máquinas de correr
              cardColor = movementDetected == false ? Colors.green : Colors.red;
              imagen = movementDetected == true ? item['imagenOcupada'] : item['imagenLibre'];
            } else {
              // Para bicicletas estáticas
              cardColor = Colors.green;
              imagen = item['imagen'];
            }

            return AnimatedContainer(
              duration: Duration(milliseconds: 200),
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Card(
                color: cardColor,
                child: Column(
                  children: [
                    Expanded(
                      child: Image.asset(
                        imagen,
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
