// Pruebas de la aplicación: inicio de sesión, finanzas, alertas y
// notificaciones, actualización de datos y pantalla de bienvenida.
//
// Se ejecutan con: flutter test

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:bienvenida_apps/datos_estudiante.dart';
import 'package:bienvenida_apps/main.dart';
import 'package:bienvenida_apps/screens/pantalla_bienvenida.dart';
import 'package:bienvenida_apps/servicios/finanzas_controlador.dart';
import 'package:bienvenida_apps/servicios/notificaciones_controlador.dart';
import 'package:bienvenida_apps/servicios/perfil_controlador.dart';
import 'package:bienvenida_apps/utils/formato.dart';
import 'package:bienvenida_apps/widgets/tarjeta_resumen.dart';

/// Canal falso que registra lo que se habría enviado a Android.
class _CanalFalso implements CanalNotificaciones {
  final List<String> enviadas = [];
  int permisosSolicitados = 0;

  @override
  Future<void> solicitarPermiso() async => permisosSolicitados++;

  @override
  Future<void> mostrar(String titulo, String mensaje) async =>
      enviadas.add(titulo);
}

/// Controladores de una app recién abierta, listos para inspeccionarse.
class _App {
  _App(this.finanzas, this.perfil, this.notificaciones, this.canal);

  final FinanzasControlador finanzas;
  final PerfilControlador perfil;
  final NotificacionesControlador notificaciones;
  final _CanalFalso canal;

  AppFinanzas get widget => AppFinanzas(
        controlador: finanzas,
        perfil: perfil,
        notificaciones: notificaciones,
      );
}

Future<_App> _crearApp() async {
  final finanzas = FinanzasControlador();
  await finanzas.cargar();
  final perfil = PerfilControlador();
  await perfil.cargar();
  final canal = _CanalFalso();
  final notificaciones = NotificacionesControlador(canal: canal);
  await notificaciones.cargar();
  notificaciones.vigilar(finanzas);
  return _App(finanzas, perfil, notificaciones, canal);
}

/// Ajusta el tamaño de la ventana de prueba para simular un teléfono real.
void _usarPantallaDeTelefono(WidgetTester tester, Size tamano) {
  tester.view.physicalSize = tamano;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetViewInsets);
}

/// Abre la app en la pantalla de inicio de sesión.
Future<_App> _abrirApp(
  WidgetTester tester, {
  Size tamano = const Size(390, 844),
}) async {
  _usarPantallaDeTelefono(tester, tamano);
  final app = await _crearApp();
  await tester.pumpWidget(app.widget);
  await tester.pumpAndSettle();
  return app;
}

Future<void> _iniciarSesion(
  WidgetTester tester, {
  String usuario = 'Daniel',
  String contrasena = 'Daniel22',
}) async {
  await tester.enterText(
    find.widgetWithText(TextFormField, 'Usuario'),
    usuario,
  );
  await tester.enterText(
    find.widgetWithText(TextFormField, 'Contraseña'),
    contrasena,
  );
  await tester.tap(find.text('Iniciar sesión'));
  await tester.pumpAndSettle();
}

/// Abre la app y entra con las credenciales correctas.
Future<_App> _entrar(
  WidgetTester tester, {
  Size tamano = const Size(390, 844),
}) async {
  final app = await _abrirApp(tester, tamano: tamano);
  await _iniciarSesion(tester);
  return app;
}

/// Abre el Drawer y toca la opción de menú con el texto indicado.
Future<void> _irA(WidgetTester tester, String opcion) async {
  await tester.tap(find.byIcon(Icons.menu));
  await tester.pumpAndSettle();
  await tester.tap(find.widgetWithText(ListTile, opcion));
  await tester.pumpAndSettle();
}

/// Completa el formulario ya abierto y lo guarda.
Future<void> _llenarYGuardar(
  WidgetTester tester, {
  required String tipo,
  required String monto,
  required String categoria,
}) async {
  await tester.tap(find.text(tipo));
  await tester.pumpAndSettle();

  await tester.enterText(find.byType(TextFormField), monto);

  await tester.tap(find.byType(DropdownButton<String>));
  await tester.pumpAndSettle();
  await tester.tap(find.text(categoria).last);
  await tester.pumpAndSettle();

  await tester.tap(find.text('Guardar transacción'));
  await tester.pumpAndSettle();
}

/// Abre el formulario, lo completa como un ingreso de [monto] en la
/// categoría "Salario" y lo guarda.
Future<void> _agregarIngreso(WidgetTester tester, String monto) async {
  await tester.tap(find.text('Agregar'));
  await tester.pumpAndSettle();
  await _llenarYGuardar(
    tester,
    tipo: 'Ingreso',
    monto: monto,
    categoria: 'Salario',
  );
}

