library firebase_storage;

import 'dart:async';

import 'package:firebase_storage_platform_interface/firebase_storage_platform_interface.dart';
import 'package:firebase_core/firebase_core.dart';

export 'package:firebase_storage_platform_interface/firebase_storage_platform_interface.dart'
    show
        FileDownloadTaskSnapshot,
        StorageFileDownloadTask,
        StorageReference,
        StorageTaskSnapshot,
        StorageError,
        StorageTaskEvent,
        StorageTaskEventType,
        StorageMetadata,
        StorageUploadTask;
part 'src/firebase_storage.dart';
