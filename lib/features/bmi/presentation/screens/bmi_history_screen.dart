import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/custom_card.dart';
import '../../domain/models/bmi_record.dart';
import '../providers/bmi_provider.dart';

class BMIHistoryScreen extends ConsumerStatefulWidget {
  const BMIHistoryScreen({super.key});

  @override
  ConsumerState<BMIHistoryScreen> createState() => _BMIHistoryScreenState();
}

class _BMIHistoryScreenState extends ConsumerState<BMIHistoryScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(bmiProvider.notifier).loadHistory());
  }

  @override
  Widget build(BuildContext context) {
    final bmiState = ref.watch(bmiProvider);
    final records = bmiState.history;

    return Scaffold(
      appBar: AppBar(
        title: const Text('BMI History'),
      ),
      body: records.isEmpty
          ? const Center(
        child: Text(
          'No BMI records yet',
          style: TextStyle(fontSize: 18),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        itemCount: records.length,
        itemBuilder: (context, index) {
          final record = records[index];
          return CustomCard(
            margin: const EdgeInsets.only(bottom: AppConstants.defaultPadding),
            child: Dismissible(
              key: Key(record.timestamp.toIso8601String()),
              direction: DismissDirection.endToStart,
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: AppConstants.defaultPadding),
                color: Colors.red,
                child: const Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
              onDismissed: (_) {
                ref.read(bmiProvider.notifier).deleteRecord(record);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Deleted ${record.bmi.toStringAsFixed(1)} BMI record'),
                    action: SnackBarAction(
                      label: 'Undo',
                      onPressed: () {
                        ref.read(bmiProvider.notifier).undoDelete(record);
                      },
                    ),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.defaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'BMI: ${record.bmi.toStringAsFixed(1)}',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          DateFormat('MMM d, y HH:mm').format(record.timestamp),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppConstants.smallPadding),
                    Text(
                      'Height: ${record.feet.toStringAsFixed(0)}\' ${record.inches.toStringAsFixed(1)}"',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Text(
                      'Weight: ${record.weight.toStringAsFixed(1)} kg',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: AppConstants.smallPadding),
                    Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: _getCategoryColor(record.bmi),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _getCategory(record.bmi),
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                            color: _getCategoryColor(record.bmi),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String _getCategory(double bmi) {
    if (bmi < 18.5) return 'Underweight';
    if (bmi < 25) return 'Normal';
    if (bmi < 30) return 'Overweight';
    return 'Obese';
  }

  Color _getCategoryColor(double bmi) {
    if (bmi < 18.5) return Colors.blue;
    if (bmi < 25) return Colors.green;
    if (bmi < 30) return Colors.orange;
    return Colors.red;
  }
}