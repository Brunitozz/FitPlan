import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:primera_aplicacion/maquinas.dart'; // Screen to test

// Using string literals for image paths as these are defined as static const
// within the private _MaquinasScreenState class and not directly accessible for import.
const String imagenMaquinaOcupada = "assets/maquinas/maquina-ocupada.png";
const String imagenMaquinaLibre = "assets/maquinas/maquina-libre.png";
const String imagenBicicletaEstaticaOcupada = "assets/maquinas/bicicleta-estatica-ocupada.png";
const String imagenBicicletaEstaticaLibre = "assets/maquinas/bicicleta-estatica-libre.png";

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late FakeFirebaseFirestore firestore; 

  // No setUpAll with Firebase.initializeApp() - relying on direct instance injection
  // and FakeFirebaseFirestore managing its own context.

  setUp(() {
    firestore = FakeFirebaseFirestore();
    // Seed initial dummy data for collections to ensure they exist for StreamBuilders
    // This helps prevent issues if a test expects a collection to exist but is empty.
    // Individual tests should clear or set specific data as needed.
    firestore.collection('maquinasDeCorrer').doc('dummyMachineForSetup').set({'nombre': 'dummyMachineForSetup', 'disponible': 0});
    firestore.collection('bicicletasEstaticas').doc('dummyBikeForSetup').set({'nombre': 'dummyBikeForSetup', 'disponible': 0});
  });
  
  // Helper to clear a collection by deleting all its documents
  Future<void> clearCollection(String collectionName) async {
    final snapshot = await firestore.collection(collectionName).get();
    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }

  // Helper to seed data
  Future<void> seedData(String collection, String docId, Map<String, dynamic> data) async {
    await firestore.collection(collection).doc(docId).set(data);
  }


  testWidgets('Muestra títulos y máquinas de correr correctamente', (WidgetTester tester) async {
    await clearCollection('maquinasDeCorrer');
    await clearCollection('bicicletasEstaticas'); 
    
    await seedData('maquinasDeCorrer', 'maq1', {'nombre': 'maq1', 'disponible': 1});
    await seedData('maquinasDeCorrer', 'maq2', {'nombre': 'maq2', 'disponible': 0});
    
    await tester.pumpWidget(MaterialApp(
      home: MaquinasScreen(firestoreInstance: firestore),
    ));
    await tester.pumpAndSettle();

    expect(find.text('Máquinas de Correr'), findsOneWidget);
    expect(find.text('Máquinas 1'), findsOneWidget); 
    expect(find.text('Máquinas 2'), findsOneWidget); 
    expect(find.text('Bicicletas Estáticas'), findsOneWidget); // Title for other section should still be present
    
    final imageFinderMaq1 = find.descendant(
      of: find.widgetWithText(Card, 'Máquinas 1'), 
      matching: find.byType(Image)
    );
    expect(tester.widget<Image>(imageFinderMaq1).image, isA<AssetImage>().having((source) => source.assetName, 'assetName', imagenMaquinaLibre));
    
    final imageFinderMaq2 = find.descendant(
      of: find.widgetWithText(Card, 'Máquinas 2'), 
      matching: find.byType(Image)
    );
    expect(tester.widget<Image>(imageFinderMaq2).image, isA<AssetImage>().having((source) => source.assetName, 'assetName', imagenMaquinaOcupada));
  });

  testWidgets('Muestra bicicletas estáticas correctamente', (WidgetTester tester) async {
    await clearCollection('bicicletasEstaticas');
    await clearCollection('maquinasDeCorrer'); 
    await seedData('bicicletasEstaticas', 'bic1', {'nombre': 'bic1', 'disponible': 1});

    await tester.pumpWidget(MaterialApp(
      home: MaquinasScreen(firestoreInstance: firestore),
    ));
    await tester.pumpAndSettle();

    expect(find.text('Bicicletas Estáticas'), findsOneWidget);
    expect(find.text('Bicicletas 1'), findsOneWidget);
    expect(find.text('Máquinas de Correr'), findsOneWidget); // Title for other section should still be present

    final imageFinderBici1 = find.descendant(
      of: find.widgetWithText(Card, 'Bicicletas 1'), 
      matching: find.byType(Image)
    );
    expect(tester.widget<Image>(imageFinderBici1).image, isA<AssetImage>().having((source) => source.assetName, 'assetName', imagenBicicletaEstaticaLibre));
  });

   testWidgets('Muestra mensaje "No hay máquinas de correr disponibles" cuando no hay datos', (WidgetTester tester) async {
    await clearCollection('maquinasDeCorrer');
    // Ensure the other collection still has its dummy data from setUp to isolate this test.
    
    await tester.pumpWidget(MaterialApp(
      home: MaquinasScreen(firestoreInstance: firestore),
    ));
    await tester.pumpAndSettle();

    expect(find.text('No hay máquinas de correr disponibles'), findsOneWidget);
  });

  testWidgets('Muestra mensaje "No hay bicicletas estáticas disponibles" cuando no hay datos', (WidgetTester tester) async {
    await clearCollection('bicicletasEstaticas');
    // Ensure the other collection still has its dummy data from setUp.

    await tester.pumpWidget(MaterialApp(
      home: MaquinasScreen(firestoreInstance: firestore),
    ));
    await tester.pumpAndSettle();
    
    expect(find.text('No hay bicicletas estáticas disponibles'), findsOneWidget);
  });

  testWidgets('Alterna disponibilidad de máquina de correr al tocar', (WidgetTester tester) async {
    const machineDocId = 'CintaTest1';
    await clearCollection('maquinasDeCorrer');
    // Ensure other collection has dummy data
    await seedData('maquinasDeCorrer', machineDocId, {'nombre': machineDocId, 'disponible': 1});
    
    await tester.pumpWidget(MaterialApp(
      home: MaquinasScreen(firestoreInstance: firestore),
    ));
    await tester.pumpAndSettle();
    
    final machineCardFinder = find.text('Máquinas 1'); 
    expect(machineCardFinder, findsOneWidget);
    var imageFinder = find.descendant(of: find.ancestor(of: machineCardFinder, matching: find.byType(Card)), matching: find.byType(Image));
    expect(tester.widget<Image>(imageFinder).image, isA<AssetImage>().having((source) => source.assetName, 'assetName', imagenMaquinaLibre));
    
    await tester.tap(machineCardFinder);
    await tester.pumpAndSettle();

    var docSnapshot = await firestore.collection('maquinasDeCorrer').doc(machineDocId).get();
    expect(docSnapshot.data()?['disponible'], 0);
    imageFinder = find.descendant(of: find.ancestor(of: machineCardFinder, matching: find.byType(Card)), matching: find.byType(Image));
    expect(tester.widget<Image>(imageFinder).image, isA<AssetImage>().having((source) => source.assetName, 'assetName', imagenMaquinaOcupada));

    await tester.tap(machineCardFinder);
    await tester.pumpAndSettle();

    docSnapshot = await firestore.collection('maquinasDeCorrer').doc(machineDocId).get();
    expect(docSnapshot.data()?['disponible'], 1);
    imageFinder = find.descendant(of: find.ancestor(of: machineCardFinder, matching: find.byType(Card)), matching: find.byType(Image));
    expect(tester.widget<Image>(imageFinder).image, isA<AssetImage>().having((source) => source.assetName, 'assetName', imagenMaquinaLibre));
  });

  testWidgets('Alterna disponibilidad de bicicleta estática al tocar', (WidgetTester tester) async {
    const bikeDocId = 'BiciTest1';
    await clearCollection('bicicletasEstaticas');
    // Ensure other collection has dummy data
    await seedData('bicicletasEstaticas', bikeDocId, {'nombre': bikeDocId, 'disponible': 0});

    await tester.pumpWidget(MaterialApp(
      home: MaquinasScreen(firestoreInstance: firestore),
    ));
    await tester.pumpAndSettle();

    final bikeCardFinder = find.text('Bicicletas 1'); 
    expect(bikeCardFinder, findsOneWidget);
    var imageFinder = find.descendant(of: find.ancestor(of: bikeCardFinder, matching: find.byType(Card)), matching: find.byType(Image));
    expect(tester.widget<Image>(imageFinder).image, isA<AssetImage>().having((source) => source.assetName, 'assetName', imagenBicicletaEstaticaOcupada));

    await tester.tap(bikeCardFinder);
    await tester.pumpAndSettle();

    var docSnapshot = await firestore.collection('bicicletasEstaticas').doc(bikeDocId).get();
    expect(docSnapshot.data()?['disponible'], 1);
    imageFinder = find.descendant(of: find.ancestor(of: bikeCardFinder, matching: find.byType(Card)), matching: find.byType(Image));
    expect(tester.widget<Image>(imageFinder).image, isA<AssetImage>().having((source) => source.assetName, 'assetName', imagenBicicletaEstaticaLibre));
  });
}
