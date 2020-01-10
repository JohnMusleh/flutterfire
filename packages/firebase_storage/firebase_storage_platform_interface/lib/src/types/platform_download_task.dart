// part of firebase_storage_platform_interface;

// abstract class PlatformDownloadTask {
//   final FirebaseStoragePlatform firebaseStorage;
//   final String path;
//   final File file;
//   PlatformDownloadTask(this.firebaseStorage, this.path, this.file);

//   Future<void> start() async {
//     throw UnimplementedError('start() is not implemented');
//   }

//   Completer<FileDownloadTaskSnapshot> _completer =
//       Completer<FileDownloadTaskSnapshot>();
//   Future<FileDownloadTaskSnapshot> get future => _completer.future;
// }
