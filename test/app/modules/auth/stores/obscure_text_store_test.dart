import 'package:calculadora_imc/app/modules/auth/stores/obscure_text_store.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late ObscureTextStore store;

  setUp(
    () {
      store = ObscureTextStore();
    },
  );

  test(
    'Initial value for obscureText should be true',
    () {
      expect(store.obscureText, isA<bool>());
      expect(store.obscureText, true);
    },
  );

  test(
    'toggleObscureText should invert obscureText current value',
    () {
      expect(store.obscureText, true);
      store.toggleObscureText();
      expect(store.obscureText, false);
      store.toggleObscureText();
      expect(store.obscureText, true);
    },
  );
}
