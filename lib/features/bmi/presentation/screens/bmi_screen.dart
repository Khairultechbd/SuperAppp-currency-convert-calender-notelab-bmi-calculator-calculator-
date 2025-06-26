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
  final _feetController = TextEditingController();
  final _inchesController = TextEditingController();
  final _weightController = TextEditingController();

  @override
  void dispose() {
    _feetController.dispose();
    _inchesController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  void _calculateBMI() {
    if (_feetController.text.isEmpty ||
        _inchesController.text.isEmpty ||
        _weightController.text.isEmpty) {
      _showError('Please enter all values');
      return;
    }

    final feet = double.tryParse(_feetController.text) ?? 0;
    final inches = double.tryParse(_inchesController.text) ?? 0;
    final weight = double.tryParse(_weightController.text) ?? 0;

    if (feet <= 0 || inches < 0 || weight <= 0) {
      _showError('Please enter valid values');
      return;
    }

    ref.read(bmiProvider.notifier).calculateBMI(
      feet: feet,
      inches: inches,
      weight: weight,
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _resetInputs() {
    _feetController.clear();
    _inchesController.clear();
    _weightController.clear();
    ref.read(bmiProvider.notifier).resetCurrentBMI();
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
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const BMIHistoryScreen()),
            ),
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
                      const Icon(Icons.height),
                      const SizedBox(width: 8),
                      const Text('Height'),
                    ],
                  ),
                  const SizedBox(height: AppConstants.defaultPadding),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _feetController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Feet',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextField(
                          controller: _inchesController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Inches',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppConstants.defaultPadding),
                  TextField(
                    controller: _weightController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Weight (kg)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: AppConstants.defaultPadding),
                  Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          text: 'Calculate BMI',
                          onPressed: _calculateBMI,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: CustomButton(
                          text: 'Reset',
                          onPressed: _resetInputs,
                          backgroundColor: Colors.grey,
                        ),
                      ),
                    ],
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
                        fontWeight: FontWeight.bold,
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