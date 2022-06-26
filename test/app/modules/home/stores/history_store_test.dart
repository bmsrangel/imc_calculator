import 'package:calculadora_imc/app/modules/home/models/measurement_model.dart';
import 'package:calculadora_imc/app/modules/home/services/history_local_storage/history_local_storage_service.dart';
import 'package:calculadora_imc/app/modules/home/stores/history_store.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockHistoryLocalStorageService extends Mock
    implements HistoryLocalStorageService {}

void main() {
  late HistoryLocalStorageService service;
  late HistoryStore store;
  late List<MeasurementModel> mockedMeasurements;

  setUpAll(
    () {
      service = MockHistoryLocalStorageService();
      store = HistoryStore(service);
      mockedMeasurements = [
        MeasurementModel(
          weight: 112.0,
          height: 1.9,
          bmi: 31.02,
          classification: 'Obesidade',
          measurementDate: DateTime(2022, 06, 25),
        ),
      ];
    },
  );

  test(
    'Initial isLoading value should be false, measurements should be an empty list and error should be null',
    () {
      expect(store.isLoading, false);
      expect(store.measurements, isA<List<MeasurementModel>>());
      expect(store.measurements, isEmpty);
      expect(store.error, isNull);
    },
  );

  test(
    'getHistoricMeasurements should set measurements properly',
    () async {
      when(
        () => service.getAllMeasurements(),
      ).thenAnswer(
        (_) async => mockedMeasurements,
      );
      await store.getHistoricMeasurements();
      expect(store.measurements, isNotNull);
      expect(store.measurements.length, 1);
    },
  );

  test(
    'registerMeasurement should save a new measurement properly',
    () async {
      final newMeasurement = MeasurementModel(
        weight: 113.0,
        height: 1.9,
        bmi: 31.03,
        classification: 'Obesidade',
        measurementDate: DateTime(2022, 06, 24),
      );
      when(() => service.saveMeasurement(newMeasurement)).thenAnswer(
        (_) async {
          mockedMeasurements.add(newMeasurement);
          return Future.value(() => () {});
        },
      );
      when(
        () => service.getAllMeasurements(),
      ).thenAnswer(
        (_) async => mockedMeasurements,
      );
      await store.registerMeasurement(newMeasurement);
      await store.getHistoricMeasurements();
      expect(store.measurements, isNotEmpty);
      expect(store.measurements.length, 2);
    },
  );
}
