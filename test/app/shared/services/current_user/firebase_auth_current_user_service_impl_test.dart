import 'package:calculadora_imc/app/shared/models/user_model.dart';
import 'package:calculadora_imc/app/shared/services/current_user/firebase_auth_current_user_service_impl.dart';
import 'package:faker/faker.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late MockFirebaseAuth mockFirebaseAuth;
  late FirebaseAuthCurrentUserServiceImpl service;
  late Faker faker;
  late String id;
  late String displayName;
  late String email;

  setUp(
    () {
      faker = Faker();
      id = faker.guid.guid();
      displayName = faker.person.name();
      email = faker.internet.email();
    },
  );

  group(
    'User already logged',
    () {
      setUp(
        () {
          mockFirebaseAuth = MockFirebaseAuth(
            signedIn: true,
            mockUser: MockUser(
              uid: id,
              displayName: displayName,
              email: email,
            ),
          );
          service = FirebaseAuthCurrentUserServiceImpl(mockFirebaseAuth);
        },
      );
      test(
        'getCurrentUser should return an UserModel instance if currentUser is not null',
        () async {
          final user = await service.getCurrentUser();
          expect(user, isNotNull);
          expect(user, isA<UserModel>());
          expect(user!.id, id);
          expect(user.displayName, displayName);
          expect(user.email, email);
        },
      );
    },
  );

  group(
    'User not logged',
    () {
      setUp(
        () {
          mockFirebaseAuth = MockFirebaseAuth();
          service = FirebaseAuthCurrentUserServiceImpl(mockFirebaseAuth);
        },
      );

      test(
        'getCurrentUser should return null if user is not logged',
        () async {
          final userModel = await service.getCurrentUser();
          expect(userModel, isNull);
        },
      );
    },
  );
}
