import 'package:flutter/material.dart';

import '../servicios/notificaciones_controlador.dart';
import '../tema.dart';
import '../utils/formato.dart';

/// Bandeja con el historial de avisos. Al abrirse marca todo como leído,
/// lo que apaga el contador de la campana.
class PantallaNotificaciones extends StatefulWidget {
  const PantallaNotificaciones({super.key, required this.controlador});

  final NotificacionesControlador controlador;

  @override
  State<PantallaNotificaciones> createState() => _PantallaNotificacionesState();
}

class _PantallaNotificacionesState extends State<PantallaNotificaciones> {
  @override
  void initState() {
    super.initState();
    // Tras el primer frame: la campana de la pantalla anterior también
    // escucha este controlador y no puede reconstruirse durante el build.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.controlador.marcarTodasLeidas();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.controlador,
      builder: (context, _) {
        final notificaciones = widget.controlador.notificaciones;

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Tema.violeta,
            foregroundColor: Colors.white,
            title: const Text('Notificaciones'),
            actions: [
              if (notificaciones.isNotEmpty)
                IconButton(
                  tooltip: 'Borrar todas',
                  icon: const Icon(Icons.delete_sweep_outlined),
                  onPressed: widget.controlador.limpiar,
                ),
            ],
          ),
          backgroundColor: const Color(0xFFF5F4FB),
          body: notificaciones.isEmpty
              ? const Center(
                  child: Text(
                    'No tienes notificaciones',
                    style: TextStyle(color: Tema.textoSuave),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(18),
                  itemCount: notificaciones.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (context, i) {
                    final n = notificaciones[i];
                    return Card(
                      color: Colors.white,
                      margin: EdgeInsets.zero,
                      child: ListTile(
                        leading: const Icon(
                          Icons.warning_amber_rounded,
                          color: Tema.rojo,
                        ),
                        title: Text(
                          n.titulo,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          '${n.mensaje}\n${formatearFecha(n.fecha)}',
                        ),
                        isThreeLine: true,
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}
