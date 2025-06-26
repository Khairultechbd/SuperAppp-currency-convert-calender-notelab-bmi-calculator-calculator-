class BMIRecord {
  final double bmi;
  final double feet;
  final double inches;
  final double weight;
  final DateTime timestamp;

  BMIRecord({
    required this.bmi,
    required this.feet,
    required this.inches,
    required this.weight,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'bmi': bmi,
      'feet': feet,
      'inches': inches,
      'weight': weight,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory BMIRecord.fromJson(Map<String, dynamic> json) {
    return BMIRecord(
      bmi: json['bmi'] as double,
      feet: json['feet'] as double,
      inches: json['inches'] as double,
      weight: json['weight'] as double,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }
}