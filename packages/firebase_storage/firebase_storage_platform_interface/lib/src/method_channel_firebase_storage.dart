// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
// import 'package:firebase_storage_platform_interface/firebase_storage_platform_interface.dart';

part of firebase_storage_platform_interface;

class MethodChannelFirebaseStorage extends FirebaseStoragePlatform {
  /// The [FirebaseApp] instance to which this [FirebaseStorage] belongs.
  ///
  /// If null, the default [FirebaseApp] is used.
  final FirebaseApp app;

  /// The Google Cloud Storage bucket to which this [FirebaseStorage] belongs.
  ///
  /// If null, the storage bucket of the specified [FirebaseApp] is used.
  final String storageBucket;

  /// Used to dispatch method calls
  static final StreamController<MethodCall> _methodStreamController =
      StreamController<MethodCall>.broadcast(); // ignore: close_sinks
  Stream<MethodCall> get _methodStream => _methodStreamController.stream;

  MethodChannelFirebaseStorage({this.app, this.storageBucket}) {
    channel.setMethodCallHandler((MethodCall call) async {
      _methodStreamController.add(call);
    });
  }

  @visibleForTesting
  static const MethodChannel channel = MethodChannel(
    'plugins.flutter.io/firebase_storage',
  );

  @override
  StorageReference ref() {
    return StorageReference._(const <String>[], this);
  }

  @override
  Future<int> getMaxDownloadRetryTimeMillis() async {
    return await channel.invokeMethod<int>(
        "FirebaseStorage#getMaxDownloadRetryTime", <String, dynamic>{
      'app': app?.name,
      'bucket': storageBucket,
    });
  }

  @override
  Future<int> getMaxUploadRetryTimeMillis() async {
    return await channel.invokeMethod<int>(
        "FirebaseStorage#getMaxUploadRetryTime", <String, dynamic>{
      'app': app?.name,
      'bucket': storageBucket,
    });
  }

  @override
  Future<int> getMaxOperationRetryTimeMillis() async {
    return await channel.invokeMethod<int>(
        "FirebaseStorage#getMaxOperationRetryTime", <String, dynamic>{
      'app': app?.name,
      'bucket': storageBucket,
    });
  }

  Future<void> setMaxDownloadRetryTimeMillis(int time) {
    return channel.invokeMethod<void>(
        "FirebaseStorage#setMaxDownloadRetryTime", <String, dynamic>{
      'app': app?.name,
      'bucket': storageBucket,
      'time': time,
    });
  }

  Future<void> setMaxUploadRetryTimeMillis(int time) {
    return channel.invokeMethod<void>(
        "FirebaseStorage#setMaxUploadRetryTime", <String, dynamic>{
      'app': app?.name,
      'bucket': storageBucket,
      'time': time,
    });
  }

  Future<void> setMaxOperationRetryTimeMillis(int time) {
    return channel.invokeMethod<void>(
        "FirebaseStorage#setMaxOperationRetryTime", <String, dynamic>{
      'app': app?.name,
      'bucket': storageBucket,
      'time': time,
    });
  }

  /// Creates a [StorageReference] given a gs:// or // URL pointing to a Firebase
  /// Storage location.
  Future<StorageReference> getReferenceFromUrl(String fullUrl) async {
    final String path = await channel.invokeMethod<String>(
        "FirebaseStorage#getReferenceFromUrl", <String, dynamic>{
      'app': app?.name,
      'bucket': storageBucket,
      'fullUrl': fullUrl
    });
    if (path != null) {
      return ref().child(path);
    } else {
      return null;
    }
  }
}
