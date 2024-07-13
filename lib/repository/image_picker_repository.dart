import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

/// A provider for the imagePickerRepository to access it globaly
final Provider<ImagePickerRepository> imagePickerRepositoryProvider =
    Provider<ImagePickerRepository>(
  (ProviderRef<Object?> ref) => ImagePickerRepository(),
);

/// Contains the functions to allow user to pick a picture from their device
class ImagePickerRepository {
  /// Creates a [ImagePickerRepository] instance
  ImagePickerRepository() {
    _picker = ImagePicker();
  }
  late ImagePicker _picker;

  /// Allow a user to pick a picture from his gallery
  Future<XFile?> pickImageFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    return image;
  }

  /// Allow a user to pick a picture from his camera
  Future<XFile?> pickImageFromCameraRoll() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);

    return image;
  }

  /// Allow a user to pick a picture from his device on web device
  Future<FilePickerResult?> pickImageFromWeb() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles();

    return result;
  }
}
