import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/custom_card.dart';
import '../../../notelab/presentation/screens/notelab_screen.dart';
import '../../../calculator/presentation/screens/calculator_screen.dart';
import '../../../bmi/presentation/screens/bmi_screen.dart';
import '../../../settings/presentation/screens/settings_screen.dart';
import '../../../about/presentation/screens/about_screen.dart';
import '../../../currency/presentation/screens/currency_screen.dart';
import '../../../calendar/presentation/screens/calendar_screen.dart';

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
    const CurrencyScreen(), // ✅ CHANGED: Added CurrencyScreen()
    const SettingsScreen(),
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
            icon: Icon(Icons.currency_exchange), // ✅ FIXED: proper icon
            selectedIcon: Icon(Icons.currency_exchange),
            label: 'Currency',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
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
        title: const Text(AppConstants.appName),
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
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        crossAxisCount: 2,
        mainAxisSpacing: AppConstants.defaultPadding,
        crossAxisSpacing: AppConstants.defaultPadding,
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
            Icons.currency_exchange, // ✅ NEW: Proper icon for currency
            Colors.purple,
                () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CurrencyScreen()), // ✅ NEW: Navigate to currency screen
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
    return CustomCard(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 48,
            color: color,
          ),
          const SizedBox(height: AppConstants.smallPadding),
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ],
      ),
    );
  }
}