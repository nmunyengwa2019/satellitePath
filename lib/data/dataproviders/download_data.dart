import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sat_tracker/data/models/satellite_model.dart';

import '../../business_logic/blocs/app_states.dart';


class UserRepository {
  Future<UserState> getSatellites() async {

    String url = 'https://www.space-track.org/ajaxauth/login';

    final response = await http.post(Uri.parse(url), body: {
      'identity': 'poso.draxy@gmail.com',
      'password': '9kj39-Btb8xUB58',
      'query':
          'https://www.space-track.org/basicspacedata/query/class/gp/EPOCH/%3Enow-30/orderby/NORAD_CAT_ID,EPOCH/format/json'
    }, headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Cookie': 'chocolatechip=u3tifs0tm1c299t2t82es58d5eus33e4'
    });

    if (response.statusCode == 200) {
      final List result = jsonDecode(response.body);
      List<DataModel> results = result.map((e) => DataModel.fromJson(e)).toList();
      return Loaded(data: results);
    } else {
      return Error();
    }
  }
}
