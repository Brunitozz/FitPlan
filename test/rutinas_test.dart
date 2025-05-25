import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart'; // Import for initializeDateFormatting
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:primera_aplicacion/main.dart';
import 'package:primera_aplicacion/Rutinas/rutinas.dart';
import 'package:primera_aplicacion/Rutinas/editar_rutinas.dart';
import 'package:primera_aplicacion/Rutinas/provider.dart';

// Note: The RutinasScreen.dart uses a global `diaDeLaSemana` initialized by DateTime.now().
// Testing specific day behaviors reliably requires either:
// 1. Refactoring RutinasScreen to take `diaDeLaSemana` as a parameter or from a mockable source.
// 2. Using a more advanced mocking framework to control `DateTime.now()`.
// The current tests for day-specific UI will operate under the assumption that if the conditions
// for a specific day were met within RutinasScreen, the UI would behave as asserted.

void main() {
  // Initialize date formatting for Spanish locale before any tests run.
  setUpAll(() async {
    await initializeDateFormatting('es_ES', null);
  });

  group('RutinasScreen', () {
    late RutinasProvider rutinasProvider;
    
    Widget buildTestableWidget(Widget child) {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: rutinasProvider),
        ],
        child: MaterialApp(
          home: child,
          routes: {
            '/editarRutinas': (context) => EditarRutinasScreen(),
          },
        ),
      );
    }

    setUp(() {
      rutinasProvider = RutinasProvider();
      // It's important to know that diaDeLaSemana in rutinas.dart will be set by DateTime.now()
      // when RutinasScreen is first constructed or when that file is loaded.
    });

    testWidgets('Muestra UI general y botones principales', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestableWidget(RutinasScreen()));

      expect(find.byType(Image), findsOneWidget); 
      expect(find.text('Editar rutina'), findsOneWidget);
      expect(find.text('Rutinas sugeridas'), findsOneWidget);
    });

    testWidgets('Muestra lista de rutinas o mensaje de día libre basado en el día actual', (WidgetTester tester) async {
      rutinasProvider.updateRutina('Chest Press', 3, 12); // Ensure at least one routine is active

      await tester.pumpWidget(buildTestableWidget(RutinasScreen()));
      await tester.pumpAndSettle();

      String currentDayString = DateFormat('EEEE', 'es_ES').format(DateTime.now()).toLowerCase();
      print("Current day for test: $currentDayString");

      if (currentDayString == 'lunes' || currentDayString == 'miércoles') {
        expect(find.text('Chest Press'), findsOneWidget);
        expect(find.text('Repeticiones: 12'), findsOneWidget);
        expect(find.text('Series: 3'), findsOneWidget);
        expect(find.textContaining('libre, recupera energías!'), findsNothing);
      } else if (currentDayString == 'martes' || currentDayString == 'jueves' || currentDayString == 'viernes' || currentDayString == 'sábado' || currentDayString == 'domingo') {
        expect(find.textContaining('libre, recupera energías!'), findsOneWidget);
        expect(find.text('Chest Press'), findsNothing);
      } else {
        // Fallback for unknown day string, though DateFormat should be consistent
        print("Unknown day: $currentDayString, test might not be accurate.");
      }
    });

    testWidgets('Muestra "No hay rutinas creadas para hoy" si no hay rutinas activas en día de rutina', (WidgetTester tester) async {
      rutinasProvider.rutinas.forEach((key, rutina) {
        rutinasProvider.updateRutina(key, 0, 0); // Deactivate all routines
      });

      await tester.pumpWidget(buildTestableWidget(RutinasScreen()));
      await tester.pumpAndSettle();
      
      String currentDayString = DateFormat('EEEE', 'es_ES').format(DateTime.now()).toLowerCase();
      print("Current day for test (no routines active): $currentDayString");

      if (currentDayString == 'lunes' || currentDayString == 'miércoles') {
        expect(find.text('No hay rutinas creadas para hoy.'), findsOneWidget);
      } else {
        // If it's a free day, the "libre" message will be shown instead.
        expect(find.textContaining('libre, recupera energías!'), findsOneWidget);
        expect(find.text('No hay rutinas creadas para hoy.'), findsNothing);
      }
    });

    testWidgets('El botón "Editar rutina" muestra el diálogo y navega a Gimnasio', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestableWidget(RutinasScreen()));

      await tester.tap(find.text('Editar rutina'));
      await tester.pumpAndSettle(); 

      expect(find.text('Calistenia'), findsOneWidget);
      expect(find.text('Gimnasio'), findsOneWidget);

      await tester.tap(find.text('Gimnasio'));
      await tester.pumpAndSettle(); 

      expect(find.byType(EditarRutinasScreen), findsOneWidget);
    });

    testWidgets('El botón "Editar rutina" muestra el diálogo y muestra SnackBar para Calistenia', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestableWidget(RutinasScreen()));

      await tester.tap(find.text('Editar rutina'));
      await tester.pumpAndSettle(); 

      expect(find.text('Calistenia'), findsOneWidget);
      expect(find.text('Gimnasio'), findsOneWidget);

      await tester.tap(find.text('Calistenia'));
      await tester.pumpAndSettle(); 

      expect(find.byType(EditarRutinasScreen), findsNothing); 
      expect(find.text('En progreso'), findsOneWidget); 
    });
    
    testWidgets('El botón "Rutinas sugeridas" está presente', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestableWidget(RutinasScreen()));
      expect(find.text('Rutinas sugeridas'), findsOneWidget);
    });
  });
}
