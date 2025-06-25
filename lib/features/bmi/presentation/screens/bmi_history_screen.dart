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

    if (records.isEmpty) {
      return const Center(
        child: Text('No BMI records yet'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      itemCount: records.length,
      itemBuilder: (context, index) {
        final record = records[index];
        return CustomCard(
          margin: const EdgeInsets.only(bottom: AppConstants.smallPadding),
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
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'BMI: ${record.bmi.toStringAsFixed(1)}',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(
                      DateFormat('MMM d, y HH:mm').format(record.timestamp),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                const SizedBox(height: AppConstants.smallPadding),
                Text(
                  'Height: ${record.height.toStringAsFixed(1)} ${record.isMetric ? 'cm' : 'inches'}',
                ),
                Text(
                  'Weight: ${record.weight.toStringAsFixed(1)} ${record.isMetric ? 'kg' : 'lbs'}',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
} 