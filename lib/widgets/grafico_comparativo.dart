import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../servicios/finanzas_controlador.dart';
import '../tema.dart';

/// Gráfico de barras agrupadas que compara ingresos vs. gastos punto a
/// punto (por día en la vista semanal, por mes en la mensual).
class GraficoComparativo extends StatelessWidget {
  const GraficoComparativo({super.key, required this.datos});

  final List<PuntoComparativo> datos;

  @override
  Widget build(BuildContext context) {
    final maximo = datos.fold<double>(0, (m, p) {
      final mayor = p.ingresos > p.gastos ? p.ingresos : p.gastos;
      return mayor > m ? mayor : m;
    });
    final techo = maximo <= 0 ? 100.0 : maximo * 1.25;

    return Column(
      children: [
        SizedBox(
          height: 180,
          child: BarChart(
            BarChartData(
              maxY: techo,
              alignment: BarChartAlignment.spaceAround,
              barTouchData: BarTouchData(enabled: false),
              gridData: FlGridData(
                drawVerticalLine: false,
                horizontalInterval: techo / 4,
                getDrawingHorizontalLine: (_) => FlLine(
                  color: const Color(0xFFE1E0D9),
                  strokeWidth: 1,
                ),
              ),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (valor, meta) {
                      final indice = valor.toInt();
                      if (indice < 0 || indice >= datos.length) {
                        return const SizedBox.shrink();
                      }
                      return Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(
                          datos[indice].etiqueta,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Tema.textoSuave,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              barGroups: List.generate(datos.length, (i) {
                final punto = datos[i];
                return BarChartGroupData(
                  x: i,
                  barsSpace: 4,
                  barRods: [
                    BarChartRodData(
                      toY: punto.ingresos,
                      color: Tema.verde,
                      width: 8,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    BarChartRodData(
                      toY: punto.gastos,
                      color: Tema.rojo,
                      width: 8,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _leyenda(Tema.verde, 'Ingresos'),
            const SizedBox(width: 18),
            _leyenda(Tema.rojo, 'Gastos'),
          ],
        ),
      ],
    );
  }

  Widget _leyenda(Color color, String texto) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            texto,
            style: const TextStyle(
              fontSize: 12,
              color: Tema.textoSuave,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      );
}
