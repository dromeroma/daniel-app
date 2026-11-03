import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'notificaciones_controlador.dart';

/// Envía los avisos a la bandeja de notificaciones de Android.
///
/// Un fallo aquí nunca debe afectar a la app: el aviso sigue disponible en
/// la bandeja interna y en el banner del resumen.
class NotificacionesSistema implements CanalNotificaciones {
  final _plugin = FlutterLocalNotificationsPlugin();

  static const _detalles = NotificationDetails(
    android: AndroidNotificationDetails(
      'alertas_saldo',
      'Alertas de saldo',
      channelDescription: 'Avisos cuando el saldo está bajo o es negativo',
      importance: Importance.high,
      priority: Priority.high,
    ),
  );

  Future<void> inicializar() async {
    try {
      await _plugin.initialize(
        settings: const InitializationSettings(
          android: AndroidInitializationSettings(
            '@drawable/ic_launcher_foreground',
          ),
        ),
      );
    } catch (error) {
      debugPrint('No se pudieron inicializar las notificaciones: $error');
    }
  }

  @override
  Future<void> solicitarPermiso() async {
    try {
      await _plugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
    } catch (error) {
      debugPrint('No se pudo solicitar el permiso: $error');
    }
  }

  @override
  Future<void> mostrar(String titulo, String mensaje) async {
    try {
      await _plugin.show(
        // Android exige un id de 32 bits: los segundos caben en él.
        id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title: titulo,
        body: mensaje,
        notificationDetails: _detalles,
      );
    } catch (error) {
      debugPrint('No se pudo mostrar la notificación: $error');
    }
  }
}
