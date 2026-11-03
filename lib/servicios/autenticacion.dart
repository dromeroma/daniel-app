/// Credenciales de acceso a la aplicación.
///
/// La app no tiene backend, así que el único usuario está fijo en el código.
/// Esto sirve para la actividad, pero no protege datos reales: cualquiera
/// con el APK podría extraer estos valores.
class Autenticacion {
  const Autenticacion._();

  static const String usuario = 'Daniel';
  static const String contrasena = 'Daniel22';

  /// Indica si los datos coinciden. Se distingue entre mayúsculas y
  /// minúsculas; los espacios alrededor del usuario se ignoran porque el
  /// teclado del teléfono suele añadirlos al autocompletar.
  static bool validar(String usuarioIngresado, String contrasenaIngresada) =>
      usuarioIngresado.trim() == usuario && contrasenaIngresada == contrasena;
}
