import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/satellite_model.dart';

class LoadData {
  List<SatelliteData> satellites = [];

  Future<List<SatelliteData>> loadSatellites({void Function(double)? onProgress}) async {
    List<SatelliteData>  _satelliteList = [];

    final prefs = await SharedPreferences.getInstance();
    final filePath = prefs.getString('satellitesFilePath');

    if (filePath != null) {
      final file = File(filePath);
      if (await file.exists()) {
        final totalBytes = await file.length();
        final progressStream = file.openRead().cast<List<int>>();
        var loadedBytes = 0;
        await for (final chunk in progressStream) {
          loadedBytes += chunk.length;
          final progress = loadedBytes / totalBytes;
          if (onProgress != null) {
            onProgress(progress);
          }
          // Concatenate all chunks into a single list
          final bytes = chunk.toList();
          final jsonString = utf8.decode(bytes);
          //final jsonString = await file.readAsString();
          final jsonData = jsonDecode(jsonString);
          _satelliteList = List<SatelliteData>.from(
              jsonData.map((e) => SatelliteData.fromJson(e)));

          if (kDebugMode) {
            print('JSON data loaded from file: $jsonString');
          }
        }
      } else {
        debugPrint('\n\n File path not found in shared preferences \n\n');
        // throw Exception('File path not found in shared preferences');
      }
    }
    return _satelliteList;
  }
}
