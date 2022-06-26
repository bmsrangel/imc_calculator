import 'package:calculadora_imc/app/app_module.dart';
import 'package:calculadora_imc/app/shared/repositories/auth/auth_repository.dart';
import 'package:calculadora_imc/app/shared/repositories/storage/storage_repository.dart';
import 'package:calculadora_imc/app/shared/services/current_user/current_user_service.dart';
import 'package:calculadora_imc/app/shared/services/image/image_service.dart';
import 'package:calculadora_imc/app/shared/services/location/location_service.dart';
import 'package:calculadora_imc/app/shared/stores/auth_store.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modular_test/modular_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../mocks.dart';

void main() {
  late MockFirebaseAuth mockFirebaseAuth;
  late MockFirebaseStorage mockFirebaseStorage;
  late MockSharedPreferences mockSharedPreferences;
  late MockImagePicker mockImagePicker;
  late MockGeolocatorPlatform mockGeolocatorPlatform;

  late MockAuthRepository mockAuthRepository;
  late MockStorageRepository mockStorageRepository;

  late MockCurrentUserService mockCurrentUserService;
  late MockImageService mockImageService;
  late MockLocationService mockLocationService;

  setUp(
    () async {
      mockFirebaseAuth = MockFirebaseAuth();
      mockFirebaseStorage = MockFirebaseStorage();
      mockSharedPreferences = MockSharedPreferences();
      mockImagePicker = MockImagePicker();
      mockGeolocatorPlatform = MockGeolocatorPlatform();
      mockAuthRepository = MockAuthRepository();
      mockStorageRepository = MockStorageRepository();
      mockCurrentUserService = MockCurrentUserService();
      mockImageService = MockImageService();
      mockLocationService = MockLocationService();

      initModule(
        AppModule(),
        replaceBinds: [
          Bind.instance<FirebaseAuth>(mockFirebaseAuth),
          Bind.instance<FirebaseStorage>(mockFirebaseStorage),
          AsyncBind<SharedPreferences>((i) async => mockSharedPreferences),
          Bind.instance<ImagePicker>(mockImagePicker),
          Bind.instance<GeolocatorPlatform>(mockGeolocatorPlatform),
          Bind.instance<AuthRepository>(mockAuthRepository),
          Bind.instance<StorageRepository>(mockStorageRepository),
          Bind.instance<CurrentUserService>(mockCurrentUserService),
          Bind.instance<ImageService>(mockImageService),
          Bind.instance<LocationService>(mockLocationService),
        ],
      );
    },
  );

  test(
    'should retrieve an instance of MockFirebaseAuth',
    () {
      final instance = Modular.get<FirebaseAuth>();
      expect(instance, isA<MockFirebaseAuth>());
    },
  );

  test(
    'should retrieve an instance of MockFirebaseStorage',
    () {
      final instance = Modular.get<FirebaseStorage>();
      expect(instance, isA<MockFirebaseStorage>());
    },
  );

  test(
    'should retrieve an instance of MockSharedPreferences',
    () async {
      await Modular.isModuleReady<AppModule>();
      final instance = Modular.get<SharedPreferences>();
      expect(instance, isA<MockSharedPreferences>());
    },
  );

  test(
    'should retrieve an instance of MockImagePicker',
    () {
      final instance = Modular.get<ImagePicker>();
      expect(instance, isA<MockImagePicker>());
    },
  );

  test(
    'should retrieve an instance of MockGeolocatorPlatform',
    () {
      final instance = Modular.get<GeolocatorPlatform>();
      expect(instance, isA<MockGeolocatorPlatform>());
    },
  );

  test(
    'should retrieve an instance of MockAuthRepository',
    () {
      final instance = Modular.get<AuthRepository>();
      expect(instance, isA<MockAuthRepository>());
    },
  );

  test(
    'should retrieve an instance of MockStorageRepository',
    () {
      final instance = Modular.get<StorageRepository>();
      expect(instance, isA<MockStorageRepository>());
    },
  );

  test(
    'should retrieve an instance of CurrentUserService',
    () {
      final instance = Modular.get<CurrentUserService>();
      expect(instance, isA<MockCurrentUserService>());
    },
  );

  test(
    'should retrieve an instance of ImageService',
    () {
      final instance = Modular.get<ImageService>();
      expect(instance, isA<MockImageService>());
    },
  );
  test(
    'should retrieve an instance of LocationService',
    () {
      final instance = Modular.get<LocationService>();
      expect(instance, isA<MockLocationService>());
    },
  );

  test('authStore should be an instance of AuthStore', () {
    final authStore = Modular.get<AuthStore>();
    expect(authStore, isA<AuthStore>());
  });
}
