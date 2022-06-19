import 'dart:async';

import 'package:flutter_modular/flutter_modular.dart';

import '../../../shared/services/location/location_service.dart';

class LocationGuard extends RouteGuard {
  @override
  FutureOr<bool> canActivate(String path, ParallelRoute route) async {
    final locationService = Modular.get<LocationService>();
    await locationService.isLocationEnabled();
    await locationService.isPermissionGranted();
    return true;
  }
}
