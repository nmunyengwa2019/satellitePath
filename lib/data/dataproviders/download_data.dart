import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  const ApiClient();

  static const String _baseURL = "https://www.space-track.org";
  static const String _authPath = "/ajaxauth/login";
  static const String _userName = "poso.draxy@gmail.com";
  static const String _password = "9kj39-Btb8xUB58";
  static const String _query =
      "/basicspacedata/query/class/gp/EPOCH/%3Enow-30/orderby/NORAD_CAT_ID,EPOCH/format/json";
  static const String _cookie =
      'chocolatechip=4uqbo14lukj1q10m0shuq7b144ogeprm';

  Future<void> downloadSatellites(void Function(double) onProgress) async {
    try {

      String? cookie = await login();
      if(cookie == null){
        debugPrint('failed to login............');
      }
      else {
        var headers = {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Cookie': 'chocolatechip=$cookie'
        };

        var response = await http.post(Uri.parse(_baseURL + _authPath),
            headers: headers,
            body: {
              'identity': _userName,
              'password': _password,
              'query': _baseURL + _query
            });

        if (response.statusCode == 200) {
          var responseBody = response.bodyBytes;
          var totalBytes = responseBody.length;
          var downloadedBytes = 0;
          var chunkSize = 1024;
          //var chunkIndex = 0;

          // Save data to local storage
          var directory = await getExternalStorageDirectory();
          if (directory == null) {
            throw Exception('Failed to access external storage');
          }

          var filePath = '${directory.path}/satellites.json';
          var file = File(filePath);

          // Write the JSON data to a file in external storage
          await file.writeAsBytes(responseBody);

          final prefs = await SharedPreferences.getInstance();
          for (var i = 0; i < responseBody.length; i += chunkSize) {
            var chunkEnd = i + chunkSize;
            if (chunkEnd > responseBody.length) {
              chunkEnd = responseBody.length;
            }

            await prefs.setString(
                'satellites', utf8.decode(responseBody.sublist(i, chunkEnd)));

            downloadedBytes += chunkSize;
            onProgress(downloadedBytes / totalBytes);
          }

          // Save timestamp to shared preferences
          await prefs.setInt(
              'lastUpdateTime', DateTime.now().millisecondsSinceEpoch);

          if (kDebugMode) {
            print('Data saved to local storage');
          }
        } else {
          if (kDebugMode) {
            print(
                'Server response status code is not 200: ${response.statusCode}');
            throw Exception(
                'Server responded with status code ${response.statusCode}');
          }
        }

// Log out after completing the request
        var logoutResponse =
        await http.get(Uri.parse(_baseURL + "/ajaxauth/logout"));
        if (logoutResponse.statusCode == 200) {
          if (kDebugMode) {
            print('Logged out successfully');
          }
        } else {
          if (kDebugMode) {
            print(logoutResponse.reasonPhrase);
          }
        }
      }
    } on SocketException catch (e) {
      throw Exception('Failed to connect to server: $e');
    } on HttpException catch (e) {
      throw Exception('Failed to connect to server: $e');
    } on FormatException catch (e) {
      throw Exception('Invalid server response: $e');
    } catch (e) {
      throw Exception('Failed to download satellites: $e');
    }

    // Read data from local storage
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('satellites');
    if (jsonString != null) {
      final data = jsonDecode(jsonString);
      if (kDebugMode) {
        print(data);
      }
    } else {
      throw Exception('Failed to read data from local storage');
    }
  }

  Future<String?> login() async {
    Response response = await http.post(Uri.parse(_baseURL + _authPath), headers: {
      'Content-Type': 'application/x-www-form-urlencoded'
    }, body: {
      'identity': _userName,
      'password': _password,
      'query': _baseURL + _query
    });


    if(response.statusCode == 200){
      String rawCookie = response.headers['chocolatechip']!;
      int index = rawCookie.indexOf(';');
      String refreshToken = (index == -1) ? rawCookie : rawCookie.substring(0, index);
      int idx = refreshToken.indexOf("=");
      return refreshToken.substring(idx+1).trim();
    }
    else {
      return null;
    }

  }
}
