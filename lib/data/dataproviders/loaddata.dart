import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/satellite.dart';

class LoadData
{
  late List<Satellite> _satellites;
  late Map<String, Satellite> _satelliteMap;

  List<Satellite> get satellites => _satellites;

  Future<void> loadSatellites() async {
    final prefs = await SharedPreferences.getInstance();
    final filePath = prefs.getString('satellitesFilePath');
    if (filePath != null) {
      final file = File(filePath);
      if (await file.exists()) {
        final jsonString = await file.readAsString();
        if (kDebugMode) {
          print('JSON data loaded from file: $jsonString');
        }
        final jsonData = jsonDecode(jsonString);
        _satellites = List<Satellite>.from(
            jsonData.map((e) => Satellite.fromJson(e))
        );
        _preprocessSatellites();
      } else {
        throw Exception('Data file does not exist: $filePath');
      }
    } else {
      throw Exception('File path not found in shared preferences');
    }
  }
  void _preprocessSatellites() {
    try {
      _satelliteMap = { for (var satellite in _satellites) satellite.name.toLowerCase() : satellite };
    } catch (e) {
      if (kDebugMode) {
        print('Error preprocessing satellites: $e');
      }
      _satelliteMap = {};
    }
  }

  List<Satellite> searchSatellites(String query) {
    try {
      if (query.isEmpty) {
        return _satellites;
      }
      final filteredList = _satelliteMap.entries
          .where((entry) => entry.key.contains(query))
          .map((entry) => entry.value)
          .toList();
      return filteredList;
    } catch (e) {
      if (kDebugMode) {
        print('Error searching satellites: $e');
      }
      return [];
    }
  }
}
