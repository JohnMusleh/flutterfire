// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
// import 'package:firebase_storage_platform_interface/firebase_storage_platform_interface.dart';

part of firebase_storage_platform_interface;

class MethodChannelFirebaseStorage extends FirebaseStoragePlatform {
  MethodChannelFirebaseStorage({FirebaseApp app, String storageBucket})
      : super(app, storageBucket) {
    channel.setMethodCallHandler((MethodCall call) async {
      FirebaseStoragePlatform._methodStreamController.add(call);
    });
  }

  @visibleForTesting
  static const MethodChannel channel = MethodChannel(
    'plugins.flutter.io/firebase_storage',
  );

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
  Future<PlatformStorageRef> getReferenceFromUrl(String fullUrl) async {
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

  @override
  PlatformStorageRef ref() {
    return PlatformStorageRef([], this);
  }
}
