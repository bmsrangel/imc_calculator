import 'package:dio/dio.dart';

import '../../../../shared/exceptions/api_exception.dart';
import '../../../../shared/models/location_model.dart';
import 'weather_repository.dart';

class DioWeatherRepositoryImpl implements WeatherRepository {
  DioWeatherRepositoryImpl(this._client);

  final Dio _client;

  @override
  Future<double> getCurrentTemperature(LocationModel currentLocation) async {
    try {
      final response = await _client.get(
        '/forecast',
        queryParameters: {
          'current_weather': true,
          ...currentLocation.toMap(),
        },
      );
      final responseData = response.data;
      return responseData['current_weather']['temperature'] as double;
    } on DioError catch (e) {
      throw ApiException(e.message);
    }
  }
}
