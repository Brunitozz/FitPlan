import 'package:flutter/material.dart';

class MaquinasScreen extends StatefulWidget {
  const MaquinasScreen({Key? key}) : super(key: key);

  @override
  _MaquinasScreenState createState() => _MaquinasScreenState();
}

class _MaquinasScreenState extends State<MaquinasScreen> {
  late Map<String, Map<String, dynamic>> _maquinasDeCorrer;
  late Map<String, Map<String, dynamic>> _bicicletasEstaticas;
  static const String imagenMaquina_Ocupada = "assets/maquinas/maquina-ocupada.png";
  static const String imagenMaquina_Libre = "assets/maquinas/maquina-libre.png";
  static const String imagenBicicleta_Estatica_Ocupada = "assets/maquinas/bicicleta-estatica-ocupada.png";
  static const String imagenBicicleta_Estatica_Libre = "assets/maquinas/bicicleta-estatica-libre.png";

  @override
  void initState() {
    super.initState();

    _maquinasDeCorrer = {
      'maquina1': {'disponible': 0},
      'maquina2': {'disponible': 1},
      'maquina3': {'disponible': 1},
      'maquina4': {'disponible': 1},
      'maquina5': {'disponible': 0},
      'maquina6': {'disponible': 0},
      'maquina7': {'disponible': 1},
      'maquina8': {'disponible': 1},
      'maquina9': {'disponible': 1},
    };

    _bicicletasEstaticas = {
      'bicicleta1': {'disponible': 0},
      'bicicleta2': {'disponible': 1},
      'bicicleta3': {'disponible': 1},
      'bicicleta4': {'disponible': 1},
      'bicicleta5': {'disponible': 0},
      'bicicleta6': {'disponible': 0},
      'bicicleta7': {'disponible': 1},
      'bicicleta8': {'disponible': 1},
      'bicicleta9': {'disponible': 1},
    };
  }

  void _toggleAvailabilityMaquina(String key, Map<String, dynamic> item) async {
    setState(() {
      item['disponible'] = item['disponible'] == 0 ? 1 : 0;
    });
  }

  void _toggleAvailabilityBicicleta(String key, Map<String, dynamic> item) async {
    setState(() {
      item['disponible'] = item['disponible'] == 0 ? 1 : 0;
    });
  }

  String _getImageForMaquina(bool isAvailable) {
    return isAvailable ? imagenMaquina_Libre : imagenMaquina_Ocupada;
  }

  String _getImageForBicicleta(bool isAvailable) {
    return isAvailable ? imagenBicicleta_Estatica_Libre : imagenBicicleta_Estatica_Ocupada;
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
            SectionGrid(
              title: 'Máquinas de Correr',
              items: _maquinasDeCorrer,
              crossAxisCount: 3,
              onItemTap: _toggleAvailabilityMaquina,
              getImage: _getImageForMaquina,
            ),
            SectionGrid(
              title: 'Bicicletas Estáticas',
              items: _bicicletasEstaticas,
              crossAxisCount: 3,
              onItemTap: _toggleAvailabilityBicicleta,
              getImage: _getImageForBicicleta,
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
            bool isAvailable = item['disponible'] == 0;

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
