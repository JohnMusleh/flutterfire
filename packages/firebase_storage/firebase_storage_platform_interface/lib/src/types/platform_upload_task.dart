// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

part of firebase_storage_platform_interface;

enum UploadDataType { DATA, FILE, STRING }

abstract class PlatformUploadTask {
  PlatformUploadTask(this._data, this._firebaseStorage, this._ref,
      this._metadata, this._dataType);

  final FirebaseStoragePlatform _firebaseStorage;
  final PlatformStorageRef _ref;
  final StorageMetadata _metadata;
  final UploadDataType _dataType;
  final dynamic _data;

  Future<dynamic> platformStart();

  int _handle;

  int get handle => _handle;
  FirebaseStoragePlatform get firebaseStorage => _firebaseStorage;
  PlatformStorageRef get ref => _ref;
  StorageMetadata get metadata => _metadata;
  UploadDataType get dataType => _dataType;

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
    _handle = await platformStart();
    final StorageTaskEvent event = await _firebaseStorage.methodStream
        .where((MethodCall m) {
      return m.method == 'StorageTaskEvent' && m.arguments['handle'] == _handle;
    }).map<StorageTaskEvent>((MethodCall m) {
      final Map<dynamic, dynamic> args = m.arguments;
      final StorageTaskEvent e =
          StorageTaskEvent._(args['type'], _ref, args['snapshot']);
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

  /// Pause the upload
  void pause() => throw UnimplementedError('pause() is not implemented');

  /// Resume the upload
  void resume() => throw UnimplementedError('resume() is not implemented');

  /// Cancel the upload
  void cancel() => throw UnimplementedError('cancel() is not implemented');
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
//         'app': _firebaseStorage.app?.name,
//         'bucket': _firebaseStorage.storageBucket,
//         'filename': _file.absolute.path,
//         'path': _ref.path,
//         'metadata':
//             _metadata == null ? null : _buildMetadataUploadMap(_metadata),
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
//         'app': _firebaseStorage.app?.name,
//         'bucket': _firebaseStorage.storageBucket,
//         'data': _bytes,
//         'path': _ref.path,
//         'metadata':
//             _metadata == null ? null : _buildMetadataUploadMap(_metadata),
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
