import 'package:flutter/material.dart';

import '../servicios/finanzas_controlador.dart';
import '../tema.dart';
import '../widgets/alerta_saldo.dart';
import '../widgets/grafico_comparativo.dart';
import '../widgets/grafico_dona.dart';
import '../widgets/tarjeta_resumen.dart';

/// Dashboard principal: alerta de saldo, tarjetas resumen y los dos
/// gráficos (comparativo semanal/mensual y distribución de gastos).
class PantallaResumen extends StatefulWidget {
  const PantallaResumen({super.key, required this.controlador});

  final FinanzasControlador controlador;

  @override
  State<PantallaResumen> createState() => _PantallaResumenState();
}

class _PantallaResumenState extends State<PantallaResumen> {
  bool _vistaSemanal = true;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.controlador,
      builder: (context, _) {
        final c = widget.controlador;
        final datosComparativo =
            _vistaSemanal ? c.resumenSemanal() : c.resumenMensual();

        return SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (c.enAlerta) ...[
                AlertaSaldo(saldo: c.saldo),
                const SizedBox(height: 16),
              ],
              Row(
                children: [
                  Expanded(
                    child: TarjetaResumen(
                      titulo: 'Ingresos',
                      valor: c.totalIngresos,
                      icono: Icons.arrow_upward,
                      color: Tema.verde,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TarjetaResumen(
                      titulo: 'Gastos',
                      valor: c.totalGastos,
                      icono: Icons.arrow_downward,
                      color: Tema.rojo,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TarjetaResumen(
                      titulo: 'Saldo',
                      valor: c.saldo,
                      icono: Icons.account_balance_wallet_outlined,
                      color: c.enAlerta ? Tema.rojo : Tema.violeta,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _tarjetaSeccion(
                titulo: 'Ingresos vs. Gastos',
                accion: SegmentedButton<bool>(
                  segments: const [
                    ButtonSegment(value: true, label: Text('Semanal')),
                    ButtonSegment(value: false, label: Text('Mensual')),
                  ],
                  selected: {_vistaSemanal},
                  showSelectedIcon: false,
                  onSelectionChanged: (seleccion) =>
                      setState(() => _vistaSemanal = seleccion.first),
                ),
                child: GraficoComparativo(datos: datosComparativo),
              ),
              const SizedBox(height: 16),
              _tarjetaSeccion(
                titulo: 'Distribución de gastos',
                child: GraficoDona(datos: c.distribucionGastos()),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _tarjetaSeccion({
    required String titulo,
    Widget? accion,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (accion == null)
            Text(
              titulo,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Tema.textoOscuro,
              ),
            )
          else
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              runSpacing: 10,
              children: [
                Text(
                  titulo,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Tema.textoOscuro,
                  ),
                ),
                accion,
              ],
            ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}
