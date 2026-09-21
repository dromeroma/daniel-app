import 'package:flutter/material.dart';

import '../datos_estudiante.dart';
import '../tema.dart';

/// Tarjeta blanca que presenta al autor de la actividad:
/// avatar, nombre completo y programa académico.
class TarjetaEstudiante extends StatelessWidget {
  const TarjetaEstudiante({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Avatar: círculo con degradado y un icono de desarrollador.
          Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: Tema.fondo,
            ),
            child: const Icon(Icons.code, color: Colors.white, size: 30),
          ),
          const SizedBox(height: 12),
          Text(
            DatosEstudiante.nombre,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Tema.textoOscuro,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            DatosEstudiante.programa,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 13, color: Tema.textoSuave),
          ),
        ],
      ),
    );
  }
}
