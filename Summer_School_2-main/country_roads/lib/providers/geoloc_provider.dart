import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:task_manager/services/geoloc_service.dart';

class GeolocProvider with ChangeNotifier {
  final GeolocService _geolocService = GeolocService();

  Position? _position;
  Position? get position => _position;

  bool _hasError = false;
  bool get hasError => _hasError;
  
  bool _isLoading = false;
  bool get isLoading => _position == null;
  
  GeolocProvider() {
    _determinePosition();
  }

  void setLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  Future<Position?> _determinePosition() async {
    setLoading(true);
    try {
      _position = await _geolocService.determinePosition();
      _hasError = false;
    }
    catch (e) {
      _position = null;
      _hasError = true;
    }
    setLoading(false);
    notifyListeners();
    return _position;
  }

  Future<Position?> determinePosition() async {
    return await _determinePosition();
  }
}