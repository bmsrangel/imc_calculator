import 'package:calculadora_imc/app/shared/models/location_model.dart';

abstract class LocationService {
  Future<bool> isLocationEnabled();
  Future<bool> isPermissionGranted();
  Future<LocationModel> getCurrentLocation();
}
