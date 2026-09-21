/// ---------------------------------------------------------------------------
/// DATOS DE LA ACTIVIDAD
///
/// Todos los datos que aparecen en la aplicación están centralizados aquí.
/// Para personalizar la app basta con cambiar los valores de este archivo:
/// no es necesario tocar el resto del código.
/// ---------------------------------------------------------------------------
library;

class DatosEstudiante {
  // Evita que la clase se pueda instanciar: solo se usa como contenedor
  // de constantes.
  const DatosEstudiante._();

  /// Nombre completo del estudiante que firma la actividad.
  static const String nombre = 'Daniel Felipe Madera Cavadía';

  /// Programa académico que cursa el estudiante.
  static const String programa = 'Estudiante de Ingeniería de Sistemas';

  /// Nombre de la materia / curso.
  static const String curso = 'Desarrollo de Apps';

  /// Institución educativa.
  static const String universidad = 'Universidad de Cartagena';

  /// Nombre de la actividad entregada.
  static const String actividad = 'Aplicación de bienvenida';

  /// Descripción breve que se muestra en la pantalla principal.
  static const String descripcion =
      'Primera actividad del curso: una aplicación Android '
      'nativa construida con Flutter y Dart.';

  /// Firma que exige el enunciado de la actividad.
  static String get firma => 'ATT: $nombre';
}
