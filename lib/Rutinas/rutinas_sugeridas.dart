import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'provider.dart';

class RutinasSugeridasScreen extends StatelessWidget {
  RutinasSugeridasScreen({Key? key}) : super(key: key);

  final Map<String, Map<String, Rutina>> rutinasSugeridas = {
    'lunes': {
      'Rowing': Rutina(name: 'Rowing', repeticiones: 13, series: 3),
      'Chest Press': Rutina(name: 'Chest Press', repeticiones: 15, series: 4),
      'Crunch': Rutina(name: 'Crunch', repeticiones: 10, series: 3),
    },
    'miércoles': {
      'Leg curl': Rutina(name: 'Leg curl', repeticiones: 15, series: 3),
      'Leg press': Rutina(name: 'Leg press', repeticiones: 15, series: 4),
    },
    'sábado': {
      'Treadmill': Rutina(name: 'Treadmill', repeticiones: 10, series: 3),
      'Elliptical': Rutina(name: 'Elliptical', repeticiones: 10, series: 4),
    },
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rutinas Sugeridas'),
      ),
      body: Column(
        children: [
          Flexible(
            flex: 2,
            child: AspectRatio(
              aspectRatio: 2.75 / 1,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'rutinas/rutinas_sug.jpg',
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.5),
                          Colors.transparent,
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: const [
                Text(
                  'Rutina cuerpo completo',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Reemplaza tus rutinas actuales con las sugeridas para un entrenamiento completo.',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Expanded(
            flex: 4, // Increase the flex value to give more space to the list
            child: ListView(
              children: rutinasSugeridas.entries.map((entry) {
                String dia = entry.key;
                return _buildRutinasList(entry.value, dia);
              }).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                _confirmarReemplazo(context);
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
              ),
              child: const Text('Implementar rutina'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRutinasList(Map<String, Rutina> rutinas, String dia) {
    List<Widget> rutinasWidgets = [];

    rutinas.forEach((key, rutina) {
      if (rutina.repeticiones > 0 && rutina.series > 0) {
        rutinasWidgets.add(Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.redAccent.withOpacity(0.5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Image.asset(
                obtenerImagen(rutina.name),
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    rutina.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Repeticiones: ${rutina.repeticiones}',
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  Text(
                    'Series: ${rutina.series}',
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
            ],
          ),
        ));
      }
    });

    return ExpansionTile(
      title: Text(dia[0].toUpperCase() + dia.substring(1)),
      children: rutinasWidgets,
    );
  }

  String obtenerImagen(String nombre) {
    switch (nombre) {
      case 'Rowing':
        return 'assets/rutinas/rowing.png';
      case 'Chest Press':
        return 'assets/rutinas/chest_press.png';
      case 'Crunch':
        return 'assets/rutinas/crunch.png';
      case 'Leg curl':
        return 'assets/rutinas/leg_curl.png';
      case 'Leg press':
        return 'assets/rutinas/leg_press.png';
      case 'Treadmill':
        return 'assets/rutinas/treadmill.png';
      case 'Elliptical':
        return 'assets/rutinas/elliptical.png';
      default:
        return 'assets/rutinas/default.png';
    }
  }

  void _confirmarReemplazo(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Reemplazo'),
          content: const Text(
              '¿Estás seguro de que deseas reemplazar todas las rutinas existentes con las rutinas sugeridas? Esto eliminará las rutinas previas.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _aplicarRutinasSugeridas(context);
              },
              child: const Text('Reemplazar'),
            ),
          ],
        );
      },
    );
  }

  void _aplicarRutinasSugeridas(BuildContext context) {
    final rutinasProvider = Provider.of<RutinasProvider>(context, listen: false);

    // Reemplazar las rutinas del día con las sugeridas
    rutinasSugeridas.forEach((dia, rutinas) {
      rutinasProvider.rutinasPorDia[dia] = rutinas;
    });

    // Añadir rutinas con 0 repeticiones y 0 series para los días restantes
    for (String dia in ['martes', 'jueves', 'viernes', 'domingo']) {
      if (rutinasProvider.rutinasPorDia[dia]!.isEmpty) {
        continue;
      }

      rutinasProvider.rutinasPorDia[dia]!.forEach((name, rutina) {
        rutina.repeticiones = 0;
        rutina.series = 0;
      });
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Rutinas sugeridas aplicadas con éxito')),
    );
  }
}
