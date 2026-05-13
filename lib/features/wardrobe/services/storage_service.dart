import 'dart:io';
import 'package:uuid/uuid.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StorageService {
  final SupabaseClient _client = Supabase.instance.client;
  final String _bucketName = 'clothing-images';
  final Uuid _uuid = const Uuid();

  Future<String> uploadImage(File file, String userId) async {
    final fileName = '${_uuid.v4()}.jpg';
    final path = 'users/$userId/$fileName';
    int retries = 3;

    while (retries > 0) {
      try {
        await _client.storage.from(_bucketName).upload(
              path,
              file,
              fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
            );
print("UPLOAD PATH: users/$userId/$fileName");
print("BUCKET: clothing-images");
print("---------------------------❗️---------------------------");

final buckets = await Supabase.instance.client.storage.listBuckets();

print("BUCKETS: $buckets");

        return _client.storage.from(_bucketName).getPublicUrl(path);
      } catch (e) {
        retries--;
        if (retries == 0) {
          throw Exception('Failed to upload image after multiple attempts: $e');
        }
        await Future.delayed(const Duration(seconds: 1));
      }
    }
    
    throw Exception('Upload failed');
  }
  
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
      print('Failed to delete image from storage: $e');
    }
  }
}