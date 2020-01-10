// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

part of firebase_storage_platform_interface;

class PlatformStorageRef {
  final List<String> _pathComponents;
  final FirebaseStoragePlatform _firebaseStorage;

  PlatformStorageRef(
    this._pathComponents,
    this._firebaseStorage,
  );

  @visibleForTesting
  static const MethodChannel channel = MethodChannel(
    'plugins.flutter.io/firebase_storage',
  );

  PlatformStorageRef get parent {
    if (_pathComponents.isEmpty ||
        _pathComponents.every((String e) => e.isEmpty)) {
      return null;
    }
    final List<String> parentPath = List<String>.from(_pathComponents);
    // Trim for trailing empty path components that can
    // come from trailing slashes in the path.
    while (parentPath.last.isEmpty) {
      parentPath.removeLast();
    }
    parentPath.removeLast();

    return PlatformStorageRef(parentPath, _firebaseStorage);
  }

  PlatformStorageRef get root =>
      PlatformStorageRef(<String>[], _firebaseStorage);

  FirebaseStoragePlatform get storage => _firebaseStorage;

  FirebaseStoragePlatform get firebaseStorage => _firebaseStorage;

  List<String> get pathComponents => _pathComponents;

  String get path => _pathComponents?.join('/');

  PlatformStorageRef child(String path) {
    final List<String> childPath = List<String>.from(_pathComponents)
      ..addAll(path.split("/"));
    return PlatformStorageRef(childPath, _firebaseStorage);
  }

  Future<String> getBucket() async {
    return await channel
        .invokeMethod<String>("StorageReference#getBucket", <String, String>{
      'app': firebaseStorage.app?.name,
      'bucket': firebaseStorage.storageBucket,
      'path': path,
    });
  }

  Future<String> getPath() async {
    final String _path = await channel
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

  Future<String> getName() async {
    return await channel
        .invokeMethod<String>("StorageReference#getName", <String, String>{
      'app': firebaseStorage.app?.name,
      'bucket': firebaseStorage.storageBucket,
      'path': path,
    });
  }

  Future<void> delete() {
    return channel
        .invokeMethod<void>("StorageReference#delete", <String, String>{
      'app': firebaseStorage.app?.name,
      'bucket': firebaseStorage.storageBucket,
      'path': path
    });
  }

  Future<dynamic> getDownloadURL() async {
    return await channel.invokeMethod<dynamic>(
        "StorageReference#getDownloadUrl", <String, String>{
      'app': firebaseStorage.app?.name,
      'bucket': firebaseStorage.storageBucket,
      'path': path,
    });
  }

  Future<StorageMetadata> getMetadata() async {
    return StorageMetadata.fromMap(await channel
        .invokeMapMethod<String, dynamic>(
            "StorageReference#getMetadata", <String, String>{
      'app': firebaseStorage.app?.name,
      'bucket': firebaseStorage.storageBucket,
      'path': path,
    }));
  }

  Future<Uint8List> getData(int maxSize) async {
    return await channel.invokeMethod<Uint8List>(
      "StorageReference#getData",
      <String, dynamic>{
        'app': firebaseStorage.app?.name,
        'bucket': firebaseStorage.storageBucket,
        'maxSize': maxSize,
        'path': path,
      },
    );
  }

  Future<StorageMetadata> updateMetadata(StorageMetadata metadata) async {
    return StorageMetadata.fromMap(await channel
        .invokeMapMethod<String, dynamic>(
            "StorageReference#updateMetadata", <String, dynamic>{
      'app': firebaseStorage.app?.name,
      'bucket': firebaseStorage.storageBucket,
      'path': path,
      'metadata': metadata == null ? null : _buildMetadataUploadMap(metadata),
    }));
  }

  @deprecated
  PlatformUploadTask put(File file, [StorageMetadata metadata]) {
    return putFile(file, metadata);
  }

  PlatformUploadTask putFile(File file, [StorageMetadata metadata]) {
    assert(file.existsSync());
    final PlatformUploadTask task = PlatformUploadTask(
        file, firebaseStorage, this, metadata, UploadDataType.FILE);
    task.start();
    return task;
  }

  PlatformUploadTask putData(Uint8List data, [StorageMetadata metadata]) {
    final PlatformUploadTask task = PlatformUploadTask(
        data, firebaseStorage, this, metadata, UploadDataType.DATA);
    task.start();
    return task;
  }

  PlatformDownloadTask writeToFile(File file) {
    final PlatformDownloadTask task =
        PlatformDownloadTask(firebaseStorage, path, file);
    task._start();
    return task;
  }
}

Map<String, dynamic> _buildMetadataUploadMap(StorageMetadata metadata) {
  return <String, dynamic>{
    'cacheControl': metadata.cacheControl,
    'contentDisposition': metadata.contentDisposition,
    'contentLanguage': metadata.contentLanguage,
    'contentType': metadata.contentType,
    'contentEncoding': metadata.contentEncoding,
    'customMetadata': metadata.customMetadata,
  };
}
