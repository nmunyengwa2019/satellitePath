import 'package:flutter/material.dart';
import 'package:sat_tracker/screens/form_results_widgets.dart';

TextEditingController name = TextEditingController();
TextEditingController lineOne = TextEditingController();
TextEditingController lineTwo = TextEditingController();

class NameField extends StatelessWidget {
  const NameField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        controller: name,
        keyboardType: TextInputType.text,
        validator: (value) {
          if (value!.isEmpty) {
            return "name is required";
          }
          return null;
        },
        decoration: const InputDecoration(
          hintText: 'Name',
          labelText: 'Name',
          labelStyle: TextStyle(
            fontSize: 15,
            color: Colors.black,
            fontWeight: FontWeight.normal,
          ),
        ));
  }
}

class LineOneField extends StatelessWidget {
  const LineOneField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        controller: lineOne,
        keyboardType: TextInputType.text,
        validator: (value) {
          if (value!.isEmpty) {
            return "line one is required";
          }
          return null;
        },
        decoration: const InputDecoration(
          hintText: 'Line One',
          labelText: 'Line One',
          labelStyle: TextStyle(
            fontSize: 15,
            color: Colors.black,
            fontWeight: FontWeight.normal,
          ),
        ));
  }
}

class LineTwoField extends StatelessWidget {
  const LineTwoField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        controller: lineTwo,
        keyboardType: TextInputType.text,
        validator: (value) {
          if (value!.isEmpty) {
            return "line two is required";
          }
          return null;
        },
        decoration: const InputDecoration(
          hintText: 'Line Two',
          labelText: 'Line Two',
          labelStyle: TextStyle(
            fontSize: 15,
            color: Colors.black,
            fontWeight: FontWeight.normal,
          ),
        ));
  }
}

class SubmitBtn extends StatelessWidget {
  final GlobalKey<FormState> formKey;

  const SubmitBtn({Key? key, required this.formKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Center(
            child: TextButton(
                style: TextButton.styleFrom(
                    backgroundColor: Colors.blue,
                    elevation: 5,
                    shape: const StadiumBorder(),
                    fixedSize: Size(MediaQuery.of(context).size.width * 0.5,
                        MediaQuery.of(context).size.width * 0.07)),
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FormResultsScreen(name: name)),
                    );
                  } else {
                    SnackBar snackBar = const SnackBar(
                        content: Text('Error !',
                            style: TextStyle(color: Colors.white)),
                        backgroundColor: Colors.red);
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                },
                child: Text(
                  'Track'.toUpperCase(),
                  style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ))));
  }
}
