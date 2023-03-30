import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:sat_tracker/data/models/satellite_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SatellitesData
{
  get defaultData => null; // need to store default satellites data

  Future saveJsonData(jsonData) async
  {
    final prefs = await SharedPreferences.getInstance();
    var saveData = jsonEncode(jsonData);
    await prefs.setString('jsonData', saveData);
  }

  Future<void> getJsonData() async
  {
    final prefs = await SharedPreferences.getInstance();
    var temp = prefs.getString('jsonData') ?? defaultData;
    debugPrint('Data received: $temp');
    var data = DataModel.fromJson(jsonDecode(temp.toString()));
  }
}
