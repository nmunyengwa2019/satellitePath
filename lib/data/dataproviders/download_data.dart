import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/satellite_model.dart';

class ApiClient {
  const ApiClient();

  static const String _baseURL = "https://www.space-track.org";
  static const String _authPath = "/ajaxauth/login";
  static const String _userName = "poso.draxy@gmail.com";
  static const String _password = "9kj39-Btb8xUB58";
  static const String _query = "/basicspacedata/query/class/gp/ORDERBY/EPOCH%20desc/favorites/Iridium/format/json";
  static const String _cookie = 'chocolatechip=inkbbp1d328teh7dpfic57nth12tbefq';


  Future<void> downloadSatellites(void Function(double) onProgress) async {
    try
    {
      var headers =
      {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Cookie': _cookie
      };

      var response = await http.post(
          Uri.parse(_baseURL + _authPath),
          headers: headers,
          body: {
            'identity': _userName,
            'password': _password,
            'query': _baseURL + _query
          });

      if (response.statusCode == 200) {
        var responseBody = response.bodyBytes;

        // Check if local storage permission is already granted
        var permissionStatus = await Permission.manageExternalStorage.status;
        if (permissionStatus.isGranted)
        {
          var directory = await getApplicationDocumentsDirectory();
          var filePath = '${directory.path}/satellites.json';
          var file = File(filePath);
          if (await file.exists()) await file.delete();

          var jsonData = jsonDecode(utf8.decode(responseBody)); // Extract the required fields from the JSON response
          var satellites = jsonData.map((e) => SatelliteData.fromJson({
            'TLE_LINE0': e['TLE_LINE0'],
            'TLE_LINE1': e['TLE_LINE1'],
            'TLE_LINE2': e['TLE_LINE2']
          })).toList();
          var progress = 0.05;
          file.writeAsString(jsonEncode(satellites)).asStream().listen((event)
          {
            onProgress(progress); // Report progress as the data is being written to the file
            progress += 0.01; // Increase progress by 1% each time
          });

          final prefs = await SharedPreferences.getInstance(); // Save the JSON data to shared preferences
          await prefs.setString('satellitesFilePath', filePath);
          await prefs.setInt('lastUpdateTime', DateTime.now().millisecondsSinceEpoch); // Save timestamp to shared preferences

          if (kDebugMode) {
            print('Data saved to local storage');
          }
        }
      } else {
        if (kDebugMode) {
          print('Server response status code is not 200: ${response.statusCode}');
          throw Exception('Server responded with status code ${response.statusCode}');
        }
      }

// Log out after completing the request
      var logoutResponse = await http.get( Uri.parse(_baseURL + "/ajaxauth/logout"));
      if (logoutResponse.statusCode == 200)
      {
        if (kDebugMode)
        {
          print('Logged out successfully');
        }
      }
      else {
        if (kDebugMode) {
          print(logoutResponse.reasonPhrase);
        }
      }
    }
    on SocketException catch (e)
    {
      throw Exception('Failed to connect to server: $e');
    } on HttpException catch (e)
    {
      throw Exception('Failed to connect to server: $e');
    } on FormatException catch (e)
    {
      throw Exception('Invalid server response: $e');
    } catch (e)
    {
      throw Exception('Failed to download satellites: $e');
    }
  }
}
