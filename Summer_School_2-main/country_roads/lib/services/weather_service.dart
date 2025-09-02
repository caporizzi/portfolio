import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  Future<Map<String, dynamic>> fetchWeather(double latitude, double longitude) async {
    final url = Uri.parse(
      "https://api.open-meteo.com/v1/forecast?latitude=$latitude&longitude=$longitude&current=temperature_2m,weather_code",
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body)["current"];
    } else {
      throw Exception('Failed to load weather data.');
    }
  }

  Map<String, dynamic> getWeatherAtTime(Map<String, dynamic> weatherData, DateTime time) {
    if (weatherData.isEmpty) {
      throw Exception('No weather data available.');
    }

    var formattedTime = time.toIso8601String().split(".")[0]; // e.g., "2024-09-01T12:00:00"
    var times = weatherData["time"];
    var temperatures = weatherData["temperature_2m"];
    var rain = weatherData["rain"];
    var cloud = weatherData["cloud_cover"];
    var weatherCode = weatherData["weather_code"];

    var index = times.indexOf(formattedTime);

    if (index != -1) {
      return {
        "temp": temperatures[index],
        "rain": rain[index],
        "cloud": cloud[index],
        "wmo": weatherCode[index],
      };
    } else {
      throw Exception('Weather data not available for the specified time.');
    }
  }
}