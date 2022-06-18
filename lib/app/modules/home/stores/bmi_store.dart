import 'dart:math';

import 'package:flutter/material.dart';

import '../models/measurement_model.dart';

class BMIStore extends ChangeNotifier {
  MeasurementModel? result;

  void calculateBMI(String weightText, String heightText) {
    var weight = double.parse(weightText.trim().replaceAll(',', '.'));
    var height = double.parse(heightText.trim().replaceAll(',', '.'));
    var bmi = min(weight / pow(height, 2), 40.0);
    var classification = _getClassification(bmi);
    result = MeasurementModel(
      weight: weight,
      height: height,
      bmi: bmi,
      classification: classification,
      measurementDate: DateTime.now(),
    );

    notifyListeners();
  }

  String _getClassification(double bmi) {
    if (bmi < 18.5) {
      return 'Magreza';
    } else if (bmi < 24.9) {
      return 'Normal';
    } else if (bmi < 29.9) {
      return 'Sobrepeso';
    } else if (bmi < 39.9) {
      return 'Obesidade';
    } else {
      return 'Obesidade grave';
    }
  }
}
