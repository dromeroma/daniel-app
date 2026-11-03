import 'package:flutter/material.dart';

import '../servicios/autenticacion.dart';
import '../tema.dart';

/// Primera pantalla de la app: pide usuario y contraseña. Al validarlos
/// reemplaza esta pantalla por el resumen, de modo que el botón "atrás"
/// no regresa al formulario.
class PantallaLogin extends StatefulWidget {
  const PantallaLogin({super.key});

  @override
  State<PantallaLogin> createState() => _PantallaLoginState();
}

class _PantallaLoginState extends State<PantallaLogin> {
  final _formKey = GlobalKey<FormState>();
  final _usuarioCtrl = TextEditingController();
  final _contrasenaCtrl = TextEditingController();

  bool _ocultarContrasena = true;
  bool _credencialesInvalidas = false;

  @override
  void dispose() {
    _usuarioCtrl.dispose();
    _contrasenaCtrl.dispose();
    super.dispose();
  }

  void _ingresar() {
    if (!_formKey.currentState!.validate()) return;

    if (Autenticacion.validar(_usuarioCtrl.text, _contrasenaCtrl.text)) {
      Navigator.of(context).pushReplacementNamed('/inicio');
    } else {
      setState(() => _credencialesInvalidas = true);
    }
  }

  String? _obligatorio(String? valor) =>
      (valor ?? '').trim().isEmpty ? 'Este campo es obligatorio' : null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: Tema.fondo),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 22,
                vertical: 16,
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 460),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Icon(
                      Icons.account_balance_wallet_outlined,
                      size: 56,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Mis Finanzas',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Inicia sesión para continuar',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15, color: Colors.white70),
                    ),
                    const SizedBox(height: 24),
                    _formulario(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _formulario() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 24,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _usuarioCtrl,
              textInputAction: TextInputAction.next,
              autocorrect: false,
              decoration: const InputDecoration(
                labelText: 'Usuario',
                prefixIcon: Icon(Icons.person_outline),
                border: OutlineInputBorder(),
              ),
              validator: _obligatorio,
              onChanged: (_) => _ocultarError(),
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _contrasenaCtrl,
              obscureText: _ocultarContrasena,
              textInputAction: TextInputAction.done,
              autocorrect: false,
              enableSuggestions: false,
              decoration: InputDecoration(
                labelText: 'Contraseña',
                prefixIcon: const Icon(Icons.lock_outline),
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  tooltip: _ocultarContrasena
                      ? 'Mostrar contraseña'
                      : 'Ocultar contraseña',
                  icon: Icon(
                    _ocultarContrasena
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                  onPressed: () => setState(
                    () => _ocultarContrasena = !_ocultarContrasena,
                  ),
                ),
              ),
              validator: _obligatorio,
              onChanged: (_) => _ocultarError(),
              onFieldSubmitted: (_) => _ingresar(),
            ),
            if (_credencialesInvalidas) ...[
              const SizedBox(height: 12),
              const Text(
                'Usuario o contraseña incorrectos',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Tema.rojo,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
            const SizedBox(height: 18),
            FilledButton(
              onPressed: _ingresar,
              style: FilledButton.styleFrom(
                backgroundColor: Tema.violeta,
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                'Iniciar sesión',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _ocultarError() {
    if (_credencialesInvalidas) setState(() => _credencialesInvalidas = false);
  }
}
