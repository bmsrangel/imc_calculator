import 'package:flutter_modular/flutter_modular.dart';

import 'pages/login_page.dart';
import 'pages/reset_password_page.dart';
import 'pages/sign_up_page.dart';
import 'stores/obscure_text_store.dart';

class AuthModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.factory((i) => ObscureTextStore()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute, child: (_, __) => const LoginPage()),
    ChildRoute('/signup', child: (_, __) => const SignUpPage()),
    ChildRoute('/reset', child: (_, __) => const ResetPasswordPage()),
  ];
}
