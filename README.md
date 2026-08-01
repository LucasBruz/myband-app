# MyBand

## Cómo arrancar

```bash
flutter create . --project-name myband   # si hace falta generar los archivos nativos android/ios
flutter pub get
flutterfire configure                     # conecta con tu proyecto de Firebase, genera firebase_options.dart
flutter run
```

Después de correr `flutterfire configure`, descomentar en `lib/main.dart`:
```dart
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
// ...
await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
```

## Qué incluye este arranque

- Estructura de carpetas Clean Architecture (`lib/core`, `lib/features/*`)
- Tema Material 3 claro/oscuro (`lib/core/theme/app_theme.dart`)
- Motor de metrónomo completo con look-ahead scheduling, tap tempo,
  swing y acentos (`lib/features/metronome/metronome_engine.dart`)
- `pubspec.yaml` con todas las dependencias de Firebase, Riverpod,
  go_router y audio ya declaradas

## Qué falta agregar (ver roadmap en la documentación técnica)

- Pantallas de auth, grupos, biblioteca de canciones, chat, calendario
- Editor colaborativo + sistema de versiones
- Afinador cromático (requiere FFT sobre input de micrófono, ej. paquete `pitch_detector_dart`)
- Cloud Functions de IA
- Panel de administración

Ver `MyBand_Documentacion_Tecnica.md` para el modelo de datos completo
de Firestore, roles y el roadmap por fases.
