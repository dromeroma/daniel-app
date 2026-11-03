import 'package:flutter/material.dart';

import '../datos_finanzas.dart';
import '../models/transaccion.dart';
import '../servicios/finanzas_controlador.dart';
import '../tema.dart';
import '../utils/formato.dart';

/// Abre el formulario en un modal: vacío o, con [transaccion], para editarla.
void abrirFormularioTransaccion(
  BuildContext context,
  FinanzasControlador controlador, {
  Transaccion? transaccion,
}) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => FormularioTransaccion(
      controlador: controlador,
      transaccion: transaccion,
    ),
  );
}

/// Formulario para registrar una transacción nueva o, si se indica
/// [transaccion], para editarla. Se muestra dentro de un modal (ver
/// [abrirFormularioTransaccion]).
class FormularioTransaccion extends StatefulWidget {
  const FormularioTransaccion({
    super.key,
    required this.controlador,
    this.transaccion,
  });

  final FinanzasControlador controlador;

  /// Transacción que se edita; `null` para registrar una nueva.
  final Transaccion? transaccion;

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

  bool get _editando => widget.transaccion != null;

  List<String> get _categorias =>
      _tipo == TipoTransaccion.gasto
          ? CategoriasFinanzas.gasto
          : CategoriasFinanzas.ingreso;

  @override
  void initState() {
    super.initState();
    final original = widget.transaccion;
    if (original == null) return;
    _tipo = original.tipo;
    _categoria = original.categoria;
    _fecha = original.fecha;
    _montoCtrl.text = formatearNumero(original.monto);
  }

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

    final transaccion = Transaccion(
      id: widget.transaccion?.id ??
          DateTime.now().microsecondsSinceEpoch.toString(),
      tipo: _tipo,
      monto: interpretarMonto(_montoCtrl.text)!,
      categoria: _categoria!,
      fecha: _fecha,
    );

    if (_editando) {
      widget.controlador.actualizar(transaccion);
    } else {
      widget.controlador.agregar(transaccion);
    }

    final mensajero = ScaffoldMessenger.of(context);
    Navigator.of(context).pop();
    mensajero.showSnackBar(
      SnackBar(
        content: Text(
          _editando ? 'Transacción actualizada' : 'Transacción guardada',
        ),
      ),
    );
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
      // Con el teclado abierto el formulario no cabe en pantallas pequeñas:
      // el scroll mantiene alcanzable el botón de guardar.
      child: SingleChildScrollView(
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
              Text(
                _editando ? 'Editar transacción' : 'Nueva transacción',
                style: const TextStyle(
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
                  if (interpretarMonto(valor ?? '') == null) {
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
      ),
    );
  }
}
