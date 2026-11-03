import 'package:flutter/material.dart';

/// Categorías disponibles, junto con su color e ícono, para el módulo
/// de finanzas. Centralizarlas aquí evita repetir listas en cada pantalla.
class CategoriasFinanzas {
  const CategoriasFinanzas._();

  static const List<String> gasto = [
    'Alimentación',
    'Transporte',
    'Vivienda',
    'Entretenimiento',
    'Salud',
    'Educación',
    'Otros',
  ];

  static const List<String> ingreso = [
    'Salario',
    'Negocio',
    'Regalo',
    'Inversión',
    'Otros',
  ];

  /// Color fijo por categoría de gasto, usado en el gráfico de dona.
  /// El orden sigue una paleta validada para distinguirse incluso con
  /// daltonismo; cada categoría conserva siempre el mismo color.
  static const Map<String, Color> _coloresGasto = {
    'Alimentación': Color(0xFF2A78D6),
    'Transporte': Color(0xFFEB6834),
    'Vivienda': Color(0xFF1BAF7A),
    'Entretenimiento': Color(0xFFEDA100),
    'Salud': Color(0xFFE87BA4),
    'Educación': Color(0xFF008300),
    'Otros': Color(0xFF4A3AA7),
  };

  static const Map<String, IconData> _iconos = {
    'Alimentación': Icons.restaurant_outlined,
    'Transporte': Icons.directions_bus_outlined,
    'Vivienda': Icons.home_outlined,
    'Entretenimiento': Icons.movie_outlined,
    'Salud': Icons.favorite_outline,
    'Educación': Icons.school_outlined,
    'Salario': Icons.payments_outlined,
    'Negocio': Icons.storefront_outlined,
    'Regalo': Icons.card_giftcard_outlined,
    'Inversión': Icons.trending_up,
    'Otros': Icons.category_outlined,
  };

  static Color colorGasto(String categoria) =>
      _coloresGasto[categoria] ?? _coloresGasto['Otros']!;

  static IconData icono(String categoria) =>
      _iconos[categoria] ?? Icons.category_outlined;
}
