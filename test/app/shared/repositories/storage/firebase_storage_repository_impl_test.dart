import 'package:calculadora_imc/app/shared/dtos/storage_upload_dto.dart';
import 'package:calculadora_imc/app/shared/models/image_file_model.dart';
import 'package:calculadora_imc/app/shared/repositories/storage/firebase_storage_repository_impl.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  late MockFirebaseStorage mockFirebaseStorage;
  late FirebaseStorageRepositoryImpl repository;
  late ImageFileModel mockImageFile;
  late String cameraPath;
  late StorageUploadDTO mockStorageUpload;

  setUp(
    () {
      mockFirebaseStorage = MockFirebaseStorage();
    },
  );

  group(
    'Success tests',
    () {
      setUp(
        () {
          repository = FirebaseStorageRepositoryImpl(mockFirebaseStorage);
          cameraPath = 'path/camera.jpg';
          mockImageFile = ImageFileModel(path: cameraPath);
          mockStorageUpload = StorageUploadDTO(
            imageFileModel: mockImageFile,
            userId: 'any',
            currentProfileURL: null,
          );
          registerFallbackValue(mockStorageUpload);
        },
      );
      test(
        '_getFileExtension should return jpg when argument is /path1/path2/file.jpg',
        () {
          const path = '/path1/path2/file.jpg';
          final extension = repository.getFileExtension(path);
          expect(extension, 'jpg');
        },
      );

      test(
        'uploadImage should return a downloadUrl',
        () async {
          const imageUrl = 'http://image.firebase.com';
          final storageUploadDTO = StorageUploadDTO(
            imageFileModel: ImageFileModel(
              path: 'mockImage.jpeg',
              mimeType: 'media/jpeg',
            ),
            userId: 'any',
            currentProfileURL: null,
          );
          when(() => mockFirebaseStorage.ref().getDownloadURL()).thenAnswer(
            (realInvocation) async => imageUrl,
          );
          final downloadUrl = await repository.uploadImage(storageUploadDTO);
          expect(downloadUrl, isA<String>());
          expect(downloadUrl, imageUrl);
        },
      );
    },
  );
}
