import 'package:calculadora_imc/app/modules/home/repositories/weather/dio_weather_repository_impl.dart';
import 'package:calculadora_imc/app/shared/exceptions/api_exception.dart';
import 'package:calculadora_imc/app/shared/models/location_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late Dio mockDio;
  late DioWeatherRepositoryImpl repository;
  late Map mockedData;
  late RequestOptions requestOptions;
  late LocationModel location;

  setUp(
    () {
      requestOptions = RequestOptions(path: '');
      mockDio = MockDio();
      repository = DioWeatherRepositoryImpl(mockDio);
      location = LocationModel(latitude: -22.875, longitude: -43);
      mockedData = {
        'elevation': 772,
        'utc_offset_seconds': 0,
        'latitude': -22.875,
        'longitude': -43,
        'current_weather': {
          'time': '2022-06-25T23:00',
          'weathercode': 3,
          'temperature': 15.1,
          'windspeed': 6.9,
          'winddirection': 276
        },
        'generationtime_ms': 0.2620220184326172
      };
    },
  );

  test(
    'getCurrentTemperature should return a double value',
    () async {
      when(
        () => mockDio.get(
          any(),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: requestOptions,
          data: mockedData,
        ),
      );
      final result = await repository.getCurrentTemperature(location);
      expect(result, 15.1);
    },
  );

  test(
    'getCurrentTemperature should throw an ApiException',
    () {
      when(
        () => mockDio.get(
          any(),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenThrow(
        DioError(requestOptions: requestOptions),
      );
      expect(
        () => repository.getCurrentTemperature(location),
        throwsA(isA<ApiException>()),
      );
    },
  );
}
