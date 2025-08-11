import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;

class StorageService {
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  static Future<String?> uploadFile({
    required File file,
    required String folder,
    String? fileName,
  }) async {
    try {
      final String fileExtension = path.extension(file.path);
      final String uploadFileName = fileName ?? 
          '${DateTime.now().millisecondsSinceEpoch}$fileExtension';
      
      final Reference ref = _storage.ref().child('$folder/$uploadFileName');
      final UploadTask uploadTask = ref.putFile(file);
      
      final TaskSnapshot snapshot = await uploadTask;
      final String downloadUrl = await snapshot.ref.getDownloadURL();
      
      return downloadUrl;
    } catch (e) {
      return null;
    }
  }

  static Future<bool> deleteFile(String url) async {
    try {
      final Reference ref = _storage.refFromURL(url);
      await ref.delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<List<String>> getFileUrls(String folder) async {
    try {
      final ListResult result = await _storage.ref().child(folder).listAll();
      final List<String> urls = [];
      
      for (Reference ref in result.items) {
        final String url = await ref.getDownloadURL();
        urls.add(url);
      }
      
      return urls;
    } catch (e) {
      return [];
    }
  }
}