import 'package:flutter/material.dart';

import '../../../shared/exceptions/api_exception.dart';
import '../../../shared/services/location/location_service.dart';
import '../repositories/weather/weather_repository.dart';

class WeatherStore extends ChangeNotifier {
  WeatherStore(
    this._weatherRepository,
    this._locationService,
  );

  final WeatherRepository _weatherRepository;
  final LocationService _locationService;

  var isLoading = false;
  double? currentTemperature;
  String? error;

  Future<void> getCurrentTemperature() async {
    final currentLocation = await _locationService.getCurrentLocation();
    try {
      isLoading = true;
      notifyListeners();
      currentTemperature =
          await _weatherRepository.getCurrentTemperature(currentLocation);
    } on ApiException catch (e) {
      error = e.message;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
