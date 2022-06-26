import 'package:calculadora_imc/app/modules/home/repositories/weather/weather_repository.dart';
import 'package:calculadora_imc/app/modules/home/stores/weather_store.dart';
import 'package:calculadora_imc/app/shared/exceptions/api_exception.dart';
import 'package:calculadora_imc/app/shared/models/location_model.dart';
import 'package:calculadora_imc/app/shared/services/location/location_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockWeatherRepository extends Mock implements WeatherRepository {}

class MockLocationService extends Mock implements LocationService {}

void main() {
  late MockWeatherRepository repository;
  late MockLocationService service;
  late WeatherStore store;
  late LocationModel currentLocation;

  setUp(
    () {
      repository = MockWeatherRepository();
      service = MockLocationService();
      store = WeatherStore(repository, service);
      currentLocation = LocationModel(
        latitude: -22.3,
        longitude: -43.0,
      );
    },
  );

  test(
    'Initial values for isLoading should false, currentTemperature and error should be null',
    () {
      expect(store.isLoading, false);
      expect(store.currentTemperature, isNull);
      expect(store.error, isNull);
    },
  );

  test(
    'getCurrentTemperature should set currentTemperature value properly',
    () async {
      when(
        () => service.getCurrentLocation(),
      ).thenAnswer(
        (_) async => currentLocation,
      );
      when(
        () => repository.getCurrentTemperature(currentLocation),
      ).thenAnswer(
        (_) async => 15.1,
      );

      await store.getCurrentTemperature();
      expect(store.currentTemperature, 15.1);
    },
  );

  test(
    'getCurrentTemperature should set error to a proper value',
    () async {
      const errorMessage = 'Erro de conexão';
      when(
        () => service.getCurrentLocation(),
      ).thenAnswer(
        (_) async => currentLocation,
      );
      when(() => repository.getCurrentTemperature(currentLocation)).thenThrow(
        ApiException(errorMessage),
      );

      await store.getCurrentTemperature();
      expect(store.error, isNotNull);
      expect(store.error, errorMessage);
    },
  );
}
