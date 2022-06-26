import 'package:calculadora_imc/app/app_module.dart';
import 'package:calculadora_imc/app/modules/home/home_module.dart';
import 'package:calculadora_imc/app/modules/home/pages/profile_page.dart';
import 'package:calculadora_imc/app/modules/home/repositories/weather/weather_repository.dart';
import 'package:calculadora_imc/app/modules/home/services/history_local_storage/history_local_storage_service.dart';
import 'package:calculadora_imc/app/shared/models/user_model.dart';
import 'package:calculadora_imc/app/shared/repositories/auth/auth_repository.dart';
import 'package:calculadora_imc/app/shared/repositories/storage/storage_repository.dart';
import 'package:calculadora_imc/app/shared/services/current_user/current_user_service.dart';
import 'package:calculadora_imc/app/shared/services/image/image_service.dart';
import 'package:calculadora_imc/app/shared/services/location/location_service.dart';
import 'package:calculadora_imc/app/shared/stores/auth_store.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:modular_test/modular_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../mocks.dart';

void main() {
  // AppModule binds
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

  // HomeModule binds
  late MockDio mockDio;
  late MockWeatherRepository mockWeatherRepository;
  late MockHistoryLocalStorageService mockHistoryLocalStorageService;

  late MockAuthStore mockAuthStore;

  late Widget widget;

  late UserModel mockUserModel;

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
      mockDio = MockDio();
      mockWeatherRepository = MockWeatherRepository();
      mockHistoryLocalStorageService = MockHistoryLocalStorageService();
      mockAuthStore = MockAuthStore();

      initModules([
        AppModule(),
        HomeModule(),
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
        Bind.instance<Dio>(mockDio),
        Bind.instance<WeatherRepository>(mockWeatherRepository),
        Bind.instance<HistoryLocalStorageService>(
          mockHistoryLocalStorageService,
        ),
        Bind.instance<AuthStore>(mockAuthStore),
      ]);

      widget = const MaterialApp(
        home: ProfilePage(),
      );

      mockUserModel = UserModel(
        id: 'any',
        displayName: 'John Doe',
        email: 'jdoe@email.com',
        profileUrl: null,
      );
    },
  );
  testWidgets('Initial state ProfilePage test', (tester) async {
    when(() => mockAuthStore.user).thenReturn(mockUserModel);

    await tester.pumpWidget(widget);

    var widgetFinder = find.byType(CircleAvatar);
    expect(widgetFinder, findsOneWidget);
    widgetFinder = find.byType(TextButton);
    expect(widgetFinder, findsOneWidget);
    widgetFinder = find.text('Alterar imagem');
    expect(widgetFinder, findsOneWidget);
    widgetFinder = find.text(mockUserModel.displayName);
    expect(widgetFinder, findsOneWidget);
    widgetFinder = find.text(mockUserModel.email);
    expect(widgetFinder, findsOneWidget);
    widgetFinder = find.byType(ElevatedButton);
    expect(widgetFinder, findsOneWidget);
  });

  testWidgets('Set image pressed ProfilePage test', (tester) async {
    when(() => mockAuthStore.user).thenReturn(mockUserModel);

    await tester.pumpWidget(widget);

    var widgetFinder = find.byType(TextButton);
    expect(widgetFinder, findsOneWidget);
    await tester.tap(widgetFinder);
    await tester.pump();
    widgetFinder = find.byType(BottomSheet);
    expect(widgetFinder, findsWidgets);
  });
}
