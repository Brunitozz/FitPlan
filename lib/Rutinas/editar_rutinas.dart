import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'provider.dart'; // Asegúrate de tener la ruta correcta

class EditarRutinasScreen extends StatefulWidget {
  const EditarRutinasScreen({Key? key}) : super(key: key);

  @override
  _EditarRutinasScreenState createState() => _EditarRutinasScreenState();
}

class _EditarRutinasScreenState extends State<EditarRutinasScreen> {
  int _selectedIndex = 0;
  late List<List<Widget>> _contenidos;

  final List<String> _letras = ['L', 'M', 'Mi', 'J', 'V', 'S', 'D'];

  @override
  void initState() {
    super.initState();
    _updateContents();
  }

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
            thickness: 1,
            width: 1,
            color: Colors.grey,
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _contenidos[_selectedIndex],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRedSquare(String imagePath, String label) {
    return GestureDetector(
      onTap: () {
        _showEditDialog(context, label);
      },
      child: Consumer<RutinasProvider>(
        builder: (context, rutinasProvider, child) {
          Rutina rutina = rutinasProvider.rutinas[label]!;
          return Container(
            width: 120,
            height: 140,
            margin: EdgeInsets.only(right: 8.0),
            decoration: BoxDecoration(
              color: (rutina.repeticiones == 0 && rutina.series == 0)
                  ? Colors.redAccent.withOpacity(0.5)
                  : Colors.green.withOpacity(0.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(imagePath, width: 80, height: 80, fit: BoxFit.cover),
                SizedBox(height: 8),
                Text(label, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showEditDialog(BuildContext context, String label) {
    TextEditingController repeticionesController = TextEditingController();
    TextEditingController seriesController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Consumer<RutinasProvider>(
          builder: (context, rutinasProvider, child) {
            Rutina rutina = rutinasProvider.rutinas[label]!;

            repeticionesController.text = rutina.repeticiones.toString();
            seriesController.text = rutina.series.toString();

            return AlertDialog(
              title: Text('Añadir rutina $label'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  if (rutina.repeticiones > 0)
                    Text('Rutina ya creada'),
                  if (rutina.repeticiones == 0)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Coloque los valores a su criterio $label.'),
                        SizedBox(height: 16),
                        _buildTextField(
                          labelText: 'Repeticiones',
                          controller: repeticionesController,
                        ),
                        SizedBox(height: 16),
                        _buildTextField(
                          labelText: 'Series',
                          controller: seriesController,
                        ),
                      ],
                    ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cerrar'),
                ),
                if (rutina.repeticiones == 0)
                  TextButton(
                    onPressed: () {
                      rutinasProvider.updateRutina(
                        label,
                        int.parse(repeticionesController.text),
                        int.parse(seriesController.text),
                      );
                      Navigator.of(context).pop();
                    },
                    child: Text('Crear'),
                  ),
              ],
            );
          },
        );
      },
    );
  }

  void _updateContents() {
    _contenidos = [
      [ // Lunes
        Text('Brazo', style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold)),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildRedSquare('assets/rutinas/rowing.png', 'Rowing'),
              _buildRedSquare('assets/rutinas/chest_press.png', 'Chest Press'),
              _buildRedSquare('assets/rutinas/shoulder_press.png', 'Shoulder Press'),
            ],
          ),
        ),
        Text('Abdomen', style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold)),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildRedSquare('assets/rutinas/chair.png', 'C. chair'),
              _buildRedSquare('assets/rutinas/crunch.png', 'Crunch'),
            ],
          ),
        ),
        Text('Pierna', style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold)),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildRedSquare('assets/rutinas/calf_raise.png', 'Calf raise'),
              _buildRedSquare('assets/rutinas/leg_curl.png', 'Leg curl'),
              _buildRedSquare('assets/rutinas/leg_press.png', 'Leg press'),
            ],
          ),
        ),
        Text('Cardio', style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold)),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildRedSquare('assets/rutinas/elliptical.png', 'Elliptical'),
              _buildRedSquare('assets/rutinas/treadmill.png', 'Treadmill'),
              _buildRedSquare('assets/rutinas/stationary_bike.png', 'Stationary bike'),
            ],
          ),
        ),
      ],
      [Text('Contenido Martes', style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold))], // Martes
      [Text('Contenido Miércoles', style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold))], // Miércoles
      [Text('Contenido Jueves', style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold))], // Jueves
      [Text('Contenido Viernes', style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold))], // Viernes
      [Text('Contenido Sábado', style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold))], // Sábado
      [Text('Contenido Domingo', style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold))], // Domingo
    ];
    setState(() {}); // Asegura que la pantalla se actualice inmediatamente
  }

  Widget _buildTextField({
    required String labelText,
    required TextEditingController controller,
  }) {
    return Row(
      children: [
        Text(labelText + ' ', style: TextStyle(color: Colors.white)),
        SizedBox(width: 8),
        SizedBox(
          width: 40,
          child: TextFormField(
            controller: controller,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              border: UnderlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(vertical: 5),
              isDense: true,
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
          ),
        ),
      ],
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