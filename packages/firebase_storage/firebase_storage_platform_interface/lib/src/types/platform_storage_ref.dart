// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

part of firebase_storage_platform_interface;

class PlatformStorageRef {
  final List<String> _pathComponents;
  final FirebaseStoragePlatform _firebaseStorage;

  // PlatformStorageRef _parent;
  // PlatformStorageRef _root;

  PlatformStorageRef(
    this._pathComponents,
    this._firebaseStorage,
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

  PlatformStorageRef get root {
    return PlatformStorageRef(<String>[], _firebaseStorage);
  }

  FirebaseStoragePlatform get firebaseStorage => _firebaseStorage;

  List<String> get pathComponents => _pathComponents;

  String get path => _pathComponents?.join('/');

  FirebaseStoragePlatform get storage => _firebaseStorage;

  PlatformStorageRef child(String path) {
    final List<String> childPath = List<String>.from(_pathComponents)
      ..addAll(path.split("/"));
    return PlatformStorageRef(childPath, _firebaseStorage);
  }

  @deprecated
  PlatformUploadTask put(File file, [StorageMetadata metadata]) {
    return putFile(file, metadata);
  }

  Future<String> getBucket() {
    throw UnimplementedError('getBucket() is not implemented');
  }

  Future<String> getPath() {
    throw UnimplementedError('getPath() is not implemented');
  }

  Future<String> getName() {
    throw UnimplementedError('getName() is not implemented');
  }

  Future<void> delete() {
    throw UnimplementedError('delete() is not implemented');
  }

  Future<dynamic> getDownloadURL() async {
    throw UnimplementedError('getDownloadURL() is not implemented');
  }

  Future<StorageMetadata> getMetadata() async {
    throw UnimplementedError('getMetadata() is not implemented');
  }

  PlatformUploadTask putFile(File file, [StorageMetadata metadata]) {
    throw UnimplementedError('putFile() is not implemented');
  }

  PlatformUploadTask putData(Uint8List data, [StorageMetadata metadata]) {
    throw UnimplementedError('putData() is not implemented');
  }

  Future<StorageMetadata> updateMetadata(StorageMetadata metadata) async {
    throw UnimplementedError('updateMetadata() is not implemented');
  }

  dynamic writeToFile(File file) {
    throw UnimplementedError('updateMetadata() is not implemented');
  }
}
