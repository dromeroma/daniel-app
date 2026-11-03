/// Tipo de movimiento financiero registrado por el usuario.
enum TipoTransaccion { ingreso, gasto }

/// Un movimiento financiero individual (ingreso o gasto).
class Transaccion {
  const Transaccion({
    required this.id,
    required this.tipo,
    required this.monto,
    required this.categoria,
    required this.fecha,
  });

  final String id;
  final TipoTransaccion tipo;
  final double monto;
  final String categoria;
  final DateTime fecha;

  Map<String, dynamic> toJson() => {
        'id': id,
        'tipo': tipo.name,
        'monto': monto,
        'categoria': categoria,
        'fecha': fecha.toIso8601String(),
      };

  factory Transaccion.fromJson(Map<String, dynamic> json) => Transaccion(
        id: json['id'] as String,
        tipo: TipoTransaccion.values.byName(json['tipo'] as String),
        monto: (json['monto'] as num).toDouble(),
        categoria: json['categoria'] as String,
        fecha: DateTime.parse(json['fecha'] as String),
      );
}
