import 'package:flutter/material.dart';

/// Paleta de colores y tema visual de la aplicación.
/// Centralizarlos aquí permite cambiar el aspecto de toda la app
/// modificando un solo archivo.
class Tema {
  const Tema._();

  static const Color violeta = Color(0xFF4F46E5);
  static const Color violetaOscuro = Color(0xFF7C3AED);
  static const Color indigoClaro = Color(0xFF818CF8);
  static const Color textoOscuro = Color(0xFF1E1B4B);
  static const Color textoSuave = Color(0xFF64748B);

  /// Degradado usado como fondo en las dos pantallas.
  static const LinearGradient fondo = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [violeta, violetaOscuro, indigoClaro],
  );

  /// Tema Material 3 de la aplicación.
  static ThemeData get datos => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: violeta),
        scaffoldBackgroundColor: violeta,
        fontFamily: 'Roboto',
      );
}
