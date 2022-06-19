import 'package:calculadora_imc/app/shared/models/location_model.dart';

abstract class WeatherRepository {
  Future<double> getCurrentTemperature(LocationModel currentLocation);
}
