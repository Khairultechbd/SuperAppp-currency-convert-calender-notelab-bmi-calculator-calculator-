import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/custom_card.dart';
import '../providers/settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        children: [
          CustomCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Theme',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: AppConstants.smallPadding),
                SegmentedButton<ThemeMode>(
                  segments: const [
                    ButtonSegment(
                      value: ThemeMode.system,
                      icon: Icon(Icons.brightness_auto),
                      label: Text('System'),
                    ),
                    ButtonSegment(
                      value: ThemeMode.light,
                      icon: Icon(Icons.brightness_high),
                      label: Text('Light'),
                    ),
                    ButtonSegment(
                      value: ThemeMode.dark,
                      icon: Icon(Icons.brightness_4),
                      label: Text('Dark'),
                    ),
                  ],
                  selected: {state.themeMode},
                  onSelectionChanged: (Set<ThemeMode> modes) {
                    notifier.setThemeMode(modes.first);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: AppConstants.defaultPadding),
          CustomCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Font Size',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: AppConstants.smallPadding),
                Slider(
                  value: state.fontSize,
                  min: AppConstants.smallFontSize,
                  max: AppConstants.largeFontSize,
                  divisions: 2,
                  label: state.fontSize.toStringAsFixed(1),
                  onChanged: (value) {
                    notifier.setFontSize(value);
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Small'),
                    Text('Medium'),
                    Text('Large'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppConstants.defaultPadding),
          CustomCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Font Style',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: AppConstants.smallPadding),
                DropdownButtonFormField<String>(
                  value: state.fontFamily,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    DropdownMenuItem(
                      value: AppConstants.sansFont,
                      child: Text('Sans'),
                    ),
                    DropdownMenuItem(
                      value: AppConstants.serifFont,
                      child: Text('Serif'),
                    ),
                    DropdownMenuItem(
                      value: AppConstants.monoFont,
                      child: Text('Monospace'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      notifier.setFontFamily(value);
                    }
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: AppConstants.defaultPadding),
          CustomCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'History',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: AppConstants.smallPadding),
                ListTile(
                  leading: const Icon(Icons.calculate),
                  title: const Text('Clear Calculator History'),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Clear Calculator History'),
                        content: const Text('Are you sure you want to clear all calculator history?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              notifier.clearCalculatorHistory();
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Calculator history cleared'),
                                ),
                              );
                            },
                            child: const Text('Clear'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.monitor_weight),
                  title: const Text('Clear BMI History'),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Clear BMI History'),
                        content: const Text('Are you sure you want to clear all BMI history?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              notifier.clearBMIHistory();
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('BMI history cleared'),
                                ),
                              );
                            },
                            child: const Text('Clear'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 