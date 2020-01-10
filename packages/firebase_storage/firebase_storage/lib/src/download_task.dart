part of firebase_storage;

class StorageFileDownloadTask extends PlatformDownloadTask {
  StorageFileDownloadTask._(
      FirebaseStorage _firebaseStorage, String _path, File _file)
      : super(_firebaseStorage, _path, _file);

  factory StorageFileDownloadTask._fromPlatform(
      PlatformDownloadTask platformDownloadTask) {
    return platformDownloadTask == null
        ? null
        : StorageFileDownloadTask._(platformDownloadTask.firebaseStorage,
            platformDownloadTask.path, platformDownloadTask.file);
  }

  Future<FileDownloadTaskSnapshot> get future => super.future;
}
