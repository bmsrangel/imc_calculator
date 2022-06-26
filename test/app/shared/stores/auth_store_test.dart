import 'package:calculadora_imc/app/shared/dtos/sign_up_dto.dart';
import 'package:calculadora_imc/app/shared/dtos/storage_upload_dto.dart';
import 'package:calculadora_imc/app/shared/exceptions/auth_exception.dart';
import 'package:calculadora_imc/app/shared/exceptions/storage_exception.dart';
import 'package:calculadora_imc/app/shared/models/image_file_model.dart';
import 'package:calculadora_imc/app/shared/models/user_model.dart';
import 'package:calculadora_imc/app/shared/repositories/auth/auth_repository.dart';
import 'package:calculadora_imc/app/shared/repositories/storage/storage_repository.dart';
import 'package:calculadora_imc/app/shared/services/current_user/current_user_service.dart';
import 'package:calculadora_imc/app/shared/services/image/image_service.dart';
import 'package:calculadora_imc/app/shared/stores/auth_store.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockCurrentUserService extends Mock implements CurrentUserService {}

class MockImageService extends Mock implements ImageService {}

class MockStorageRepository extends Mock implements StorageRepository {}

void main() {
  late AuthRepository mockAuthRepository;
  late CurrentUserService mockCurrentUserService;
  late ImageService mockImageService;
  late StorageRepository mockStorageRepository;
  late AuthStore store;
  late UserModel mockUser;
  late ImageFileModel mockImageFile;
  late SignUpDTO mockUserData;
  late String cameraPath;
  late String newProfileUrl;
  late StorageUploadDTO mockStorageUpload;

  setUp(
    () {
      mockAuthRepository = MockAuthRepository();
      mockCurrentUserService = MockCurrentUserService();
      mockImageService = MockImageService();
      mockStorageRepository = MockStorageRepository();
      store = AuthStore(
        mockAuthRepository,
        mockCurrentUserService,
        mockImageService,
        mockStorageRepository,
      );
      mockUser = UserModel(
        id: 'any',
        displayName: 'any',
        email: 'any',
        profileUrl: null,
      );
      mockUserData = SignUpDTO(
        displayName: 'any',
        email: 'any',
        password: 'any',
      );
      cameraPath = 'path/camera.jpg';
      mockImageFile = ImageFileModel(path: cameraPath);
      newProfileUrl = 'http://image.firebase.com';
      mockStorageUpload = StorageUploadDTO(
        imageFileModel: mockImageFile,
        userId: mockUser.id,
        currentProfileURL: null,
      );
      registerFallbackValue(mockUserData);
      registerFallbackValue(mockStorageUpload);
    },
  );

  test(
    'Initial isLoading value should be false, user and error should be null',
    () {
      expect(store.isLoading, false);
      expect(store.user, isNull);
      expect(store.error, isNull);
    },
  );

  group(
    'Success tests',
    () {
      test(
        'getCurrentUser should return set user value properly',
        () async {
          when(() => mockCurrentUserService.getCurrentUser()).thenAnswer(
            (_) async => null,
          );
          await store.getCurrentUser();
          expect(store.user, isNull);
          when(() => mockCurrentUserService.getCurrentUser()).thenAnswer(
            (_) async => mockUser,
          );
          await store.getCurrentUser();
          expect(store.user, isNotNull);
          expect(store.error, isNull);
          expect(store.isLoading, false);
          expect(store.user!.id, mockUser.id);
          expect(store.user!.displayName, mockUser.displayName);
          expect(store.user!.email, mockUser.email);
          expect(store.user!.profileUrl, isNull);
        },
      );

      test(
        'loginWithEmailPassword should set user properly',
        () async {
          when(
            () => mockAuthRepository.loginWithEmailPassword(
              any(),
              any(),
            ),
          ).thenAnswer(
            (_) async => mockUser,
          );

          await store.loginWithEmailPassword('email', 'password');
          expect(store.user, isNotNull);
          expect(store.error, isNull);
          expect(store.isLoading, false);
          expect(store.user!.id, mockUser.id);
          expect(store.user!.displayName, mockUser.displayName);
          expect(store.user!.email, mockUser.email);
          expect(store.user!.profileUrl, isNull);
        },
      );

      test(
        'signUpWithEmailPassword should set user properly',
        () async {
          when(
            () => mockAuthRepository.signUpWithEmailPassword(any<SignUpDTO>()),
          ).thenAnswer(
            (_) async => mockUser,
          );

          await store.signUpWithEmailPassword(mockUserData);
          expect(store.error, isNull);
          expect(store.isLoading, false);
          expect(store.user, isNotNull);
          expect(store.user!.id, mockUser.id);
          expect(store.user!.displayName, mockUser.displayName);
          expect(store.user!.email, mockUser.email);
          expect(store.user!.profileUrl, isNull);
        },
      );

      test(
        'logout should cause error and user to be null',
        () async {
          when(() => mockAuthRepository.logout()).thenAnswer(
            (_) async => () => () {},
          );
          await store.logout();
          expect(store.user, isNull);
          expect(store.error, isNull);
        },
      );

      test(
        'setProfileImage should cause user to have an updated profileUrl with ImageSource.camera',
        () async {
          when(() => mockImageService.getImageFromCamera()).thenAnswer(
            (_) async => mockImageFile,
          );
          when(
            () => mockStorageRepository.uploadImage(
              any<StorageUploadDTO>(),
            ),
          ).thenAnswer(
            (_) async => newProfileUrl,
          );
          when(
            () => mockAuthRepository.setProfileURL(newProfileUrl),
          ).thenAnswer(
            (_) async => () => () {},
          );
          store.user = mockUser;
          await store.setProfileImage(ImageSource.camera);
          expect(store.user!.profileUrl, newProfileUrl);
        },
      );

      test(
        'setProfileImage should cause user to have an updated profileUrl with ImageSource.gallery',
        () async {
          when(() => mockImageService.getImageFromGallery()).thenAnswer(
            (_) async => mockImageFile,
          );
          when(
            () => mockStorageRepository.uploadImage(
              any<StorageUploadDTO>(),
            ),
          ).thenAnswer(
            (_) async => newProfileUrl,
          );
          when(
            () => mockAuthRepository.setProfileURL(newProfileUrl),
          ).thenAnswer(
            (_) async => () => () {},
          );
          store.user = mockUser;
          await store.setProfileImage(ImageSource.gallery);
          expect(store.user!.profileUrl, newProfileUrl);
        },
      );
    },
  );

  group(
    'Exceptions tests',
    () {
      test(
        'loginWithEmailPassword should throw an AuthException causing error not to be null',
        () async {
          final exception = AuthException('user-not-found');
          when(
            () => mockAuthRepository.loginWithEmailPassword(any(), any()),
          ).thenThrow(exception);
          await store.loginWithEmailPassword('email', 'password');
          expect(store.user, isNull);
          expect(store.isLoading, false);
          expect(store.error, isNotNull);
          expect(store.error, exception.message);
        },
      );

      test(
        'signUpWithEmailPassword should throw an AuthException causing error not to be null',
        () async {
          final exception = AuthException('email-already-in-use');
          when(
            () => mockAuthRepository.signUpWithEmailPassword(any<SignUpDTO>()),
          ).thenThrow(exception);
          await store.signUpWithEmailPassword(mockUserData);
          expect(store.user, isNull);
          expect(store.isLoading, false);
          expect(store.error, isNotNull);
          expect(store.error, exception.message);
        },
      );

      test(
        'setProfileImage should throw an Storage exception causing error not to be null',
        () async {
          const exceptionMessage = 'Falha ao carregar imagem';
          final exception = StorageException(exceptionMessage);
          when(() => mockImageService.getImageFromCamera()).thenAnswer(
            (_) async => mockImageFile,
          );
          when(() => mockStorageRepository.uploadImage(any<StorageUploadDTO>()))
              .thenThrow(exception);
          store.user = mockUser;
          await store.setProfileImage(ImageSource.camera);
          expect(store.isLoading, false);
          expect(store.error, isNotNull);
          expect(store.error, exception.message);
        },
      );
    },
  );
}
