import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

/// Configuración de Firebase para MyBand.
///
/// Generado a mano a partir de la configuración web copiada de la consola
/// de Firebase (Project settings → General → Your apps → Web app).
///
/// TODO: cuando se compile para Android/iOS de verdad, agregar esos
/// bloques de FirebaseOptions acá (se consiguen agregando una app
/// Android/iOS en la misma consola de Firebase → descargar
/// google-services.json / GoogleService-Info.plist, o corriendo
/// `flutterfire configure` si en algún momento tenés acceso a una
/// computadora donde instalar el SDK de Flutter).
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    throw UnsupportedError(
      'DefaultFirebaseOptions todavía no está configurado para esta '
      'plataforma (solo web por ahora). Agregar el bloque correspondiente '
      'cuando se compile para Android/iOS.',
    );
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyB5aPy3bzsn-npwHn5dtZw4E_EOTkbAKYE',
    authDomain: 'my-band-6aca0.firebaseapp.com',
    projectId: 'my-band-6aca0',
    storageBucket: 'my-band-6aca0.firebasestorage.app',
    messagingSenderId: '406567211355',
    appId: '1:406567211355:web:cd309ddc68470f2d5b4a7e',
    measurementId: 'G-ENPQ0EDV7K',
  );
}
