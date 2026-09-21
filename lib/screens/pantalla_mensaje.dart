import 'package:flutter/material.dart';

import '../datos_estudiante.dart';
import '../tema.dart';
import '../widgets/animacion_entrada.dart';

/// Segunda pantalla de la aplicación.
///
/// Se abre al pulsar el botón "COMENZAR" de la pantalla de bienvenida
/// y muestra el mensaje personal del estudiante junto con su firma.
class PantallaMensaje extends StatelessWidget {
  const PantallaMensaje({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar transparente para que se vea el degradado del fondo.
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
        title: const Text('Mi primera app'),
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(gradient: Tema.fondo),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 32,
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 460),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Icono de celebración con animación de escala.
                    AnimacionEntrada(
                      conEscala: true,
                      child: Center(
                        child: Container(
                          width: 104,
                          height: 104,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.18),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white24,
                              width: 2,
                            ),
                          ),
                          child: const Icon(
                            Icons.celebration_outlined,
                            size: 52,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Mensaje principal.
                    const AnimacionEntrada(
                      retraso: Duration(milliseconds: 200),
                      child: Text(
                        '¡Hola!\nEsta es mi primera\naplicación móvil.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          height: 1.4,
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Tarjeta con los datos del autor.
                    const AnimacionEntrada(
                      retraso: Duration(milliseconds: 340),
                      child: _TarjetaAutor(),
                    ),
                    const SizedBox(height: 28),

                    // Botón para volver a la pantalla de bienvenida.
                    AnimacionEntrada(
                      retraso: const Duration(milliseconds: 480),
                      child: OutlinedButton.icon(
                        onPressed: () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white70),
                          minimumSize: const Size.fromHeight(52),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        icon: const Icon(Icons.arrow_back),
                        label: const Text('Volver al inicio'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Tarjeta blanca que repite el nombre del estudiante y su firma.
class _TarjetaAutor extends StatelessWidget {
  const _TarjetaAutor();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            DatosEstudiante.nombre,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: Tema.textoOscuro,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${DatosEstudiante.curso} · ${DatosEstudiante.universidad}',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 13, color: Tema.textoSuave),
          ),
          const Divider(height: 26),
          Text(
            DatosEstudiante.firma,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.italic,
              color: Tema.violeta,
            ),
          ),
        ],
      ),
    );
  }
}
