import 'dart:async';

import 'package:calculadora_imc/app/modules/home/home_module.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ModuleReadyGuard extends RouteGuard {
  @override
  FutureOr<bool> canActivate(String path, ParallelRoute route) async {
    await Modular.isModuleReady<HomeModule>();
    return true;
  }
}
