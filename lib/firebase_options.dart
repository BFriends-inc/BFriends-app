// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return windows;
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
    apiKey: 'AIzaSyDqV0TlLTz4Cp4LJeOvqU6rC_hg6rU91Oc',
    appId: '1:997487712381:web:9e774abd62720501daf914',
    messagingSenderId: '997487712381',
    projectId: 'bfriend-dev',
    authDomain: 'bfriend-dev.firebaseapp.com',
    storageBucket: 'bfriend-dev.appspot.com',
    measurementId: 'G-K1ZJNKP3PF',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAiYYYNJ8zYfeFpxJ3FasypDMvcZa4JJzA',
    appId: '1:997487712381:android:92fe6c4d5bd38609daf914',
    messagingSenderId: '997487712381',
    projectId: 'bfriend-dev',
    storageBucket: 'bfriend-dev.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDdNggOqg2Rml1eXwPy4WC6kjLPaLEvVts',
    appId: '1:997487712381:ios:082defa29a50d619daf914',
    messagingSenderId: '997487712381',
    projectId: 'bfriend-dev',
    storageBucket: 'bfriend-dev.appspot.com',
    iosBundleId: 'com.example.bfriendsApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDdNggOqg2Rml1eXwPy4WC6kjLPaLEvVts',
    appId: '1:997487712381:ios:082defa29a50d619daf914',
    messagingSenderId: '997487712381',
    projectId: 'bfriend-dev',
    storageBucket: 'bfriend-dev.appspot.com',
    iosBundleId: 'com.example.bfriendsApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDqV0TlLTz4Cp4LJeOvqU6rC_hg6rU91Oc',
    appId: '1:997487712381:web:f5147a703283e7fcdaf914',
    messagingSenderId: '997487712381',
    projectId: 'bfriend-dev',
    authDomain: 'bfriend-dev.firebaseapp.com',
    storageBucket: 'bfriend-dev.appspot.com',
    measurementId: 'G-2429R4VM69',
  );
}
