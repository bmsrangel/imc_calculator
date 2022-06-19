import 'dart:async';

import 'package:calculadora_imc/app/shared/services/location/location_service.dart';
import 'package:flutter_modular/flutter_modular.dart';

class LocationGuard extends RouteGuard {
  @override
  FutureOr<bool> canActivate(String path, ParallelRoute route) async {
    final locationService = Modular.get<LocationService>();
    await locationService.isLocationEnabled();
    await locationService.isPermissionGranted();
    return true;
  }
}
