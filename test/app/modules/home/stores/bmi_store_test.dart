import 'package:calculadora_imc/app/modules/home/stores/bmi_store.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late BMIStore store;

  setUp(
    () {
      store = BMIStore();
    },
  );

  test(
    'Initial result value should be null',
    () {
      expect(store.result, isNull);
    },
  );

  test(
    'getClassification should return Magreza if bmi is less then 18.5',
    () {
      final result = store.getClassification(18.0);
      expect(result, 'Magreza');
    },
  );

  test(
    'getClassification should return Normal if bmi is greater or equal to 18.5 and less than 24.9',
    () {
      final result = store.getClassification(22.0);
      expect(result, 'Normal');
    },
  );

  test(
    'getClassification should return Sobrepeso if bmi is greater or equal to 25 and less than 29.9',
    () {
      final result = store.getClassification(29.0);
      expect(result, 'Sobrepeso');
    },
  );

  test(
    'getClassification should return Obesidade if bmi is greater or equal to 30 and less than 39.9',
    () {
      final result = store.getClassification(31.0);
      expect(result, 'Obesidade');
    },
  );

  test(
    'getClassification should return Obesidade grave if bmi is greater or equal to 40',
    () {
      final result = store.getClassification(40);
      expect(result, 'Obesidade grave');
    },
  );

  test('calculateBMI should set result with a MeasurementModel instance', () {
    store.calculateBMI('112', '1.9');
    final result = store.result;
    expect(result, isNotNull);
    expect(result!.weight, 112.0);
    expect(result.height, 1.9);
    expect(result.classification, 'Obesidade');
    expect(result.bmi.round(), 31);
  });
}
