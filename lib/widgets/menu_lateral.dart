import 'package:flutter/material.dart';

import '../datos_estudiante.dart';
import '../servicios/perfil_controlador.dart';
import '../tema.dart';

/// Menú lateral (Drawer) de la app de finanzas, con las secciones
/// disponibles, la actualización de datos y el cierre de sesión.
class MenuLateral extends StatelessWidget {
  const MenuLateral({
    super.key,
    required this.perfil,
    required this.indiceActual,
    required this.onSeleccionar,
    required this.onNotificaciones,
    required this.onActualizarDatos,
    required this.onAcercaDe,
    required this.onCerrarSesion,
  });

  final PerfilControlador perfil;
  final int indiceActual;
  final ValueChanged<int> onSeleccionar;
  final VoidCallback onNotificaciones;
  final VoidCallback onActualizarDatos;
  final VoidCallback onAcercaDe;
  final VoidCallback onCerrarSesion;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(20, 54, 20, 20),
            decoration: const BoxDecoration(gradient: Tema.fondo),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white24, width: 2),
                  ),
                  child: const Icon(
                    Icons.account_balance_wallet_outlined,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  'Mis Finanzas',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                ListenableBuilder(
                  listenable: perfil,
                  builder: (context, _) => Text(
                    perfil.nombre,
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
          // Con scroll propio: en pantallas pequeñas las opciones no caben.
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(top: 8),
              children: [
                _opcion(
                  context,
                  icono: Icons.dashboard_outlined,
                  texto: 'Resumen',
                  indice: 0,
                ),
                _opcion(
                  context,
                  icono: Icons.receipt_long_outlined,
                  texto: 'Transacciones',
                  indice: 1,
                ),
                const Divider(height: 24, indent: 16, endIndent: 16),
                _accion(
                  icono: Icons.notifications_outlined,
                  texto: 'Notificaciones',
                  onTap: onNotificaciones,
                ),
                _accion(
                  icono: Icons.manage_accounts_outlined,
                  texto: 'Actualizar datos',
                  onTap: onActualizarDatos,
                ),
                _accion(
                  icono: Icons.info_outline,
                  texto: 'Acerca de',
                  onTap: onAcercaDe,
                ),
                _accion(
                  icono: Icons.logout,
                  texto: 'Cerrar sesión',
                  onTap: onCerrarSesion,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              DatosEstudiante.firma,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11,
                color: Tema.textoSuave,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _accion({
    required IconData icono,
    required String texto,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icono, color: Tema.textoSuave),
      title: Text(texto),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      onTap: onTap,
    );
  }

  Widget _opcion(
    BuildContext context, {
    required IconData icono,
    required String texto,
    required int indice,
  }) {
    final seleccionado = indice == indiceActual;
    return ListTile(
      leading: Icon(icono, color: seleccionado ? Tema.violeta : Tema.textoSuave),
      title: Text(
        texto,
        style: TextStyle(
          color: seleccionado ? Tema.violeta : Tema.textoOscuro,
          fontWeight: seleccionado ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: seleccionado,
      selectedTileColor: Tema.violeta.withValues(alpha: 0.08),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      onTap: () => onSeleccionar(indice),
    );
  }
}
