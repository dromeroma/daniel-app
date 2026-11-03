import 'package:flutter/material.dart';

import '../tema.dart';
import '../utils/formato.dart';

/// Banner destacado que se muestra cuando el saldo es negativo o está
/// por debajo del límite recomendado ([Tema.limiteAlertaSaldo]).
class AlertaSaldo extends StatelessWidget {
  const AlertaSaldo({super.key, required this.saldo});

  final double saldo;

  @override
  Widget build(BuildContext context) {
    final esNegativo = saldo < 0;
    final titulo = esNegativo ? '¡Saldo negativo!' : 'Saldo bajo';
    final mensaje = esNegativo
        ? 'Tu saldo actual es ${formatearMoneda(saldo)}. Estás gastando '
            'más de lo que ingresas.'
        : 'Tu saldo actual es ${formatearMoneda(saldo)}, por debajo de '
            '${formatearMoneda(Tema.limiteAlertaSaldo)}. Reduce gastos o '
            'registra nuevos ingresos.';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Tema.rojo,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Tema.rojo.withValues(alpha: 0.35),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.warning_amber_rounded, color: Colors.white, size: 30),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  mensaje,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12.5,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
