import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/satellite.dart';

class LoadData {
  late List<Satellite> _satellites;

  List<Satellite> get satellites => _satellites;

  Future<void> loadSatellites() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('satellites');
    if (jsonString != null) {
      final jsonData = jsonDecode(jsonString);
      _satellites = jsonData.map((e) => Satellite.fromJson(e)).toList();
    } else {
      throw Exception('Failed to read data from local storage');
    }
  }
}
