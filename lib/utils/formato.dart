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

final _montoSimple = RegExp(r'^\d+(?:[.,]\d{1,2})?$');
final _montoMilesConPunto = RegExp(r'^\d{1,3}(?:\.\d{3})+(?:,\d{1,2})?$');
final _montoMilesConComa = RegExp(r'^\d{1,3}(?:,\d{3})+(?:\.\d{1,2})?$');

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

/// Formatea un monto sin símbolo, para prellenar el campo de edición.
/// Ejemplo: 1234567.0 -> "1.234.567"; 1500.5 -> "1.500,50".
String formatearNumero(double valor) {
  final entero = formatearMoneda(valor.truncateToDouble()).substring(2);
  final centavos = ((valor - valor.truncateToDouble()) * 100).round();
  if (centavos == 0) return entero;
  return '$entero,${centavos.toString().padLeft(2, '0')}';
}

/// Convierte el texto de un monto a número, o devuelve `null` si no es
/// válido. Acepta el punto como separador de miles, igual que muestra la
/// app: "150.000" son ciento cincuenta mil, no ciento cincuenta. También
/// acepta "1,500" (miles) y decimales de hasta dos cifras ("1500,50").
double? interpretarMonto(String texto) {
  final limpio = texto.trim();

  double? valor;
  if (_montoSimple.hasMatch(limpio)) {
    valor = double.tryParse(limpio.replaceAll(',', '.'));
  } else if (_montoMilesConPunto.hasMatch(limpio)) {
    valor = double.tryParse(limpio.replaceAll('.', '').replaceAll(',', '.'));
  } else if (_montoMilesConComa.hasMatch(limpio)) {
    valor = double.tryParse(limpio.replaceAll(',', ''));
  }

  if (valor == null || !valor.isFinite || valor <= 0) return null;
  return valor;
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
