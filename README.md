# Bienvenida Apps — Universidad de Cartagena

Aplicación móvil Android desarrollada con **Flutter** y **Dart** como primera actividad
del curso **Desarrollo de Apps**.

| Dato | Valor |
|---|---|
| **Estudiante** | Daniel Felipe Madera Cavadía |
| **Programa** | Ingeniería de Sistemas |
| **Curso** | Desarrollo de Apps |
| **Universidad** | Universidad de Cartagena |
| **Actividad** | Aplicación de bienvenida |
| **Package name** | `com.unicartagena.desarrolloapps` |
| **Versión** | 1.0.0 (versionCode 1) |

---

## 1. Objetivo

Crear y diseñar una aplicación Android que muestre un **mensaje de bienvenida al curso de
Desarrollo de Apps**, incluyendo la representación (firma) de quien la realiza:

```
ATT: Daniel Felipe Madera Cavadía
```

---

## 2. Qué hace la aplicación

**Inicio de sesión**

- La app abre siempre en un formulario de usuario y contraseña.
- Credenciales: usuario `Daniel`, contraseña `Daniel22` (distinguen mayúsculas).
- Al entrar se muestra el resumen de finanzas. **Cerrar sesión** está en el menú lateral.

> Las credenciales están fijas en `lib/servicios/autenticacion.dart` porque la app no tiene
> backend. Es suficiente para la actividad, pero no protege datos reales.

**Mis Finanzas** (pantalla principal)

- **Resumen:** ingresos, gastos, saldo y gráficos semanal, mensual y por categoría.
- **Transacciones:** agregar, editar y eliminar ingresos y gastos.
- **Actualizar datos:** nombre, correo y teléfono del usuario.
- **Notificaciones:** bandeja de avisos, también accesible desde la campana.
- Los montos aceptan el punto como separador de miles: `150.000` son ciento cincuenta mil.

**Alertas y notificaciones**

- Banner rojo en el resumen cuando el saldo es negativo o inferior a $ 50.000
  (no aparece mientras no haya transacciones).
- Cuando el saldo empeora se envía una notificación de Android y se guarda en la bandeja.
  En Android 13 o superior hay que aceptar el permiso que se pide al iniciar sesión.
- Mensajes breves al guardar, editar o eliminar.

**Pantalla Bienvenida** (menú → *Acerca de*)

- Icono que representa el desarrollo de aplicaciones móviles.
- Título **«¡Bienvenido!»** y subtítulo **«Curso de Desarrollo de Apps»**.
- Tarjeta del estudiante con su nombre y programa académico.
- Tarjeta de información de la actividad:
  - 📱 Desarrollo de Apps
  - 🎓 Universidad de Cartagena
  - 💻 Aplicación Android
  - 🚀 Primera actividad
- Botón **COMENZAR**.
- Firma: *ATT: Daniel Felipe Madera Cavadía*.

**Pantalla Mensaje** (botón COMENZAR)

- Mensaje **«¡Hola! Esta es mi primera aplicación móvil.»**
- Nombre del estudiante, curso, universidad y firma.
- Botón para volver al inicio.

**Detalles de implementación**

- Animaciones de entrada escalonadas usando únicamente widgets nativos de Flutter:
  `FadeTransition`, `SlideTransition` y `ScaleTransition`.
- Diseño adaptable: todo el contenido está dentro de un `SingleChildScrollView` y limitado
  con `ConstrainedBox`, de modo que **no se produce overflow** en pantallas pequeñas ni
  cuando el usuario aumenta el tamaño de fuente del sistema.
- Orientación bloqueada en vertical.
- Icono de lanzador propio (vector adaptativo).

---

## 3. Tecnologías utilizadas

| Tecnología | Versión usada |
|---|---|
| Flutter | 3.47.2 (canal stable) |
| Dart | 3.13.2 |
| Android Gradle Plugin | 9.1.0 |
| Gradle | 9.3.1 |
| Kotlin | 2.4.0 |
| JDK | 17 (Eclipse Temurin) |
| Android SDK | Platform 36 · Build-Tools 36.0.0 |

