import 'package:calculadora_imc/app/shared/models/image_file_model.dart';
import 'package:calculadora_imc/app/shared/services/image/image_picker_image_service_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mocktail/mocktail.dart';

class MockImagePicker extends Mock implements ImagePicker {}

void main() {
  late ImagePicker mockImagePicker;
  late ImagePickerImageServiceImpl service;
  late String imagePath;
  late String mimeType;

  setUp(
    () {
      mockImagePicker = MockImagePicker();
      service = ImagePickerImageServiceImpl(mockImagePicker);
      imagePath = '/path1/path2/image.jpg';
      mimeType = 'image/jpg';
    },
  );

  test(
    'getImageFromCamera should return an ImageFileModel when a photo is taken',
    () async {
      when(() => mockImagePicker.pickImage(source: ImageSource.camera))
          .thenAnswer(
        (_) async => XFile(imagePath, mimeType: mimeType),
      );
      final imageFile = await service.getImageFromCamera();
      expect(imageFile, isNotNull);
      expect(imageFile, isA<ImageFileModel>());
      expect(imageFile!.path, imagePath);
      expect(imageFile.mimeType, mimeType);
    },
  );

  test(
    'getImageFromCamera should return null if photo is not taken',
    () async {
      when(() => mockImagePicker.pickImage(source: ImageSource.camera))
          .thenAnswer(
        (_) async => null,
      );
      final imageFile = await service.getImageFromCamera();
      expect(imageFile, isNull);
    },
  );

  test(
    'getImageFromGallery should return an ImageFileModel when an image is selected',
    () async {
      when(() => mockImagePicker.pickImage(source: ImageSource.gallery))
          .thenAnswer(
        (_) async => XFile(imagePath, mimeType: mimeType),
      );
      final imageFile = await service.getImageFromGallery();
      expect(imageFile, isNotNull);
      expect(imageFile, isA<ImageFileModel>());
      expect(imageFile!.path, imagePath);
      expect(imageFile.mimeType, mimeType);
    },
  );

  test(
    'getImageFromCamera should return null if an image is not selected',
    () async {
      when(() => mockImagePicker.pickImage(source: ImageSource.gallery))
          .thenAnswer(
        (_) async => null,
      );
      final imageFile = await service.getImageFromGallery();
      expect(imageFile, isNull);
    },
  );
}
