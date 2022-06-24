import 'dart:convert';

import 'package:calculadora_imc/app/shared/models/user_model.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late Faker faker;
  late UserModel userModel;
  late String id;
  late String displayName;
  late String email;
  late String profileUrl;
  late Map<String, dynamic> mockedMap;

  setUpAll(
    () {
      faker = Faker();
      id = faker.guid.guid();
      displayName = faker.person.name();
      email = faker.internet.email();
      profileUrl = faker.image.image(width: 200, height: 200);
      userModel = UserModel(
        id: id,
        displayName: displayName,
        email: email,
        profileUrl: profileUrl,
      );
      mockedMap = {
        'id': id,
        'displayName': displayName,
        'email': email,
        'profileUrl': profileUrl,
      };
    },
  );

  test('userModel should be an instance of UserModel', () {
    expect(userModel, isA<UserModel>());
  });

  test(
    'userModel attributes should match individual fields above',
    () {
      expect(userModel.id, id);
      expect(userModel.displayName, displayName);
      expect(userModel.email, email);
      expect(userModel.profileUrl, profileUrl);
    },
  );

  test(
    'UserModel.fromMap() should return an instance of UserModel with proper attributes set',
    () {
      final expectedResult = UserModel.fromMap(mockedMap);
      expect(expectedResult, isA<UserModel>());
      expect(expectedResult.id, id);
      expect(expectedResult.displayName, displayName);
      expect(expectedResult.email, email);
      expect(expectedResult.profileUrl, profileUrl);
    },
  );

  test(
    'UserModel.toMap() should return a Map instance with proper key and values set',
    () {
      final expectedResult = userModel.toMap();
      expect(expectedResult, isA<Map<String, dynamic>>());
      expect(expectedResult, mockedMap);
    },
  );

  test(
    'UserModel.fromJson() should return an instance of UserModel with attributes set',
    () {
      final mockedJsonString = jsonEncode(mockedMap);
      final expectedResult = UserModel.fromJson(mockedJsonString);
      expect(expectedResult, isA<UserModel>());
      expect(expectedResult.id, id);
      expect(expectedResult.displayName, displayName);
      expect(expectedResult.email, email);
      expect(expectedResult.profileUrl, profileUrl);
    },
  );

  test('UserModel.toJson() should return a JSON string with proper attributes',
      () {
    final expectedResult = userModel.toJson();
    final match = jsonEncode(mockedMap);
    expect(expectedResult, isA<String>());
    expect(expectedResult, match);
  });

  test(
    'Method copyWith should return an instance with unmodified attributes when nothis is passed',
    () {
      userModel = userModel.copyWith();
      expect(userModel, isA<UserModel>());
      expect(userModel.id, id);
      expect(userModel.displayName, displayName);
      expect(userModel.email, email);
      expect(userModel.profileUrl, profileUrl);
    },
  );

  test(
    'Method copyWith should return a new instance with new attribute adjusted',
    () {
      final newId = faker.guid.guid();
      final newDisplayName = faker.person.name();
      final newEmail = faker.internet.email();
      final newProfileUrl = faker.image.image(width: 200, height: 200);

      userModel = userModel.copyWith(
        id: newId,
        displayName: newDisplayName,
        email: newEmail,
        profileUrl: newProfileUrl,
      );

      expect(userModel, isA<UserModel>());
      expect(userModel.id, newId);
      expect(userModel.displayName, newDisplayName);
      expect(userModel.email, newEmail);
      expect(userModel.profileUrl, newProfileUrl);
    },
  );
}
