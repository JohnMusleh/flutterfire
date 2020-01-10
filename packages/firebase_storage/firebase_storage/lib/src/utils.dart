part of firebase_storage;

Map<String, dynamic> _buildMetadataUploadMap(StorageMetadata metadata) {
  return <String, dynamic>{
    'cacheControl': metadata.cacheControl,
    'contentDisposition': metadata.contentDisposition,
    'contentLanguage': metadata.contentLanguage,
    'contentType': metadata.contentType,
    'contentEncoding': metadata.contentEncoding,
    'customMetadata': metadata.customMetadata,
  };
}

const MethodChannel _channel = MethodChannel(
  'plugins.flutter.io/firebase_storage',
);
