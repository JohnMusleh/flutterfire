library firebase_storage;

import 'dart:async';
import 'dart:typed_data';

import 'package:firebase_storage_platform_interface/firebase_storage_platform_interface.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'dart:io';

export 'package:firebase_storage_platform_interface/firebase_storage_platform_interface.dart'
    show
        FileDownloadTaskSnapshot,
        StorageTaskSnapshot,
        StorageError,
        StorageTaskEvent,
        StorageTaskEventType,
        StorageMetadata;

part 'src/firebase_storage.dart';
part 'src/storage_reference.dart';
part 'src/upload_task.dart';
part 'src/download_task.dart';
