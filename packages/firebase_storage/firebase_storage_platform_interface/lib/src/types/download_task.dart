part of firebase_storage_platform_interface;

class StorageFileDownloadTask {
  StorageFileDownloadTask._(this._firebaseStorage, this._path, this._file);

  final MethodChannelFirebaseStorage _firebaseStorage;
  final String _path;
  final File _file;

  Future<void> _start() async {
    try {
      final int totalByteCount =
          await MethodChannelFirebaseStorage.channel.invokeMethod<int>(
        "StorageReference#writeToFile",
        <String, dynamic>{
          'app': _firebaseStorage.app?.name,
          'bucket': _firebaseStorage.storageBucket,
          'filePath': _file.absolute.path,
          'path': _path,
        },
      );
      _completer
          .complete(FileDownloadTaskSnapshot(totalByteCount: totalByteCount));
    } catch (e) {
      _completer.completeError(e);
    }
  }

  Completer<FileDownloadTaskSnapshot> _completer =
      Completer<FileDownloadTaskSnapshot>();
  Future<FileDownloadTaskSnapshot> get future => _completer.future;
}
