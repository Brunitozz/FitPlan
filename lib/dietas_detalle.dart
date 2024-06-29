import 'package:flutter/material.dart';

class DietasDetalleScreen extends StatelessWidget {
  const DietasDetalleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles de la Dieta Clásica'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildComidaBox(
            context,
            'Desayuno (8:00 AM)',
            '3 huevos enteros + 2 claras de huevo revueltos con espinacas y tomate.',
          ),
          const SizedBox(height: 20),
          _buildComidaBox(
            context,
            'Almuerzo (1:00 PM)',
            '150g de pechuga de pollo a la plancha con 1 taza de arroz integral y ensalada verde.',
          ),
          const SizedBox(height: 20),
          _buildComidaBox(
            context,
            'Comida Intermedia (4:00 PM)',
            'Batido de proteína de suero de leche con un plátano.',
          ),
          const SizedBox(height: 20),
          _buildComidaBox(
            context,
            'Cena (8:00 PM)',
            '200g de pescado con brócoli y 1/2 taza de quinoa.',
          ),
        ],
      ),
    );
  }

  Widget _buildComidaBox(BuildContext context, String title, String description) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10.0),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
