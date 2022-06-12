import 'package:firebase_auth/firebase_auth.dart';

import '../models/user_model.dart';
import 'current_user_service.dart';

class FirebaseAuthCurrentUserServiceImpl implements CurrentUserService {
  FirebaseAuthCurrentUserServiceImpl(this._firebaseAuth);

  final FirebaseAuth _firebaseAuth;

  @override
  Future<UserModel?> getCurrentUser() async {
    final currentUser = _firebaseAuth.currentUser;
    if (currentUser != null) {
      final userModel = UserModel(
        id: currentUser.uid,
        displayName: currentUser.displayName!,
        email: currentUser.email!,
        profileUrl: currentUser.photoURL,
      );
      return userModel;
    } else {
      return null;
    }
  }
}
