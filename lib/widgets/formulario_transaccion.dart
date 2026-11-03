import 'package:flutter/material.dart';

import '../datos_finanzas.dart';
import '../models/transaccion.dart';
import '../servicios/finanzas_controlador.dart';
import '../tema.dart';
import '../utils/formato.dart';

/// Formulario para registrar una transacción nueva. Se muestra dentro de
/// un modal (ver [showModalBottomSheet] en PantallaTransacciones).
class FormularioTransaccion extends StatefulWidget {
  const FormularioTransaccion({super.key, required this.controlador});

  final FinanzasControlador controlador;

  @override
  State<FormularioTransaccion> createState() => _FormularioTransaccionState();
}

class _FormularioTransaccionState extends State<FormularioTransaccion> {
  final _formKey = GlobalKey<FormState>();
  final _montoCtrl = TextEditingController();

  TipoTransaccion _tipo = TipoTransaccion.gasto;
  String? _categoria;
  DateTime _fecha = DateTime.now();
  bool _mostrarErrorCategoria = false;

  List<String> get _categorias =>
      _tipo == TipoTransaccion.gasto
          ? CategoriasFinanzas.gasto
          : CategoriasFinanzas.ingreso;

  @override
  void dispose() {
    _montoCtrl.dispose();
    super.dispose();
  }

  Future<void> _elegirFecha() async {
    final seleccionada = await showDatePicker(
      context: context,
      initialDate: _fecha,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime.now(),
    );
    if (!mounted || seleccionada == null) return;
    setState(() => _fecha = seleccionada);
  }

  void _guardar() {
    final formularioValido = _formKey.currentState!.validate();
    final categoriaValida = _categoria != null;

    if (!formularioValido || !categoriaValida) {
      setState(() => _mostrarErrorCategoria = !categoriaValida);
      return;
    }

    final monto = double.parse(_montoCtrl.text.replaceAll(',', '.'));
    widget.controlador.agregar(
      Transaccion(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        tipo: _tipo,
        monto: monto,
        categoria: _categoria!,
        fecha: _fecha,
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        20,
        20,
        MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Nueva transacción',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Tema.textoOscuro,
              ),
            ),
            const SizedBox(height: 18),
            SegmentedButton<TipoTransaccion>(
              segments: const [
                ButtonSegment(
                  value: TipoTransaccion.gasto,
                  label: Text('Gasto'),
                  icon: Icon(Icons.arrow_downward),
                ),
                ButtonSegment(
                  value: TipoTransaccion.ingreso,
                  label: Text('Ingreso'),
                  icon: Icon(Icons.arrow_upward),
                ),
              ],
              selected: {_tipo},
              onSelectionChanged: (seleccion) => setState(() {
                _tipo = seleccion.first;
                _categoria = null;
                _mostrarErrorCategoria = false;
              }),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _montoCtrl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Monto',
                prefixText: '\$ ',
                border: OutlineInputBorder(),
              ),
              validator: (valor) {
                final numero = double.tryParse((valor ?? '').replaceAll(',', '.'));
                if (numero == null || numero <= 0) {
                  return 'Ingresa un monto válido mayor a 0';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            InputDecorator(
              decoration: InputDecoration(
                labelText: 'Categoría',
                border: const OutlineInputBorder(),
                errorText:
                    _mostrarErrorCategoria ? 'Selecciona una categoría' : null,
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _categoria,
                  isExpanded: true,
                  hint: const Text('Selecciona una categoría'),
                  items: _categorias
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (valor) => setState(() {
                    _categoria = valor;
                    _mostrarErrorCategoria = false;
                  }),
                ),
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: _elegirFecha,
              icon: const Icon(Icons.calendar_today_outlined, size: 18),
              label: Text(formatearFecha(_fecha)),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(52),
                foregroundColor: Tema.textoOscuro,
                side: const BorderSide(color: Color(0xFFE1E0D9)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 22),
            FilledButton(
              onPressed: _guardar,
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(52),
                backgroundColor: Tema.violeta,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                'Guardar transacción',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
