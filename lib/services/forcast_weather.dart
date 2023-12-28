import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherForcast {
  double? lat;
  double? log;

  //! Get Weekly
  Future<Map<String, dynamic>> getWeeklyForecast(double lat, double lon) async {
    final response = await http.get(Uri.parse(
        "https://api.openweathermap.org/data/3.0/forecast/daily?lat=$lat&lon=$lon&cnt=7&appid=c1f835f3b2449407da33ffab9e776ca9&units=metric"));
    print(response.toString());

    if (response.statusCode == 200) {
      print(response.body);
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load weekly forecast data');
    }
  }
}
