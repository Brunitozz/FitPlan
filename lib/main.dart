import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:primera_aplicacion/firebase_options.dart';
import 'package:provider/provider.dart';
import 'maquinas.dart';
import 'Rutinas/rutinas.dart';
import 'Rutinas/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initializeDateFormatting('es_ES', null);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RutinasProvider()),
      ],
      child: MaterialApp(
        title: 'Smart Fit',
        theme: ThemeData(
          primaryColor: Colors.red, // Color de la barra superior
          colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.white), // Esquema de colores
          scaffoldBackgroundColor: Colors.white, // Color de fondo del Scaffold
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.red, // Color de fondo de la AppBar
            foregroundColor: Colors.white, // Color del contenido de la AppBar
          ),
        ),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  String _getTitle() {
    switch (_currentIndex) {
      case 0:
        return 'Máquinas';
      case 1:
        return 'Rutinas';
      case 2:
        return 'Dietas';
      default:
        return 'Inicio';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _getTitle(),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              print('Ícono de fotos presionado');
            },
            icon: const Icon(Icons.home),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.red,
              ),
              child: Text(
                'Menú',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Máquinas'),
              onTap: () {
                setState(() {
                  _currentIndex = 0; // Cambia al índice de la página de máquinas
                  Navigator.pop(context); // Cerrar el Drawer después de la selección
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.access_time),
              title: const Text('Rutinas'),
              onTap: () {
                setState(() {
                  _currentIndex = 1; // Cambia al índice de la página de rutinas
                  Navigator.pop(context); // Cerrar el Drawer después de la selección
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.access_alarm),
              title: const Text('Dietas'),
              onTap: () {
                setState(() {
                  _currentIndex = 2; // Cambia al índice de la página de dietas
                  Navigator.pop(context); // Cerrar el Drawer después de la selección
                });
              },
            ),
          ],
        ),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          const MaquinasScreen(),
          const RutinasScreen(), // Contenido para Rutinas
          const Center(child: Text('Contenido Dietas')), // Contenido para Dietas
        ],
      ),
    );
  }
}
