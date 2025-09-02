import 'package:flutter/material.dart';
import 'package:task_manager/services/transport_data_service.dart';

class TransportDataProvider extends ChangeNotifier {
  List<List<String>> trips = [];
  bool isLoading = false;

  final TransportDataService _service = TransportDataService();

  Future<void> getTrips((double, double) startLocation, (double, double, String) arrivalLocation) async {
    isLoading = true;
    notifyListeners();

    final query = _service.prepareQuery(startLocation, arrivalLocation);
    trips = await _service.parsedQuery(query);

    isLoading = false;
    notifyListeners();
  }
}