// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

part of firebase_storage_platform_interface;

enum UploadDataType { DATA, FILE, STRING }

class PlatformUploadTask {
  PlatformUploadTask(
      this.data, this.firebaseStorage, this.ref, this.metadata, this.dataType);

  final FirebaseStoragePlatform firebaseStorage;
  final PlatformStorageRef ref;
  final StorageMetadata metadata;
  final UploadDataType dataType;
  final dynamic data;

  @visibleForTesting
  static const MethodChannel channel = MethodChannel(
    'plugins.flutter.io/firebase_storage',
  );

  Future<dynamic> _platformStart() {
    String key;
    dynamic value;
    String method;
    switch (dataType) {
      case UploadDataType.FILE:
        key = 'filename';
        value = data.absolute.path; //File.absolute.path
        method = 'StorageReference#putFile';
        break;
      case UploadDataType.DATA:
        key = 'data';
        method = 'StorageReference#putData';
        value = data; //Uint8List
        break;
      default:
        break;
    }
    print('invoking  channel $channel with args $key:$value');
    return channel.invokeMethod<dynamic>(
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

  int _handle;

  int get handle => _handle;

  bool isCanceled = false;
  bool isComplete = false;
  bool isInProgress = true;
  bool isPaused = false;
  bool isSuccessful = false;

  StorageTaskSnapshot _lastSnapshot;
  StorageTaskSnapshot get lastSnapshot => _lastSnapshot;

  /// Returns a last snapshot when completed
  Completer<StorageTaskSnapshot> _completer = Completer<StorageTaskSnapshot>();
  Future<StorageTaskSnapshot> get onComplete => _completer.future;

  StreamController<StorageTaskEvent> _controller =
      StreamController<StorageTaskEvent>.broadcast();
  Stream<StorageTaskEvent> get events => _controller.stream;

  Future<StorageTaskSnapshot> start() async {
    _handle = await _platformStart();
    final StorageTaskEvent event = await firebaseStorage.methodStream
        .where((MethodCall m) {
      return m.method == 'StorageTaskEvent' && m.arguments['handle'] == _handle;
    }).map<StorageTaskEvent>((MethodCall m) {
      final Map<dynamic, dynamic> args = m.arguments;
      final StorageTaskEvent e =
          StorageTaskEvent._(args['type'], ref, args['snapshot']);
      _changeState(e);
      _lastSnapshot = e.snapshot;
      _controller.add(e);
      if (e.type == StorageTaskEventType.success ||
          e.type == StorageTaskEventType.failure) {
        _completer.complete(e.snapshot);
      }
      return e;
    }).firstWhere((StorageTaskEvent e) =>
            e.type == StorageTaskEventType.success ||
            e.type == StorageTaskEventType.failure);
    return event.snapshot;
  }

  void _changeState(StorageTaskEvent event) {
    _resetState();
    switch (event.type) {
      case StorageTaskEventType.progress:
        isInProgress = true;
        break;
      case StorageTaskEventType.resume:
        isInProgress = true;
        break;
      case StorageTaskEventType.pause:
        isPaused = true;
        break;
      case StorageTaskEventType.success:
        isSuccessful = true;
        isComplete = true;
        break;
      case StorageTaskEventType.failure:
        isComplete = true;
        if (event.snapshot.error == StorageError.canceled) {
          isCanceled = true;
        }
        break;
    }
  }

  void _resetState() {
    isCanceled = false;
    isComplete = false;
    isInProgress = false;
    isPaused = false;
    isSuccessful = false;
  }

  void pause() => channel.invokeMethod<void>(
        'UploadTask#pause',
        <String, dynamic>{
          'app': firebaseStorage.app?.name,
          'bucket': firebaseStorage.storageBucket,
          'handle': handle,
        },
      );

  void resume() => channel.invokeMethod<void>(
        'UploadTask#resume',
        <String, dynamic>{
          'app': firebaseStorage.app?.name,
          'bucket': firebaseStorage.storageBucket,
          'handle': handle,
        },
      );

  void cancel() => channel.invokeMethod<void>(
        'UploadTask#cancel',
        <String, dynamic>{
          'app': firebaseStorage.app?.name,
          'bucket': firebaseStorage.storageBucket,
          'handle': handle,
        },
      );
}
//to be implemented in firebase_storage.dart
// class _StorageFileUploadTask extends PlatformUploadTask {
//   _StorageFileUploadTask._(
//       this._file,
//       MethodChannelFirebaseStorage firebaseStorage,
//       PlatformStorageRef ref,
//       StorageMetadata metadata)
//       : super._(firebaseStorage, ref, metadata);

//   final File _file;

//   @override
//   Future<dynamic> platformStart() {
//     return MethodChannelFirebaseStorage.channel.invokeMethod<dynamic>(
//       'StorageReference#putFile',
//       <String, dynamic>{
//         'app': firebaseStorage.app?.name,
//         'bucket': firebaseStorage.storageBucket,
//         'filename': _file.absolute.path,
//         'path': ref.path,
//         'metadata':
//             metadata == null ? null : _buildMetadataUploadMap(metadata),
//       },
//     );
//   }
// }

// class _StorageDataUploadTask extends PlatformUploadTask {
//   _StorageDataUploadTask._(
//       this._bytes,
//       MethodChannelFirebaseStorage firebaseStorage,
//       PlatformStorageRef ref,
//       StorageMetadata metadata)
//       : super._(firebaseStorage, ref, metadata);

//   final Uint8List _bytes;

//   @override
//   Future<dynamic> platformStart() {
//     return MethodChannelFirebaseStorage.channel.invokeMethod<dynamic>(
//       'StorageReference#putData',
//       <String, dynamic>{
//         'app': firebaseStorage.app?.name,
//         'bucket': firebaseStorage.storageBucket,
//         'data': _bytes,
//         'path': ref.path,
//         'metadata':
//             metadata == null ? null : _buildMetadataUploadMap(metadata),
//       },
//     );
//   }
// }

// Map<String, dynamic> _buildMetadataUploadMap(StorageMetadata metadata) {
//   return <String, dynamic>{
//     'cacheControl': metadata.cacheControl,
//     'contentDisposition': metadata.contentDisposition,
//     'contentLanguage': metadata.contentLanguage,
//     'contentType': metadata.contentType,
//     'contentEncoding': metadata.contentEncoding,
//     'customMetadata': metadata.customMetadata,
//   };
// }
