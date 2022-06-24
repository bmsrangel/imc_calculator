import 'package:calculadora_imc/app/shared/dtos/sign_up_dto.dart';
import 'package:calculadora_imc/app/shared/models/user_model.dart';
import 'package:calculadora_imc/app/shared/repositories/auth/auth_repository.dart';
import 'package:calculadora_imc/app/shared/repositories/auth/firebase_auth_repository_impl.dart';
import 'package:faker/faker.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late MockFirebaseAuth mockFirebaseAuth;
  late AuthRepository repository;
  late Faker faker;

  late String id;
  late String displayName;
  late String email;
  late String profileUrl;

  group(
    'Success tests',
    () {
      setUpAll(
        () {
          faker = Faker();
          id = faker.guid.guid();
          displayName = faker.person.name();
          email = faker.internet.email();
          profileUrl = faker.image.image(width: 200, height: 200);
          mockFirebaseAuth = MockFirebaseAuth(
            mockUser: MockUser(
              uid: id,
              displayName: displayName,
              email: email,
              photoURL: profileUrl,
            ),
          );
          repository = FirebaseAuthRepositoryImpl(mockFirebaseAuth);
        },
      );

      test(
        'loginWithEmailPassword should return an UserModel instance with proper attributes set',
        () async {
          final userModel =
              await repository.loginWithEmailPassword(email, '123123');
          expect(userModel, isA<UserModel>());
          expect(userModel.id, id);
          expect(userModel.displayName, displayName);
          expect(userModel.email, email);
          expect(userModel.profileUrl, profileUrl);
        },
      );

      test(
        'signUpWithEmailPassword should return an UserModel instance with proper attributes set',
        () async {
          final newId = faker.guid.guid();
          final newDisplayName = faker.person.name();
          final newEmail = faker.internet.email();
          final password = faker.internet.password();
          final signUpDTO = SignUpDTO(
            displayName: newDisplayName,
            email: newEmail,
            password: password,
          );
          mockFirebaseAuth = MockFirebaseAuth(
            mockUser: MockUser(
              uid: newId,
              displayName: newDisplayName,
              email: newEmail,
            ),
          );
          final newUser = await repository.signUpWithEmailPassword(signUpDTO);
          expect(newUser.id, 'mock_uid');
          expect(newUser.email, newEmail);
          expect(newUser.displayName, newDisplayName);
          expect(newUser.profileUrl, null);
        },
      );
      test(
        'Logout should throw no exceptions',
        () async {
          await repository.logout();
          expect(mockFirebaseAuth.currentUser, null);
        },
      );
    },
  );
}
