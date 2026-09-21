// Pruebas básicas de la aplicación de bienvenida.
//
// Se ejecutan con: flutter test

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bienvenida_apps/datos_estudiante.dart';
import 'package:bienvenida_apps/main.dart';

/// Ajusta el tamaño de la ventana de prueba para simular un teléfono real.
void _usarPantallaDeTelefono(WidgetTester tester, Size tamano) {
  tester.view.physicalSize = tamano;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

void main() {
  testWidgets('La pantalla de bienvenida muestra los datos del estudiante',
      (WidgetTester tester) async {
    _usarPantallaDeTelefono(tester, const Size(390, 844));

    await tester.pumpWidget(const AppBienvenida());
    await tester.pumpAndSettle();

    expect(find.text('¡Bienvenido!'), findsOneWidget);
    expect(find.text('Curso de ${DatosEstudiante.curso}'), findsOneWidget);
    expect(find.text(DatosEstudiante.nombre), findsOneWidget);
    expect(find.text(DatosEstudiante.programa), findsOneWidget);
    expect(find.text(DatosEstudiante.universidad), findsOneWidget);
    expect(find.text(DatosEstudiante.firma), findsOneWidget);
  });

  testWidgets('El botón COMENZAR abre la segunda pantalla y se puede volver',
      (WidgetTester tester) async {
    _usarPantallaDeTelefono(tester, const Size(390, 844));

    await tester.pumpWidget(const AppBienvenida());
    await tester.pumpAndSettle();

    // El botón está dentro de un SingleChildScrollView: primero nos
    // aseguramos de que sea visible y después lo pulsamos.
    final boton = find.widgetWithText(FilledButton, 'COMENZAR');
    await tester.ensureVisible(boton);
    await tester.pumpAndSettle();
    await tester.tap(boton);
    await tester.pumpAndSettle();

    expect(
      find.text('¡Hola!\nEsta es mi primera\naplicación móvil.'),
      findsOneWidget,
    );
    expect(find.text(DatosEstudiante.nombre), findsOneWidget);

    // Se regresa a la pantalla de bienvenida.
    final volver = find.widgetWithText(OutlinedButton, 'Volver al inicio');
    await tester.ensureVisible(volver);
    await tester.pumpAndSettle();
    await tester.tap(volver);
    await tester.pumpAndSettle();

    expect(find.text('¡Bienvenido!'), findsOneWidget);
  });

  testWidgets('No hay desbordamientos en una pantalla pequeña',
      (WidgetTester tester) async {
    // Tamaño equivalente a un teléfono antiguo y pequeño.
    _usarPantallaDeTelefono(tester, const Size(320, 480));

    await tester.pumpWidget(const AppBienvenida());
    await tester.pumpAndSettle();

    // Si hubiese overflow, Flutter lanzaría una excepción durante el
    // renderizado y esta comprobación fallaría.
    expect(tester.takeException(), isNull);
    expect(find.text('¡Bienvenido!'), findsOneWidget);
  });
}
