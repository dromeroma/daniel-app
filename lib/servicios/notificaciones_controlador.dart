import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/notificacion.dart';
import '../tema.dart';
import '../utils/formato.dart';
import 'finanzas_controlador.dart';

/// Vía por la que un aviso llega a la bandeja del sistema operativo.
/// Es una interfaz para poder sustituirla en las pruebas.
abstract class CanalNotificaciones {
  Future<void> solicitarPermiso();

  Future<void> mostrar(String titulo, String mensaje);
}

/// Mantiene la bandeja de notificaciones de la app y avisa cuando el saldo
/// empeora. Solo notifica al cambiar de nivel, no con cada movimiento.
class NotificacionesControlador extends ChangeNotifier {
  NotificacionesControlador({this.canal});

  static const _clavePreferencia = 'finanzas_notificaciones';

  /// Con más avisos que estos se descartan los más antiguos.
  static const _maximo = 50;

  final CanalNotificaciones? canal;

  final List<Notificacion> _notificaciones = [];

  FinanzasControlador? _finanzas;
  NivelSaldo _nivelAnterior = NivelSaldo.normal;

  /// Notificaciones de la más reciente a la más antigua.
  List<Notificacion> get notificaciones => List.unmodifiable(_notificaciones);

  int get noLeidas => _notificaciones.where((n) => !n.leida).length;

  /// Carga la bandeja guardada. Un aviso dañado se ignora para que no
  /// impida abrir la app.
  Future<void> cargar() async {
    final prefs = await SharedPreferences.getInstance();
    final guardadas = prefs.getStringList(_clavePreferencia) ?? [];
    _notificaciones
      ..clear()
      ..addAll(guardadas.map(_leerNotificacion).whereType<Notificacion>());
    notifyListeners();
  }

  Notificacion? _leerNotificacion(String texto) {
    try {
      return Notificacion.fromJson(jsonDecode(texto) as Map<String, dynamic>);
    } catch (error) {
      debugPrint('Notificación guardada ignorada: $error');
      return null;
    }
  }

  Future<void> _guardar() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _clavePreferencia,
      _notificaciones.map((n) => jsonEncode(n.toJson())).toList(),
    );
  }

  /// Empieza a observar el saldo. El nivel con el que abre la app no genera
  /// aviso: ya lo muestra el banner del resumen.
  void vigilar(FinanzasControlador finanzas) {
    _finanzas = finanzas;
    _nivelAnterior = finanzas.nivelSaldo;
    finanzas.addListener(_revisarSaldo);
  }

  void _revisarSaldo() {
    final finanzas = _finanzas!;
    final nivel = finanzas.nivelSaldo;
    final empeoro = nivel.index > _nivelAnterior.index;
    _nivelAnterior = nivel;
    if (!empeoro) return;

    final saldo = formatearMoneda(finanzas.saldo);
    if (nivel == NivelSaldo.negativo) {
      publicar(
        '¡Saldo negativo!',
        'Tu saldo es $saldo. Estás gastando más de lo que ingresas.',
      );
    } else {
      final limite = formatearMoneda(Tema.limiteAlertaSaldo);
      publicar('Saldo bajo', 'Tu saldo es $saldo, por debajo de $limite.');
    }
  }

  /// Agrega el aviso a la bandeja y lo envía al sistema operativo.
  Future<void> publicar(String titulo, String mensaje) async {
    final ahora = DateTime.now();
    _notificaciones.insert(
      0,
      Notificacion(
        id: ahora.microsecondsSinceEpoch.toString(),
        titulo: titulo,
        mensaje: mensaje,
        fecha: ahora,
      ),
    );
    if (_notificaciones.length > _maximo) {
      _notificaciones.removeRange(_maximo, _notificaciones.length);
    }
    notifyListeners();
    await _guardar();
    await canal?.mostrar(titulo, mensaje);
  }

  Future<void> marcarTodasLeidas() async {
    if (noLeidas == 0) return;
    final leidas = _notificaciones.map((n) => n.marcadaComoLeida()).toList();
    _notificaciones
      ..clear()
      ..addAll(leidas);
    notifyListeners();
    await _guardar();
  }

  Future<void> limpiar() async {
    _notificaciones.clear();
    notifyListeners();
    await _guardar();
  }

  @override
  void dispose() {
    _finanzas?.removeListener(_revisarSaldo);
    super.dispose();
  }
}
