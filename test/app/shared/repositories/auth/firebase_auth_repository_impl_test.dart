import 'package:calculadora_imc/app/shared/dtos/sign_up_dto.dart';
import 'package:calculadora_imc/app/shared/exceptions/auth_exception.dart';
import 'package:calculadora_imc/app/shared/models/user_model.dart';
import 'package:calculadora_imc/app/shared/repositories/auth/auth_repository.dart';
import 'package:calculadora_imc/app/shared/repositories/auth/firebase_auth_repository_impl.dart';
import 'package:faker/faker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MocktailFirebaseAuth extends Mock implements FirebaseAuth {}

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
      test(
        'setProfileURL should throw no exceptions',
        () async {
          final newProfileURL = faker.image.image(width: 200, height: 200);
          await repository.setProfileURL(newProfileURL);
          expect(mockFirebaseAuth.currentUser?.photoURL, isNull);
        },
      );

      test('resetPassword should throw no exceptions', () async {
        final mocktailFirebaseAuth = MocktailFirebaseAuth();
        repository = FirebaseAuthRepositoryImpl(mocktailFirebaseAuth);
        when(() => mocktailFirebaseAuth.sendPasswordResetEmail(
            email: any<String>(named: 'email'))).thenAnswer(
          (_) async => () {},
        );
        await repository.resetPassword('any');
        verify(() => mocktailFirebaseAuth.sendPasswordResetEmail(
            email: any<String>(named: 'email'))).called(1);
      });
    },
  );

  group(
    'Exceptions tests',
    () {
      group(
        'With MockFirebaseAuth mocks',
        () {
          setUp(
            () {
              mockFirebaseAuth = MockFirebaseAuth(
                authExceptions: AuthExceptions(
                  signInWithEmailAndPassword:
                      FirebaseAuthException(code: 'user-not-found'),
                  createUserWithEmailAndPassword: FirebaseAuthException(
                    code: 'email-already-in-use',
                  ),
                ),
              );
              repository = FirebaseAuthRepositoryImpl(mockFirebaseAuth);
            },
          );

          test(
            'loginWithEmailPassword should throw an AuthException with code user-not-found',
            () {
              expect(
                () => repository.loginWithEmailPassword('any', 'any'),
                throwsA(isA<AuthException>()),
              );
              expect(
                () => repository.loginWithEmailPassword('any', 'any'),
                throwsA(
                  predicate((e) =>
                      e is AuthException && e.errorCode == 'user-not-found'),
                ),
              );
            },
          );
          test(
            'signUpWithEmailPassword should throw an AuthException with code email-already-in-use',
            () {
              final userData = SignUpDTO(
                displayName: 'any',
                email: 'any',
                password: 'any',
              );
              expect(
                () => repository.signUpWithEmailPassword(userData),
                throwsA(
                  predicate((e) =>
                      e is AuthException &&
                      e.errorCode == 'email-already-in-use'),
                ),
              );
            },
          );
        },
      );

      group(
        'With MocktailFirebaseAuth mocks',
        () {
          late MocktailFirebaseAuth mocktailFirebaseAuth;
          setUp(
            () {
              mocktailFirebaseAuth = MocktailFirebaseAuth();
              repository = FirebaseAuthRepositoryImpl(mocktailFirebaseAuth);
            },
          );

          test(
            'resetPassword should throw an AuthException',
            () {
              when(
                () => mocktailFirebaseAuth.sendPasswordResetEmail(
                  email: any(named: 'email'),
                ),
              ).thenThrow(
                FirebaseAuthException(code: 'user-not-found'),
              );
              expect(
                () => repository.resetPassword('any'),
                throwsA(
                  predicate((e) =>
                      e is AuthException && e.errorCode == 'user-not-found'),
                ),
              );
            },
          );

          test(
            'setProfileUrl should throw an AuthException',
            () {
              when(
                () => mocktailFirebaseAuth.currentUser?.updatePhotoURL(
                  any(named: 'url'),
                ),
              ).thenThrow(
                FirebaseAuthException(code: 'user-not-found'),
              );
              expect(
                () => repository.setProfileURL('any'),
                throwsA(
                  predicate((e) =>
                      e is AuthException && e.errorCode == 'user-not-found'),
                ),
              );
            },
          );
        },
      );
    },
  );
}
