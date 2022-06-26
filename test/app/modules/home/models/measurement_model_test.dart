import 'dart:convert';

import 'package:calculadora_imc/app/modules/home/models/measurement_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late double weight;
  late double height;
  late double bmi;
  late String classification;
  late DateTime measurementDate;
  late MeasurementModel measurementModel;
  late Map<String, dynamic> mockedMap;

  setUp(
    () {
      weight = 112.0;
      height = 1.9;
      bmi = 31.0;
      classification = 'Overweight';
      measurementDate = DateTime(2022, 06, 25);
      measurementModel = MeasurementModel(
        weight: weight,
        height: height,
        bmi: bmi,
        classification: classification,
        measurementDate: measurementDate,
      );
      mockedMap = {
        'weight': weight,
        'height': height,
        'bmi': bmi,
        'classification': classification,
        'measurementDate': measurementDate.millisecondsSinceEpoch,
      };
    },
  );

  test(
    'measurementModel should be an instance of MeasurementModel with attributes set',
    () {
      expect(measurementModel, isA<MeasurementModel>());
      expect(measurementModel.weight, weight);
      expect(measurementModel.height, height);
      expect(measurementModel.bmi, bmi);
      expect(measurementModel.measurementDate, measurementDate);
      expect(measurementModel.classification, classification);
    },
  );

  test(
    'measurementModel.toMap should return a Map instance with proper key/values set',
    () {
      final result = measurementModel.toMap();
      expect(result, mockedMap);
    },
  );

  test(
    'MeasurementModel.fromMap should return an instance of MeasurementModel with attributes set',
    () {
      final result = MeasurementModel.fromMap(mockedMap);

      expect(result, isA<MeasurementModel>());
      expect(result.weight, weight);
      expect(result.height, height);
      expect(result.bmi, bmi);
      expect(result.measurementDate, measurementDate);
      expect(result.classification, classification);
    },
  );

  test(
    'measurementModel.toJson should return a string with proper attributes',
    () {
      final mockJsonString = jsonEncode(mockedMap);
      final result = measurementModel.toJson();
      expect(result, isA<String>());
      expect(result, mockJsonString);
    },
  );

  test(
    'MeasurementModel.fromJson should return',
    () {
      final mockJsonString = jsonEncode(mockedMap);
      final result = MeasurementModel.fromJson(mockJsonString);
      expect(result, isA<MeasurementModel>());
      expect(result.weight, weight);
      expect(result.height, height);
      expect(result.bmi, bmi);
      expect(result.measurementDate, measurementDate);
      expect(result.classification, classification);
    },
  );
}
