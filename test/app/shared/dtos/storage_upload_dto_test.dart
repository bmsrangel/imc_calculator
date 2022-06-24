import 'package:calculadora_imc/app/shared/dtos/storage_upload_dto.dart';
import 'package:calculadora_imc/app/shared/models/image_file_model.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late String userId;
  late String? currentProfileUrl;
  late ImageFileModel imageFileModel;
  late String newImagePath;
  late Faker faker;

  late StorageUploadDTO storageUploadDTO;

  setUp(
    () {
      faker = Faker();
      userId = faker.guid.guid();
      currentProfileUrl = faker.image.image(width: 200, height: 200);
      newImagePath = faker.image.image(width: 200, height: 200);
      imageFileModel = ImageFileModel(
        path: newImagePath,
      );
      storageUploadDTO = StorageUploadDTO(
        imageFileModel: imageFileModel,
        userId: userId,
        currentProfileURL: currentProfileUrl,
      );
    },
  );

  test(
    'storageUploadDTO should be an instance of StorageUploadDTO',
    () {
      expect(storageUploadDTO, isA<StorageUploadDTO>());
    },
  );

  test(
    'storageUploadDTO should have attributes set as setup variables',
    () {
      expect(storageUploadDTO.userId, userId);
      expect(storageUploadDTO.currentProfileURL, currentProfileUrl);
      expect(storageUploadDTO.imageFileModel, isA<ImageFileModel>());
      expect(storageUploadDTO.imageFileModel.path, newImagePath);
      expect(storageUploadDTO.imageFileModel.mimeType, null);
    },
  );
}
