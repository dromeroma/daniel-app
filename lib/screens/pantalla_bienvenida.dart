import 'package:flutter/material.dart';

import '../datos_estudiante.dart';
import '../tema.dart';
import '../widgets/animacion_entrada.dart';
import '../widgets/fila_info.dart';
import '../widgets/tarjeta_estudiante.dart';
import 'pantalla_mensaje.dart';

/// Pantalla principal de la aplicación.
///
/// Muestra el mensaje de bienvenida al curso, la tarjeta del estudiante,
/// la información de la actividad y el botón que lleva a la segunda
/// pantalla. Todos los elementos entran con una animación escalonada.
class PantallaBienvenida extends StatelessWidget {
  const PantallaBienvenida({super.key});

  /// Abre la segunda pantalla usando la transición estándar de Android.
  void _irAlMensaje(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const PantallaMensaje()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Degradado que ocupa toda la pantalla.
        decoration: const BoxDecoration(gradient: Tema.fondo),
        child: SafeArea(
          child: Center(
            // SingleChildScrollView evita cualquier overflow cuando la
            // pantalla es pequeña o la fuente del sistema es muy grande.
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 22,
                vertical: 16,
              ),
              child: ConstrainedBox(
                // En tablets el contenido no se estira: se mantiene legible.
                constraints: const BoxConstraints(maxWidth: 460),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 1. Icono principal (fade + slide + scale).
                    const AnimacionEntrada(
                      conEscala: true,
                      child: _IconoPrincipal(),
                    ),
                    const SizedBox(height: 16),

                    // 2. Título de bienvenida.
                    const AnimacionEntrada(
                      retraso: Duration(milliseconds: 180),
                      child: Text(
                        '¡Bienvenido!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),

                    // 3. Subtítulo con el nombre del curso.
                    const AnimacionEntrada(
                      retraso: Duration(milliseconds: 300),
                      child: Text(
                        'Curso de ${DatosEstudiante.curso}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                          height: 1.25,
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),

                    // 4. Tarjeta del estudiante.
                    const AnimacionEntrada(
                      retraso: Duration(milliseconds: 420),
                      child: TarjetaEstudiante(),
                    ),
                    const SizedBox(height: 12),

                    // 5. Información del curso.
                    const AnimacionEntrada(
                      retraso: Duration(milliseconds: 540),
                      child: _TarjetaInformacion(),
                    ),
                    const SizedBox(height: 18),

                    // 6. Botón que abre la segunda pantalla.
                    AnimacionEntrada(
                      retraso: const Duration(milliseconds: 660),
                      child: FilledButton.icon(
                        onPressed: () => _irAlMensaje(context),
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Tema.violeta,
                          minimumSize: const Size.fromHeight(50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.8,
                          ),
                        ),
                        icon: const Icon(Icons.rocket_launch_outlined),
                        label: const Text('COMENZAR'),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // 7. Firma exigida por el enunciado de la actividad.
                    AnimacionEntrada(
                      retraso: const Duration(milliseconds: 780),
                      child: Text(
                        DatosEstudiante.firma,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.italic,
                        ),
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

/// Círculo semitransparente con el icono que representa el desarrollo
/// de aplicaciones móviles.
class _IconoPrincipal extends StatelessWidget {
  const _IconoPrincipal();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 84,
        height: 84,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.18),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white24, width: 2),
        ),
        child: const Icon(
          Icons.phone_android,
          size: 42,
          color: Colors.white,
        ),
      ),
    );
  }
}

/// Tarjeta blanca con los cuatro datos clave de la actividad.
class _TarjetaInformacion extends StatelessWidget {
  const _TarjetaInformacion();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const FilaInfo(emoji: '📱', texto: DatosEstudiante.curso),
          const FilaInfo(emoji: '🎓', texto: DatosEstudiante.universidad),
          const FilaInfo(emoji: '💻', texto: 'Aplicación Android'),
          const FilaInfo(emoji: '🚀', texto: 'Primera actividad'),
          const Divider(height: 18),
          Text(
            DatosEstudiante.descripcion,
            style: const TextStyle(
              fontSize: 12.5,
              color: Tema.textoSuave,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}
