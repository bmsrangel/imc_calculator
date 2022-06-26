import 'package:calculadora_imc/app/shared/exceptions/api_exception.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late String message;
  late ApiException apiException;
  late Faker faker;

  setUp(
    () {
      faker = Faker();
      message = faker.lorem.sentence();
      apiException = ApiException(message);
    },
  );

  test(
    'apiException should be an instance of ApiException',
    () {
      expect(apiException, isA<ApiException>());
    },
  );

  test(
    'apiException should have a message set',
    () {
      expect(apiException.message, message);
    },
  );
}
