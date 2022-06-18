import 'package:firebase_auth/firebase_auth.dart';

import '../../dtos/sign_up_dto.dart';
import '../../exceptions/auth_exception.dart';
import '../../models/user_model.dart';
import 'auth_repository.dart';

class FirebaseAuthRepositoryImpl implements AuthRepository {
  FirebaseAuthRepositoryImpl(this._firebaseAuth);

  final FirebaseAuth _firebaseAuth;

  @override
  Future<UserModel> loginWithEmailPassword(
    String email,
    String password,
  ) async {
    try {
      final credentials = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credentials.user;
      final userModel = UserModel(
        id: user!.uid,
        displayName: user.displayName!,
        email: user.email!,
        profileUrl: user.photoURL,
      );
      return userModel;
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.code);
    }
  }

  @override
  Future<UserModel> signUpWithEmailPassword(SignUpDTO userData) async {
    try {
      final credentials = await _firebaseAuth.createUserWithEmailAndPassword(
        email: userData.email,
        password: userData.password,
      );
      final user = credentials.user;
      await user!.updateDisplayName(userData.displayName);
      final UserCredential updatedUserCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: userData.email,
        password: userData.password,
      );
      final updatedUser = updatedUserCredential.user!;
      final userModel = UserModel(
        id: updatedUser.uid,
        displayName: updatedUser.displayName!,
        email: updatedUser.email!,
        profileUrl: updatedUser.photoURL,
      );
      return userModel;
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.code);
    }
  }

  @override
  Future<void> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.code);
    }
  }

  @override
  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  @override
  Future<void> setProfileURL(String profileUrl) async {
    try {
      await _firebaseAuth.currentUser?.updatePhotoURL(profileUrl);
      await _firebaseAuth.currentUser?.reload();
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.code);
    }
  }
}
