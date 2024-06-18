import 'package:flutter/material.dart';

class Rutina {
  final String name;
  int repeticiones;
  int series;

  Rutina({
    required this.name,
    required this.repeticiones,
    required this.series,
  });
}

class RutinasProvider with ChangeNotifier {
  Map<String, Rutina> _rutinas = {
    'Rowing': Rutina(name: 'Rowing', repeticiones: 0, series: 0),
    'Chest Press': Rutina(name: 'Chest Press', repeticiones: 0, series: 0),
    'Shoulder Press': Rutina(name: 'Shoulder Press', repeticiones: 0, series: 0),
    'C. chair': Rutina(name: 'C. chair', repeticiones: 0, series: 0),
    'Crunch': Rutina(name: 'Crunch', repeticiones: 0, series: 0),
    'Calf raise': Rutina(name: 'Calf raise', repeticiones: 0, series: 0),
    'Leg curl': Rutina(name: 'Leg curl', repeticiones: 0, series: 0),
    'Leg press': Rutina(name: 'Leg press', repeticiones: 0, series: 0),
    'Elliptical': Rutina(name: 'Elliptical', repeticiones: 0, series: 0),
    'Treadmill': Rutina(name: 'Treadmill', repeticiones: 0, series: 0),
    'Stationary bike': Rutina(name: 'Stationary bike', repeticiones: 0, series: 0),
  };

  Map<String, Rutina> get rutinas => _rutinas;

  void updateRutina(String name, int repeticiones, int series) {
    if (_rutinas.containsKey(name)) {
      _rutinas[name]!.repeticiones = repeticiones;
      _rutinas[name]!.series = series;
      notifyListeners();
    }
  }
}
