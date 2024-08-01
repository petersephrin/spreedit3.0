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
    apiKey: 'AIzaSyAX9vATHC4FRwTJJrgb6PrJDPEUJc71yAA',
    appId: '1:711533775509:web:0701153a64b1eb3a38e99c',
    messagingSenderId: '711533775509',
    projectId: 'spreeditx',
    authDomain: 'spreeditx.firebaseapp.com',
    storageBucket: 'spreeditx.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDfxuchYLhp8uSFgdXLJpCGGZ_tNn2ET6w',
    appId: '1:711533775509:android:8a2ffe390879c42a38e99c',
    messagingSenderId: '711533775509',
    projectId: 'spreeditx',
    storageBucket: 'spreeditx.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAmEMyCnhOaY8ELN2HckaT7TMl3XHUaRa4',
    appId: '1:711533775509:ios:2f56dee884ec044c38e99c',
    messagingSenderId: '711533775509',
    projectId: 'spreeditx',
    storageBucket: 'spreeditx.appspot.com',
    iosBundleId: 'com.example.spreeditx',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAmEMyCnhOaY8ELN2HckaT7TMl3XHUaRa4',
    appId: '1:711533775509:ios:2f56dee884ec044c38e99c',
    messagingSenderId: '711533775509',
    projectId: 'spreeditx',
    storageBucket: 'spreeditx.appspot.com',
    iosBundleId: 'com.example.spreeditx',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAX9vATHC4FRwTJJrgb6PrJDPEUJc71yAA',
    appId: '1:711533775509:web:6c14affb83f55f8238e99c',
    messagingSenderId: '711533775509',
    projectId: 'spreeditx',
    authDomain: 'spreeditx.firebaseapp.com',
    storageBucket: 'spreeditx.appspot.com',
  );

}