import 'dart:convert';

class MeasurementModel {
  MeasurementModel({
    required this.weight,
    required this.height,
    required this.bmi,
    required this.classification,
    required this.measurementDate,
  });

  final double weight;
  final double height;
  final double bmi;
  final String classification;
  final DateTime measurementDate;

  Map<String, dynamic> toMap() {
    return {
      'weight': weight,
      'height': height,
      'bmi': bmi,
      'classification': classification,
      'measurementDate': measurementDate.millisecondsSinceEpoch,
    };
  }

  factory MeasurementModel.fromMap(Map<String, dynamic> map) {
    return MeasurementModel(
      weight: map['weight']?.toDouble() ?? 0.0,
      height: map['height']?.toDouble() ?? 0.0,
      bmi: map['bmi']?.toDouble() ?? 0.0,
      classification: map['classification'] ?? '',
      measurementDate:
          DateTime.fromMillisecondsSinceEpoch(map['measurementDate']),
    );
  }

  String toJson() => json.encode(toMap());

  factory MeasurementModel.fromJson(String source) =>
      MeasurementModel.fromMap(json.decode(source));
}
