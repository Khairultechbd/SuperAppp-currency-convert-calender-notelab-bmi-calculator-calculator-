// features/age_calculator/presentation/screens/age_calculator_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_card.dart';
import '../../logic/age_utils.dart';

class AgeCalculatorScreen extends StatefulWidget {
  const AgeCalculatorScreen({super.key});

  @override
  State<AgeCalculatorScreen> createState() => _AgeCalculatorScreenState();
}

class _AgeCalculatorScreenState extends State<AgeCalculatorScreen> {
  DateTime? _selectedDate;
  Map<String, dynamic>? _ageResult;

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _ageResult = null;
      });
    }
  }

  void _calculateAge() {
    if (_selectedDate == null) return;

    setState(() {
      _ageResult = AgeCalculator.calculateAge(_selectedDate!);
    });
  }

  void _reset() {
    setState(() {
      _selectedDate = null;
      _ageResult = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Age Calculator')),
      body: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          children: [
            CustomCard(
              child: Column(
                children: [
                  const Text('Select Date of Birth', style: TextStyle(fontSize: 18)),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _selectedDate == null
                              ? 'No date selected'
                              : DateFormat.yMMMMd().format(_selectedDate!),
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      CustomButton(
                        text: 'Choose Date',
                        onPressed: () => _selectDate(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          text: 'Calculate Age',
                          onPressed: _calculateAge,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: CustomButton(
                          text: 'Reset',
                          onPressed: _reset,
                          backgroundColor: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            if (_ageResult != null) ...[
              const SizedBox(height: AppConstants.defaultPadding),
              CustomCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Your Exact Age', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(
                      '${_ageResult!['exactAge']['years']} years '
                          '${_ageResult!['exactAge']['months']} months '
                          '${_ageResult!['exactAge']['days']} days',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppConstants.defaultPadding),
              CustomCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Total Time Lived', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text('${_ageResult!['totalDays']} days', style: const TextStyle(fontSize: 16)),
                    Text('${_ageResult!['totalWeeks']} weeks', style: const TextStyle(fontSize: 16)),
                    Text('${_ageResult!['totalMonths']} months', style: const TextStyle(fontSize: 16)),
                  ],
                ),
              ),

              const SizedBox(height: AppConstants.defaultPadding),
              CustomCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Next Birthday', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(
                      'In ${_ageResult!['nextBirthday']['months']} months '
                          '${_ageResult!['nextBirthday']['days']} days',
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      'On a ${_ageResult!['nextBirthday']['weekday']}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}