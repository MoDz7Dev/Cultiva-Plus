# Cultiva+

App Flutter (MVP) para **identificar plantas** y **simular su crecimiento**.

> Versión inicial: la identificación usa datos de ejemplo (todavía sin cámara, sin IA y sin API).

## Requisitos

- **Flutter 3.47.5 (stable) / Dart 3.13.4** — comprobar con `flutter --version`.
  El `pubspec.yaml` pide `sdk: ^3.13.3`; con un Flutter anterior, `flutter pub get` fallará con *version solving failed*.
- **Android SDK 36** para ejecutar en Android, **o Chrome** para ejecutar en web.
- Visual Studio **no** es necesario (solo haría falta para Windows desktop, que este proyecto no incluye).

## Puesta en marcha

```bash
# 1. Clonar el repositorio
git clone https://github.com/MoDz7Dev/Cultiva-Plus.git
cd Cultiva-Plus            # la carpeta que contiene pubspec.yaml

# 2. Descargar dependencias (OBLIGATORIO la primera vez)
flutter pub get

# 3. Ejecutar
flutter run -d chrome      # en el navegador
flutter run                # en el dispositivo o emulador conectado
```

### ¿Por qué es obligatorio `flutter pub get`?

La carpeta `.dart_tool/` (que contiene `package_config.json`) **no se versiona**: está en el `.gitignore`
porque guarda rutas absolutas de tu máquina. La genera `flutter pub get`.

Sin ella, el analizador **no puede resolver** `package:flutter/...` ni tu propio `package:cultiva_plus/...`,
y en VS Code aparecen cientos de errores falsos del tipo
`Target of URI doesn't exist: 'package:flutter/material.dart'`, `Undefined class 'Widget'`, etc.

### Importante al abrir el proyecto en VS Code

Abre como raíz del workspace **la carpeta que contiene `pubspec.yaml`**, no una carpeta padre.
El analysis server solo activa el proyecto Flutter cuando encuentra el `pubspec.yaml`.

## Análisis estático y tests

```bash
flutter analyze    # debe terminar en: No issues found!
flutter test       # debe terminar en: All tests passed!
```

> ⚠️ Hoy `flutter test` **falla** porque `test/widget_test.dart` sigue siendo la plantilla del contador
> que trae Flutter. Ver *Pendientes conocidos* al final.

## Solución de problemas

| Síntoma | Causa | Solución |
| --- | --- | --- |
| `Target of URI doesn't exist: 'package:flutter/material.dart'` | Falta `flutter pub get` | `flutter pub get` y en VS Code `Ctrl+Shift+P` → **Dart: Restart Analysis Server** |
| `Undefined class 'Widget'`, `'Scaffold'`, `'BuildContext'`, muchos `undefined_method` | Cascada del error anterior (el import sin resolver arrastra todo) | Igual que arriba |
| `The URI 'package:flutter_lints/flutter.yaml' ... can't be found` (en `analysis_options.yaml`) | `flutter_lints` aún no está resuelto | Igual que arriba |
| `version solving failed ... requires SDK version ^3.13.3` | Flutter/Dart más antiguo que el exigido | `flutter upgrade` o bajar la restricción en `pubspec.yaml` |
| `Unable to locate gradlew script` al compilar Android | Faltan `gradlew`, `gradlew.bat` y `gradle-wrapper.jar` (están ignorados en `android/.gitignore`, es normal) | Usa siempre `flutter run`/`flutter build`: el tool de Flutter los regenera. No ejecutes `gradlew` a mano |
| La terminal compila pero VS Code sigue en rojo | El analysis server quedó apuntando a la carpeta equivocada | Reabrir la carpeta del `pubspec.yaml` y ejecutar **Dart: Restart Analysis Server** |

## Estructura del proyecto

```
lib/
  main.dart                                        # punto de entrada (MaterialApp + tema)
  config/theme/app_theme.dart                      # tema Material 3 (seed de color)
  presentation/screens/home_screen.dart            # pantalla de bienvenida
  presentation/screens/scan_screen.dart            # "escanear planta" (placeholder)
  presentation/screens/planta_detail_screen.dart   # detalle de planta con datos de ejemplo
test/
  widget_test.dart                                 # tests de widget
android/  ios/  web/                               # proyectos nativos
backend/                                           # reservado para el API (vacío por ahora)
```

## Navegación actual

`HomeScreen` → `ScanScreen` → `PlantaDetailScreen`, con `Navigator.push` y `MaterialPageRoute`.

## Reglas para contribuir

- **Nunca** subir `.dart_tool/`, `build/` ni `.flutter-plugins-dependencies` (ya están en `.gitignore`).
- `pubspec.lock` **sí** se versiona (es una app, no un paquete).
- Antes de hacer commit: `flutter analyze` sin errores y `flutter test` en verde.
- Usar ramas (`fix/...`, `feat/...`) y abrir Pull Request en lugar de subir directo a `main`.

## Pendientes conocidos

- `test/widget_test.dart`: sigue siendo el test plantilla del contador, por lo que **falla**. Hay que reescribirlo para probar la pantalla de inicio, la navegación a `ScanScreen` y el detalle de planta.
- `backend/`: la carpeta existe solo con `.gitkeep` y `requirements.txt` está vacío; falta el código del API.
- Identificación de plantas: por ahora son datos de ejemplo (sin cámara, sin IA y sin API).

## Recursos

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter documentation](https://docs.flutter.dev/)
