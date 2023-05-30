import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/satellite_model.dart';

class ApiClient
{
  const ApiClient();

  static const String _baseURL = "https://www.space-track.org";
  static const String _authPath = "/ajaxauth/login";
  static const String _userName = "poso.draxy@gmail.com";
  static const String _password = "9kj39-Btb8xUB58";
  static const String _query = "/basicspacedata/query/class/gp/EPOCH/%3Enow-30/orderby/NORAD_CAT_ID,EPOCH/format/json";
  static const String _cookie = 'chocolatechip=4uqbo14lukj1q10m0shuq7b144ogeprm';

  Future<void> downloadSatellites(void Function(double) onProgress) async
  {
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

        // Request external storage permission
        var permissionStatus = await Permission.storage.request();
        if (permissionStatus.isDenied)
        {
          throw Exception('External storage permission is required');
        }

        // Save data to local storage
        var directory = await getApplicationDocumentsDirectory();
        if (directory == null) {
          throw Exception('Failed to access application documents directory');
        }

        var filePath = '${directory.path}/satellites.json';
        var file = File(filePath);

        if (await file.exists()) await file.delete();

        // Extract the required fields from the JSON response
        var jsonData = jsonDecode(utf8.decode(responseBody));
        var satellites = jsonData.map((e) => DataModel.fromJson({
          'OBJECT_NAME': e['OBJECT_NAME'],
          'TLE_LINE0': e['TLE_LINE0'],
          'TLE_LINE1': e['TLE_LINE1'],
          'TLE_LINE2': e['TLE_LINE2']
        })).toList();

        // Write the JSON data to a file in external storage
        var progress = 0.5;
        file.writeAsString(jsonEncode(satellites)).asStream().listen((event)
        {
          // Report progress as the data is being written to the file
          onProgress(progress);
          progress += 0.01; // Increase progress by 1% each time
        });

        // Save the JSON data to shared preferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('satellitesFilePath', filePath);

        // Save timestamp to shared preferences
        await prefs.setInt('lastUpdateTime', DateTime
            .now()
            .millisecondsSinceEpoch);

        if (kDebugMode) {
          print('Data saved to local storage');
        }
      }
      else {
        if (kDebugMode) {
          print(
              'Server response status code is not 200: ${response.statusCode}');
          throw Exception(
              'Server responded with status code ${response.statusCode}');
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

    // Read data from local storage
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('satellites');
    if (jsonString != null)
    {
      final data = jsonDecode(jsonString);
      if (kDebugMode) {
        print(data);
      }
    }
    else
    {
      throw Exception('Failed to read data from local storage');
    }
  }
}
