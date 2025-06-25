import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarFormat _format = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime _pickerDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  void _showYearMonthPicker() async {
    int selectedYear = _focusedDay.year;
    int selectedMonth = _focusedDay.month;

    await showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Select Year and Month'),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DropdownButton<int>(
                value: selectedYear,
                items: List.generate(30, (index) {
                  final year = DateTime.now().year - 15 + index;
                  return DropdownMenuItem(
                    value: year,
                    child: Text('$year'),
                  );
                }),
                onChanged: (value) {
                  setState(() {
                    selectedYear = value!;
                  });
                },
              ),
              DropdownButton<int>(
                value: selectedMonth,
                items: List.generate(12, (index) {
                  return DropdownMenuItem(
                    value: index + 1,
                    child: Text(DateFormat.MMMM().format(DateTime(0, index + 1))),
                  );
                }),
                onChanged: (value) {
                  setState(() {
                    selectedMonth = value!;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _focusedDay = DateTime(selectedYear, selectedMonth);
                  _selectedDay = _focusedDay;
                });
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
        actions: [
          IconButton(
            icon: const Icon(Icons.date_range),
            onPressed: _showYearMonthPicker,
          )
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          ToggleButtons(
            isSelected: [
              _format == CalendarFormat.week,
              _format == CalendarFormat.month,
            ],
            onPressed: (index) {
              setState(() {
                _format = index == 0 ? CalendarFormat.week : CalendarFormat.month;
              });
            },
            children: const [
              Padding(padding: EdgeInsets.all(8.0), child: Text("Week")),
              Padding(padding: EdgeInsets.all(8.0), child: Text("Month")),
            ],
          ),
          TableCalendar(
            firstDay: DateTime.utc(2000, 1, 1),
            lastDay: DateTime.utc(2100, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selected, focused) {
              setState(() {
                _selectedDay = selected;
                _focusedDay = focused;
              });
            },
            calendarFormat: _format,
            onFormatChanged: (format) {
              setState(() {
                _format = format;
              });
            },
          ),
        ],
      ),
    );
  }
}