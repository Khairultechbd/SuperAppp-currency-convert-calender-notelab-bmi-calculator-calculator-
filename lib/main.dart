import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:super_app/core/theme/app_theme.dart';
import 'package:super_app/core/constants/app_constants.dart';
import 'package:super_app/features/notelab/presentation/screens/notelab_screen.dart';
import 'package:super_app/features/calculator/presentation/screens/calculator_screen.dart';
import 'package:super_app/features/bmi/presentation/screens/bmi_screen.dart';
import 'package:super_app/features/settings/presentation/screens/settings_screen.dart';
import 'package:super_app/features/about/presentation/screens/about_screen.dart';
import 'package:super_app/features/settings/presentation/providers/settings_provider.dart';
import 'package:super_app/features/currency/presentation/screens/currency_screen.dart';
import 'package:super_app/features/calendar/presentation/screens/calendar_screen.dart';
import 'package:super_app/features/age_calculator/presentation/screens/age_calculator_screen.dart';
void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}
//gitdm
class MyApp extends ConsumerWidget {
  const MyApp({super.key});
//checks
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return MaterialApp(
      title: 'SuperApp',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: settings.themeMode,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            textTheme: Theme.of(context).textTheme.apply(
              fontSizeFactor: settings.fontSize / AppConstants.mediumFontSize,
              fontFamily: settings.fontFamily,
            ),
          ),
          child: child!,
        );
      },
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const MainMenuScreen(),
    const NoteLabScreen(),
    const CalculatorScreen(),
    const BMIScreen(),
    const SettingsScreen(),
    const AboutScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.note_alt_outlined),
            selectedIcon: Icon(Icons.note_alt),
            label: 'NoteLab',
          ),
          NavigationDestination(
            icon: Icon(Icons.calculate_outlined),
            selectedIcon: Icon(Icons.calculate),
            label: 'Calculator',
          ),
          NavigationDestination(
            icon: Icon(Icons.monitor_weight_outlined),
            selectedIcon: Icon(Icons.monitor_weight),
            label: 'BMI',
          ),

          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
          NavigationDestination(
            icon: Icon(Icons.info_outline),
            selectedIcon: Icon(Icons.info),
            label: 'About',
          ),
          // NavigationDestination(
          //   icon: Icon(Icons.currency_exchange),
          //   selectedIcon: Icon(Icons.money),
          //   label: 'Currency',
          // ),
        ],
      ),
    );
  }
}

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SuperApp'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutScreen()),
              );
            },
          ),
        ],
      ),
      body: GridView.count(
        padding: const EdgeInsets.all(16),
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        children: [
          _buildFeatureCard(
            context,
            'NoteLab',
            Icons.note_alt,
            Colors.blue,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const NoteLabScreen()),
            ),
          ),
          _buildFeatureCard(
            context,
            'Calculator',
            Icons.calculate,
            Colors.green,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CalculatorScreen()),
            ),
          ),
          _buildFeatureCard(
            context,
            'BMI Calculator',
            Icons.monitor_weight,
            Colors.orange,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const BMIScreen()),
            ),
          ),
          _buildFeatureCard(
            context,
            'Currency Converter',
            Icons.currency_exchange,
            Colors.purple,
                () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CurrencyScreen()), //
            ),
          ),
          _buildFeatureCard(
            context,
            'Calendar',
            Icons.calendar_month,
            Colors.teal,
                () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CalendarScreen()),
            ),
          ),
          _buildFeatureCard(
            context,
            'Age Calculator',
            Icons.cake,
            Colors.indigo,
                () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AgeCalculatorScreen()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 48,
              color: color,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: title == 'Currency Converter' ? 19 : 22,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