### Dependencias

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  fl_chart: ^0.69.0                    # Gráficos
  shared_preferences: ^2.3.0           # Guardado local
  flutter_local_notifications: ^22.3.3 # Notificaciones de Android

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^6.0.0
```

Sin backend, sin Firebase y sin APIs: todos los datos se guardan en el teléfono.

---

## 4. Estructura del proyecto

```
bienvenida_apps/
├── lib/
│   ├── main.dart                       # Punto de entrada de la app
│   ├── datos_estudiante.dart           # ⭐ Datos del estudiante
│   ├── datos_finanzas.dart             # Categorías, colores e iconos
│   ├── tema.dart                       # Colores, tema y límite de alerta
│   ├── models/                         # Transacción y notificación
│   ├── servicios/
│   │   ├── autenticacion.dart          # Credenciales de acceso
│   │   ├── finanzas_controlador.dart   # Transacciones y totales
│   │   ├── perfil_controlador.dart     # Datos del usuario
│   │   ├── notificaciones_controlador.dart # Bandeja y vigilancia del saldo
│   │   └── notificaciones_sistema.dart # Notificaciones de Android
│   ├── screens/
│   │   ├── pantalla_login.dart         # Inicio de sesión
│   │   ├── pantalla_finanzas.dart      # Contenedor con menú y campana
│   │   ├── pantalla_resumen.dart       # Home: resumen de finanzas
│   │   ├── pantalla_transacciones.dart # Lista de movimientos
│   │   ├── pantalla_perfil.dart        # Actualizar datos
│   │   ├── pantalla_notificaciones.dart # Bandeja de avisos
│   │   ├── pantalla_bienvenida.dart    # Acerca de
│   │   └── pantalla_mensaje.dart       # Mensaje del estudiante
│   ├── utils/formato.dart              # Moneda, fechas y lectura de montos
│   └── widgets/                        # Componentes reutilizables
├── android/                            # Proyecto Android nativo (Gradle)
├── test/
│   └── widget_test.dart                # Pruebas automáticas
├── pubspec.yaml
└── README.md
```

### Cómo cambiar los datos del estudiante

Están centralizados en **`lib/datos_estudiante.dart`**. Basta con editar ese archivo:

```dart
static const String nombre = 'Daniel Felipe Madera Cavadía';
static const String programa = 'Estudiante de Ingeniería de Sistemas';
static const String curso = 'Desarrollo de Apps';
static const String universidad = 'Universidad de Cartagena';
static const String actividad = 'Aplicación de bienvenida';
```

El nombre también se puede cambiar dentro de la app, en *Actualizar datos*.

---

## 5. Requisitos

- Windows 10/11, macOS o Linux.
- **Flutter SDK 3.47** o superior.
- **JDK 17**.
- **Android SDK** (Platform 36, Build-Tools 36.0.0, Platform-Tools).
- **Visual Studio Code** con las extensiones *Flutter* y *Dart*.
- Un teléfono Android con depuración USB activada, o un emulador.

> Si no tienes nada instalado, sigue el archivo **[MANUAL_INSTALACION.md](MANUAL_INSTALACION.md)**,
> que explica la instalación paso a paso desde cero.

---

## 6. Instalación del proyecto

```bash
# 1. Comprobar que el entorno está bien configurado
flutter doctor

# 2. Situarse en la carpeta del proyecto
cd bienvenida_apps

# 3. Descargar las dependencias declaradas en pubspec.yaml
flutter pub get
```

---

## 7. Ejecución desde VS Code

1. Abre la carpeta del proyecto: **File → Open Folder…** y selecciona `bienvenida_apps`.
2. Comprueba abajo a la derecha, en la barra de estado, que aparece el dispositivo
   seleccionado. Si no, haz clic ahí y elige tu teléfono o emulador.
3. Pulsa **F5** (o menú **Run → Start Debugging**).

También puedes ejecutarla desde la terminal integrada:

```bash
flutter run
```

Mientras la app corre en modo *debug*, puedes usar **Hot Reload** pulsando `r`
en la terminal (o guardando el archivo en VS Code).

---

## 8. Conectar un dispositivo Android

1. En el teléfono, abre **Ajustes → Acerca del teléfono**.
2. Toca **7 veces** sobre *Número de compilación* hasta ver «Ya eres desarrollador».
3. Vuelve a **Ajustes → Sistema → Opciones de desarrollador**.
4. Activa **Depuración por USB**.
5. Conecta el teléfono al PC con el cable USB.
6. Acepta en el teléfono el aviso **«¿Permitir depuración USB?»** (marca *Siempre permitir*).

Verifica que el sistema lo reconoce:

```bash
flutter devices
```

Debe aparecer tu teléfono en la lista, por ejemplo:

```
SM A515F (mobile) • RZ8N70XXXXX • android-arm64 • Android 13 (API 33)
```

---

## 9. Ejecutar la aplicación

```bash
# Modo debug (con Hot Reload)
flutter run

