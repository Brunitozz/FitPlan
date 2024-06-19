import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MaquinasScreen extends StatefulWidget {
  const MaquinasScreen({Key? key}) : super(key: key);

  @override
  _MaquinasScreenState createState() => _MaquinasScreenState();
}

class _MaquinasScreenState extends State<MaquinasScreen> {
  late Map<String, Map<String, dynamic>> _maquinasDeCorrer;
  late Map<String, Map<String, dynamic>> _bicicletasEstaticas;

  @override
  void initState() {
    super.initState();
    _maquinasDeCorrer = {
      'maquina1': {
        'imagen': 'assets/maquinas/maquina-libre.png',
        'disponible': 0,
      },
      'maquina2': {
        'imagen': 'assets/maquinas/maquina-ocupada.png',
        'disponible': 1,
      },
      'maquina3': {
        'imagen': 'assets/maquinas/maquina-ocupada.png',
        'disponible': 1,
      },
      'maquina4': {
        'imagen': 'assets/maquinas/maquina-ocupada.png',
        'disponible': 1,
      },
      'maquina5': {
        'imagen': 'assets/maquinas/maquina-libre.png',
        'disponible': 0,
      },
      'maquina6': {
        'imagen': 'assets/maquinas/maquina-libre.png',
        'disponible': 0,
      },
      'maquina7': {
        'imagen': 'assets/maquinas/maquina-ocupada.png',
        'disponible': 1,
      },
      'maquina8': {
        'imagen': 'assets/maquinas/maquina-ocupada.png',
        'disponible': 1,
      },
      'maquina9': {
        'imagen': 'assets/maquinas/maquina-ocupada.png',
        'disponible': 1,
      },
    };

    _bicicletasEstaticas = {
      'bicicleta1': {
        'imagen': 'assets/maquinas/bicicleta-estatica-libre.png',
        'disponible': 0,
      },
      'bicicleta2': {
        'imagen': 'assets/maquinas/bicicleta-estatica-ocupada.png',
        'disponible': 1,
      },
      'bicicleta3': {
        'imagen': 'assets/maquinas/bicicleta-estatica-ocupada.png',
        'disponible': 1,
      },
      'bicicleta4': {
        'imagen': 'assets/maquinas/bicicleta-estatica-ocupada.png',
        'disponible': 1,
      },
      'bicicleta5': {
        'imagen': 'assets/maquinas/bicicleta-estatica-libre.png',
        'disponible': 0,
      },
      'bicicleta6': {
        'imagen': 'assets/maquinas/bicicleta-estatica-libre.png',
        'disponible': 0,
      },
      'bicicleta7': {
        'imagen': 'assets/maquinas/bicicleta-estatica-ocupada.png',
        'disponible': 1,
      },
      'bicicleta8': {
        'imagen': 'assets/maquinas/bicicleta-estatica-ocupada.png',
        'disponible': 1,
      },
      'bicicleta9': {
        'imagen': 'assets/maquinas/bicicleta-estatica-ocupada.png',
        'disponible': 1,
      },
    };
  }

  /*void getMaquinas() async {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection("maquinasDeCorrer");
    QuerySnapshot maquinasDeCorrer = await collectionReference.get();

    if (maquinasDeCorrer.docs.length != 0) {
      setState(() {
        for (var maquina in maquinasDeCorrer.docs) {
          var data = maquina.data() as Map<String, dynamic>;
          _maquinasDeCorrer[maquina.id] = {
            'imagen': data['imagen'],
            'disponible': data['disponible'],
          };
        }
      });
    }
  }

  void getBicicletas() async {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection("bicicletasEstaticas");
    QuerySnapshot bicicletasEstaticas = await collectionReference.get();

    if (bicicletasEstaticas.docs.length != 0) {
      setState(() {
        for (var maquina in bicicletasEstaticas.docs) {
          var data = maquina.data() as Map<String, dynamic>;
          _bicicletasEstaticas[maquina.id] = {
            'imagen': data['imagen'],
            'disponible': data['disponible'],
          };
        }
      });
    }
  }*/

  void _toggleAvailabilityMaquina(
      String key, Map<String, dynamic> item) async {
    setState(() {
      if (item['disponible'] == 0) {
        item['disponible'] = 1;
        item['imagen'] = 'assets/maquinas/maquina-ocupada.png';
      } else {
        item['disponible'] = 0;
        item['imagen'] = 'assets/maquinas/maquina-libre.png';
      }
    });

    /*await FirebaseFirestore.instance.collection('maquinas').doc(key).set({
      'disponible': item['disponible'],
      'imagen': item['imagen'],
    });*/
  }

  void _toggleAvailabilityBicicleta(
      String key, Map<String, dynamic> item) async {
    setState(() {
      if (item['disponible'] == 0) {
        item['disponible'] = 1;
        item['imagen'] = 'assets/maquinas/bicicleta-estatica-ocupada.png';
      } else {
        item['disponible'] = 0;
        item['imagen'] = 'assets/maquinas/bicicleta-estatica-libre.png';
      }
    });

    /*await FirebaseFirestore.instance
        .collection('bicicletasEstaticas')
        .doc(key)
        .set({
      'disponible': item['disponible'],
      'imagen': item['imagen'],
    });*/
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
            ),
            SectionGrid(
              title: 'Bicicletas Estáticas',
              items: _bicicletasEstaticas,
              crossAxisCount: 3,
              onItemTap: _toggleAvailabilityBicicleta,
            ),
          ],
        ),
      ),
    );
  }
}

class SectionGrid extends StatefulWidget {
  final String title;
  final Map<String, Map<String, dynamic>> items;
  final int crossAxisCount;
  final void Function(String, Map<String, dynamic>) onItemTap;

  const SectionGrid({
    required this.title,
    required this.items,
    required this.crossAxisCount,
    required this.onItemTap,
  });

  @override
  _SectionGridState createState() => _SectionGridState();
}

class _SectionGridState extends State<SectionGrid> {
  final Map<int, bool> _hovering = {};

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            widget.title,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: widget.crossAxisCount, // Número de columnas
            childAspectRatio: 1, // Aspecto de las celdas
          ),
          itemCount: widget.items.length, // Número de elementos (celdas)
          itemBuilder: (BuildContext context, int index) {
            String key = widget.items.keys.elementAt(index);
            Map<String, dynamic> item = widget.items[key]!;
            Color cardColor = item['disponible'] == 0
                ? Color(0xFFBBF246) // Color verde personalizado
                : Color(0xFFFF3C3C); // Color rojo personalizado

            return InkWell(
              onTap: () {
                widget.onItemTap(key, item);
              },
              child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                margin: EdgeInsets.symmetric(
                    vertical: _hovering[index] ?? false ? 0 : 10),
                child: Card(
                  color: cardColor,
                  child: Column(
                    children: [
                      Expanded(
                        child: Image.asset(
                          item['imagen'],
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '${widget.title.split(' ')[0]} ${index + 1}', // Nombre del ítem
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
