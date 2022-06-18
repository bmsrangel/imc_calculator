import 'dart:async';

import 'package:flutter_modular/flutter_modular.dart';

import '../../../app_module.dart';

class ModuleReadyGuard extends RouteGuard {
  @override
  FutureOr<bool> canActivate(String path, ParallelRoute route) async {
    await Modular.isModuleReady<AppModule>();
    return true;
  }
}
