import 'package:calculadora_imc/app/app_module.dart';
import 'package:calculadora_imc/app/modules/home/guards/module_ready_guard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:modular_test/modular_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late ModuleReadyGuard guard;
  late MockFirebaseAuth mockFirebaseAuth;
  late MockFirebaseStorage mockFirebaseStorage;
  late MockSharedPreferences mockSharedPreferences;

  setUpAll(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      mockFirebaseAuth = MockFirebaseAuth();
      mockFirebaseStorage = MockFirebaseStorage();
      mockSharedPreferences = MockSharedPreferences();
      guard = ModuleReadyGuard();
      initModule(AppModule(), replaceBinds: [
        Bind.instance<FirebaseAuth>(mockFirebaseAuth),
        Bind.instance<FirebaseStorage>(mockFirebaseStorage),
        AsyncBind<SharedPreferences>((i) async => mockSharedPreferences),
      ]);
    },
  );

  test('canActivate should return true when executed', () async {
    final result = await guard.canActivate('/', ParallelRoute(name: '/'));
    expect(result, true);
  });
}
