import 'package:hive/hive.dart';
import '../domain/models/calendar_event_model.dart';

class CalendarRepository {
  static const boxName = 'calendar_events';

  Future<void> addEvent(CalendarEvent event) async {
    final box = await Hive.openBox(boxName);
    final events = box.get(event.date.toIso8601String(), defaultValue: []) as List;
    events.add(event.toMap());
    await box.put(event.date.toIso8601String(), events);
  }

  Future<List<CalendarEvent>> getEventsByDate(DateTime date) async {
    final box = await Hive.openBox(boxName);
    final events = box.get(date.toIso8601String(), defaultValue: []) as List;
    return events.map((e) => CalendarEvent.fromMap(Map<String, dynamic>.from(e))).toList();
  }
}