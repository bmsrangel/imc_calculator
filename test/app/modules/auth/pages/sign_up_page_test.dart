import 'package:calculadora_imc/app/app_module.dart';
import 'package:calculadora_imc/app/modules/auth/auth_module.dart';
import 'package:calculadora_imc/app/modules/auth/pages/sign_up_page.dart';
import 'package:calculadora_imc/app/shared/repositories/auth/auth_repository.dart';
import 'package:calculadora_imc/app/shared/repositories/storage/storage_repository.dart';
import 'package:calculadora_imc/app/shared/services/current_user/current_user_service.dart';
import 'package:calculadora_imc/app/shared/services/image/image_service.dart';
import 'package:calculadora_imc/app/shared/services/location/location_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modular_test/modular_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../mocks.dart';

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
    () {
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
      initModules([
        AppModule(),
        AuthModule(),
      ], replaceBinds: [
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
      ]);
    },
  );
  testWidgets('SignUpPage test', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: SignUpPage(),
      ),
    );

    final titleFinder = find.text('Criar Conta');
    expect(titleFinder, findsOneWidget);
  });
}
