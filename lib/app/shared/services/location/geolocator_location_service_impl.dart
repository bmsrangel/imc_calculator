import 'package:calculadora_imc/app/shared/models/location_model.dart';
import 'package:calculadora_imc/app/shared/services/location/location_service.dart';
import 'package:geolocator/geolocator.dart';

class GeolocatorLocationServiceImpl implements LocationService {
  GeolocatorLocationServiceImpl(this._geolocator);

  final GeolocatorPlatform _geolocator;

  @override
  Future<LocationModel> getCurrentLocation() async {
    final location = await _geolocator.getCurrentPosition();
    return LocationModel(
      latitude: location.latitude,
      longitude: location.longitude,
    );
  }

  @override
  Future<bool> isLocationEnabled() async {
    final isLocationEnabled = await _geolocator.isLocationServiceEnabled();
    return isLocationEnabled;
  }

  @override
  Future<bool> isPermissionGranted() async {
    final permission = await _geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      await _geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever ||
        permission == LocationPermission.unableToDetermine) {
      return false;
    } else {
      return true;
    }
  }
}
