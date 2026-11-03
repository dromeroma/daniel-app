import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../datos_finanzas.dart';
import '../tema.dart';
import '../utils/formato.dart';

/// Gráfico de dona con la distribución de gastos por categoría, más una
/// leyenda con el porcentaje de cada una.
class GraficoDona extends StatelessWidget {
  const GraficoDona({super.key, required this.datos});

  /// Mapa categoría -> total gastado.
  final Map<String, double> datos;

  @override
  Widget build(BuildContext context) {
    final total = datos.values.fold(0.0, (a, b) => a + b);

    if (total <= 0) {
      return const SizedBox(
        height: 140,
        child: Center(
          child: Text(
            'Aún no hay gastos registrados',
            style: TextStyle(color: Tema.textoSuave, fontSize: 13),
          ),
        ),
      );
    }

    // El orden fijo de CategoriasFinanzas.gasto asigna siempre el mismo
    // color a cada categoría, sin importar cuánto pese en el total.
    final entradas = CategoriasFinanzas.gasto
        .where((categoria) => (datos[categoria] ?? 0) > 0)
        .map((categoria) => MapEntry(categoria, datos[categoria]!))
        .toList();

    return Column(
      children: [
        SizedBox(
          height: 190,
          child: Stack(
            alignment: Alignment.center,
            children: [
              PieChart(
                PieChartData(
                  sectionsSpace: 3,
                  centerSpaceRadius: 55,
                  sections: entradas.map((entrada) {
                    final porcentaje = entrada.value / total * 100;
                    return PieChartSectionData(
                      value: entrada.value,
                      color: CategoriasFinanzas.colorGasto(entrada.key),
                      radius: 42,
                      title: porcentaje >= 8 ? '${porcentaje.round()}%' : '',
                      titleStyle: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    );
                  }).toList(),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Total gastos',
                    style: TextStyle(
                      fontSize: 11,
                      color: Tema.textoSuave,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    formatearMoneda(total),
                    style: const TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.bold,
                      color: Tema.textoOscuro,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 14,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: entradas
              .map((entrada) => _leyendaItem(entrada.key, entrada.value, total))
              .toList(),
        ),
      ],
    );
  }

  Widget _leyendaItem(String categoria, double valor, double total) {
    final porcentaje = (valor / total * 100).round();
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: CategoriasFinanzas.colorGasto(categoria),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          '$categoria ($porcentaje%)',
          style: const TextStyle(
            fontSize: 12,
            color: Tema.textoSuave,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
