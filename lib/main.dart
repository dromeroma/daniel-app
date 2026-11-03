import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'screens/pantalla_finanzas.dart';
import 'screens/pantalla_login.dart';
import 'servicios/finanzas_controlador.dart';
import 'servicios/notificaciones_controlador.dart';
import 'servicios/notificaciones_sistema.dart';
import 'servicios/perfil_controlador.dart';
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

  // Se cargan los datos guardados antes de mostrar la interfaz, para que
  // el dashboard nunca se muestre vacío por un instante.
  final controlador = FinanzasControlador();
  await controlador.cargar();

  final perfil = PerfilControlador();
  await perfil.cargar();

  final canal = NotificacionesSistema();
  await canal.inicializar();

  final notificaciones = NotificacionesControlador(canal: canal);
  await notificaciones.cargar();
  notificaciones.vigilar(controlador);

  runApp(AppFinanzas(
    controlador: controlador,
    perfil: perfil,
    notificaciones: notificaciones,
  ));
}

/// Widget raíz de la aplicación. Arranca siempre en el inicio de sesión.
class AppFinanzas extends StatelessWidget {
  const AppFinanzas({
    super.key,
    required this.controlador,
    required this.perfil,
    required this.notificaciones,
  });

  final FinanzasControlador controlador;
  final PerfilControlador perfil;
  final NotificacionesControlador notificaciones;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mis Finanzas',
      debugShowCheckedModeBanner: false,
      theme: Tema.datos,
      routes: {
        '/': (_) => const PantallaLogin(),
        '/inicio': (_) => PantallaFinanzas(
              controlador: controlador,
              perfil: perfil,
              notificaciones: notificaciones,
            ),
      },
    );
  }
}
