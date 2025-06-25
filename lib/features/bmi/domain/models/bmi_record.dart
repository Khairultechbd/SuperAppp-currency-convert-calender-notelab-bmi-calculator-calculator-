class BMIRecord {
  final double bmi;
  final double height;
  final double weight;
  final bool isMetric;
  final DateTime timestamp;

  BMIRecord({
    required this.bmi,
    required this.height,
    required this.weight,
    required this.isMetric,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'bmi': bmi,
      'height': height,
      'weight': weight,
      'isMetric': isMetric,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory BMIRecord.fromJson(Map<String, dynamic> json) {
    return BMIRecord(
      bmi: json['bmi'] as double,
      height: json['height'] as double,
      weight: json['weight'] as double,
      isMetric: json['isMetric'] as bool,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }
} 