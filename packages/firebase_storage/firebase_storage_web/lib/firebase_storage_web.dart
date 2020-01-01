import 'dart:async';

import 'package:firebase/firebase.dart' as fb;
import 'package:firebase_storage_platform_interface/firebase_storage_platform_interface.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:js/js_util.dart' as js_util;

class FirebaseStorageWeb extends FirebaseStoragePlatform {
  /// Registers that [FirebaseCoreWeb] is the platform implementation.
  static void registerWith(Registrar registrar) {
    FirebaseStoragePlatform.instance = FirebaseStorageWeb();
  }

  StorageReference ref() {
    print('calling ref from web plugin and returning null');
    return null;
  }
}
