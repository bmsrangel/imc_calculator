import 'package:calculadora_imc/app/shared/exceptions/auth_exception.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late String message;
  late AuthException authException;
  setUp(
    () {
      message = 'A senha é inválida ou o usuário não possui uma senha.';
      authException = AuthException('wrong-password');
    },
  );

  test(
    'authException should be an instance of AuthException',
    () {
      expect(authException, isA<AuthException>());
    },
  );

  test(
    'authException should a message depending on the error code provided in constructor',
    () {
      expect(authException.message, message);
    },
  );

  test(
    'Should return another message when error code is "user-not-found"',
    () {
      message =
          'Não há registro de usuário correspondente à este identificador. O usuário pode ter sido excluído.';
      authException = AuthException('user-not-found');
      expect(authException, isA<AuthException>());
      expect(authException.message, message);
    },
  );

  test(
    'Should return another message when error code is "email-already-in-use"',
    () {
      message = 'O e-mail informado já está em uso por outra conta';
      authException = AuthException('email-already-in-use');
      expect(authException, isA<AuthException>());
      expect(authException.message, message);
    },
  );
}
