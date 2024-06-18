import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart'; // Importar provider
import 'editar_rutinas.dart';
import 'provider.dart'; // Importar RutinasProvider


class RutinasScreen extends StatelessWidget {
  const RutinasScreen({Key? key}) : super(key: key);

  String _getContenidoDelDia() {
    String diaDeLaSemana = DateFormat('EEEE', 'es_ES').format(DateTime.now());
    switch (diaDeLaSemana.toLowerCase()) {
      case 'lunes':
        return 'Contenido para el Lunes...';
      case 'martes':
        return 'Contenido para el Martes...';
      case 'miércoles':
        return 'Contenido para el Miércoles...';
      case 'jueves':
        return 'Contenido para el Jueves...';
      case 'viernes':
        return 'Contenido para el Viernes...';
      case 'sábado':
        return 'Contenido para el Sábado...';
      case 'domingo':
        return 'Contenido para el Domingo...';
      default:
        return 'Contenido de las rutinas...';
    }
  }

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
                    String contenido = _getContenidoDelDia();
                    return Text(
                      contenido,
                      style: const TextStyle(fontSize: 18),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
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
        width: 200,
        height: 200,
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