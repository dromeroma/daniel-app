import 'package:flutter/material.dart';

import '../servicios/finanzas_controlador.dart';
import '../tema.dart';
import '../widgets/formulario_transaccion.dart';
import '../widgets/item_transaccion.dart';

/// Lista de transacciones registradas, con opciones de editar y eliminar
/// en cada fila. El botón para agregar está en [PantallaFinanzas]: ese
/// Scaffold es el que muestra los SnackBar y así estos no lo tapan.
class PantallaTransacciones extends StatelessWidget {
  const PantallaTransacciones({super.key, required this.controlador});

  final FinanzasControlador controlador;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controlador,
      builder: (context, _) {
        final transacciones = controlador.transacciones;

        if (transacciones.isEmpty) return _estadoVacio();

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 90),
          itemCount: transacciones.length,
          itemBuilder: (context, i) {
            final t = transacciones[i];
            return ItemTransaccion(
              transaccion: t,
              onEditar: () => abrirFormularioTransaccion(
                context,
                controlador,
                transaccion: t,
              ),
              onEliminar: () {
                controlador.eliminar(t.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Transacción eliminada')),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _estadoVacio() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.receipt_long_outlined,
              size: 56,
              color: Tema.textoSuave,
            ),
            const SizedBox(height: 12),
            const Text(
              'Aún no tienes transacciones',
              style: TextStyle(fontWeight: FontWeight.bold, color: Tema.textoOscuro),
            ),
            const SizedBox(height: 6),
            const Text(
              'Pulsa "Agregar" para registrar tu primer ingreso o gasto.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Tema.textoSuave, fontSize: 12.5),
            ),
          ],
        ),
      ),
    );
  }
}
