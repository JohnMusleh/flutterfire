// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

part of firebase_storage;

class StorageReference extends PlatformStorageRef {
  StorageReference(
    List<String> pathComponents,
    FirebaseStoragePlatform firebaseStorage,
  ) : super(pathComponents, firebaseStorage);

  factory StorageReference._fromPlatform(
      PlatformStorageRef platformStorageRef) {
    return platformStorageRef == null
        ? null
        : StorageReference(platformStorageRef.pathComponents,
            platformStorageRef.firebaseStorage);
  }

  /// Returns the Google Cloud Storage bucket that holds this object.
  @override
  Future<String> getBucket() async {
    return await _channel
        .invokeMethod<String>("StorageReference#getBucket", <String, String>{
      'app': firebaseStorage.app?.name,
      'bucket': firebaseStorage.storageBucket,
      'path': path,
    });
  }

  /// Returns the short name of this object.
  @override
  Future<String> getName() async {
    return await _channel
        .invokeMethod<String>("StorageReference#getName", <String, String>{
      'app': firebaseStorage.app?.name,
      'bucket': firebaseStorage.storageBucket,
      'path': path,
    });
  }

  /// Returns the full path to this object, not including the Google Cloud
  /// Storage bucket.
  @override
  Future<String> getPath() async {
    final String _path = await _channel
        .invokeMethod<String>("StorageReference#getPath", <String, String>{
      'app': firebaseStorage.app?.name,
      'bucket': firebaseStorage.storageBucket,
      'path': path,
    });

    if (_path.startsWith('/')) {
      return _path.substring(1);
    } else {
      return _path;
    }
  }

  /// Asynchronously retrieves a long lived download URL with a revokable token.
  /// This can be used to share the file with others, but can be revoked by a
  /// developer in the Firebase Console if desired.
  @override
  Future<dynamic> getDownloadURL() async {
    return await _channel.invokeMethod<dynamic>(
        "StorageReference#getDownloadUrl", <String, String>{
      'app': firebaseStorage.app?.name,
      'bucket': firebaseStorage.storageBucket,
      'path': path,
    });
  }

  @override
  Future<void> delete() {
    return _channel
        .invokeMethod<void>("StorageReference#delete", <String, String>{
      'app': firebaseStorage.app?.name,
      'bucket': firebaseStorage.storageBucket,
      'path': path
    });
  }

  /// Retrieves metadata associated with an object at this [StorageReference].
  @override
  Future<StorageMetadata> getMetadata() async {
    return StorageMetadata.fromMap(await _channel
        .invokeMapMethod<String, dynamic>(
            "StorageReference#getMetadata", <String, String>{
      'app': firebaseStorage.app?.name,
      'bucket': firebaseStorage.storageBucket,
      'path': path,
    }));
  }

  /// Updates the metadata associated with this [StorageReference].
  ///
  /// Returns a [Future] that will complete to the updated [StorageMetadata].
  ///
  /// This method ignores fields of [metadata] that cannot be set by the public
  /// [StorageMetadata] constructor. Writable metadata properties can be deleted
  /// by passing the empty string.
  @override
  Future<StorageMetadata> updateMetadata(StorageMetadata metadata) async {
    return StorageMetadata.fromMap(await _channel
        .invokeMapMethod<String, dynamic>(
            "StorageReference#updateMetadata", <String, dynamic>{
      'app': firebaseStorage.app?.name,
      'bucket': firebaseStorage.storageBucket,
      'path': path,
      'metadata': metadata == null ? null : _buildMetadataUploadMap(metadata),
    }));
  }

  /// Asynchronously downloads the object at the StorageReference to a list in memory.
  /// A list of the provided max size will be allocated.
  Future<Uint8List> getData(int maxSize) async {
    return await _channel.invokeMethod<Uint8List>(
      "StorageReference#getData",
      <String, dynamic>{
        'app': firebaseStorage.app?.name,
        'bucket': firebaseStorage.storageBucket,
        'maxSize': maxSize,
        'path': path,
      },
    );
  }

  /// Asynchronously downloads the object at this [StorageReference] to a
  /// specified system file.
  StorageFileDownloadTask writeToFile(File file) {
    final StorageFileDownloadTask task =
        StorageFileDownloadTask._(firebaseStorage, path, file);
    task._start();
    return task;
  }

  /// This method is deprecated. Please use [putFile] instead.
  ///
  /// Asynchronously uploads a file to the currently specified
  /// [StorageReference], with an optional [metadata].
  @deprecated
  StorageUploadTask put(File file, [StorageMetadata metadata]) {
    return putFile(file, metadata);
  }

  /// Asynchronously uploads a file to the currently specified
  /// [StorageReference], with an optional [metadata].
  StorageUploadTask putFile(File file, [StorageMetadata metadata]) {
    assert(file.existsSync());
    final StorageUploadTask task = StorageUploadTask._(
        file, firebaseStorage, this, metadata, UploadDataType.FILE);
    task.start();
    return task;
  }

  /// Asynchronously uploads byte data to the currently specified
  /// [StorageReference], with an optional [metadata].
  StorageUploadTask putData(Uint8List data, [StorageMetadata metadata]) {
    final StorageUploadTask task = StorageUploadTask._(
        data, firebaseStorage, this, metadata, UploadDataType.DATA);
    task.start();
    return task;
  }
}
