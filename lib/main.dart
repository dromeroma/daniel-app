import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'datos_estudiante.dart';
import 'screens/pantalla_bienvenida.dart';
import 'tema.dart';

/// Punto de entrada de la aplicación.
void main() {
  // Necesario antes de llamar a SystemChrome.
  WidgetsFlutterBinding.ensureInitialized();

  // La actividad pide orientación vertical: se bloquea el giro.
  SystemChrome.setPreferredOrientations(const [
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Barra de estado transparente con iconos claros, para que el
  // degradado se vea de borde a borde.
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));

  runApp(const AppBienvenida());
}

/// Widget raíz de la aplicación.
class AppBienvenida extends StatelessWidget {
  const AppBienvenida({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: DatosEstudiante.curso,
      debugShowCheckedModeBanner: false,
      theme: Tema.datos,
      home: const PantallaBienvenida(),
    );
  }
}
