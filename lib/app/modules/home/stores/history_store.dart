import 'package:calculadora_imc/app/modules/home/models/measurement_model.dart';
import 'package:calculadora_imc/app/modules/home/services/history_local_storage_service.dart';
import 'package:flutter/material.dart';

class HistoryStore extends ChangeNotifier {
  HistoryStore(this._storageService);

  final HistoryLocalStorageService _storageService;

  var isLoading = false;
  var measurements = <MeasurementModel>[];
  String? error;

  Future<void> getHistoricMeasurements() async {
    isLoading = true;
    notifyListeners();
    final storedMeasurements = await _storageService.getAllMeasurements();
    measurements.clear();
    measurements.addAll(storedMeasurements);
    isLoading = false;
    notifyListeners();
  }

  Future<void> registerMeasurement(MeasurementModel newMeasurement) async {
    await _storageService.saveMeasurement(newMeasurement);
  }
}
