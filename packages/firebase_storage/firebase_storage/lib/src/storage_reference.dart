// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

part of firebase_storage;

class StorageReference extends PlatformStorageRef {
  StorageReference._(
    _pathComponents,
    _firebaseStorage,
  ) : super(_pathComponents, _firebaseStorage);

  factory StorageReference._fromPlatform(
      PlatformStorageRef platformStorageRef) {
    return platformStorageRef == null
        ? null
        : StorageReference._(platformStorageRef.pathComponents,
            platformStorageRef.firebaseStorage);
  }

  @override
  FirebaseStorage get firebaseStorage =>
      FirebaseStorage._fromPlatform(super.firebaseStorage);

  @override
  FirebaseStorage get storage => FirebaseStorage._fromPlatform(super.storage);

  @override
  StorageReference child(String path) =>
      StorageReference._fromPlatform(super.child(path));

  @override
  StorageReference get parent => StorageReference._fromPlatform(super.parent);

  @override
  StorageReference get root => StorageReference._fromPlatform(super.root);

  /// Returns the Google Cloud Storage bucket that holds this object.
  @override
  Future<String> getBucket() => super.getBucket();

  /// Returns the short name of this object.
  @override
  Future<String> getName() => super.getName();

  /// Returns the full path to this object, not including the Google Cloud
  /// Storage bucket.
  @override
  Future<String> getPath() => super.getPath();

  /// Asynchronously retrieves a long lived download URL with a revokable token.
  /// This can be used to share the file with others, but can be revoked by a
  /// developer in the Firebase Console if desired.
  @override
  Future<dynamic> getDownloadURL() => super.getDownloadURL();

  @override
  Future<void> delete() => super.delete();

  /// Retrieves metadata associated with an object at this [StorageReference].
  @override
  Future<StorageMetadata> getMetadata() => super.getMetadata();

  /// Updates the metadata associated with this [StorageReference].
  ///
  /// Returns a [Future] that will complete to the updated [StorageMetadata].
  ///
  /// This method ignores fields of [metadata] that cannot be set by the public
  /// [StorageMetadata] constructor. Writable metadata properties can be deleted
  /// by passing the empty string.
  @override
  Future<StorageMetadata> updateMetadata(StorageMetadata metadata) =>
      super.updateMetadata(metadata);

  /// Asynchronously downloads the object at the StorageReference to a list in memory.
  /// A list of the provided max size will be allocated.
  Future<Uint8List> getData(int maxSize) => super.getData(maxSize);

  /// Asynchronously downloads the object at this [StorageReference] to a
  /// specified system file.
  StorageFileDownloadTask writeToFile(File file) =>
      StorageFileDownloadTask._fromPlatform(super.writeToFile(file));

  /// This method is deprecated. Please use [putFile] instead.
  ///
  /// Asynchronously uploads a file to the currently specified
  /// [StorageReference], with an optional [metadata].
  @deprecated
  StorageUploadTask put(File file, [StorageMetadata metadata]) =>
      StorageUploadTask._fromPlatform(
          metadata == null ? super.put(file) : super.put(file, metadata));

  /// Asynchronously uploads a file to the currently specified
  /// [StorageReference], with an optional [metadata].
  StorageUploadTask putFile(File file, [StorageMetadata metadata]) =>
      StorageUploadTask._fromPlatform(metadata == null
          ? super.putFile(file)
          : super.putFile(file, metadata));

  /// Asynchronously uploads byte data to the currently specified
  /// [StorageReference], with an optional [metadata].
  StorageUploadTask putData(Uint8List data, [StorageMetadata metadata]) =>
      StorageUploadTask._fromPlatform(metadata == null
          ? super.putData(data)
          : super.putData(data, metadata));
}
