import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'modules/auth/auth_module.dart';
import 'modules/home/home_module.dart';
import 'shared/repositories/auth/auth_repository.dart';
import 'shared/repositories/auth/firebase_auth_repository_impl.dart';
import 'shared/services/current_user_service.dart';
import 'shared/services/firebase_auth_current_user_service_impl.dart';
import 'shared/stores/auth_store.dart';

class AppModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton<AuthRepository>(
      (i) => FirebaseAuthRepositoryImpl(FirebaseAuth.instance),
    ),
    Bind.lazySingleton<CurrentUserService>(
      (i) => FirebaseAuthCurrentUserServiceImpl(FirebaseAuth.instance),
    ),
    Bind.lazySingleton(
      (i) => AuthStore(
        i<AuthRepository>(),
        i<CurrentUserService>(),
      ),
    ),
  ];

  @override
  final List<ModularRoute> routes = [
    ModuleRoute(Modular.initialRoute, module: HomeModule()),
    ModuleRoute('/auth', module: AuthModule()),
  ];
}
