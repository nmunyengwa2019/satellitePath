import 'package:flutter/material.dart';
import 'package:sat_tracker/widgets/form_widgets.dart';
import 'package:dio/dio.dart';


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
                        Container(
                            margin: const EdgeInsets.only(top: 30),
                            child: const NameField()),
                        Container(
                            margin: const EdgeInsets.only(top: 30),
                            child: SubmitBtn(formKey: formKey))
                      ],
                    )))));
  }
}



void getHTTP() async
{
  try
  {
    var response = await Dio().get("");
    print(response);
  } catch(e)
  {
    print(e);
  }
}