Future<void> _agregarGasto(WidgetTester tester, String monto) async {
  await tester.tap(find.text('Agregar'));
  await tester.pumpAndSettle();
  await _llenarYGuardar(
    tester,
    tipo: 'Gasto',
    monto: monto,
    categoria: 'Salud',
  );
}

void main() {
  setUp(() {
    // Evita que SharedPreferences intente usar un canal de plataforma real.
    SharedPreferences.setMockInitialValues({});
  });

  group('Inicio de sesión', () {
    testWidgets('La app abre en el formulario, no en el resumen',
        (WidgetTester tester) async {
      await _abrirApp(tester);

      expect(find.text('Iniciar sesión'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'Usuario'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'Contraseña'), findsOneWidget);
      expect(find.byType(TarjetaResumen), findsNothing);
    });

    testWidgets('Las credenciales correctas llevan al resumen',
        (WidgetTester tester) async {
      await _entrar(tester);

      expect(find.text('Iniciar sesión'), findsNothing);
      expect(find.text('Resumen'), findsOneWidget);
      expect(find.byType(TarjetaResumen), findsNWidgets(3));
    });

    testWidgets('Datos incorrectos muestran error y no dejan entrar',
        (WidgetTester tester) async {
      await _abrirApp(tester);

      for (final (usuario, contrasena) in const [
        ('Daniel', 'incorrecta'),
        ('daniel', 'Daniel22'),
        ('Daniel', 'daniel22'),
        ('Otro', 'Daniel22'),
      ]) {
        await _iniciarSesion(
          tester,
          usuario: usuario,
          contrasena: contrasena,
        );
        expect(find.text('Usuario o contraseña incorrectos'), findsOneWidget);
        expect(find.byType(TarjetaResumen), findsNothing);
      }
    });

    testWidgets('Los campos vacíos se rechazan', (WidgetTester tester) async {
      await _abrirApp(tester);

      await tester.tap(find.text('Iniciar sesión'));
      await tester.pumpAndSettle();

      expect(find.text('Este campo es obligatorio'), findsNWidgets(2));
      expect(find.byType(TarjetaResumen), findsNothing);
    });

    testWidgets('Al entrar se pide permiso para notificar',
        (WidgetTester tester) async {
      final app = await _abrirApp(tester);
      expect(app.canal.permisosSolicitados, 0);

      await _iniciarSesion(tester);

      expect(app.canal.permisosSolicitados, 1);
    });

    testWidgets('Cerrar sesión vuelve al formulario',
        (WidgetTester tester) async {
      await _entrar(tester);

      await _irA(tester, 'Cerrar sesión');

      expect(find.text('Iniciar sesión'), findsOneWidget);
      expect(find.byType(TarjetaResumen), findsNothing);
    });
  });

  group('Transacciones', () {
    testWidgets('Sin transacciones no hay alerta y las tarjetas están en cero',
        (WidgetTester tester) async {
      await _entrar(tester);

      expect(find.widgetWithText(TarjetaResumen, 'Ingresos'), findsOneWidget);
      expect(find.widgetWithText(TarjetaResumen, 'Gastos'), findsOneWidget);
      expect(find.widgetWithText(TarjetaResumen, 'Saldo'), findsOneWidget);
      expect(find.text('Saldo bajo'), findsNothing);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Agregar un ingreso actualiza la lista y el resumen',
        (WidgetTester tester) async {
      await _entrar(tester);

      await _irA(tester, 'Transacciones');
      await _agregarIngreso(tester, '150.000');

      expect(find.text('Salario'), findsOneWidget);
      expect(find.text('Transacción guardada'), findsOneWidget);
      expect(find.textContaining('150.000'), findsWidgets);

      await _irA(tester, 'Resumen');

      expect(find.text('Saldo bajo'), findsNothing);
      expect(find.text('¡Saldo negativo!'), findsNothing);
      expect(find.text(formatearMoneda(150000)), findsWidgets);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Editar una transacción cambia su monto',
        (WidgetTester tester) async {
      final app = await _entrar(tester);

      await _irA(tester, 'Transacciones');
      await _agregarIngreso(tester, '80000');

      await tester.tap(find.byIcon(Icons.edit_outlined));
      await tester.pumpAndSettle();

      expect(find.text('Editar transacción'), findsOneWidget);
      expect(find.text('80.000'), findsOneWidget);

      await tester.enterText(find.byType(TextFormField), '95.000');
      await tester.tap(find.text('Guardar transacción'));
      await tester.pumpAndSettle();

      expect(app.finanzas.transacciones, hasLength(1));
      expect(app.finanzas.transacciones.single.monto, 95000);
    });

    testWidgets('Eliminar una transacción la quita de la lista',
        (WidgetTester tester) async {
      await _entrar(tester);

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

    testWidgets('Un monto inválido no se guarda', (WidgetTester tester) async {
      final app = await _entrar(tester);

      await _irA(tester, 'Transacciones');
      await _agregarIngreso(tester, 'Infinity');

      expect(find.text('Ingresa un monto válido mayor a 0'), findsOneWidget);
      expect(app.finanzas.transacciones, isEmpty);
    });

    testWidgets('El formulario se puede usar con el teclado abierto',
        (WidgetTester tester) async {
      await _entrar(tester, tamano: const Size(360, 640));

      await _irA(tester, 'Transacciones');
      await tester.tap(find.text('Agregar'));
      await tester.pumpAndSettle();

      tester.view.viewInsets = const FakeViewPadding(bottom: 280);
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      await tester.ensureVisible(find.text('Guardar transacción'));
      await tester.pumpAndSettle();
      expect(find.text('Guardar transacción').hitTestable(), findsOneWidget);
    });

    test('Un registro dañado no impide cargar los demás', () async {
      SharedPreferences.setMockInitialValues({
        'finanzas_transacciones': <String>[
          '{dañado',
          '{"id":"1","tipo":"ingreso","monto":5,"categoria":"Salario",'
              '"fecha":"2026-11-02T10:00:00.000"}',
        ],
      });

      final finanzas = FinanzasControlador();
      await finanzas.cargar();

      expect(finanzas.transacciones, hasLength(1));
    });
  });

  group('Alertas y notificaciones', () {
    testWidgets('Un saldo bajo muestra el banner y notifica',
        (WidgetTester tester) async {
      final app = await _entrar(tester);

      await _irA(tester, 'Transacciones');
      await _agregarIngreso(tester, '10000');
      await _irA(tester, 'Resumen');

      expect(find.text('Saldo bajo'), findsOneWidget);
      expect(app.canal.enviadas, ['Saldo bajo']);
      expect(app.notificaciones.noLeidas, 1);
    });

    testWidgets('Un saldo negativo muestra su alerta y notifica',
        (WidgetTester tester) async {
      final app = await _entrar(tester);

      await _irA(tester, 'Transacciones');
      await _agregarGasto(tester, '20000');
      await _irA(tester, 'Resumen');

      expect(find.text('¡Saldo negativo!'), findsOneWidget);
      expect(app.canal.enviadas, ['¡Saldo negativo!']);
    });

    testWidgets('Solo se notifica cuando el saldo empeora',
        (WidgetTester tester) async {
      final app = await _entrar(tester);

      await _irA(tester, 'Transacciones');
      await _agregarIngreso(tester, '30000');
      await _agregarIngreso(tester, '5000');
      expect(app.canal.enviadas, ['Saldo bajo']);

      await _agregarGasto(tester, '50000');
      expect(app.canal.enviadas, ['Saldo bajo', '¡Saldo negativo!']);
    });

    testWidgets('La campana muestra los avisos y los marca como leídos',
        (WidgetTester tester) async {
      final app = await _entrar(tester);

      await _irA(tester, 'Transacciones');
      await _agregarIngreso(tester, '10000');

      await tester.tap(find.byTooltip('Notificaciones'));
      await tester.pumpAndSettle();

      expect(find.text('Saldo bajo'), findsOneWidget);
      expect(app.notificaciones.noLeidas, 0);
    });

    testWidgets('Las notificaciones sobreviven a cerrar la app',
        (WidgetTester tester) async {
      final app = await _entrar(tester);

      await app.notificaciones.publicar('Aviso', 'Contenido');

      final reabierta = NotificacionesControlador();
      await reabierta.cargar();

      expect(reabierta.notificaciones.single.titulo, 'Aviso');
      expect(reabierta.noLeidas, 1);
    });
  });

  group('Actualizar datos', () {
    testWidgets('Los cambios se guardan y aparecen en el menú',
        (WidgetTester tester) async {
      await _entrar(tester);

      await _irA(tester, 'Actualizar datos');
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Nombre completo'),
        'Daniel Madera',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Correo electrónico (opcional)'),
        'daniel@ejemplo.com',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Teléfono (opcional)'),
        '3001234567',
      );
      await tester.tap(find.text('Guardar cambios'));
      await tester.pumpAndSettle();

      expect(find.text('Datos actualizados'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();
      expect(find.text('Daniel Madera'), findsOneWidget);

      final reabierto = PerfilControlador();
      await reabierto.cargar();
      expect(reabierto.nombre, 'Daniel Madera');
      expect(reabierto.correo, 'daniel@ejemplo.com');
      expect(reabierto.telefono, '3001234567');
    });

    testWidgets('Los datos inválidos no se guardan',
        (WidgetTester tester) async {
      final app = await _entrar(tester);

      await _irA(tester, 'Actualizar datos');
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Nombre completo'),
        '   ',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Correo electrónico (opcional)'),
        'sin-arroba',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Teléfono (opcional)'),
        '12',
      );
      await tester.tap(find.text('Guardar cambios'));
      await tester.pumpAndSettle();

      expect(find.text('Este campo es obligatorio'), findsOneWidget);
      expect(find.text('Ingresa un correo válido'), findsOneWidget);
      expect(
        find.text('Ingresa solo números, entre 7 y 15 dígitos'),
        findsOneWidget,
      );
      expect(app.perfil.nombre, DatosEstudiante.nombre);
    });
  });

  group('Pantalla de bienvenida', () {
    testWidgets('Se abre desde el menú y se puede volver',
        (WidgetTester tester) async {
      await _entrar(tester);

      await _irA(tester, 'Acerca de');

      expect(find.text('¡Bienvenido!'), findsOneWidget);
      expect(find.text('Curso de ${DatosEstudiante.curso}'), findsOneWidget);
      expect(find.text(DatosEstudiante.nombre), findsOneWidget);
      expect(find.text(DatosEstudiante.programa), findsOneWidget);
      expect(find.text(DatosEstudiante.universidad), findsOneWidget);
      expect(find.text(DatosEstudiante.firma), findsOneWidget);

      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();

      expect(find.byType(TarjetaResumen), findsNWidgets(3));
    });

    testWidgets('El botón COMENZAR abre la segunda pantalla y se puede volver',
        (WidgetTester tester) async {
      _usarPantallaDeTelefono(tester, const Size(390, 844));

      await tester.pumpWidget(const MaterialApp(home: PantallaBienvenida()));
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

      // Se regresa a la pantalla de bienvenida.
      final volver = find.widgetWithText(OutlinedButton, 'Volver al inicio');
      await tester.ensureVisible(volver);
      await tester.pumpAndSettle();
      await tester.tap(volver);
      await tester.pumpAndSettle();

      expect(find.text('¡Bienvenido!'), findsOneWidget);
    });
  });

  group('Sin desbordamientos en una pantalla pequeña', () {
    // Tamaño equivalente a un teléfono antiguo y pequeño. Si hubiese
    // overflow, Flutter lanzaría una excepción durante el renderizado y
    // estas comprobaciones fallarían.
    const pequena = Size(320, 480);

    testWidgets('Inicio de sesión', (WidgetTester tester) async {
      await _abrirApp(tester, tamano: pequena);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Resumen y menú lateral', (WidgetTester tester) async {
      await _entrar(tester, tamano: pequena);
      expect(tester.takeException(), isNull);

      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });

    testWidgets('Bienvenida', (WidgetTester tester) async {
      _usarPantallaDeTelefono(tester, pequena);
      await tester.pumpWidget(const MaterialApp(home: PantallaBienvenida()));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  });

  group('interpretarMonto', () {
    test('El punto seguido de tres cifras separa miles', () {
      expect(interpretarMonto('150.000'), 150000);
      expect(interpretarMonto('1.234.567'), 1234567);
      expect(interpretarMonto('1.234.567,89'), 1234567.89);
    });

    test('La coma seguida de tres cifras también separa miles', () {
      expect(interpretarMonto('1,500'), 1500);
      expect(interpretarMonto('1,234,567.5'), 1234567.5);
    });

    test('Acepta números simples y hasta dos decimales', () {
      expect(interpretarMonto('80000'), 80000);
      expect(interpretarMonto(' 1500,50 '), 1500.5);
      expect(interpretarMonto('1500.50'), 1500.5);
    });

    test('Rechaza lo que no es un monto válido', () {
      for (final texto in [
        '',
        'abc',
        '0',
        '-5',
        'Infinity',
        'NaN',
        '1e5',
        '1.2.3',
        '12.34.567',
        '1,500.000',
        '9' * 400,
      ]) {
        expect(interpretarMonto(texto), isNull, reason: texto);
      }
    });

    test('formatearNumero produce un texto que se lee igual', () {
      for (final valor in [80000.0, 1234567.0, 1500.5, 999.99]) {
        expect(interpretarMonto(formatearNumero(valor)), valor);
      }
    });
  });
}
