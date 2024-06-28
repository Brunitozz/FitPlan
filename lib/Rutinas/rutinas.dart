import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'editar_rutinas.dart';
import 'provider.dart';

String diaDeLaSemana = DateFormat('EEEE', 'es_ES').format(DateTime.now());

class RutinasScreen extends StatelessWidget {
  const RutinasScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    'assets/rutinas/rutinas_main.jpg',
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
                  Positioned(
                    right: 16.0,
                    bottom: 16.0,
                    child: Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            _mostrarOpciones(context);
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                            backgroundColor: Colors.redAccent,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Editar rutina', style: TextStyle(fontSize: 16)),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: () {
                            // Acción del segundo botón
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                            backgroundColor: Colors.redAccent,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Rutinas sugeridas', style: TextStyle(fontSize: 16)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Consumer<RutinasProvider>(
                  builder: (context, rutinasProvider, child) {
                    return mostrarRutinas(rutinasProvider);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget mostrarRutinas(RutinasProvider rutinasProvider) {
    switch (diaDeLaSemana.toLowerCase()) {
      case 'lunes':
        return _buildRutinasList(rutinasProvider);
      case 'martes':
        return _buildMensaje('¡Martes libre, recupera energías!');
      case 'miércoles':
        return _buildRutinasList(rutinasProvider);
      case 'jueves':
        return _buildMensaje('¡Jueves libre, recupera energías!');
      case 'viernes':
        return _buildMensaje('¡Viernes libre, recupera energías!');
      case 'sábado':
        return _buildMensaje('¡Sábado libre, recupera energías!');
      case 'domingo':
        return _buildMensaje('¡Domingo libre, recupera energías!');
      default:
        return _buildMensaje('Contenido de las rutinas...');
    }
  }

  Widget _buildRutinasList(RutinasProvider rutinasProvider) {
    List<Widget> rutinasWidgets = [];

    rutinasProvider.rutinas.forEach((key, rutina) {
      if (rutina.repeticiones > 0 && rutina.series > 0) {
        rutinasWidgets.add(Container(
          margin: EdgeInsets.only(bottom: 10),
          padding: EdgeInsets.all(10),
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
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    rutina.name,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Repeticiones: ${rutina.repeticiones}',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  Text(
                    'Series: ${rutina.series}',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
            ],
          ),
        ));
      }
    });

    if (rutinasWidgets.isEmpty) {
      return Text(
        'No hay rutinas creadas para hoy.',
        style: TextStyle(fontSize: 18),
      );
    }

    return ListView(
      children: rutinasWidgets,
    );
  }

  Widget _buildMensaje(String mensaje) {
    return Text(
      mensaje,
      style: TextStyle(fontSize: 18),
    );
  }

  void _mostrarOpciones(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InteractiveSquare(
                color: Colors.greenAccent,
                iconData: Icons.directions_run,
                texto: 'Calistenia',
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('En progreso')),
                  );
                },
              ),
              SizedBox(width: 16),
              InteractiveSquare(
                color: Colors.black,
                iconData: Icons.fitness_center,
                texto: 'Gimnasio',
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EditarRutinasScreen()),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  String obtenerImagen(String nombre) {
    switch (nombre) {
      case 'Rowing':
        return 'assets/rutinas/rowing.png';
      case 'Chest Press':
        return 'assets/rutinas/chest_press.png';
      case 'Shoulder Press':
        return 'assets/rutinas/shoulder_press.png';
      case 'C. chair':
        return 'assets/rutinas/chair.png';
      case 'Crunch':
        return 'assets/rutinas/crunch.png';
      case 'Calf raise':
        return 'assets/rutinas/calf_raise.png';
      case 'Leg curl':
        return 'assets/rutinas/leg_curl.png';
      case 'Leg press':
        return 'assets/rutinas/leg_press.png';
      case 'Elliptical':
        return 'assets/rutinas/elliptical.png';
      case 'Treadmill':
        return 'assets/rutinas/treadmill.png';
      case 'Stationary bike':
        return 'assets/rutinas/stationary_bike.png';
      default:
        return 'assets/rutinas/rowing.png';
    }
  }
}

class InteractiveSquare extends StatelessWidget {
  final Color color;
  final IconData iconData;
  final String texto;
  final VoidCallback onPressed;

  const InteractiveSquare({
    required this.color,
    required this.iconData,
    required this.texto,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 133,
        height: 133,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              iconData,
              color: Colors.white,
              size: 80,
            ),
            SizedBox(height: 8),
            Text(
              texto,
              style: const TextStyle(color: Colors.white, fontSize: 23, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
