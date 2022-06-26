import 'package:calculadora_imc/app/shared/models/location_model.dart';
import 'package:calculadora_imc/app/shared/services/location/geolocator_location_service_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mocktail/mocktail.dart';

class MockGeolocatorPlatform extends Mock implements GeolocatorPlatform {}

void main() {
  late GeolocatorPlatform mockGeolocator;
  late GeolocatorLocationServiceImpl service;
  late double latitude;
  late double longitude;
  late DateTime timestamp;
  late double accuracy;
  late double altitude;
  late double heading;
  late double speed;
  late double speedAccuracy;

  setUp(
    () {
      mockGeolocator = MockGeolocatorPlatform();
      service = GeolocatorLocationServiceImpl(mockGeolocator);
      latitude = -22.9014599;
      longitude = -43.1068623;
      timestamp = DateTime.now();
      accuracy = 0.0;
      altitude = 10.0;
      heading = 90.0;
      speed = 0.0;
      speedAccuracy = 0.0;
    },
  );

  test(
    'getCurrentLocation should return an instance of LocationModel',
    () async {
      when(() => mockGeolocator.getCurrentPosition()).thenAnswer(
        (_) async => Position(
          longitude: longitude,
          latitude: latitude,
          timestamp: timestamp,
          accuracy: accuracy,
          altitude: altitude,
          heading: heading,
          speed: speed,
          speedAccuracy: speedAccuracy,
        ),
      );
      final location = await service.getCurrentLocation();
      expect(location, isA<LocationModel>());
      expect(location.latitude, latitude);
      expect(location.longitude, longitude);
    },
  );

  test(
    'isLocationEnabled should return true if location is enabled and false if it\'s not',
    () async {
      when(() => mockGeolocator.isLocationServiceEnabled()).thenAnswer(
        (_) async => true,
      );
      var isLocationEnabled = await service.isLocationEnabled();
      expect(isLocationEnabled, isA<bool>());
      expect(isLocationEnabled, true);

      when(() => mockGeolocator.isLocationServiceEnabled())
          .thenAnswer((_) async => false);
      isLocationEnabled = await service.isLocationEnabled();
      expect(isLocationEnabled, false);
    },
  );

  test(
    'isPermissionGranted should return true if LocationPermission is always or whileInUse',
    () async {
      when(() => mockGeolocator.checkPermission()).thenAnswer(
        (_) async => LocationPermission.always,
      );
      var isPermissionGranted = await service.isPermissionGranted();
      expect(isPermissionGranted, isA<bool>());
      expect(isPermissionGranted, true);

      when(() => mockGeolocator.checkPermission()).thenAnswer(
        (_) async => LocationPermission.whileInUse,
      );
      isPermissionGranted = await service.isPermissionGranted();
      expect(isPermissionGranted, true);
    },
  );
  test(
    'isPermissionGranted should return false if LocationPermission is denied or deniedForever or unableToDetermine',
    () async {
      when(() => mockGeolocator.checkPermission()).thenAnswer(
        (_) async => LocationPermission.denied,
      );
      when(() => mockGeolocator.requestPermission()).thenAnswer(
        (_) async => LocationPermission.denied,
      );
      var isPermissionGranted = await service.isPermissionGranted();
      expect(isPermissionGranted, isA<bool>());
      expect(isPermissionGranted, false);

      when(() => mockGeolocator.checkPermission()).thenAnswer(
        (_) async => LocationPermission.deniedForever,
      );
      isPermissionGranted = await service.isPermissionGranted();
      expect(isPermissionGranted, false);

      when(() => mockGeolocator.checkPermission()).thenAnswer(
        (_) async => LocationPermission.unableToDetermine,
      );
      isPermissionGranted = await service.isPermissionGranted();
      expect(isPermissionGranted, false);
    },
  );
}
