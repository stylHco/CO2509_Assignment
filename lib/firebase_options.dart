// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCg8NSOR84mnnLXuMjzu3ihg9KmTN-6vZU',
    appId: '1:331856315594:web:37c66440d949470fa82033',
    messagingSenderId: '331856315594',
    projectId: 'movieslist-38147',
    authDomain: 'movieslist-38147.firebaseapp.com',
    databaseURL: 'https://movieslist-38147-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'movieslist-38147.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD0YCjSuOtjF3zlqUbMk47Ux0B-uCrz-Zc',
    appId: '1:331856315594:android:c78f74cf2154a3d3a82033',
    messagingSenderId: '331856315594',
    projectId: 'movieslist-38147',
    databaseURL: 'https://movieslist-38147-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'movieslist-38147.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDDuHvtqWOz6wULUQ0twRf-pQ69tIJNVA0',
    appId: '1:331856315594:ios:21d224692c680b69a82033',
    messagingSenderId: '331856315594',
    projectId: 'movieslist-38147',
    databaseURL: 'https://movieslist-38147-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'movieslist-38147.appspot.com',
    iosBundleId: 'com.example.co2509Assignment',
  );
}
