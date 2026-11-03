import 'package:flutter/material.dart';

import '../datos_estudiante.dart';
import '../screens/pantalla_bienvenida.dart';
import '../tema.dart';

/// Menú lateral (Drawer) de la app de finanzas, con las secciones
/// disponibles y un acceso a la pantalla de bienvenida original.
class MenuLateral extends StatelessWidget {
  const MenuLateral({
    super.key,
    required this.indiceActual,
    required this.onSeleccionar,
  });

  final int indiceActual;
  final ValueChanged<int> onSeleccionar;

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
                Text(
                  DatosEstudiante.nombre,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
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
          ListTile(
            leading: const Icon(Icons.info_outline, color: Tema.textoSuave),
            title: const Text('Acerca de'),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => const PantallaBienvenida()),
              );
            },
          ),
          const Spacer(),
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
