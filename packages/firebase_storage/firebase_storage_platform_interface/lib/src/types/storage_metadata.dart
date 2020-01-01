// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

part of firebase_storage_platform_interface;

/// Metadata for a [PlatformStorageReference]. Metadata stores default attributes such as
/// size and content type.
class StorageMetadata {
  StorageMetadata({
    this.cacheControl,
    this.contentDisposition,
    this.contentEncoding,
    this.contentLanguage,
    this.contentType,
    Map<String, String> customMetadata,
  })  : bucket = null,
        generation = null,
        metadataGeneration = null,
        path = null,
        name = null,
        sizeBytes = null,
        creationTimeMillis = null,
        updatedTimeMillis = null,
        md5Hash = null,
        customMetadata = customMetadata == null
            ? null
            : Map<String, String>.unmodifiable(customMetadata);

  StorageMetadata._fromMap(Map<String, dynamic> map)
      : bucket = map['bucket'],
        generation = map['generation'],
        metadataGeneration = map['metadataGeneration'],
        path = map['path'],
        name = map['name'],
        sizeBytes = map['sizeBytes'],
        creationTimeMillis = map['creationTimeMillis'],
        updatedTimeMillis = map['updatedTimeMillis'],
        md5Hash = map['md5Hash'],
        cacheControl = map['cacheControl'],
        contentDisposition = map['contentDisposition'],
        contentLanguage = map['contentLanguage'],
        contentType = map['contentType'],
        contentEncoding = map['contentEncoding'],
        customMetadata = map['customMetadata'] == null
            ? null
            : Map<String, String>.unmodifiable(
                map['customMetadata'].cast<String, String>());

  /// The owning Google Cloud Storage bucket for the [PlatformStorageReference].
  final String bucket;

  /// A version String indicating what version of the [PlatformStorageReference].
  final String generation;

  /// A version String indicating the version of this [StorageMetadata].
  final String metadataGeneration;

  /// The path of the [PlatformStorageReference] object.
  final String path;

  /// A simple name of the [PlatformStorageReference] object.
  final String name;

  /// The stored Size in bytes of the [PlatformStorageReference] object.
  final int sizeBytes;

  /// The time the [PlatformStorageReference] was created in milliseconds since the epoch.
  final int creationTimeMillis;

  /// The time the [PlatformStorageReference] was last updated in milliseconds since the epoch.
  final int updatedTimeMillis;

  /// The MD5Hash of the [PlatformStorageReference] object.
  final String md5Hash;

  /// The Cache Control setting of the [PlatformStorageReference].
  final String cacheControl;

  /// The content disposition of the [PlatformStorageReference].
  final String contentDisposition;

  /// The content encoding for the [PlatformStorageReference].
  final String contentEncoding;

  /// The content language for the PlatformStorageReference, specified as a 2-letter
  /// lowercase language code defined by ISO 639-1.
  final String contentLanguage;

  /// The content type (MIME type) of the [PlatformStorageReference].
  final String contentType;

  /// An unmodifiable map with custom metadata for the [PlatformStorageReference].
  final Map<String, String> customMetadata;
}
