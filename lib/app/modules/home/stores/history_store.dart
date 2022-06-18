import 'package:flutter/material.dart';

import '../models/measurement_model.dart';
import '../services/history_local_storage/history_local_storage_service.dart';

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
