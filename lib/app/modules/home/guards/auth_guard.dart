import 'dart:async';

import 'package:flutter_modular/flutter_modular.dart';

import '../../../shared/stores/auth_store.dart';

class AuthGuard extends RouteGuard {
  AuthGuard() : super(redirectTo: '/auth/');

  @override
  FutureOr<bool> canActivate(String path, ParallelRoute route) async {
    final authStore = Modular.get<AuthStore>();
    await authStore.getCurrentUser();
    if (authStore.user != null) {
      return true;
    } else {
      return false;
    }
  }
}
