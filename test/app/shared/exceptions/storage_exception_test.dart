import 'package:calculadora_imc/app/shared/exceptions/storage_exception.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late String message;
  late StorageException storageException;
  late Faker faker;

  setUp(
    () {
      faker = Faker();
      message = faker.lorem.sentence();
      storageException = StorageException(message);
    },
  );

  test(
    'storageException should be an instance of StorageException',
    () {
      expect(storageException, isA<StorageException>());
    },
  );

  test(
    'storageException should have a message set',
    () {
      expect(storageException.message, message);
    },
  );
}
