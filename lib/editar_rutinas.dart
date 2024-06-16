import 'package:flutter/material.dart';

class EditarRutinasScreen extends StatefulWidget {
  const EditarRutinasScreen({Key? key}) : super(key: key);

  @override
  _EditarRutinasScreenState createState() => _EditarRutinasScreenState();
}

class _EditarRutinasScreenState extends State<EditarRutinasScreen> {
  int _selectedIndex = 0;

  // Lista de contenidos asociados a cada ítem del NavigationRail
  List<List<String>> _contenidos = [
    // Contenido para cada día de la semana
    ['Brazo', 'Abdomen', 'Pierna', 'Cardio'], // Lunes
    ['Contenido Martes'], // Martes
    ['Contenido Miércoles'], // Miércoles
    ['Contenido Jueves'], // Jueves
    ['Contenido Viernes'], // Viernes
    ['Contenido Sábado'], // Sábado
    ['Contenido Domingo'], // Domingo
  ];

  // Lista de letras iniciales de los días de la semana
  List<String> _letras = ['L', 'M', 'Mi', 'J', 'V', 'S', 'D'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Rutinas'),
      ),
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            labelType: NavigationRailLabelType.selected,
            backgroundColor: Colors.black54,
            destinations: [
              for (int i = 0; i < 7; i++)
                NavigationRailDestination(
                  icon: Text(
                    _letras[i],
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                  selectedIcon: Text(
                    _letras[i],
                    style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  label: Text(
                    _getDiaDeLaSemana(i),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
            ],
          ),
          VerticalDivider(
            thickness: 1, // Grosor de la línea
            width: 1, // Ancho del divisor
            color: Colors.grey, // Color de la línea
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (String item in _contenidos[_selectedIndex])
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        item,
                        style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getDiaDeLaSemana(int index) {
    switch (index) {
      case 0:
        return 'Lunes';
      case 1:
        return 'Martes';
      case 2:
        return 'Miércoles';
      case 3:
        return 'Jueves';
      case 4:
        return 'Viernes';
      case 5:
        return 'Sábado';
      case 6:
        return 'Domingo';
      default:
        return '';
    }
  }
}
