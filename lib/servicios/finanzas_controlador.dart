import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/transaccion.dart';
import '../tema.dart';
import '../utils/formato.dart';

/// Un punto de datos para el gráfico comparativo (ingresos vs. gastos)
/// en una unidad de tiempo (un día o un mes).
class PuntoComparativo {
  const PuntoComparativo({
    required this.etiqueta,
    required this.ingresos,
    required this.gastos,
  });

  final String etiqueta;
  final double ingresos;
  final double gastos;
}

/// Mantiene la lista de transacciones en memoria, la persiste en el
/// dispositivo y expone los totales y series que usan el dashboard,
/// los gráficos y la lista de transacciones.
class FinanzasControlador extends ChangeNotifier {
  static const _clavePreferencia = 'finanzas_transacciones';

  final List<Transaccion> _transacciones = [];

  /// Transacciones ordenadas de la más reciente a la más antigua.
  List<Transaccion> get transacciones {
    final copia = List<Transaccion>.from(_transacciones);
    copia.sort((a, b) => b.fecha.compareTo(a.fecha));
    return copia;
  }

  double get totalIngresos => _sumar(TipoTransaccion.ingreso);

  double get totalGastos => _sumar(TipoTransaccion.gasto);

  double get saldo => totalIngresos - totalGastos;

  /// Se activa con saldo negativo o por debajo del límite recomendado.
  bool get enAlerta => saldo < Tema.limiteAlertaSaldo;

  double _sumar(TipoTransaccion tipo) => _transacciones
      .where((t) => t.tipo == tipo)
      .fold(0.0, (suma, t) => suma + t.monto);

  /// Carga las transacciones guardadas en el dispositivo. Debe llamarse
  /// una vez antes de mostrar la interfaz.
  Future<void> cargar() async {
    final prefs = await SharedPreferences.getInstance();
    final guardadas = prefs.getStringList(_clavePreferencia) ?? [];
    _transacciones
      ..clear()
      ..addAll(
        guardadas.map(
          (texto) => Transaccion.fromJson(
            jsonDecode(texto) as Map<String, dynamic>,
          ),
        ),
      );
    notifyListeners();
  }

  Future<void> _guardar() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _clavePreferencia,
      _transacciones.map((t) => jsonEncode(t.toJson())).toList(),
    );
  }

  Future<void> agregar(Transaccion transaccion) async {
    _transacciones.add(transaccion);
    notifyListeners();
    await _guardar();
  }

  Future<void> eliminar(String id) async {
    _transacciones.removeWhere((t) => t.id == id);
    notifyListeners();
    await _guardar();
  }

  /// Ingresos vs. gastos de cada uno de los últimos 7 días.
  List<PuntoComparativo> resumenSemanal() {
    final hoy = DateTime.now();
    final hoySinHora = DateTime(hoy.year, hoy.month, hoy.day);

    return List.generate(7, (i) {
      final dia = hoySinHora.subtract(Duration(days: 6 - i));
      final delDia =
          _transacciones.where((t) => _esMismoDia(t.fecha, dia)).toList();

      return PuntoComparativo(
        etiqueta: abreviarDia(dia.weekday),
        ingresos: _sumarLista(delDia, TipoTransaccion.ingreso),
        gastos: _sumarLista(delDia, TipoTransaccion.gasto),
      );
    });
  }

  /// Ingresos vs. gastos de cada uno de los últimos 6 meses.
  List<PuntoComparativo> resumenMensual() {
    final hoy = DateTime.now();

    return List.generate(6, (i) {
      final mes = DateTime(hoy.year, hoy.month - (5 - i));
      final delMes = _transacciones
          .where((t) => t.fecha.year == mes.year && t.fecha.month == mes.month)
          .toList();

      return PuntoComparativo(
        etiqueta: abreviarMes(mes.month),
        ingresos: _sumarLista(delMes, TipoTransaccion.ingreso),
        gastos: _sumarLista(delMes, TipoTransaccion.gasto),
      );
    });
  }

  /// Total de gastos agrupado por categoría, para el gráfico de dona.
  Map<String, double> distribucionGastos() {
    final mapa = <String, double>{};
    for (final t in _transacciones.where((t) => t.tipo == TipoTransaccion.gasto)) {
      mapa[t.categoria] = (mapa[t.categoria] ?? 0) + t.monto;
    }
    return mapa;
  }

  double _sumarLista(List<Transaccion> lista, TipoTransaccion tipo) => lista
      .where((t) => t.tipo == tipo)
      .fold(0.0, (suma, t) => suma + t.monto);

  bool _esMismoDia(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}
