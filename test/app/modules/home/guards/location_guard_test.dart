import 'package:calculadora_imc/app/app_module.dart';
import 'package:calculadora_imc/app/modules/home/guards/location_guard.dart';
import 'package:calculadora_imc/app/shared/services/location/location_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:modular_test/modular_test.dart';

class MockLocationService extends Mock implements LocationService {}

void main() {
  late LocationGuard guard;
  late MockFirebaseAuth mockFirebaseAuth;
  late MockFirebaseStorage mockFirebaseStorage;
  late LocationService mockLocationService;

  setUpAll(
    () async {
      mockFirebaseAuth = MockFirebaseAuth();
      mockFirebaseStorage = MockFirebaseStorage();
      guard = LocationGuard();
      mockLocationService = MockLocationService();
      initModule(AppModule(), replaceBinds: [
        Bind.instance<FirebaseAuth>(mockFirebaseAuth),
        Bind.instance<FirebaseStorage>(mockFirebaseStorage),
        Bind.instance<LocationService>(mockLocationService),
      ]);
    },
  );

  test('Should return true when executed', () async {
    when(() => mockLocationService.isLocationEnabled()).thenAnswer(
      (_) async => true,
    );
    when(() => mockLocationService.isPermissionGranted()).thenAnswer(
      (_) async => true,
    );
    final result = await guard.canActivate('/', ParallelRoute(name: '/'));
    expect(result, true);
  });
}
