import 'dart:convert';

import 'package:calculadora_imc/app/shared/models/location_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late LocationModel locationModel;
  late double latitude;
  late double longitude;
  late Map<String, dynamic> mockedMap;

  setUpAll(
    () {
      latitude = -22.9014599;
      longitude = -43.0961335;
      locationModel = LocationModel(
        latitude: latitude,
        longitude: longitude,
      );
      mockedMap = {
        'latitude': latitude,
        'longitude': longitude,
      };
    },
  );

  test(
    'locationModel should be an instance of LocationModel',
    () {
      expect(locationModel, isA<LocationModel>());
    },
  );

  test(
    'locationModel attributes should match values above',
    () {
      expect(locationModel.latitude, latitude);
      expect(locationModel.longitude, longitude);
    },
  );

  test(
    'locationModel.toMap() should return a Map with proper keys and values',
    () {
      final locationModelMap = locationModel.toMap();
      expect(locationModelMap, mockedMap);
    },
  );

  test(
    'LocationModel.fromMap() should return an instance of LocationModel with proper parameters',
    () {
      final result = LocationModel.fromMap(mockedMap);

      expect(result, isA<LocationModel>());
      expect(result.latitude, latitude);
      expect(result.longitude, longitude);
    },
  );

  test(
    'LocationModel.fromJson() should return an instance of LocationModel from a JSON string',
    () {
      final mockedJson = jsonEncode(mockedMap);
      final expectedResult = LocationModel.fromJson(mockedJson);
      expect(expectedResult, isA<LocationModel>());
      expect(expectedResult.latitude, locationModel.latitude);
      expect(expectedResult.longitude, locationModel.longitude);
    },
  );

  test(
    'LocationModel.toJson() should return a String',
    () {
      final mockedJson = jsonEncode(mockedMap);
      final expectedResult = locationModel.toJson();
      expect(expectedResult, isA<String>());
      expect(expectedResult, mockedJson);
    },
  );
}
