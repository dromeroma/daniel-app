import 'package:flutter/material.dart';

import '../servicios/finanzas_controlador.dart';
import '../tema.dart';
import '../widgets/formulario_transaccion.dart';
import '../widgets/item_transaccion.dart';

/// Lista de transacciones registradas, con botón flotante para agregar
/// una nueva y opción de eliminar en cada fila.
class PantallaTransacciones extends StatelessWidget {
  const PantallaTransacciones({super.key, required this.controlador});

  final FinanzasControlador controlador;

  void _abrirFormulario(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => FormularioTransaccion(controlador: controlador),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controlador,
      builder: (context, _) {
        final transacciones = controlador.transacciones;

        return Scaffold(
          backgroundColor: Colors.transparent,
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _abrirFormulario(context),
            backgroundColor: Tema.violeta,
            icon: const Icon(Icons.add),
            label: const Text('Agregar'),
          ),
          body: transacciones.isEmpty
              ? _estadoVacio()
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(18, 18, 18, 90),
                  itemCount: transacciones.length,
                  itemBuilder: (context, i) {
                    final t = transacciones[i];
                    return ItemTransaccion(
                      transaccion: t,
                      onEliminar: () => controlador.eliminar(t.id),
                    );
                  },
                ),
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
