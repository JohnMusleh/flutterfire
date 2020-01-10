// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

part of firebase_storage;

class StorageUploadTask extends PlatformUploadTask {
  StorageUploadTask._(
    _data,
    FirebaseStorage firebaseStorage,
    PlatformStorageRef ref,
    StorageMetadata metadata,
    UploadDataType dataType,
  ) : super(_data, firebaseStorage, ref, metadata, dataType);

  factory StorageUploadTask._fromPlatform(
      PlatformUploadTask platformUploadTask) {
    return platformUploadTask == null
        ? null
        : StorageUploadTask._(
            platformUploadTask.data,
            platformUploadTask.firebaseStorage,
            platformUploadTask.ref,
            platformUploadTask.metadata,
            platformUploadTask.dataType,
          );
  }

  /// Pause the upload
  void pause() => super.pause();

  /// Resume the upload
  void resume() => super.resume();

  /// Cancel the upload
  void cancel() => super.cancel();
}
