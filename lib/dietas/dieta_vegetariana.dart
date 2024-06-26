import 'package:flutter/material.dart';

class DietaVegetariana extends StatelessWidget {
  const DietaVegetariana({Key? key}) : super(key: key);

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
            'Batido de proteínas vegetales con espinacas, plátano, y mantequilla de almendras.',
          ),
          const SizedBox(height: 20),
          _buildComidaBox(
            context,
            'Almuerzo (1:00 PM)',
            'Ensalada de quinoa con garbanzos, espinacas, tomate cherry, pepino, y aderezo de tahini.',
          ),
          const SizedBox(height: 20),
          _buildComidaBox(
            context,
            'Comida Intermedia (4:00 PM)',
            'Yogur griego con nueces y miel.',
          ),
          const SizedBox(height: 20),
          _buildComidaBox(
            context,
            'Cena (8:00 PM)',
            'Tofu marinado y salteado con verduras mixtas y arroz integral.',
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
