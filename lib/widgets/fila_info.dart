import 'package:flutter/material.dart';

import '../tema.dart';

/// Fila sencilla "emoji + texto" usada en la tarjeta de información
/// del curso. Se usa [Expanded] para que el texto se ajuste a cualquier
/// ancho de pantalla sin provocar desbordamientos (overflow).
class FilaInfo extends StatelessWidget {
  const FilaInfo({super.key, required this.emoji, required this.texto});

  final String emoji;
  final String texto;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 17)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              texto,
              style: const TextStyle(
                fontSize: 14.5,
                color: Tema.textoOscuro,
                height: 1.25,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
