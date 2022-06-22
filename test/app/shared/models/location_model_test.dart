import 'package:calculadora_imc/app/shared/models/location_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late LocationModel locationModel;
  late double latitude;
  late double longitude;

  setUpAll(
    () {
      latitude = -22.9014599;
      longitude = -43.0961335;
      locationModel = LocationModel(
        latitude: latitude,
        longitude: longitude,
      );
    },
  );

  test(
    'locationModel should be an instance of LocationModel',
    () {
      expect(locationModel, isA<LocationModel>());
    },
  );

  test(
    'locationModel attributes should match values abote',
    () {
      expect(locationModel.latitude, latitude);
      expect(locationModel.longitude, longitude);
    },
  );

  test(
    'locationModel.toMap() should return a Map with proper keys and values',
    () {
      final expectedMap = {
        'latitude': latitude,
        'longitude': longitude,
      };

      final locationModelMap = locationModel.toMap();
      expect(locationModelMap, expectedMap);
    },
  );

  test(
    'LocationModel.fromMap() should return an instance of LocationModel with proper parameters',
    () {
      final mockedMap = {
        'latitude': latitude,
        'longitude': longitude,
      };
      final result = LocationModel.fromMap(mockedMap);

      expect(result, isA<LocationModel>());
      expect(result.latitude, latitude);
      expect(result.longitude, longitude);
    },
  );

  // TODO: write tests for fromJson & toJson
}
