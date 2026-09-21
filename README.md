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

**Pantalla 1 — Bienvenida**

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

**Pantalla 2 — Mensaje**

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
- Icono de lanzador propio (vector adaptativo, sin paquetes externos).

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

El proyecto **no usa ningún paquete externo**. Solo las dependencias que crea Flutter
por defecto:

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^6.0.0
```

Sin backend, sin base de datos, sin Firebase, sin APIs y sin autenticación.

---

## 4. Estructura del proyecto

```
bienvenida_apps/
├── lib/
│   ├── main.dart                       # Punto de entrada de la app
│   ├── datos_estudiante.dart           # ⭐ Todos los datos, parametrizados
│   ├── tema.dart                       # Colores y tema Material 3
│   ├── screens/
│   │   ├── pantalla_bienvenida.dart    # Pantalla 1
│   │   └── pantalla_mensaje.dart       # Pantalla 2
│   └── widgets/
│       ├── animacion_entrada.dart      # Fade + Slide + Scale reutilizable
│       ├── tarjeta_estudiante.dart     # Tarjeta con nombre y programa
│       └── fila_info.dart              # Fila "emoji + texto"
├── android/                            # Proyecto Android nativo (Gradle)
├── test/
│   └── widget_test.dart                # Pruebas automáticas
├── pubspec.yaml
└── README.md
```

### Cómo cambiar los datos del estudiante

Todo está centralizado en **`lib/datos_estudiante.dart`**. Basta con editar ese archivo:

```dart
static const String nombre = 'Daniel Felipe Madera Cavadía';
static const String programa = 'Estudiante de Ingeniería de Sistemas';
static const String curso = 'Desarrollo de Apps';
static const String universidad = 'Universidad de Cartagena';
static const String actividad = 'Aplicación de bienvenida';
```

No hay que tocar ningún otro archivo.

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
flutter analyze   # Análisis estático: 0 errores, 0 warnings
flutter test      # 3 pruebas automáticas, todas correctas
```

Las pruebas de `test/widget_test.dart` verifican:

1. Que la pantalla de bienvenida muestra el nombre, el programa, la universidad y la firma.
2. Que el botón **COMENZAR** navega a la segunda pantalla y que se puede volver atrás.
3. Que **no se producen desbordamientos (overflow)** en una pantalla pequeña de 320×480.

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
