import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'colors.dart';
import 'globals.dart' as globals;
import '../main.dart';
import '../size_config.dart';

final ButtonStyle buttonStyle = ElevatedButton.styleFrom(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(25.0),
    ),
    // backgroundColor: kPrimaryColor,
    primary: kPrimaryColor);

class DefaultButton extends StatefulWidget {
  const DefaultButton({
    required this.text,
    required this.press,
  }) : super();
  final String text;
  final VoidCallback press;

  @override
  State<DefaultButton> createState() => _DefaultButtonState();
}

class _DefaultButtonState extends State<DefaultButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: SizedBox(
        width: double.infinity,
        height: getProportionateScreenHeight(45),
        child: ElevatedButton(
          style: buttonStyle,
          onPressed: () {
            widget.press();
            // keepAlive();
          },
          child: Text(
            widget.text,
            style: TextStyle(
              fontSize: getProportionateScreenWidth(18),
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class FrameButton extends StatelessWidget {
  const FrameButton({
    required this.text,
    required this.press,
  }) : super();
  final String text;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: SizedBox(
        width: double.infinity,
        height: getProportionateScreenHeight(40),
        child: ElevatedButton(
          style: buttonStyle,
          onPressed: press,
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class SmallButton extends StatelessWidget {
  const SmallButton({
    required this.text,
    required this.press,
  }) : super();
  final String text;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: SizedBox(
        width: double.infinity,
        height: getProportionateScreenHeight(56),
        child: ElevatedButton(
          style: buttonStyle,
          //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          //color: kPrimaryColor,
          onPressed: press,
          child: Text(
            text,
            style: TextStyle(
              fontSize: getProportionateScreenWidth(12),
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
