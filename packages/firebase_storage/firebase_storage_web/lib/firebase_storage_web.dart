library firebase_storage_web;

import 'dart:async';
import 'dart:html' as html;
import 'package:firebase/firebase.dart' as fb;
import 'package:firebase_storage_platform_interface/firebase_storage_platform_interface.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

/// getData() and writeToFile() are not currently supported
/// put methods are not tested/stable
class FirebaseStorageWeb extends FirebaseStoragePlatform {
  FirebaseStorageWeb() : super(null, null);

  /// Registers that [FirebaseStorageWeb] is the platform implementation.
  static void registerWith(Registrar registrar) {
    final MethodChannel channel = MethodChannel(
        'plugins.flutter.io/firebase_storage',
        const StandardMethodCodec(),
        registrar.messenger);
    FirebaseStoragePlatform.instance = FirebaseStorageWeb();
    channel.setMethodCallHandler(handleMethodCall);
  }

  static Future<dynamic> handleMethodCall(MethodCall call) async {
    var app = call.arguments['app'];
    var path = call.arguments['path'];
    var metaDataUploadMap = call.arguments['metadata'];
    if (path == null) {
      path = '/';
    }
    var fbStorage = app == null ? fb.storage() : fb.storage(app);
    var storageRef = fbStorage.ref(path);

    switch (call.method) {

      /// StorageReference Method calls
      case 'StorageReference#getBucket':
        return storageRef.bucket;

      case 'StorageReference#getName':
        return storageRef.name;

      case 'StorageReference#getPath':
        return storageRef.fullPath;

      case 'StorageReference#getDownloadUrl':
        Uri uri = await storageRef.getDownloadURL();
        return uri.path;
        break;
      case 'StorageReference#delete':
        return storageRef.delete();

      case 'StorageReference#getMetadata':
        fb.FullMetadata metaData = await storageRef.getMetadata();
        return StorageMetadata.fromMap({
          'bucket': metaData.bucket,
          'generation': metaData.generation,
          'path': metaData.fullPath,
          'name': metaData.name,
          'sizeBytes': metaData.size,
          'creationTimeMillis': metaData.timeCreated.millisecondsSinceEpoch,
          'updatedTimeMillis': metaData.updated.millisecondsSinceEpoch,
          'md5Hash': metaData.md5Hash,
          'cacheControl': metaData.cacheControl,
          'contentDisposition': metaData.contentDisposition,
          'contentLanguage': metaData.contentLanguage,
          'contentType': metaData.contentType,
          'contentEncoding': metaData.contentEncoding,
          'customMetadata': metaData.customMetadata,
        });

      case 'StorageReference#updateMetadata':
        return storageRef.updateMetadata(metaDataUploadMap != null
            ? fb.SettableMetadata(
                cacheControl: metaDataUploadMap['cacheControl'],
                contentDisposition: metaDataUploadMap['contentDisposition'],
                contentLanguage: metaDataUploadMap['contentLanguage'],
                contentType: metaDataUploadMap['contentType'],
                contentEncoding: metaDataUploadMap['contentEncoding'],
                customMetadata: metaDataUploadMap['customMetadata'],
              )
            : null);

      case 'StorageReference#putData':
        var data = call.arguments['data'];
        return data != null
            ? metaDataUploadMap != null
                ? storageRef.put(
                    data,
                    fb.UploadMetadata(
                      cacheControl: metaDataUploadMap['cacheControl'],
                      contentDisposition:
                          metaDataUploadMap['contentDisposition'],
                      contentLanguage: metaDataUploadMap['contentLanguage'],
                      contentType: metaDataUploadMap['contentType'],
                      contentEncoding: metaDataUploadMap['contentEncoding'],
                      customMetadata: metaDataUploadMap['customMetadata'],
                    ))
                : storageRef.put(data)
            : null;
      case 'StorageReference#putFile':
        var filePath = call.arguments['filename'];
        return filePath != null
            ? storageRef.put(html.File([], filePath))
            : null;

      default:
        throw PlatformException(
            code: 'Unimplemented',
            details: "The url_launcher plugin for web doesn't implement "
                "the method '${call.method}'");
    }
  }

  PlatformStorageRef ref() {
    return PlatformStorageRef([], this);
  }
}
