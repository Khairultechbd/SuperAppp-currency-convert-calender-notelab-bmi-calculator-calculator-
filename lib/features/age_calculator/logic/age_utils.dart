// features/age_calculator/logic/age_utils.dart
class AgeCalculator {
  static Map<String, dynamic> calculateAge(DateTime dob) {
    final now = DateTime.now();
    final nextBirthday = _getNextBirthday(dob);

    // Calculate exact age
    int years = now.year - dob.year;
    int months = now.month - dob.month;
    int days = now.day - dob.day;

    if (days < 0) {
      months--;
      final prevMonth = now.month == 1 ? 12 : now.month - 1;
      final year = now.month == 1 ? now.year - 1 : now.year;
      days += _daysInMonth(year, prevMonth);
    }

    if (months < 0) {
      years--;
      months += 12;
    }

    // Calculate total days/weeks/months lived
    final totalDays = now.difference(dob).inDays;
    final totalWeeks = totalDays ~/ 7;
    final totalMonths = years * 12 + months;

    // Calculate next birthday countdown
    final nextBdayCountdown = nextBirthday.difference(now);
    final nextBdayMonths = (nextBdayCountdown.inDays / 30).floor();
    final nextBdayDays = nextBdayCountdown.inDays % 30;

    return {
      'exactAge': {'years': years, 'months': months, 'days': days},
      'totalDays': totalDays,
      'totalWeeks': totalWeeks,
      'totalMonths': totalMonths,
      'nextBirthday': {
        'months': nextBdayMonths,
        'days': nextBdayDays,
        'weekday': _getWeekdayName(nextBirthday.weekday),
      },
    };
  }

  static DateTime _getNextBirthday(DateTime dob) {
    final now = DateTime.now();
    DateTime nextBirthday = DateTime(now.year, dob.month, dob.day);

    if (nextBirthday.isBefore(now)) {
      nextBirthday = DateTime(now.year + 1, dob.month, dob.day);
    }
    return nextBirthday;
  }

  static int _daysInMonth(int year, int month) {
    return DateTime(year, month + 1, 0).day;
  }

  static String _getWeekdayName(int weekday) {
    const days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return days[weekday - 1];
  }
}