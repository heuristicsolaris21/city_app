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
        return macos;
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
    apiKey: 'AIzaSyDgqMaMFxTxpnlGjZ64if-GMqsEb2R_8W0',
    appId: '1:645444337466:web:236685b5f0c6251bf31a03',
    messagingSenderId: '645444337466',
    projectId: 'cityapp-5a6b5',
    authDomain: 'cityapp-5a6b5.firebaseapp.com',
    storageBucket: 'cityapp-5a6b5.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAW-Wkd_rwvB5c1jtbFpOLYc9oT6NOud7k',
    appId: '1:645444337466:android:77c7a585dbea9c56f31a03',
    messagingSenderId: '645444337466',
    projectId: 'cityapp-5a6b5',
    storageBucket: 'cityapp-5a6b5.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD8IjxyjnjXLwrwAyRx-attPiQDFmk3QAY',
    appId: '1:645444337466:ios:0c2446171e92d542f31a03',
    messagingSenderId: '645444337466',
    projectId: 'cityapp-5a6b5',
    storageBucket: 'cityapp-5a6b5.appspot.com',
    iosBundleId: 'com.example.cityApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyD8IjxyjnjXLwrwAyRx-attPiQDFmk3QAY',
    appId: '1:645444337466:ios:3a0d06d82f096a07f31a03',
    messagingSenderId: '645444337466',
    projectId: 'cityapp-5a6b5',
    storageBucket: 'cityapp-5a6b5.appspot.com',
    iosBundleId: 'com.example.cityApp.RunnerTests',
  );
}