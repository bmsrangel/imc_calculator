import '../../models/measurement_model.dart';

abstract class HistoryLocalStorageService {
  Future<List<MeasurementModel>> getAllMeasurements();
  Future<void> saveMeasurement(MeasurementModel newMeasurement);
}
