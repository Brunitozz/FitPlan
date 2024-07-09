import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'provider.dart';

class EditarRutinasScreen extends StatefulWidget {
  const EditarRutinasScreen({Key? key}) : super(key: key);

  @override
  _EditarRutinasScreenState createState() => _EditarRutinasScreenState();
}

class _EditarRutinasScreenState extends State<EditarRutinasScreen> {
  int _selectedIndex = 0;

  final List<String> _letras = ['L', 'M', 'Mi', 'J', 'V', 'S', 'D'];
  final List<String> _dias = ['lunes', 'martes', 'miércoles', 'jueves', 'viernes', 'sábado', 'domingo'];

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
                    _dias[i],
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
                children: _buildContentForDay(_dias[_selectedIndex]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRedSquare(String imagePath, String label, String dia) {
    return GestureDetector(
      onTap: () {
        _showEditDialog(context, label, dia);
      },
      child: Consumer<RutinasProvider>(
        builder: (context, rutinasProvider, child) {
          Rutina? rutina = rutinasProvider.rutinasPorDia[dia]![label];
          return Container(
            width: 120,
            height: 140,
            margin: EdgeInsets.only(right: 8.0),
            decoration: BoxDecoration(
              color: (rutina == null || (rutina.repeticiones == 0 && rutina.series == 0))
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

  void _showEditDialog(BuildContext context, String label, String dia) {
    TextEditingController repeticionesController = TextEditingController();
    TextEditingController seriesController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Consumer<RutinasProvider>(
          builder: (context, rutinasProvider, child) {
            Rutina? rutina = rutinasProvider.rutinasPorDia[dia]![label];

            repeticionesController.text = rutina?.repeticiones.toString() ?? '0';
            seriesController.text = rutina?.series.toString() ?? '0';

            return AlertDialog(
              title: Text('Editar rutina $label para $dia'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
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
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cerrar'),
                ),
                TextButton(
                  onPressed: () {
                    rutinasProvider.updateRutina(
                      dia,
                      label,
                      int.parse(repeticionesController.text),
                      int.parse(seriesController.text),
                    );
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Rutina guardada exitosamente'),
                      ),
                    );
                  },
                  child: Text('Guardar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  List<Widget> _buildContentForDay(String dia) {
    return [
      Text('Brazo', style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold)),
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildRedSquare('assets/rutinas/rowing.png', 'Rowing', dia),
            _buildRedSquare('assets/rutinas/chest_press.png', 'Chest Press', dia),
            _buildRedSquare('assets/rutinas/shoulder_press.png', 'Shoulder Press', dia),
          ],
        ),
      ),
      Text('Abdomen', style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold)),
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildRedSquare('assets/rutinas/chair.png', 'C. chair', dia),
            _buildRedSquare('assets/rutinas/crunch.png', 'Crunch', dia),
          ],
        ),
      ),
      Text('Pierna', style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold)),
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildRedSquare('assets/rutinas/calf_raise.png', 'Calf raise', dia),
            _buildRedSquare('assets/rutinas/leg_curl.png', 'Leg curl', dia),
            _buildRedSquare('assets/rutinas/leg_press.png', 'Leg press', dia),
          ],
        ),
      ),
      Text('Cardio', style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold)),
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildRedSquare('assets/rutinas/elliptical.png', 'Elliptical', dia),
            _buildRedSquare('assets/rutinas/treadmill.png', 'Treadmill', dia),
            _buildRedSquare('assets/rutinas/stationary_bike.png', 'Stationary bike', dia),
          ],
        ),
      ),
    ];
  }

  Widget _buildTextField({
    required String labelText,
    required TextEditingController controller,
  }) {
    return Row(
      children: [
        Text(labelText + ' ', style: TextStyle(color: Colors.black)),
        SizedBox(width: 8),
        SizedBox(
          width: 40,
          child: TextFormField(
            controller: controller,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black),
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              border: UnderlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(vertical: 5),
              isDense: true,
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
