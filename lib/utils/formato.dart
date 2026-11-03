/// Funciones de formato usadas en el módulo de finanzas.
/// Se implementan a mano (sin `intl`) para mantener las dependencias
/// del proyecto al mínimo.
library;

const _mesesAbrev = [
  'ene',
  'feb',
  'mar',
  'abr',
  'may',
  'jun',
  'jul',
  'ago',
  'sep',
  'oct',
  'nov',
  'dic',
];

const _diasAbrev = ['L', 'M', 'X', 'J', 'V', 'S', 'D'];

/// Formatea un monto como pesos, con punto como separador de miles.
/// Ejemplo: 1234567.0 -> "$ 1.234.567".
String formatearMoneda(double valor) {
  final esNegativo = valor < 0;
  final digitos = valor.abs().round().toString();

  final buffer = StringBuffer();
  for (var i = 0; i < digitos.length; i++) {
    final posicionDesdeElFinal = digitos.length - i;
    if (i > 0 && posicionDesdeElFinal % 3 == 0) buffer.write('.');
    buffer.write(digitos[i]);
  }

  return '${esNegativo ? '-' : ''}\$ $buffer';
}

/// Formatea una fecha como "21 sep 2026".
String formatearFecha(DateTime fecha) {
  final dia = fecha.day.toString().padLeft(2, '0');
  return '$dia ${_mesesAbrev[fecha.month - 1]} ${fecha.year}';
}

/// Abrevia el día de la semana (1 = lunes ... 7 = domingo) a una letra.
String abreviarDia(int diaSemana) => _diasAbrev[diaSemana - 1];

/// Abrevia el mes (1 = enero ... 12 = diciembre), con mayúscula inicial.
String abreviarMes(int mes) {
  final texto = _mesesAbrev[mes - 1];
  return texto[0].toUpperCase() + texto.substring(1);
}
