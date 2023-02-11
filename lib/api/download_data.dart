import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sat_tracker/model/satellite_model.dart';

class DownloadDataScreen extends StatelessWidget {
  const DownloadDataScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          backgroundColor: Colors.lightBlue,
          centerTitle: true,
          title: const Text('Data Download',
              style: TextStyle(color: Colors.white)),
        ),
        body: Container(
            margin: const EdgeInsets.all(15),
            child: Form(
                key: formKey,
                child: Container(
                    margin: const EdgeInsets.only(left: 20, right: 20),
                    child: ListView(
                      children: [
                        ElevatedButton(
                            onPressed: (){
                              getHTTP();
                            },
                            child: const Text("Download Data",
                            style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    )))));
  }
}

Future<List<DataModel>> getHTTP() async
{
  var headers = {
    'Content-Type': 'application/x-www-form-urlencoded',
    'Cookie': 'chocolatechip=u3tifs0tm1c299t2t82es58d5eus33e4'
  };
  var request = http.Request('POST', Uri.parse('https://www.space-track.org/ajaxauth/login'));
  request.bodyFields = {
    'identity': 'poso.draxy@gmail.com',
    'password': '9kj39-Btb8xUB58',
    'query': 'https://www.space-track.org/basicspacedata/query/class/gp/EPOCH/%3Enow-30/orderby/NORAD_CAT_ID,EPOCH/format/json'
  };

  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200)
  {
    final List result = jsonDecode(response.body)['data']; // data?
    return result.map((e) => DataModel.fromJson(e)).toList();
  }
  else
  {
    throw Exception(response.reasonPhrase);
  }
}
