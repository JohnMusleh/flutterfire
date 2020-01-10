part of firebase_storage_platform_interface;

class PlatformDownloadTask {
  final FirebaseStoragePlatform firebaseStorage;
  final String path;
  final File file;
  PlatformDownloadTask(this.firebaseStorage, this.path, this.file);

  static const MethodChannel channel = MethodChannel(
    'plugins.flutter.io/firebase_storage',
  );

  Future<void> _start() async {
    try {
      final int totalByteCount = await channel.invokeMethod<int>(
        "StorageReference#writeToFile",
        <String, dynamic>{
          'app': firebaseStorage.app?.name,
          'bucket': firebaseStorage.storageBucket,
          'filePath': file.absolute.path,
          'path': path,
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
