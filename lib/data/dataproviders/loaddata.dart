import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/satellite.dart';

class LoadData
{
  late List<Satellite> _satellites;

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
      } else {
        throw Exception('Data file does not exist: $filePath');
      }
    } else {
      throw Exception('File path not found in shared preferences');
    }
  }
}
