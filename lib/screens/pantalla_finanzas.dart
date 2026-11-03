import 'package:flutter/material.dart';

import '../servicios/finanzas_controlador.dart';
import '../servicios/notificaciones_controlador.dart';
import '../servicios/perfil_controlador.dart';
import '../tema.dart';
import '../widgets/formulario_transaccion.dart';
import '../widgets/menu_lateral.dart';
import 'pantalla_bienvenida.dart';
import 'pantalla_notificaciones.dart';
import 'pantalla_perfil.dart';
import 'pantalla_resumen.dart';
import 'pantalla_transacciones.dart';

/// Pantalla principal de la app: AppBar + menú lateral moderno que
/// alterna entre el dashboard (Resumen) y la lista de Transacciones.
class PantallaFinanzas extends StatefulWidget {
  const PantallaFinanzas({
    super.key,
    required this.controlador,
    required this.perfil,
    required this.notificaciones,
  });

  final FinanzasControlador controlador;
  final PerfilControlador perfil;
  final NotificacionesControlador notificaciones;

  @override
  State<PantallaFinanzas> createState() => _PantallaFinanzasState();
}

class _PantallaFinanzasState extends State<PantallaFinanzas> {
  int _indice = 0;

  static const _titulos = ['Resumen', 'Transacciones'];

  @override
  void initState() {
    super.initState();
    // Android 13+ pide autorización; se solicita aquí y no al abrir la app
    // para no interrumpir el inicio de sesión.
    widget.notificaciones.canal?.solicitarPermiso();
  }

  void _irA(int indice) {
    Navigator.of(context).pop();
    setState(() => _indice = indice);
  }

  void _abrir(Widget pantalla) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => pantalla),
    );
  }

  void _abrirNotificaciones() => _abrir(
        PantallaNotificaciones(controlador: widget.notificaciones),
      );

  /// Cierra el menú lateral y abre la pantalla indicada.
  void _abrirDesdeMenu(Widget pantalla) {
    Navigator.of(context).pop();
    _abrir(pantalla);
  }

  void _cerrarSesion() {
    Navigator.of(context).pushNamedAndRemoveUntil('/', (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Tema.violeta,
        foregroundColor: Colors.white,
        title: Text(_titulos[_indice]),
        actions: [
          ListenableBuilder(
            listenable: widget.notificaciones,
            builder: (context, _) {
              final noLeidas = widget.notificaciones.noLeidas;
              return IconButton(
                tooltip: 'Notificaciones',
                onPressed: _abrirNotificaciones,
                icon: Badge(
                  isLabelVisible: noLeidas > 0,
                  label: Text('$noLeidas'),
                  child: const Icon(Icons.notifications_outlined),
                ),
              );
            },
          ),
        ],
      ),
      drawer: MenuLateral(
        perfil: widget.perfil,
        indiceActual: _indice,
        onSeleccionar: _irA,
        onNotificaciones: () {
          Navigator.of(context).pop();
          _abrirNotificaciones();
        },
        onActualizarDatos: () =>
            _abrirDesdeMenu(PantallaPerfil(perfil: widget.perfil)),
        onAcercaDe: () => _abrirDesdeMenu(const PantallaBienvenida()),
        onCerrarSesion: _cerrarSesion,
      ),
      backgroundColor: const Color(0xFFF5F4FB),
      floatingActionButton: _indice == 1
          ? FloatingActionButton.extended(
              onPressed: () => abrirFormularioTransaccion(
                context,
                widget.controlador,
              ),
              backgroundColor: Tema.violeta,
              foregroundColor: Colors.white,
              icon: const Icon(Icons.add),
              label: const Text('Agregar'),
            )
          : null,
      body: SafeArea(
        child: IndexedStack(
          index: _indice,
          children: [
            PantallaResumen(controlador: widget.controlador),
            PantallaTransacciones(controlador: widget.controlador),
          ],
        ),
      ),
    );
  }
}
