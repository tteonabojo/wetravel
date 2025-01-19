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
    apiKey: 'YOUR-WEB-API-KEY',
    appId: 'YOUR-WEB-APP-ID',
    messagingSenderId: 'YOUR-SENDER-ID',
    projectId: 'YOUR-PROJECT-ID',
    authDomain: 'YOUR-AUTH-DOMAIN',
    storageBucket: 'YOUR-STORAGE-BUCKET',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD9FXUs9pi8RkbNx5smRb3ozstlyv5bVIE',
    appId: '1:386530691152:android:2eade6104f114a69392955',
    messagingSenderId: '386530691152',
    projectId: 'wetravel-bebad',
    databaseURL: 'https://wetravel-bebad-default-rtdb.firebaseio.com',
    storageBucket: 'wetravel-bebad.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDvcVJB3KxiSqQbV-JD8FnlemHB_h0kjoI',
    appId: '1:386530691152:ios:8e761608465ca1d0392955',
    messagingSenderId: '386530691152',
    projectId: 'wetravel-bebad',
    databaseURL: 'https://wetravel-bebad-default-rtdb.firebaseio.com',
    storageBucket: 'wetravel-bebad.firebasestorage.app',
    iosBundleId: 'com.tteonabojo.wetravel',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'YOUR-MACOS-API-KEY',
    appId: 'YOUR-MACOS-APP-ID',
    messagingSenderId: 'YOUR-SENDER-ID',
    projectId: 'YOUR-PROJECT-ID',
    storageBucket: 'YOUR-STORAGE-BUCKET',
    iosClientId: 'YOUR-MACOS-CLIENT-ID',
    iosBundleId: 'YOUR-MACOS-BUNDLE-ID',
  );
}
