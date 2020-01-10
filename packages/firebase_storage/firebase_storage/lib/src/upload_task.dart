// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

part of firebase_storage;

class StorageUploadTask extends PlatformUploadTask {
  StorageUploadTask._(
    this._data,
    MethodChannelFirebaseStorage firebaseStorage,
    PlatformStorageRef ref,
    StorageMetadata metadata,
    UploadDataType dataType,
  ) : super(_data, firebaseStorage, ref, metadata, dataType);

  final dynamic _data;

  /// Pause the upload
  void pause() => _channel.invokeMethod<void>(
        'UploadTask#pause',
        <String, dynamic>{
          'app': firebaseStorage.app?.name,
          'bucket': firebaseStorage.storageBucket,
          'handle': handle,
        },
      );

  /// Resume the upload
  void resume() => _channel.invokeMethod<void>(
        'UploadTask#resume',
        <String, dynamic>{
          'app': firebaseStorage.app?.name,
          'bucket': firebaseStorage.storageBucket,
          'handle': handle,
        },
      );

  /// Cancel the upload
  void cancel() => _channel.invokeMethod<void>(
        'UploadTask#cancel',
        <String, dynamic>{
          'app': firebaseStorage.app?.name,
          'bucket': firebaseStorage.storageBucket,
          'handle': handle,
        },
      );

  @override
  Future<dynamic> platformStart() {
    String key;
    dynamic value;
    String method;
    switch (dataType) {
      case UploadDataType.FILE:
        key = 'filename';
        value = _data.absolute.path; //File.absolute.path
        method = 'StorageReference#putFile';
        break;
      case UploadDataType.DATA:
        key = 'data';
        method = 'StorageReference#putData';
        value = _data; //Uint8List
        break;
      default:
        break;
    }
    return _channel.invokeMethod<dynamic>(
      method,
      <String, dynamic>{
        'app': firebaseStorage.app?.name,
        'bucket': firebaseStorage.storageBucket,
        key: value,
        'path': ref.path,
        'metadata': metadata == null ? null : _buildMetadataUploadMap(metadata),
      },
    );
  }
}
