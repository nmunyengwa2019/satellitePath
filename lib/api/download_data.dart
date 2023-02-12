import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sat_tracker/model/satellite_model.dart';

class UserRepository
{
  var headers = {'Content-Type': 'application/x-www-form-urlencoded',
    'Cookie': 'chocolatechip=u3tifs0tm1c299t2t82es58d5eus33e4'
  };

  var request = http.Request('POST', Uri.parse('https://www.space-track.org/ajaxauth/login'));

  Future<List<DataModel>> getSatellites() async
  {
    request.bodyFields = { 'identity': 'poso.draxy@gmail.com', 'password': '9kj39-Btb8xUB58',
      'query': 'https://www.space-track.org/basicspacedata/query/class/gp/EPOCH/%3Enow-30/orderby/NORAD_CAT_ID,EPOCH/format/json'
    };

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final List result = jsonDecode(response.body)['data']; // data?
      return result.map((e) => DataModel.fromJson(e)).toList();
    }
    else {
      throw Exception(response.reasonPhrase);
    }
  }
}
