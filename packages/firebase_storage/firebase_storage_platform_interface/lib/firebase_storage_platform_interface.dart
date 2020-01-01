// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

library firebase_storage_platform_interface;

import 'dart:async';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/services.dart';
import 'dart:io';
import 'dart:typed_data';

import 'package:meta/meta.dart' show visibleForTesting;

part 'src/method_channel_firebase_storage.dart';
part 'src/types/storage_reference.dart';
part 'src/types/storage_metadata.dart';
part 'src/types/upload_task.dart';
part 'src/types/download_task.dart';
part 'src/types/download_snapshot.dart';
part 'src/types/event.dart';
part 'src/types/error.dart';

/// The interface that implementations of `firebase_storage` must extend.
///
/// Platform implementations should extend this class rather than implement it
/// as `firebase_storage` does not consider newly added methods to be breaking
/// changes. Extending this class (using `extends`) ensures that the subclass
/// will get the default implementation, while platform implementations that
/// `implements` this interface will be broken by newly added
/// [FirebaseStoragePlatform] methods.
abstract class FirebaseStoragePlatform {
  /// Only mock implementations should set this to `true`.
  ///
  /// Mockito mocks implement this class with `implements` which is forbidden
  /// (see class docs). This property provides a backdoor for mocks to skip the
  /// verification that the class isn't implemented with `implements`.
  @visibleForTesting
  bool get isMock => false;

  /// The default instance of [FirebaseStoragePlatform] to use.
  ///
  /// Platform-specific plugins should override this with their own class
  /// that extends [FirebaseStoragePlatform] when they register themselves.
  ///
  /// Defaults to [MethodChannelFirebaseAuth].
  static FirebaseStoragePlatform get instance => _instance;

  static FirebaseStoragePlatform _instance = MethodChannelFirebaseStorage();

  // TODO(amirh): Extract common platform interface logic.
  // https://github.com/flutter/flutter/issues/43368
  static set instance(FirebaseStoragePlatform instance) {
    if (!instance.isMock) {
      try {
        instance._verifyProvidesDefaultImplementations();
      } on NoSuchMethodError catch (_) {
        throw AssertionError(
            'Platform interfaces must not be implemented with `implements`');
      }
    }
    _instance = instance;
  }

  /// This method ensures that [FirebaseStoragePlatform] isn't implemented with `implements`.
  ///
  /// See class docs for more details on why using `implements` to implement
  /// [FirebaseStoragePlatform] is forbidden.
  ///
  /// This private method is called by the [instance] setter, which should fail
  /// if the provided instance is a class implemented with `implements`.
  void _verifyProvidesDefaultImplementations() {}

  StorageReference ref() {
    throw UnimplementedError('ref() is not implemented');
  }

  Future<int> getMaxDownloadRetryTimeMillis() async {
    throw UnimplementedError(
        'getMaxDownloadRetryTimeMillis() is not implemented');
  }

  Future<int> getMaxUploadRetryTimeMillis() async {
    throw UnimplementedError(
        'getMaxUploadRetryTimeMillis() is not implemented');
  }

  Future<int> getMaxOperationRetryTimeMillis() async {
    throw UnimplementedError(
        'getMaxOperationRetryTimeMillis() is not implemented');
  }

  Future<void> setMaxDownloadRetryTimeMillis(int time) {
    throw UnimplementedError(
        'setMaxDownloadRetryTimeMillis() is not implemented');
  }

  Future<void> setMaxUploadRetryTimeMillis(int time) {
    throw UnimplementedError(
        'setMaxUploadRetryTimeMillis() is not implemented');
  }

  Future<void> setMaxOperationRetryTimeMillis(int time) {
    throw UnimplementedError(
        'setMaxOperationRetryTimeMillis() is not implemented');
  }

  /// Creates a [StorageReference] given a gs:// or // URL pointing to a Firebase
  /// Storage location.
  Future<StorageReference> getReferenceFromUrl(String fullUrl) async {
    throw UnimplementedError('getReferenceFromUrl() is not implemented');
  }
}
