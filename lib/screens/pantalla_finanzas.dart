import 'package:flutter/material.dart';

import '../servicios/finanzas_controlador.dart';
import '../tema.dart';
import '../widgets/menu_lateral.dart';
import 'pantalla_resumen.dart';
import 'pantalla_transacciones.dart';

/// Pantalla principal de la app: AppBar + menú lateral moderno que
/// alterna entre el dashboard (Resumen) y la lista de Transacciones.
class PantallaFinanzas extends StatefulWidget {
  const PantallaFinanzas({super.key, required this.controlador});

  final FinanzasControlador controlador;

  @override
  State<PantallaFinanzas> createState() => _PantallaFinanzasState();
}

class _PantallaFinanzasState extends State<PantallaFinanzas> {
  int _indice = 0;

  static const _titulos = ['Resumen', 'Transacciones'];

  void _irA(int indice) {
    Navigator.of(context).pop();
    setState(() => _indice = indice);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Tema.violeta,
        foregroundColor: Colors.white,
        title: Text(_titulos[_indice]),
      ),
      drawer: MenuLateral(indiceActual: _indice, onSeleccionar: _irA),
      backgroundColor: const Color(0xFFF5F4FB),
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
