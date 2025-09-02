import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:task_manager/services/weather_service.dart';

class WeatherProvider with ChangeNotifier {
  String _temperature = '';
  String _errorMessage = '';
  List<int> _weatherCode = [];
  Map<String, dynamic> _weatherData = {};

  final WeatherService _weatherService = WeatherService();

  List<int> get weatherCode => _weatherCode;
  String get temperature => _temperature;
  String get errorMessage => _errorMessage;

  static const Map<int, String> _weatherIcons = {
    0: 'assets/sunny.svg',
    1: 'assets/clear.svg',
    2: 'assets/clear.svg',
    3: 'assets/clear.svg',
    45: 'assets/fog.svg',
    48: 'assets/fog.svg',
    51: 'assets/rain.svg',
    53: 'assets/rain.svg',
    55: 'assets/rain.svg',
    56: 'assets/rain.svg',
    57: 'assets/rain.svg',
    61: 'assets/rain.svg',
    63: 'assets/rain.svg',
    65: 'assets/rain.svg',
    66: 'assets/rain.svg',
    67: 'assets/rain.svg',
    71: 'assets/snow.svg',
    73: 'assets/snow.svg',
    75: 'assets/snow.svg',
    77: 'assets/snow.svg',
    80: 'assets/rain.svg',
    81: 'assets/rain.svg',
    82: 'assets/rain.svg',
    85: 'assets/snow.svg',
    86: 'assets/snow.svg',
    95: 'assets/storm.svg',
    96: 'assets/storm.svg',
    99: 'assets/storm.svg',
  };

  static const Map<int, String> _weatherType = {
    0: 'Clear sky',
    1: 'Mainly clear',
    2: 'Partly cloudy',
    3: 'Overcast',
    45: 'Fog',
    48: 'Depositing rime fog',
    51: 'Drizzle: Light',
    53: 'Drizzle: Moderate',
    55: 'Drizzle: Dense intensity',
    56: 'Freezing drizzle: Light',
    57: 'Freezing drizzle: Dense intensity',
    61: 'Rain: Slight',
    63: 'Rain: Moderate',
    65: 'Rain: Heavy intensity',
    66: 'Freezing rain: Light',
    67: 'Freezing rain: Heavy intensity',
    71: 'Snow fall: Slight',
    73: 'Snow fall: Moderate',
    75: 'Snow fall: Heavy intensity',
    77: 'Snow grains',
    80: 'Rain showers: Slight',
    81: 'Rain showers: Moderate',
    82: 'Rain showers: Violent',
    85: 'Snow showers: Slight',
    86: 'Snow showers: Heavy',
    95: 'Thunderstorm: Slight or moderate',
    96: 'Thunderstorm with slight hail',
    99: 'Thunderstorm with heavy hail',
  };

  String get weatherIcon {
    if (_weatherCode.isNotEmpty && _weatherIcons.containsKey(_weatherCode[0])) {
      return _weatherIcons[_weatherCode[0]]!;
    }
    return 'assets/temperature_icon.svg';
  }

  String get weatherType {
    if (_weatherCode.isNotEmpty && _weatherType.containsKey(_weatherCode[0])) {
      return _weatherType[_weatherCode[0]]!;
    }
    return 'Unknown';
  }

  Future<void> getWeather(String address) async {
    _errorMessage = ''; // Reset error message
    try {
      var locations = await locationFromAddress(address);
      var first = locations.first;
      _weatherData = await _weatherService.fetchWeather(first.latitude, first.longitude);

      var temperatures = _weatherData["temperature_2m"];
      _temperature = temperatures != null ? "${temperatures}°C" : "No data available";

      var weatherCode = _weatherData["weather_code"];
      _weatherCode = [weatherCode];

      notifyListeners();
    } catch (e) {
      _errorMessage = 'Error: $e';
      _temperature = 'Error'; // Optional: Show an error message for temperature
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> getWeatherAtTime(DateTime time) async {
    try {
      return _weatherService.getWeatherAtTime(_weatherData, time);
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return {
        "temp": "Data not available",
        "rain": "Data not available",
        "cloud": "Data not available",
      };
    }
  }
}