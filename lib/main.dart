import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'screens/pantalla_finanzas.dart';
import 'servicios/finanzas_controlador.dart';
import 'tema.dart';

/// Punto de entrada de la aplicación.
void main() async {
  // Necesario antes de llamar a SystemChrome y de leer SharedPreferences.
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

  // Se cargan las transacciones guardadas antes de mostrar la interfaz,
  // para que el dashboard nunca se muestre vacío por un instante.
  final controlador = FinanzasControlador();
  await controlador.cargar();

  runApp(AppFinanzas(controlador: controlador));
}

/// Widget raíz de la aplicación.
class AppFinanzas extends StatelessWidget {
  const AppFinanzas({super.key, required this.controlador});

  final FinanzasControlador controlador;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mis Finanzas',
      debugShowCheckedModeBanner: false,
      theme: Tema.datos,
      home: PantallaFinanzas(controlador: controlador),
    );
  }
}
