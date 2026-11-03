import 'package:flutter/material.dart';

import '../servicios/perfil_controlador.dart';
import '../tema.dart';

/// Pantalla "Actualizar datos": permite cambiar el nombre, el correo y el
/// teléfono del usuario.
class PantallaPerfil extends StatefulWidget {
  const PantallaPerfil({super.key, required this.perfil});

  final PerfilControlador perfil;

  @override
  State<PantallaPerfil> createState() => _PantallaPerfilState();
}

class _PantallaPerfilState extends State<PantallaPerfil> {
  static final _formatoCorreo = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
  static final _formatoTelefono = RegExp(r'^\+?\d{7,15}$');

  final _formKey = GlobalKey<FormState>();
  late final _nombreCtrl = TextEditingController(text: widget.perfil.nombre);
  late final _correoCtrl = TextEditingController(text: widget.perfil.correo);
  late final _telefonoCtrl =
      TextEditingController(text: widget.perfil.telefono);

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _correoCtrl.dispose();
    _telefonoCtrl.dispose();
    super.dispose();
  }

  void _guardar() {
    if (!_formKey.currentState!.validate()) return;

    widget.perfil.actualizar(
      nombre: _nombreCtrl.text.trim(),
      correo: _correoCtrl.text.trim(),
      telefono: _telefonoCtrl.text.trim(),
    );

    final mensajero = ScaffoldMessenger.of(context);
    Navigator.of(context).pop();
    mensajero.showSnackBar(
      const SnackBar(content: Text('Datos actualizados')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Tema.violeta,
        foregroundColor: Colors.white,
        title: const Text('Actualizar datos'),
      ),
      backgroundColor: const Color(0xFFF5F4FB),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nombreCtrl,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: 'Nombre completo',
                  prefixIcon: Icon(Icons.person_outline),
                  border: OutlineInputBorder(),
                ),
                validator: (valor) => (valor ?? '').trim().isEmpty
                    ? 'Este campo es obligatorio'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _correoCtrl,
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                decoration: const InputDecoration(
                  labelText: 'Correo electrónico (opcional)',
                  prefixIcon: Icon(Icons.mail_outline),
                  border: OutlineInputBorder(),
                ),
                validator: (valor) {
                  final texto = (valor ?? '').trim();
                  if (texto.isEmpty || _formatoCorreo.hasMatch(texto)) {
                    return null;
                  }
                  return 'Ingresa un correo válido';
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _telefonoCtrl,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Teléfono (opcional)',
                  prefixIcon: Icon(Icons.phone_outlined),
                  border: OutlineInputBorder(),
                ),
                validator: (valor) {
                  final texto = (valor ?? '').trim();
                  if (texto.isEmpty || _formatoTelefono.hasMatch(texto)) {
                    return null;
                  }
                  return 'Ingresa solo números, entre 7 y 15 dígitos';
                },
              ),
              const SizedBox(height: 22),
              FilledButton(
                onPressed: _guardar,
                style: FilledButton.styleFrom(
                  backgroundColor: Tema.violeta,
                  minimumSize: const Size.fromHeight(52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Guardar cambios',
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
