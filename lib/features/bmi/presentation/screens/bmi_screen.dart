import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_card.dart';
import '../providers/bmi_provider.dart';
import 'bmi_history_screen.dart';

class BMIScreen extends ConsumerStatefulWidget {
  const BMIScreen({super.key});

  @override
  ConsumerState<BMIScreen> createState() => _BMIScreenState();
}

class _BMIScreenState extends ConsumerState<BMIScreen> {
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  bool _isMetric = true;

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  void _calculateBMI() {
    if (_heightController.text.isEmpty || _weightController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter both height and weight')),
      );
      return;
    }

    final height = double.parse(_heightController.text);
    final weight = double.parse(_weightController.text);

    ref.read(bmiProvider.notifier).calculateBMI(
          height: height,
          weight: weight,
          isMetric: _isMetric,
        );
  }

  @override
  Widget build(BuildContext context) {
    final bmiState = ref.watch(bmiProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('BMI Calculator'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BMIHistoryScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomCard(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Metric'),
                      Switch(
                        value: _isMetric,
                        onChanged: (value) {
                          setState(() {
                            _isMetric = value;
                            _heightController.clear();
                            _weightController.clear();
                          });
                        },
                      ),
                      const Text('Imperial'),
                    ],
                  ),
                  const SizedBox(height: AppConstants.defaultPadding),
                  TextField(
                    controller: _heightController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: _isMetric ? 'Height (cm)' : 'Height (inches)',
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: AppConstants.defaultPadding),
                  TextField(
                    controller: _weightController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: _isMetric ? 'Weight (kg)' : 'Weight (lbs)',
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: AppConstants.defaultPadding),
                  CustomButton(
                    text: 'Calculate BMI',
                    onPressed: _calculateBMI,
                  ),
                ],
              ),
            ),
            if (bmiState.bmi != null) ...[
              const SizedBox(height: AppConstants.defaultPadding),
              CustomCard(
                child: Column(
                  children: [
                    Text(
                      'Your BMI',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: AppConstants.smallPadding),
                    Text(
                      bmiState.bmi!.toStringAsFixed(1),
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    const SizedBox(height: AppConstants.smallPadding),
                    Text(
                      bmiState.category,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: bmiState.categoryColor,
                          ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: AppConstants.defaultPadding),
            CustomCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'BMI Categories',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: AppConstants.smallPadding),
                  _buildCategoryRow('Underweight', '< 18.5', Colors.blue),
                  _buildCategoryRow('Normal', '18.5 - 24.9', Colors.green),
                  _buildCategoryRow('Overweight', '25 - 29.9', Colors.orange),
                  _buildCategoryRow('Obese', '≥ 30', Colors.red),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryRow(String category, String range, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(category),
          const Spacer(),
          Text(range),
        ],
      ),
    );
  }
} 