import 'dart:convert';
import 'package:http/http.dart' as http;

class CurrencyService {
  static const String _baseUrl = 'https://open.er-api.com/v6/latest/';

  static Future<Map<String, dynamic>?> fetchRates(String baseCurrency) async {
    final url = '$_baseUrl$baseCurrency';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['rates'];
    } else {
      return null;
    }
  }
}
