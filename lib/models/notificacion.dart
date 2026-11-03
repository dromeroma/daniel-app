/// Aviso mostrado en la bandeja de notificaciones de la app.
class Notificacion {
  const Notificacion({
    required this.id,
    required this.titulo,
    required this.mensaje,
    required this.fecha,
    this.leida = false,
  });

  final String id;
  final String titulo;
  final String mensaje;
  final DateTime fecha;
  final bool leida;

  Notificacion marcadaComoLeida() => Notificacion(
        id: id,
        titulo: titulo,
        mensaje: mensaje,
        fecha: fecha,
        leida: true,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'titulo': titulo,
        'mensaje': mensaje,
        'fecha': fecha.toIso8601String(),
        'leida': leida,
      };

  factory Notificacion.fromJson(Map<String, dynamic> json) => Notificacion(
        id: json['id'] as String,
        titulo: json['titulo'] as String,
        mensaje: json['mensaje'] as String,
        fecha: DateTime.parse(json['fecha'] as String),
        leida: json['leida'] as bool,
      );
}
