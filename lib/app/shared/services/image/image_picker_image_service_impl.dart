import 'package:image_picker/image_picker.dart';

import '../../models/image_file_model.dart';
import 'image_service.dart';

class ImagePickerImageServiceImpl implements ImageService {
  ImagePickerImageServiceImpl(this._imagePicker);

  final ImagePicker _imagePicker;

  @override
  Future<ImageFileModel?> getImageFromCamera() async {
    final image = await _imagePicker.pickImage(source: ImageSource.camera);
    ImageFileModel? imageFile;
    if (image != null) {
      imageFile = ImageFileModel(
        path: image.path,
        mimeType: image.mimeType,
      );
    }
    return imageFile;
  }

  @override
  Future<ImageFileModel?> getImageFromGallery() async {
    final image = await _imagePicker.pickImage(source: ImageSource.gallery);
    ImageFileModel? imageFile;
    if (image != null) {
      imageFile = ImageFileModel(
        path: image.path,
        mimeType: image.mimeType,
      );
    }
    return imageFile;
  }
}
