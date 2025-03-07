// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

part of firebase_storage_platform_interface;

enum StorageTaskEventType {
  resume,
  progress,
  pause,
  success,
  failure,
}

/// `Event` encapsulates a StorageTaskSnapshot
class StorageTaskEvent {
  StorageTaskEvent._(
      int type, PlatformStorageRef ref, Map<dynamic, dynamic> data)
      : type = StorageTaskEventType.values[type],
        snapshot = StorageTaskSnapshot._(ref, data.cast<String, dynamic>());

  final StorageTaskEventType type;
  final StorageTaskSnapshot snapshot;
}

class StorageTaskSnapshot {
  StorageTaskSnapshot._(this.ref, Map<String, dynamic> m)
      : error = m['error'],
        bytesTransferred = m['bytesTransferred'],
        totalByteCount = m['totalByteCount'],
        uploadSessionUri = m['uploadSessionUri'] != null
            ? Uri.parse(m['uploadSessionUri'])
            : null,
        storageMetadata = m['storageMetadata'] != null
            ? StorageMetadata.fromMap(
                m['storageMetadata'].cast<String, dynamic>())
            : null;

  final PlatformStorageRef ref;
  final int error;
  final int bytesTransferred;
  final int totalByteCount;
  final Uri uploadSessionUri;
  final StorageMetadata storageMetadata;
}
