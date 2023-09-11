import 'package:flutter/material.dart';

import 'colors.dart';

typedef MyCallback = bool Function();

class MenuLineSimpleWithArgs extends StatelessWidget {
  final String title;
  final routeName;
  final Map<String, String> args;
  final MyCallback? callback;

  MenuLineSimpleWithArgs(
      {required this.title,
      required this.routeName,
      required this.args,
      this.callback})
      : super();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      height: 45,
      child: GestureDetector(
        onTap: () {
          // keepAlive();
          bool x = callback!();
          if (x) {
            Navigator.pushNamed(context, routeName, arguments: args);
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: kPrimaryColor),
                borderRadius: BorderRadius.circular(20)),
            child: Center(
                child: Text(
              title,
              maxLines: 1,
              style: TextStyle(
                  fontSize: 17,
                  color: kPrimaryColor,
                  fontWeight: FontWeight.w500),
            )),
          ),
        ),
      ),
    );
  }
}
