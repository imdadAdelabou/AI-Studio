import 'dart:developer';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Expose the FirebaseStorageRepository to access them globaly
final Provider<FirebaseStorageRepository> firebaseStorageRepositoryProvider =
    Provider<FirebaseStorageRepository>(
  (ProviderRef<FirebaseStorageRepository> ref) => FirebaseStorageRepository(),
);

/// An abstract class to manage the variants of type file and the the name of the file
/// No matter the type is
abstract class IFileName {
  /// Used to get the name of the file
  String getName();
}

/// A class to get the name of the file when the type of the file is File
class FileNameForFile implements IFileName {
  /// Creates a [FileNameForFile] instance
  FileNameForFile({required File file}) : _file = file;

  final File _file;

  @override
  String getName() {
    return _file.path.split('/').last;
  }
}

/// A class to get the name of the file when the type of the file is PlatformFile
class FileNameForFileForPlatformFile implements IFileName {
  /// Creates a [FileNameForFileForPlatformFile] instance
  FileNameForFileForPlatformFile({required PlatformFile file}) : _file = file;

  final PlatformFile _file;

  @override
  String getName() {
    return _file.name;
  }
}

/// Contains the functions to store and retrieve files from firebase cloud storage
class FirebaseStorageRepository {
  final FirebaseStorage _storageRef = FirebaseStorage.instance;

  /// Used to upload a file on a firebase cloud storage bucket
  Future<dynamic> uploadFile({
    required String path,
    required dynamic file,
    required String fileName,
  }) async {
    try {
      final Reference ref = _storageRef.ref('$path$fileName');
      if (!kIsWeb) {
        await ref.putFile(file);
      } else {
        await ref.putData((file as PlatformFile).bytes!);
      }

      final String url = await ref.getDownloadURL();

      return url;
    } catch (e) {
      log('Error upload file $e');
      return false;
    }
  }
}
