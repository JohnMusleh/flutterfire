// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

part of firebase_storage;

/// The entry point of the Firebase Storage SDK.
class FirebaseStorage {
  /// Returns the [FirebaseStorage] instance, initialized with a custom
  /// [FirebaseApp] if [app] is specified and a custom Google Cloud Storage
  /// bucket if [storageBucket] is specified. Otherwise the instance will be
  /// initialized with the default [FirebaseApp].
  ///
  /// The [FirebaseStorage] instance is a singleton for fixed [app] and
  /// [storageBucket].
  ///
  /// The [storageBucket] argument is the gs:// url to the custom Firebase
  /// Storage Bucket.
  ///
  /// The [app] argument is the custom [FirebaseApp].
  FirebaseStorage({this.app, this.storageBucket});

  static FirebaseStorage _instance = FirebaseStorage();

  /// The [FirebaseApp] instance to which this [FirebaseStorage] belongs.
  ///
  /// If null, the default [FirebaseApp] is used.
  final FirebaseApp app;

  /// The Google Cloud Storage bucket to which this [FirebaseStorage] belongs.
  ///
  /// If null, the storage bucket of the specified [FirebaseApp] is used.
  final String storageBucket;

  /// Returns the [FirebaseStorage] instance, initialized with the default
  /// [FirebaseApp].
  static FirebaseStorage get instance => _instance;

  /// Creates a new [StorageReference] initialized at the root
  /// Firebase Storage location.
  StorageReference ref() {
    return StorageReference._fromPlatform(
        FirebaseStoragePlatform.instance?.ref());
  }

  // @visibleForTesting
  // static get channel => MethodChannelFirebaseStorage.channel;

  Future<int> getMaxDownloadRetryTimeMillis() async {
    return await FirebaseStoragePlatform.instance
        .getMaxDownloadRetryTimeMillis();
  }

  Future<int> getMaxUploadRetryTimeMillis() async {
    return await FirebaseStoragePlatform.instance.getMaxUploadRetryTimeMillis();
  }

  Future<int> getMaxOperationRetryTimeMillis() async {
    return await FirebaseStoragePlatform.instance
        .getMaxOperationRetryTimeMillis();
  }

  Future<void> setMaxDownloadRetryTimeMillis(int time) async {
    await FirebaseStoragePlatform.instance.setMaxDownloadRetryTimeMillis(time);
  }

  Future<void> setMaxUploadRetryTimeMillis(int time) async {
    await FirebaseStoragePlatform.instance.setMaxUploadRetryTimeMillis(time);
  }

  Future<void> setMaxOperationRetryTimeMillis(int time) async {
    await FirebaseStoragePlatform.instance.setMaxOperationRetryTimeMillis(time);
  }

  Future<StorageReference> getReferenceFromUrl(String fullUrl) async {
    return await FirebaseStoragePlatform.instance.getReferenceFromUrl(fullUrl);
  }
}
