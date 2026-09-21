# Manual de instalación y configuración del entorno

### Configuración del entorno para desarrollar aplicaciones Android con Flutter

**Curso:** Desarrollo de Apps
**Universidad:** Universidad de Cartagena
**Estudiante:** Daniel Felipe Madera Cavadía

---

Este manual está pensado para alguien que **nunca ha configurado Flutter**. Explica cómo
dejar un computador con Windows listo para desarrollar, ejecutar y compilar una aplicación
Android usando únicamente **Visual Studio Code**, sin necesidad de instalar Android Studio.

> **Tiempo aproximado:** entre 40 y 90 minutos, según la velocidad de internet.
> **Espacio en disco necesario:** unos 10 GB libres.

### Índice

1. [Instalar Visual Studio Code](#1-instalar-visual-studio-code)
2. [Instalar Git](#2-instalar-git)
3. [Instalar Flutter](#3-instalar-flutter)
4. [Configurar Flutter en el PATH](#4-configurar-flutter-en-el-path)
5. [Instalar el JDK (Java)](#5-instalar-el-jdk-java)
6. [Instalar el Android SDK sin Android Studio](#6-instalar-el-android-sdk-sin-android-studio)
7. [Configurar las variables de entorno](#7-configurar-las-variables-de-entorno)
8. [Instalar los paquetes del Android SDK y aceptar licencias](#8-instalar-los-paquetes-del-android-sdk-y-aceptar-licencias)
9. [Instalar las extensiones de Flutter y Dart en VS Code](#9-instalar-las-extensiones-de-flutter-y-dart-en-vs-code)
10. [Ejecutar flutter doctor](#10-ejecutar-flutter-doctor)
11. [Solución de problemas comunes](#11-solución-de-problemas-comunes)
12. [Conectar un teléfono Android](#12-conectar-un-teléfono-android)
13. [Abrir y ejecutar el proyecto](#13-abrir-y-ejecutar-el-proyecto)
14. [Generar el APK](#14-generar-el-apk)
15. [Instalar el APK en el teléfono](#15-instalar-el-apk-en-el-teléfono)
16. [Abrir el proyecto en Android Studio](#16-abrir-el-proyecto-en-android-studio)

---

## 1. Instalar Visual Studio Code

1. Entra a **https://code.visualstudio.com/**
2. Pulsa **Download for Windows**.
3. Ejecuta el instalador descargado.
4. **Importante:** durante la instalación marca la casilla
   **«Agregar a PATH»** (*Add to PATH*).
5. Termina la instalación y abre VS Code para comprobar que funciona.

---

## 2. Instalar Git

Flutter necesita Git internamente para gestionar su propio código.

1. Entra a **https://git-scm.com/download/win**
2. Descarga e instala aceptando todas las opciones por defecto.
3. Comprueba la instalación abriendo **PowerShell** y escribiendo:

```powershell
git --version
```

Debe mostrar algo como `git version 2.51.0.windows.1`.

---

## 3. Instalar Flutter

Se instala descomprimiendo un archivo ZIP. **No requiere permisos de administrador.**

1. Entra a **https://docs.flutter.dev/get-started/install/windows**
2. Descarga el archivo ZIP del canal **stable** (aprox. 1.8 GB).
3. Crea la carpeta `C:\dev` y descomprime el ZIP allí, de forma que quede:

```
C:\dev\flutter\bin\flutter.bat
```

> ⚠️ **Muy importante:** NO instales Flutter en `C:\Program Files` ni en ninguna ruta
> que contenga **espacios**, **tildes** o **ñ**. Provoca errores de compilación.

Si prefieres hacerlo por línea de comandos, abre PowerShell y ejecuta:

```powershell
New-Item -ItemType Directory -Force -Path C:\dev
curl.exe -L -o C:\dev\flutter.zip "https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_3.47.2-stable.zip"
tar.exe -xf C:\dev\flutter.zip -C C:\dev
Remove-Item C:\dev\flutter.zip
```

---

## 4. Configurar Flutter en el PATH

El PATH le dice a Windows dónde buscar el comando `flutter`.

**Opción A — con interfaz gráfica**

1. Pulsa la tecla **Windows** y escribe `variables de entorno`.
2. Abre **Editar las variables de entorno de esta cuenta**.
3. En el cuadro **Variables de usuario**, selecciona **Path** y pulsa **Editar**.
4. Pulsa **Nuevo** y escribe:

```
C:\dev\flutter\bin
```

5. Acepta todas las ventanas.

**Opción B — con PowerShell** (una sola línea)

```powershell
[Environment]::SetEnvironmentVariable('Path', 'C:\dev\flutter\bin;' + [Environment]::GetEnvironmentVariable('Path','User'), 'User')
```

**Cierra y vuelve a abrir PowerShell** y comprueba:

```powershell
flutter --version
```

> La primera vez tarda varios minutos porque Flutter compila sus propias
> herramientas. Es normal.

---

## 5. Instalar el JDK (Java)

Gradle, el sistema que compila la parte Android, necesita **Java 17**.

1. Entra a **https://adoptium.net/temurin/releases/?version=17**
2. Selecciona: **Operating System = Windows**, **Architecture = x64**,
   **Package Type = JDK**, **Version = 17**.
3. Descarga el archivo **.zip** y descomprímelo en `C:\dev\tools\jdk17`,
   de forma que exista:

```
C:\dev\tools\jdk17\bin\java.exe
```

También sirve el instalador `.msi`, pero el ZIP no requiere permisos de administrador.

Por línea de comandos:

```powershell
curl.exe -L -o C:\dev\jdk17.zip "https://api.adoptium.net/v3/binary/latest/17/ga/windows/x64/jdk/hotspot/normal/eclipse?project=jdk"
tar.exe -xf C:\dev\jdk17.zip -C C:\dev\tools
Remove-Item C:\dev\jdk17.zip
```

(Después renombra la carpeta que se creó, por ejemplo `jdk-17.0.20.1+1`, a `jdk17`.)

Comprueba:

```powershell
C:\dev\tools\jdk17\bin\java.exe -version
```

---

## 6. Instalar el Android SDK sin Android Studio

Aquí está la clave para no depender de Android Studio: Google publica las
**Command Line Tools** por separado.

1. Entra a **https://developer.android.com/studio** y baja hasta la sección
   **«Command line tools only»**.
2. Descarga **commandlinetools-win-*_latest.zip**.
3. Descomprímelo y coloca su contenido en esta ruta **exacta**:

```
C:\dev\tools\android-sdk\cmdline-tools\latest\
```

Debe existir el archivo:

```
C:\dev\tools\android-sdk\cmdline-tools\latest\bin\sdkmanager.bat
```

> ⚠️ La carpeta intermedia **debe llamarse `latest`**. Si dejas la estructura tal cual
> viene en el ZIP (`cmdline-tools\bin\...`), `sdkmanager` fallará con el error
> *«Could not determine SDK root»*.

Por línea de comandos:

```powershell
New-Item -ItemType Directory -Force -Path C:\dev\tools\android-sdk\cmdline-tools
curl.exe -L -o C:\dev\cmdline.zip "https://dl.google.com/android/repository/commandlinetools-win-11076708_latest.zip"
tar.exe -xf C:\dev\cmdline.zip -C C:\dev\tmp-cli
Move-Item C:\dev\tmp-cli\cmdline-tools C:\dev\tools\android-sdk\cmdline-tools\latest
Remove-Item C:\dev\cmdline.zip
```

---

## 7. Configurar las variables de entorno

Añade estas variables en **Variables de usuario** (mismo sitio del paso 4):

| Variable | Valor |
|---|---|
| `JAVA_HOME` | `C:\dev\tools\jdk17` |
| `ANDROID_HOME` | `C:\dev\tools\android-sdk` |
| `ANDROID_SDK_ROOT` | `C:\dev\tools\android-sdk` |

Y añade al **Path** estas cuatro rutas:

```
C:\dev\flutter\bin
C:\dev\tools\jdk17\bin
C:\dev\tools\android-sdk\platform-tools
C:\dev\tools\android-sdk\cmdline-tools\latest\bin
```

Todo de una vez con PowerShell:

```powershell
[Environment]::SetEnvironmentVariable('JAVA_HOME','C:\dev\tools\jdk17','User')
[Environment]::SetEnvironmentVariable('ANDROID_HOME','C:\dev\tools\android-sdk','User')
[Environment]::SetEnvironmentVariable('ANDROID_SDK_ROOT','C:\dev\tools\android-sdk','User')

$p = [Environment]::GetEnvironmentVariable('Path','User')
$rutas = @(
  'C:\dev\flutter\bin',
  'C:\dev\tools\jdk17\bin',
  'C:\dev\tools\android-sdk\platform-tools',
  'C:\dev\tools\android-sdk\cmdline-tools\latest\bin'
)
foreach ($r in $rutas) { if ($p -notlike "*$r*") { $p = "$r;$p" } }
[Environment]::SetEnvironmentVariable('Path', $p, 'User')
```

**Cierra todas las ventanas de PowerShell y de VS Code** para que los cambios surtan efecto.

---

## 8. Instalar los paquetes del Android SDK y aceptar licencias

Abre una **nueva** ventana de PowerShell y ejecuta:

```powershell
sdkmanager --sdk_root=C:\dev\tools\android-sdk "platform-tools" "platforms;android-36" "build-tools;36.0.0"
```

Cuando pregunte por las licencias, escribe `y` y pulsa Enter.

Después acepta **todas** las licencias pendientes:

```powershell
flutter doctor --android-licenses
```

Ve respondiendo `y` a cada una hasta que aparezca:

```
All SDK package licenses accepted
```

Por último, indícale a Flutter dónde están el SDK y el JDK:

```powershell
flutter config --android-sdk C:\dev\tools\android-sdk
flutter config --jdk-dir C:\dev\tools\jdk17
```

---

## 9. Instalar las extensiones de Flutter y Dart en VS Code

1. Abre **Visual Studio Code**.
2. Pulsa `Ctrl + Shift + X` (panel de Extensiones).
3. Busca **Flutter** (autor: *Dart Code*) y pulsa **Install**.
   Esto instala automáticamente también la extensión **Dart**.
4. Recomendadas, aunque opcionales:
   - **Awesome Flutter Snippets**
   - **Error Lens**

Comprueba que VS Code encuentra Flutter:
`Ctrl + Shift + P` → escribe `Flutter: Run Flutter Doctor`.

---

## 10. Ejecutar flutter doctor

Este comando revisa toda la instalación:

```powershell
flutter doctor
```

Una salida correcta se ve así:

```
[√] Flutter (Channel stable, 3.47.2, on Microsoft Windows [Version 10.0.26200])
[√] Android toolchain - develop for Android devices (Android SDK version 36.0.0)
[√] VS Code (version 1.9x.x)
[√] Connected device (1 available)
[√] Network resources
```

Para ver el detalle de cualquier problema:

```powershell
flutter doctor -v
```

> **No pasa nada** si aparece con ✗ o ! la línea de *Android Studio* o la de
> *Visual Studio (Windows desktop development)*: no son necesarias para compilar la
> aplicación Android desde VS Code.

---

## 11. Solución de problemas comunes

| Mensaje / síntoma | Causa | Solución |
|---|---|---|
| `'flutter' no se reconoce como un comando` | El PATH no está bien configurado, o no reiniciaste la terminal | Repite el paso 4 y **cierra y abre** PowerShell |
| `cmdline-tools component is missing` | Falta la carpeta `latest` o no está en la ruta correcta | Revisa el paso 6: debe ser `android-sdk\cmdline-tools\latest\bin` |
| `Android license status unknown` | Licencias sin aceptar | `flutter doctor --android-licenses` y responde `y` a todas |
| `Unable to locate Android SDK` | Falta `ANDROID_HOME` | Paso 7, y luego `flutter config --android-sdk C:\dev\tools\android-sdk` |
| `Could not determine java version` / `Unsupported class file major version` | Versión de Java incorrecta | Usa **JDK 17** y ejecuta `flutter config --jdk-dir C:\dev\tools\jdk17` |
| `Out of memory` / `Java heap space` al compilar | Poca RAM disponible | Baja `org.gradle.jvmargs` en `android/gradle.properties` (por ejemplo a `-Xmx1024m`) y cierra el navegador y otros programas |
| `Failed to create Dart snapshot` | Poca memoria durante la primera ejecución | Cierra programas y vuelve a ejecutar `flutter --version` |
| `Gradle task assembleRelease failed` | Caché corrupta | `flutter clean` y después `flutter pub get` |
| El teléfono no aparece en `flutter devices` | Falta la depuración USB o el cable es solo de carga | Revisa el paso 12 y prueba con otro cable |
| Errores extraños de Gradle sin causa clara | Ruta con espacios, tildes o ñ | Mueve el proyecto a una ruta simple como `C:\dev\` |

Comando de emergencia que resuelve la mayoría de problemas de compilación:

```powershell
flutter clean
flutter pub get
flutter build apk --release
```

---

## 12. Conectar un teléfono Android

### 12.1 Activar las opciones de desarrollador

1. En el teléfono: **Ajustes → Acerca del teléfono**.
2. Busca **Número de compilación** (en algunos móviles está dentro de
   *Información del software*).
3. Toca **7 veces seguidas** sobre él.
4. Aparecerá el mensaje **«Ya eres desarrollador»**.

### 12.2 Activar la depuración USB

1. Ve a **Ajustes → Sistema → Opciones de desarrollador**.
   (En Xiaomi: *Ajustes adicionales → Opciones de desarrollador*).
2. Activa el interruptor **Opciones de desarrollador**.
3. Activa **Depuración por USB**.
4. En Xiaomi/Redmi activa además **Instalar vía USB**.

### 12.3 Conectar y autorizar

1. Conecta el teléfono al PC con un cable USB **de datos** (no de solo carga).
2. En el teléfono, en las opciones de conexión USB, selecciona
   **Transferencia de archivos (MTP)**.
3. Aparecerá el aviso **«¿Permitir la depuración USB?»**:
   marca *Siempre permitir desde este equipo* y pulsa **Permitir**.

### 12.4 Verificar el dispositivo

```powershell
flutter devices
```

Salida esperada:

```
Found 1 connected device:
  SM A515F (mobile) • RZ8N70XXXXX • android-arm64 • Android 13 (API 33)
```

También puedes comprobarlo con:

```powershell
adb devices
```

Debe mostrar tu dispositivo con el estado `device`. Si dice `unauthorized`,
desconecta, vuelve a conectar y acepta el aviso en el teléfono.

---

## 13. Abrir y ejecutar el proyecto

```powershell
cd C:\dev\bienvenida_apps
flutter pub get
flutter run
```

Desde VS Code:

1. **File → Open Folder…** y selecciona la carpeta `bienvenida_apps`.
2. Abajo a la derecha, en la barra de estado, elige el dispositivo.
3. Pulsa **F5**.

La primera compilación tarda varios minutos porque Gradle descarga sus dependencias.
Las siguientes son mucho más rápidas.

Mientras la app está corriendo:

| Tecla | Acción |
|---|---|
| `r` | Hot Reload (recarga los cambios al instante) |
| `R` | Hot Restart (reinicia la app) |
| `q` | Salir |

---

## 14. Generar el APK

```powershell
cd C:\dev\bienvenida_apps
flutter build apk --release
```

Al terminar verás un mensaje similar a:

```
√ Built build\app\outputs\flutter-apk\app-release.apk (21.4MB)
```

### Dónde queda el APK

El archivo se genera en esta ruta, **relativa a la carpeta del proyecto**:

```
build\app\outputs\flutter-apk\app-release.apk
```

Es decir, la ruta completa:

```
C:\dev\bienvenida_apps\build\app\outputs\flutter-apk\app-release.apk
```

Para abrir directamente esa carpeta en el explorador de Windows:

```powershell
explorer C:\dev\bienvenida_apps\build\app\outputs\flutter-apk
```

> La carpeta `build\` es material generado: no se entrega dentro del código fuente,
> solo se entrega el archivo `app-release.apk` por separado.

---

## 15. Instalar el APK en el teléfono

### Opción A — por USB (la más rápida)

Con el teléfono conectado y la depuración USB activada:

```powershell
flutter install --release
```

o bien:

```powershell
adb install -r C:\dev\bienvenida_apps\build\app\outputs\flutter-apk\app-release.apk
```

El resultado debe ser `Success`.

### Opción B — copiando el archivo

1. Copia `app-release.apk` al teléfono (por cable USB, correo, WhatsApp o Google Drive).
2. En el teléfono, abre el **gestor de archivos** y busca el APK, normalmente
   en la carpeta *Descargas*.
3. Tócalo para instalarlo.
4. Android mostrará el aviso **«Por seguridad, tu teléfono no puede instalar
   aplicaciones desconocidas de esta fuente»**.
   Pulsa **Ajustes** y activa **Permitir desde esta fuente**.
5. Vuelve atrás y pulsa **Instalar**.

La aplicación aparecerá en el menú del teléfono con el nombre **Bienvenida Apps**.

> El APK está firmado con la clave de depuración que Flutter genera automáticamente.
> Es válido para instalarlo y presentar la actividad; para subirlo a Google Play
> habría que generar una clave de firma propia.

---

## 16. Abrir el proyecto en Android Studio

Aunque todo el desarrollo se hizo desde VS Code, el proyecto **mantiene intacta la
estructura Android** que genera Flutter (la carpeta `android/` con sus archivos Gradle),
por lo que Android Studio puede abrirlo, sincronizarlo y ejecutarlo sin cambios.

1. Instala Android Studio desde **https://developer.android.com/studio**
2. Ábrelo y ve a **Settings → Plugins → Marketplace**, busca **Flutter** e instálalo
   (arrastra también el plugin de **Dart**). Reinicia Android Studio.
3. En **Settings → Languages & Frameworks → Flutter**, indica la ruta del SDK:
   `C:\dev\flutter`
4. **File → Open…** y selecciona la carpeta raíz **`bienvenida_apps`**
   (la que contiene `pubspec.yaml`, **no** la subcarpeta `android`).
5. Android Studio reconocerá el proyecto Flutter y lanzará **Gradle Sync**
   automáticamente. Si no lo hace:
   **File → Sync Project with Gradle Files**.
6. Selecciona el dispositivo en la barra superior y pulsa ▶ **Run**.

Para trabajar solo con la parte nativa (revisar `AndroidManifest.xml`, `build.gradle.kts`,
recursos, etc.) también se puede abrir directamente la carpeta `bienvenida_apps\android`
como un proyecto Android normal.

> Si al abrirlo en otro computador Gradle se queja de las rutas, basta con borrar el
> archivo `android/local.properties` y ejecutar `flutter pub get`: Flutter lo regenera
> con las rutas correctas de ese equipo.

---

## Resumen de comandos

```powershell
flutter doctor                    # Verificar la instalación
flutter doctor -v                 # Verificación detallada
flutter doctor --android-licenses # Aceptar licencias de Android
flutter devices                   # Ver dispositivos conectados
flutter pub get                   # Descargar dependencias
flutter analyze                   # Revisar errores del código
flutter test                      # Ejecutar pruebas
flutter run                       # Ejecutar la app en modo debug
flutter build apk --release       # Generar el APK
flutter install --release         # Instalar el APK en el teléfono
flutter clean                     # Limpiar la compilación
```

---

**ATT: Daniel Felipe Madera Cavadía**
Estudiante de Ingeniería de Sistemas · Universidad de Cartagena
Curso de Desarrollo de Apps