# Modo release (rendimiento real, sin herramientas de depuración)
flutter run --release
```

---

## 10. Generar el APK

Comando exacto utilizado:

```bash
flutter build apk --release
```

### Ubicación del APK generado

```
build/app/outputs/flutter-apk/app-release.apk
```

Ruta completa en el equipo de desarrollo:

```
C:\dev\bienvenida_apps\build\app\outputs\flutter-apk\app-release.apk
```

### Otras variantes útiles

```bash
# APK de depuración
flutter build apk --debug

# Un APK por arquitectura (archivos más pequeños)
flutter build apk --split-per-abi

# App Bundle, formato que pide Google Play
flutter build appbundle --release
```

### Instalar el APK en el teléfono

Opción A — con el teléfono conectado por USB:

```bash
flutter install --release
# o bien
adb install -r build/app/outputs/flutter-apk/app-release.apk
```

Opción B — copiar el archivo `app-release.apk` al teléfono (por cable, correo o
WhatsApp), abrirlo desde el gestor de archivos y permitir la instalación de
**aplicaciones de origen desconocido** cuando Android lo solicite.

> El APK está firmado con la clave de *debug* que genera Flutter automáticamente.
> Es suficiente para instalarlo y presentarlo; para publicarlo en Google Play habría
> que crear una clave de firma propia.

---

## 11. Abrir el proyecto en Android Studio

El proyecto conserva **intacta toda la estructura Android** generada por Flutter, por lo
que Android Studio lo reconoce sin ningún ajuste adicional.

1. Abre **Android Studio**.
2. **File → Open…**
3. Selecciona la carpeta raíz **`bienvenida_apps`** (no la subcarpeta `android`).
4. Android Studio detectará que es un proyecto Flutter y ejecutará *Gradle Sync*
   automáticamente. Si no lo hace: **File → Sync Project with Gradle Files**.
5. Elige el dispositivo en la barra superior y pulsa ▶ **Run**.

> **Requisito:** el plugin *Flutter* de Android Studio debe estar instalado
> (**Settings → Plugins → Marketplace → Flutter**), y en
> **Settings → Languages & Frameworks → Flutter** hay que indicar la ruta del
> Flutter SDK.

También se puede abrir únicamente la parte nativa (`bienvenida_apps/android`) como un
proyecto Android puro, útil para revisar el `AndroidManifest.xml` o los archivos Gradle.

> El archivo `android/local.properties` contiene rutas propias de este equipo
> (`sdk.dir` y `flutter.sdk`). Si el proyecto se abre en otro computador, Flutter y
> Android Studio lo regeneran automáticamente al sincronizar.

---

## 12. Comprobaciones de calidad

```bash
flutter analyze   # Análisis estático
flutter test      # Pruebas automáticas
```

Las pruebas de `test/widget_test.dart` verifican:

1. El inicio de sesión: credenciales correctas, incorrectas, campos vacíos y cierre de sesión.
2. Agregar, editar y eliminar transacciones, y la lectura de montos.
3. Las alertas de saldo, las notificaciones y la bandeja.
4. La actualización de datos del usuario.
5. La pantalla de bienvenida y su navegación.
6. Que **no se producen desbordamientos (overflow)** en una pantalla de 320×480 ni con el
   teclado abierto en el formulario de transacciones.

---

## 13. Comandos de referencia rápida

```bash
flutter doctor              # Diagnóstico del entorno
flutter doctor -v           # Diagnóstico detallado
flutter devices             # Dispositivos conectados
flutter pub get             # Descargar dependencias
flutter analyze             # Análisis estático del código
flutter test                # Ejecutar pruebas
flutter run                 # Ejecutar en modo debug
flutter build apk --release # Generar el APK de entrega
flutter clean               # Limpiar los archivos de compilación
```

---

**ATT: Daniel Felipe Madera Cavadía**
Estudiante de Ingeniería de Sistemas · Universidad de Cartagena
