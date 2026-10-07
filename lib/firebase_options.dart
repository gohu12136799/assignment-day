// File generated for Brain Rush auth bootstrap.
// Replace values by running: dart pub global run flutterfire_cli:flutterfire configure
// See .cursor/skills/auth/SETUP.md

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCUl6dkYk8lHpTitfqlHsP6G2eKiSxU434',
    appId: '1:791974031427:web:6460375a5aac6e7ba1a4f6',
    messagingSenderId: '791974031427',
    projectId: 'brain-rush-191f7',
    authDomain: 'brain-rush-191f7.firebaseapp.com',
    storageBucket: 'brain-rush-191f7.firebasestorage.app',
    measurementId: 'G-H6JMK9MCS0',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCOp0T9_OtcMvnDF3RmICyRUbhN8E64v9s',
    appId: '1:791974031427:android:eaff97963e9d3ff6a1a4f6',
    messagingSenderId: '791974031427',
    projectId: 'brain-rush-191f7',
    storageBucket: 'brain-rush-191f7.firebasestorage.app',
  );
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'REPLACE_ME',
    appId: 'REPLACE_ME',
    messagingSenderId: 'REPLACE_ME',
    projectId: 'REPLACE_ME',
    storageBucket: 'REPLACE_ME.appspot.com',
    iosBundleId: 'com.huong.brainrush',
  );

  static bool get isConfigured =>
      android.apiKey != 'REPLACE_ME' && android.projectId != 'REPLACE_ME';
}
