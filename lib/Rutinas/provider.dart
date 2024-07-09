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
  // Mapa que contiene las rutinas para cada día de la semana
  Map<String, Map<String, Rutina>> _rutinasPorDia = {
    'lunes': {},
    'martes': {},
    'miércoles': {},
    'jueves': {},
    'viernes': {},
    'sábado': {},
    'domingo': {},
  };

  Map<String, Map<String, Rutina>> get rutinasPorDia => _rutinasPorDia;

  void updateRutina(String dia, String name, int repeticiones, int series) {
    if (!_rutinasPorDia[dia]!.containsKey(name)) {
      _rutinasPorDia[dia]![name] = Rutina(name: name, repeticiones: repeticiones, series: series);
    } else {
      _rutinasPorDia[dia]![name]!.repeticiones = repeticiones;
      _rutinasPorDia[dia]![name]!.series = series;
    }
    notifyListeners();
  }
}
