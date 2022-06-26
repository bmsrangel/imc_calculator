import 'package:calculadora_imc/app/app_module.dart';
import 'package:calculadora_imc/app/modules/home/guards/auth_guard.dart';
import 'package:calculadora_imc/app/shared/models/user_model.dart';
import 'package:calculadora_imc/app/shared/stores/auth_store.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:modular_test/modular_test.dart';

class MockAuthStore extends Mock implements AuthStore {}

void main() {
  late AuthGuard guard;
  late MockFirebaseAuth mockFirebaseAuth;
  late MockFirebaseStorage mockFirebaseStorage;
  late MockAuthStore mockAuthStore;

  setUpAll(
    () async {
      mockFirebaseAuth = MockFirebaseAuth();
      mockFirebaseStorage = MockFirebaseStorage();
      guard = AuthGuard();
      mockAuthStore = MockAuthStore();
      initModule(AppModule(), replaceBinds: [
        Bind.instance(mockFirebaseAuth),
        Bind.instance(mockFirebaseStorage),
        Bind.instance<AuthStore>(mockAuthStore),
      ]);
    },
  );

  test(
    'Should return true if user is logged',
    () async {
      when(() => mockAuthStore.getCurrentUser()).thenAnswer(
        (_) async => () => {},
      );
      when(() => mockAuthStore.user).thenReturn(UserModel(
        id: 'any',
        displayName: 'any',
        email: 'any',
        profileUrl: null,
      ));
      final canActivate = await guard.canActivate(
        '/',
        ParallelRoute(name: '/'),
      );
      expect(canActivate, true);
    },
  );
  test(
    'Should return false if user is not logged',
    () async {
      when(() => mockAuthStore.getCurrentUser()).thenAnswer(
        (_) async => () => {},
      );
      when(() => mockAuthStore.user).thenReturn(null);
      final canActivate = await guard.canActivate(
        '/',
        ParallelRoute(name: '/'),
      );
      expect(canActivate, false);
    },
  );
}
