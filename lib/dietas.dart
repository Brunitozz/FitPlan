import 'package:flutter/material.dart';
import 'dietas_detalle.dart';
import 'dieta_vegetariana.dart';

class DietasScreen extends StatelessWidget {
  const DietasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // First Flexible widget with AspectRatio, Stack, Image, Container, Positioned
            AspectRatio(
              aspectRatio: 2.75 / 1, // Relación de aspecto deseada (ejemplo: 16:9)
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'assets/dietas/dieta.jpg', // Ruta de tu imagen
                    fit: BoxFit.cover, // Ajusta la imagen para cubrir el área disponible
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.5), // Left side with opacity
                          Colors.transparent,              // Right side fully transparent
                        ],
                        begin: Alignment.centerLeft,  // Gradient starts from left
                        end: Alignment.centerRight,   // Gradient ends at right
                      ),
                    ),
                  ),
                  const Positioned(
                    left: 16.0, // Espaciado desde el borde izquierdo
                    bottom: 20.0, // Adjust spacing from bottom (reduced)
                    child: Text(
                      'Dietas \nSugeridas',
                      style: TextStyle(
                        fontSize: 35, // Ajustar el tamaño del texto
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
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Botón 1
                  Container(
                    width: 350, // Ajusta este valor según lo necesario
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const DietasDetalleScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero, // Elimina el padding extra del botón
                        backgroundColor: Colors.transparent, // Fondo transparente para no añadir colores adicionales
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade800,
                          borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0), // Padding del contenedor principal
                              child: const Text(
                                'Clásica para Ganar Masa',
                                style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                            ),
                            Container(
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(20.0),
                                  bottomRight: Radius.circular(20.0),
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0), // Padding para la descripción
                              child: const Text(
                                'Potencia tu crecimiento muscular con una dieta rica en proteínas provenientes de fuentes animales, carbohidratos complejos y grasas saludables.',
                                style: TextStyle(fontSize: 17, color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 35), // Espacio entre botones
                  // Botón 2
                  Container(
                    width: 350, // Ajusta este valor según lo necesario
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const DietaVegetariana()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero, // Elimina el padding extra del botón
                        backgroundColor: Colors.transparent, // Fondo transparente para no añadir colores adicionales
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade800,
                          borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0), // Padding del contenedor principal
                              child: const Text(
                                'Vegetarianas para Ganar Masa',
                                style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                            ),
                            Container(
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(20.0),
                                  bottomRight: Radius.circular(20.0),
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0), // Padding para la descripción
                              child: const Text(
                                'Desarrolla músculo sin carne, nutriendo tu cuerpo con proteínas vegetales de alta calidad, carbohidratos integrales y grasas beneficiosas.',
                                style: TextStyle(fontSize: 17, color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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
    super.key,
  });

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
            const SizedBox(height: 8),
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
