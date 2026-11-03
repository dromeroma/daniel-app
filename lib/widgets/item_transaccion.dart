import 'package:flutter/material.dart';

import '../datos_finanzas.dart';
import '../models/transaccion.dart';
import '../tema.dart';
import '../utils/formato.dart';

/// Fila de la lista de transacciones, con botones para editar y para
/// eliminar (pide confirmación antes de borrar).
class ItemTransaccion extends StatelessWidget {
  const ItemTransaccion({
    super.key,
    required this.transaccion,
    required this.onEditar,
    required this.onEliminar,
  });

  final Transaccion transaccion;
  final VoidCallback onEditar;
  final VoidCallback onEliminar;

  @override
  Widget build(BuildContext context) {
    final esGasto = transaccion.tipo == TipoTransaccion.gasto;
    final color = esGasto ? Tema.rojo : Tema.verde;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              CategoriasFinanzas.icono(transaccion.categoria),
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaccion.categoria,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: Tema.textoOscuro,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  formatearFecha(transaccion.fecha),
                  style: const TextStyle(fontSize: 12, color: Tema.textoSuave),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${esGasto ? '-' : '+'} ${formatearMoneda(transaccion.monto)}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: color,
                  fontSize: 13.5,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: onEditar,
                    tooltip: 'Editar',
                    icon: const Icon(Icons.edit_outlined, size: 20),
                    color: Tema.textoSuave,
                    visualDensity: VisualDensity.compact,
                  ),
                  IconButton(
                    onPressed: () => _confirmarEliminar(context),
                    tooltip: 'Eliminar',
                    icon: const Icon(Icons.delete_outline, size: 20),
                    color: Tema.textoSuave,
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _confirmarEliminar(BuildContext context) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar transacción'),
        content: Text(
          '¿Seguro que deseas eliminar este registro de '
          '${transaccion.categoria}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(backgroundColor: Tema.rojo),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    if (confirmar == true) onEliminar();
  }
}
