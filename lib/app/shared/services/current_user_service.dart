import '../models/user_model.dart';

abstract class CurrentUserService {
  Future<UserModel?> getCurrentUser();
}
