import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../datos_estudiante.dart';

/// Datos personales del usuario, editables desde "Actualizar datos" y
/// guardados en el dispositivo.
class PerfilControlador extends ChangeNotifier {
  static const _claveNombre = 'perfil_nombre';
  static const _claveCorreo = 'perfil_correo';
  static const _claveTelefono = 'perfil_telefono';

  String _nombre = DatosEstudiante.nombre;
  String _correo = '';
  String _telefono = '';

  String get nombre => _nombre;

  String get correo => _correo;

  String get telefono => _telefono;

  /// Carga los datos guardados. Debe llamarse una vez antes de mostrar la
  /// interfaz.
  Future<void> cargar() async {
    final prefs = await SharedPreferences.getInstance();
    _nombre = prefs.getString(_claveNombre) ?? DatosEstudiante.nombre;
    _correo = prefs.getString(_claveCorreo) ?? '';
    _telefono = prefs.getString(_claveTelefono) ?? '';
    notifyListeners();
  }

  Future<void> actualizar({
    required String nombre,
    required String correo,
    required String telefono,
  }) async {
    _nombre = nombre;
    _correo = correo;
    _telefono = telefono;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_claveNombre, nombre);
    await prefs.setString(_claveCorreo, correo);
    await prefs.setString(_claveTelefono, telefono);
  }
}
