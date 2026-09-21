import 'package:flutter/material.dart';

/// Widget reutilizable que anima la entrada de su hijo combinando
/// dos animaciones básicas de Flutter:
///
///  * [FadeTransition]  -> aparece progresivamente (opacidad 0 -> 1)
///  * [SlideTransition] -> se desliza suavemente hacia arriba
///  * [ScaleTransition] -> opcional, crece desde un tamaño menor
///
/// Al indicar un [retraso] distinto en cada elemento de la pantalla se
/// consigue el efecto "escalonado": los widgets van apareciendo uno tras
/// otro. No se usa ningún paquete externo.
class AnimacionEntrada extends StatefulWidget {
  const AnimacionEntrada({
    super.key,
    required this.child,
    this.retraso = Duration.zero,
    this.duracion = const Duration(milliseconds: 550),
    this.desplazamiento = 0.18,
    this.conEscala = false,
  });

  /// Contenido que se va a animar.
  final Widget child;

  /// Tiempo de espera antes de iniciar la animación.
  final Duration retraso;

  /// Duración de la animación.
  final Duration duracion;

  /// Distancia vertical inicial, expresada como fracción de la altura
  /// del propio widget (0.18 = empieza un 18 % más abajo).
  final double desplazamiento;

  /// Si es `true` se añade además una animación de escala.
  final bool conEscala;

  @override
  State<AnimacionEntrada> createState() => _AnimacionEntradaState();
}

class _AnimacionEntradaState extends State<AnimacionEntrada>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controlador = AnimationController(
    vsync: this,
    duration: widget.duracion,
  );

  late final Animation<double> _opacidad = CurvedAnimation(
    parent: _controlador,
    curve: Curves.easeOut,
  );

  late final Animation<double> _escala = Tween<double>(
    begin: 0.7,
    end: 1.0,
  ).animate(
    CurvedAnimation(parent: _controlador, curve: Curves.easeOutBack),
  );

  late final Animation<Offset> _posicion = Tween<Offset>(
    begin: Offset(0, widget.desplazamiento),
    end: Offset.zero,
  ).animate(
    CurvedAnimation(parent: _controlador, curve: Curves.easeOutCubic),
  );

  @override
  void initState() {
    super.initState();
    // forward() acepta un retraso mediante un Future: si el widget ya no
    // está montado (el usuario salió antes) no se hace nada.
    Future<void>.delayed(widget.retraso, () {
      if (mounted) _controlador.forward();
    });
  }

  @override
  void dispose() {
    _controlador.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget contenido = SlideTransition(
      position: _posicion,
      child: widget.child,
    );

    if (widget.conEscala) {
      contenido = ScaleTransition(scale: _escala, child: contenido);
    }

    return FadeTransition(opacity: _opacidad, child: contenido);
  }
}
