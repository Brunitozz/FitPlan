import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'editar_rutinas.dart';

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
            flex: 2, // Ocupa 2 partes de 3 (2/3 del espacio)
            child: AspectRatio(
              aspectRatio: 2.75 / 1, // Relación de aspecto deseada (ejemplo: 16:9)
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'assets/rutinas/rutinas_main.jpg', // Ruta de tu imagen
                    fit: BoxFit.cover, // Ajusta la imagen para cubrir el área disponible
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
                    right: 16.0, // Espaciado desde el borde derecho
                    bottom: 16.0, // Espaciado desde la parte inferior
                    child: Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            _mostrarOpciones(context); // Mostrar opciones al presionar el botón
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16), // Ajustar el padding
                            backgroundColor: Colors.redAccent, // Fondo del botón
                            foregroundColor: Colors.white, // Texto del botón
                          ),
                          child: const Text('Editar rutina', style: TextStyle(fontSize: 16)), // Ajustar el tamaño del texto
                        ),
                        const SizedBox(width: 16), // Espacio entre los botones
                        ElevatedButton(
                          onPressed: () {
                            // Acción del segundo botón
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16), // Ajustar el padding
                            backgroundColor: Colors.redAccent, // Fondo del botón
                            foregroundColor: Colors.white, // Texto del botón
                          ),
                          child: const Text('Rutinas sugeridas', style: TextStyle(fontSize: 16)), // Ajustar el tamaño del texto
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Flexible(
            flex: 1, // Ocupa 1 parte de 3 (1/3 del espacio)
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  _getContenidoDelDia(),
                  style: const TextStyle(fontSize: 18),
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
          backgroundColor: Colors.transparent, // Fondo transparente
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InteractiveSquare(
                color: Colors.greenAccent,
                iconData: Icons.directions_run,
                texto: 'Calistenia',
                onPressed: () {
                  // Lógica cuando se presiona la opción 1 (cuadrado rojo)
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('En progreso')),
                  );
                },
              ),
              SizedBox(width: 16), // Espacio entre los botones
              InteractiveSquare(
                color: Colors.black,
                iconData: Icons.fitness_center,
                texto: 'Gimnasio',
                onPressed: () {
                  Navigator.pop(context); // Cerrar el AlertDialog
                  Navigator.push( // Navegar a EditarRutinasScreen
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
        width: 200, // Ajustar el ancho del cuadro
        height: 200, // Ajustar el alto del cuadro
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20), // Bordes redondeados
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              iconData,
              color: Colors.white,
              size: 80, // Ajustar el tamaño del ícono
            ),
            SizedBox(height: 8),
            Text(
              texto,
              style: const TextStyle(color: Colors.white, fontSize: 23, fontWeight: FontWeight.bold), // Ajustar el tamaño del texto
            ),
          ],
        ),
      ),
    );
  }
}