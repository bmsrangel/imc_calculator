import 'package:calculadora_imc/app/modules/home/models/measurement_model.dart';
import 'package:calculadora_imc/app/modules/home/services/history_local_storage/shared_preferences_history_storage_service_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late MockSharedPreferences mockPrefs;
  late SharedPreferencesHistoryStorageServiceImpl service;
  late List<MeasurementModel> mockedMeasurements;
  late List<String> mockedMeasurementsString;

  setUpAll(
    () {
      mockPrefs = MockSharedPreferences();
      service = SharedPreferencesHistoryStorageServiceImpl(mockPrefs);
      mockedMeasurements = [
        MeasurementModel(
          weight: 114.5,
          height: 1.9,
          bmi: 31.7,
          classification: 'Obesidade',
          measurementDate: DateTime(2022, 06, 01),
        ),
      ];
      mockedMeasurementsString =
          mockedMeasurements.map((e) => e.toJson()).toList();
    },
  );

  group(
    'getMeasurements tests',
    () {
      test(
        'getAllMeasurements should return an empty list if no measuremests are stored',
        () async {
          when(() => mockPrefs.getStringList(any())).thenReturn(null);
          final result = await service.getAllMeasurements();
          expect(result, isA<List<MeasurementModel>>());
          expect(result, isEmpty);
        },
      );

      test(
        'getAllMeasurements should return a list of MeasurementModels if any measurements are saved',
        () async {
          when(
            () => mockPrefs.getStringList(any()),
          ).thenReturn(mockedMeasurementsString);
          final results = await service.getAllMeasurements();
          expect(results, isA<List<MeasurementModel>>());
          expect(results.length, 1);
        },
      );
    },
  );

  group(
    'saveMeasurement tests',
    () {
      test(
        'saveMeasurement should store a new measurement to the list',
        () async {
          when(
            () => mockPrefs.getStringList(any()),
          ).thenReturn(mockedMeasurementsString);
          when(
            () => mockPrefs.setStringList(any(), mockedMeasurementsString),
          ).thenAnswer(
            (_) async => true,
          );
          await service.saveMeasurement(
            MeasurementModel(
              weight: 112.0,
              height: 1.9,
              bmi: 31.0,
              classification: 'Obeso',
              measurementDate: DateTime(2022, 06, 25),
            ),
          );
          expect(mockedMeasurementsString.length, 2);
        },
      );
    },
  );
}
