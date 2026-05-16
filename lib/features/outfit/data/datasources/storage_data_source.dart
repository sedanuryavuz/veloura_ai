import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

abstract class StorageDataSource {
  Future<String> uploadImage(File file, String userId);
  Future<void> deleteImage(String imageUrl);
}

class StorageDataSourceImpl implements StorageDataSource {
  final SupabaseClient _client;
  final String _bucketName = 'clothing-images';
  final Uuid _uuid = const Uuid();

  StorageDataSourceImpl(this._client);

  @override
  Future<String> uploadImage(File file, String userId) async {
    final fileName = '${_uuid.v4()}.jpg';
    final path = 'users/$userId/$fileName';
    int retries = 3;

    while (retries > 0) {
      try {
        await _client.storage
            .from(_bucketName)
            .upload(
              path,
              file,
              fileOptions: const FileOptions(
                cacheControl: '3600',
                upsert: false,
              ),
            );
        return _client.storage.from(_bucketName).getPublicUrl(path);
      } catch (e) {
        retries--;
        if (retries == 0) throw Exception('Failed to upload image: $e');
        await Future.delayed(const Duration(seconds: 1));
      }
    }
    throw Exception('Upload failed');
  }

  @override
  Future<void> deleteImage(String imageUrl) async {
    try {
      final uri = Uri.parse(imageUrl);
      final pathSegments = uri.pathSegments;
      final bucketIndex = pathSegments.indexOf(_bucketName);
      if (bucketIndex != -1 && bucketIndex + 1 < pathSegments.length) {
        final filePath = pathSegments.sublist(bucketIndex + 1).join('/');
        await _client.storage.from(_bucketName).remove([filePath]);
      }
    } catch (e) {
      // Log error
    }
  }
}
