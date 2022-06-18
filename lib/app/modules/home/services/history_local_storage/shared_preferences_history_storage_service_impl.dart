import 'package:shared_preferences/shared_preferences.dart';

import '../../models/measurement_model.dart';
import 'history_local_storage_service.dart';

class SharedPreferencesHistoryStorageServiceImpl
    implements HistoryLocalStorageService {
  SharedPreferencesHistoryStorageServiceImpl(this._prefs);

  final SharedPreferences _prefs;
  final String _measurementsKey = 'measurements';

  @override
  Future<List<MeasurementModel>> getAllMeasurements() async {
    final stringMeasurements = _prefs.getStringList(_measurementsKey);
    if (stringMeasurements != null) {
      final measurements = stringMeasurements
          .map((stringMeasure) => MeasurementModel.fromJson(stringMeasure))
          .toList();
      return measurements;
    } else {
      return [];
    }
  }

  @override
  Future<void> saveMeasurement(MeasurementModel newMeasurement) async {
    final newMeasurementString = newMeasurement.toJson();
    var stringMeasurements = _prefs.getStringList(_measurementsKey) ?? [];
    stringMeasurements.insert(0, newMeasurementString);
    await _prefs.setStringList(_measurementsKey, stringMeasurements);
  }

  @override
  Future<MeasurementModel?> getLastMeasurement() async {
    final stringMeasurements = _prefs.getStringList(_measurementsKey) ?? [];
    if (stringMeasurements.isEmpty) {
      return null;
    } else {
      final stringMeasurement = stringMeasurements.first;
      return MeasurementModel.fromJson(stringMeasurement);
    }
  }
}
