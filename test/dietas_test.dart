import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:primera_aplicacion/dietas/dietas.dart'; // Main screen to test
import 'package:primera_aplicacion/dietas/dietas_detalle.dart'; // Navigated screen
import 'package:primera_aplicacion/dietas/dieta_vegetariana.dart'; // Navigated screen

void main() {
  setUpAll(() async {
    // Initialize date formatting in case any screen uses it (good practice)
    await initializeDateFormatting('es_ES', null);
  });

  // Helper to build DietasScreen with MaterialApp
  Widget buildTestableWidget(Widget child) {
    return MaterialApp(
      home: child,
      routes: {
        '/dietasDetalle': (context) => const DietasDetalleScreen(),
        '/dietaVegetariana': (context) => const DietaVegetarianaScreen(),
      },
    );
  }

  group('DietasScreen', () {
    testWidgets('Muestra UI para "Clásica para Ganar Masa"', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestableWidget(const DietasScreen()));

      expect(find.text('Clásica para Ganar Masa'), findsOneWidget);
      expect(find.textContaining('Potencia tu crecimiento muscular con una dieta rica en proteínas'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Clásica para Ganar Masa'), findsOneWidget);
    });

    testWidgets('Muestra UI para "Vegetarianas para Ganar Masa"', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestableWidget(const DietasScreen()));

      // Scroll to ensure the widget is on screen if the content is long
      await tester.ensureVisible(find.text('Vegetarianas para Ganar Masa'));
      await tester.pumpAndSettle();


      expect(find.text('Vegetarianas para Ganar Masa'), findsOneWidget);
      expect(find.textContaining('Desarrolla músculo sin carne, nutriendo tu cuerpo'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Vegetarianas para Ganar Masa'), findsOneWidget);
    });

    testWidgets('Navega a DietasDetalleScreen al tocar "Clásica para Ganar Masa"', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestableWidget(const DietasScreen()));

      final clasicaButtonFinder = find.widgetWithText(ElevatedButton, 'Clásica para Ganar Masa');
      expect(clasicaButtonFinder, findsOneWidget);

      // Ensure the button is visible before tapping
      await tester.ensureVisible(clasicaButtonFinder);
      await tester.pumpAndSettle();

      await tester.tap(clasicaButtonFinder);
      await tester.pumpAndSettle(); 

      expect(find.byType(DietasDetalleScreen), findsOneWidget);
      expect(find.text('Detalles de la Dieta Clásica'), findsOneWidget);
    });

    testWidgets('Navega a DietaVegetarianaScreen al tocar "Vegetarianas para Ganar Masa"', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestableWidget(const DietasScreen()));
      
      final vegetarianaButtonFinder = find.widgetWithText(ElevatedButton, 'Vegetarianas para Ganar Masa');
      expect(vegetarianaButtonFinder, findsOneWidget);

      // Ensure the button is visible before tapping
      await tester.ensureVisible(vegetarianaButtonFinder);
      await tester.pumpAndSettle();

      await tester.tap(vegetarianaButtonFinder);
      await tester.pumpAndSettle();

      expect(find.byType(DietaVegetarianaScreen), findsOneWidget);
      expect(find.text('Detalles de la Dieta Vegetariana'), findsOneWidget);
    });
  });
}
