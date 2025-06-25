import 'package:flutter/material.dart';
import '../../../currency/data/currency_service.dart';

class CurrencyScreen extends StatefulWidget {
  const CurrencyScreen({super.key});

  @override
  State<CurrencyScreen> createState() => _CurrencyScreenState();
}

class _CurrencyScreenState extends State<CurrencyScreen> {
  final TextEditingController _amountController = TextEditingController();

  String _from = 'USD';
  String _to = 'BDT';
  double _result = 0.0;
  Map<String, dynamic>? _rates;

  final List<String> _currencies = [
    'USD', 'EUR', 'GBP', 'INR', 'BDT', 'CAD', 'AUD', 'JPY', 'CNY'
  ];

  @override
  void initState() {
    super.initState();
    _loadRates();
  }

  Future<void> _loadRates() async {
    final rates = await CurrencyService.fetchRates(_from);
    if (rates != null) {
      setState(() {
        _rates = rates;
      });
    }
  }

  void _convert() {
    final amount = double.tryParse(_amountController.text);
    if (amount == null || _rates == null) return;

    final rate = _rates![_to];
    setState(() {
      _result = amount * rate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Currency Converter")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Enter amount",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildDropdown(_from, (val) {
                  setState(() {
                    _from = val!;
                    _loadRates();
                  });
                })),
                const Icon(Icons.arrow_forward),
                Expanded(child: _buildDropdown(_to, (val) {
                  setState(() {
                    _to = val!;
                  });
                })),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _convert,
              child: const Text("Convert"),
            ),
            const SizedBox(height: 16),
            Text(
              _result == 0.0
                  ? 'Result will appear here'
                  : '$_result $_to',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown(String value, ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      value: value,
      items: _currencies
          .map((e) => DropdownMenuItem(
        value: e,
        child: Text(e),
      ))
          .toList(),
      onChanged: onChanged,
      decoration: const InputDecoration(
        labelText: 'Currency',
        border: OutlineInputBorder(),
      ),
    );
  }
}
