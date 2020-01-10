// part of firebase_storage_web;

// class StorageReferenceWeb extends PlatformStorageRef {
//   StorageReferenceWeb(
//     List<String> pathComponents,
//     FirebaseStoragePlatform firebaseStorage,
//   ) : super(pathComponents, firebaseStorage);

//   /// Returns the Google Cloud Storage bucket that holds this object.
//   @override
//   Future<String> getBucket() async {
//     print('calling getbucket in web $pathComponents');
//     return fb
//         .storage()
//         .ref(pathComponents == null || pathComponents.isEmpty
//             ? '/'
//             : pathComponents.join('/'))
//         .bucket;
//   }
// }
