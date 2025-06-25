import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_card.dart';
import '../providers/calculator_provider.dart';

class CalculatorScreen extends ConsumerWidget {
  const CalculatorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(calculatorProvider);
    final notifier = ref.read(calculatorProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculator'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              _showHistory(context, ref);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          CustomCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  state.previousInput.isEmpty ? '0' : state.previousInput,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: AppConstants.smallPadding),
                Text(
                  state.currentInput,
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ],
            ),
          ),
          Expanded(
            child: _buildKeypad(context, notifier),
          ),
        ],
      ),
    );
  }

  Widget _buildKeypad(BuildContext context, CalculatorProvider notifier) {
    return GridView.count(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      crossAxisCount: 4,
      mainAxisSpacing: AppConstants.smallPadding,
      crossAxisSpacing: AppConstants.smallPadding,
      children: [
        _buildButton(context, 'C', () => notifier.clear()),
        _buildButton(context, '⌫', () => notifier.delete()),
        _buildButton(context, '%', () => notifier.appendOperator('%')),
        _buildButton(context, '÷', () => notifier.appendOperator('/')),
        _buildButton(context, '7', () => notifier.appendNumber('7')),
        _buildButton(context, '8', () => notifier.appendNumber('8')),
        _buildButton(context, '9', () => notifier.appendNumber('9')),
        _buildButton(context, '×', () => notifier.appendOperator('*')),
        _buildButton(context, '4', () => notifier.appendNumber('4')),
        _buildButton(context, '5', () => notifier.appendNumber('5')),
        _buildButton(context, '6', () => notifier.appendNumber('6')),
        _buildButton(context, '-', () => notifier.appendOperator('-')),
        _buildButton(context, '1', () => notifier.appendNumber('1')),
        _buildButton(context, '2', () => notifier.appendNumber('2')),
        _buildButton(context, '3', () => notifier.appendNumber('3')),
        _buildButton(context, '+', () => notifier.appendOperator('+')),
        _buildButton(context, '±', () => notifier.appendOperator('-')),
        _buildButton(context, '0', () => notifier.appendNumber('0')),
        _buildButton(context, '.', () => notifier.appendNumber('.')),
        _buildButton(
          context,
          '=',
          () => notifier.calculate(),
          isPrimary: true,
        ),
      ],
    );
  }

  Widget _buildButton(
    BuildContext context,
    String text,
    VoidCallback onPressed, {
    bool isPrimary = false,
  }) {
    return CustomButton(
      text: text,
      onPressed: onPressed,
      backgroundColor: isPrimary ? Theme.of(context).colorScheme.primary : null,
      textColor: isPrimary ? Theme.of(context).colorScheme.onPrimary : null,
    );
  }

  void _showHistory(BuildContext context, WidgetRef ref) {
    final state = ref.read(calculatorProvider);
    final notifier = ref.read(calculatorProvider.notifier);

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'History',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () {
                      notifier.clearHistory();
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              const SizedBox(height: AppConstants.defaultPadding),
              Expanded(
                child: state.history.isEmpty
                    ? Center(
                        child: Text(
                          'No calculations yet',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      )
                    : ListView.builder(
                        itemCount: state.history.length,
                        itemBuilder: (context, index) {
                          final calc = state.history[index];
                          return CustomCard(
                            margin: const EdgeInsets.only(bottom: AppConstants.smallPadding),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        calc.expression,
                                        style: Theme.of(context).textTheme.bodyLarge,
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline),
                                      onPressed: () => notifier.deleteHistoryItem(index),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: AppConstants.smallPadding),
                                Text(
                                  '= ${calc.result}',
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                                const SizedBox(height: AppConstants.smallPadding),
                                Text(
                                  DateFormat('MMM d, y HH:mm').format(calc.timestamp),
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
} 