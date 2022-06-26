import 'package:calculadora_imc/app/modules/auth/auth_module.dart';
import 'package:calculadora_imc/app/modules/auth/stores/obscure_text_store.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:modular_test/modular_test.dart';

void main() {
  late ObscureTextStore store;

  setUp(
    () {
      initModule(AuthModule());
      store = Modular.get<ObscureTextStore>();
    },
  );

  test(
    'store should be an instance of ObscureTextStore',
    () {
      expect(store, isA<ObscureTextStore>());
    },
  );
}
