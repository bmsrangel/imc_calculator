import '../../models/image_file_model.dart';

abstract class ImageService {
  Future<ImageFileModel?> getImageFromCamera();
  Future<ImageFileModel?> getImageFromGallery();
}
