import 'dart:convert';

import 'package:calculadora_imc/app/shared/dtos/sign_up_dto.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late String displayName;
  late String email;
  late String password;

  late SignUpDTO signUpDTO;
  late Map<String, dynamic> mockedMap;

  late Faker faker;

  setUp(
    () {
      faker = Faker();
      displayName = faker.person.name();
      email = faker.internet.email();
      password = faker.internet.password();

      signUpDTO = SignUpDTO(
        displayName: displayName,
        email: email,
        password: password,
      );
      mockedMap = {
        'displayName': displayName,
        'email': email,
        'password': password,
      };
    },
  );

  test(
    'Should return a SignUpDTO instance',
    () {
      expect(signUpDTO, isA<SignUpDTO>());
    },
  );

  test(
    'signUpDTO should have attributes set as the setup variables',
    () {
      expect(signUpDTO.displayName, displayName);
      expect(signUpDTO.email, email);
      expect(signUpDTO.password, password);
    },
  );

  test(
    'signUpDTO.toMap() should return a Map instance with proper keys and values',
    () {
      final result = signUpDTO.toMap();
      expect(result, isA<Map<String, dynamic>>());
      expect(result, mockedMap);
    },
  );

  test(
    'SignUpDTO.fromMap() should return an instance of SignUpDTO with attributes set',
    () {
      final result = SignUpDTO.fromMap(mockedMap);
      expect(result, isA<SignUpDTO>());
      expect(result.displayName, displayName);
      expect(result.email, email);
      expect(result.password, password);
    },
  );

  test(
    'signUpDTO.toJson() should return a JSON string with proper attributes',
    () {
      final result = signUpDTO.toJson();
      final expectedResult = jsonEncode(mockedMap);
      expect(result, isA<String>());
      expect(result, expectedResult);
    },
  );

  test(
      'SignUpDTO.fromJson() should return an instance of SignUpDTO with proper attributes set',
      () {
    final json = jsonEncode(mockedMap);
    final result = SignUpDTO.fromJson(json);
    expect(result, isA<SignUpDTO>());
    expect(result.displayName, displayName);
    expect(result.email, email);
    expect(result.password, password);
  });
}
