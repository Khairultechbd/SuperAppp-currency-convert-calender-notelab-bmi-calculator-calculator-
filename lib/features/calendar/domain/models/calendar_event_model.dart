class CalendarEvent {
  final String title;
  final String description;
  final DateTime date;

  CalendarEvent({
    required this.title,
    required this.description,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
    };
  }

  factory CalendarEvent.fromMap(Map<String, dynamic> map) {
    return CalendarEvent(
      title: map['title'],
      description: map['description'],
      date: DateTime.parse(map['date']),
    );
  }
}