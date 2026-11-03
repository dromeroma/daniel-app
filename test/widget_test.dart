// Pruebas del módulo de finanzas: alerta de saldo, tarjetas resumen,
// alta y baja de transacciones.
//
// Se ejecutan con: flutter test

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:bienvenida_apps/main.dart';
import 'package:bienvenida_apps/servicios/finanzas_controlador.dart';
import 'package:bienvenida_apps/utils/formato.dart';

/// Ajusta el tamaño de la ventana de prueba para simular un teléfono real.
void _usarPantallaDeTelefono(WidgetTester tester, Size tamano) {
  tester.view.physicalSize = tamano;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

/// Abre el Drawer y toca la opción de menú con el texto indicado.
Future<void> _irA(WidgetTester tester, String opcion) async {
  await tester.tap(find.byIcon(Icons.menu));
  await tester.pumpAndSettle();
  await tester.tap(find.widgetWithText(ListTile, opcion));
  await tester.pumpAndSettle();
}

/// Abre el formulario, lo completa como un ingreso de [monto] en la
/// categoría "Salario" y lo guarda.
Future<void> _agregarIngreso(WidgetTester tester, String monto) async {
  await tester.tap(find.text('Agregar'));
  await tester.pumpAndSettle();

  await tester.tap(find.text('Ingreso'));
  await tester.pumpAndSettle();

  await tester.enterText(find.byType(TextFormField), monto);

  await tester.tap(find.byType(DropdownButton<String>));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Salario').last);
  await tester.pumpAndSettle();

  await tester.tap(find.text('Guardar transacción'));
  await tester.pumpAndSettle();
}

void main() {
  setUp(() {
    // Evita que SharedPreferences intente usar un canal de plataforma real.
    SharedPreferences.setMockInitialValues({});
  });

  Future<FinanzasControlador> crearControlador() async {
    final controlador = FinanzasControlador();
    await controlador.cargar();
    return controlador;
  }

  testWidgets(
      'Sin transacciones se muestra la alerta de saldo bajo y las tarjetas en cero',
      (WidgetTester tester) async {
    _usarPantallaDeTelefono(tester, const Size(390, 844));
    final controlador = await crearControlador();

    await tester.pumpWidget(AppFinanzas(controlador: controlador));
    await tester.pumpAndSettle();

    expect(find.text('Resumen'), findsOneWidget);
    expect(find.text('Ingresos'), findsOneWidget);
    expect(find.text('Gastos'), findsOneWidget);
    expect(find.text('Saldo'), findsOneWidget);
    // Saldo = 0, que es inferior a $50.000: la alerta debe estar visible.
    expect(find.text('Saldo bajo'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
      'Agregar un ingreso suficiente actualiza el saldo y hace desaparecer la alerta',
      (WidgetTester tester) async {
    _usarPantallaDeTelefono(tester, const Size(390, 844));
    final controlador = await crearControlador();

    await tester.pumpWidget(AppFinanzas(controlador: controlador));
    await tester.pumpAndSettle();

    await _irA(tester, 'Transacciones');
    await _agregarIngreso(tester, '150000');

    // La transacción recién creada aparece en la lista.
    expect(find.text('Salario'), findsOneWidget);
    expect(find.textContaining('150.000'), findsWidgets);

    await _irA(tester, 'Resumen');

    expect(find.text('Saldo bajo'), findsNothing);
    expect(find.text('¡Saldo negativo!'), findsNothing);
    expect(find.text(formatearMoneda(150000)), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Eliminar una transacción la quita de la lista',
      (WidgetTester tester) async {
    _usarPantallaDeTelefono(tester, const Size(390, 844));
    final controlador = await crearControlador();

    await tester.pumpWidget(AppFinanzas(controlador: controlador));
    await tester.pumpAndSettle();

    await _irA(tester, 'Transacciones');
    await _agregarIngreso(tester, '80000');

    expect(find.text('Salario'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.delete_outline));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Eliminar'));
    await tester.pumpAndSettle();

    expect(find.text('Salario'), findsNothing);
    expect(find.text('Aún no tienes transacciones'), findsOneWidget);
  });
}
