import 'package:flutter/material.dart';

import 'colors.dart';
import 'size_config.dart';

final ButtonStyle buttonStyle = ElevatedButton.styleFrom(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(25.0),
    ),
    backgroundColor: kPrimaryColor);

class DefaultButton extends StatefulWidget {
  const DefaultButton({
    Key? key,
    required this.text,
    required this.press,
  }) : super(key: key);
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
        // height: getProportionateScreenHeight(45),
        height: 45,
        child: ElevatedButton(
          style: buttonStyle,
          onPressed: () {
            widget.press();
          },
          child: Text(
            widget.text,
            style: TextStyle(
              // fontSize: getProportionateScreenWidth(18),
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

typedef MyCallback = bool Function();

class MenuLineSimpleWithArgs extends StatelessWidget {
  final String title;
  final String routeName;
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
              style: const TextStyle(
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

class StyleAppBar extends StatelessWidget {
  final String title;

  // final bool ? navToCategories;
  const StyleAppBar({
    required this.title,

    // ,this.navToCategories = false,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      margin: EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        //color: kPrimaryColor,
        color: kPrimaryColor,
        borderRadius: new BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Image.asset(
                    'assets/icons/left-arrow.png',
                    width: getProportionateScreenWidth(35),
                    color: Colors.white,
                  ),
                ),
              ),
              Expanded(
                  child: Center(
                child: Text(
                  title,
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w500),
                ),
              )),
              SizedBox(
                width: 60,
              )
            ],
          ),
        ],
      ),
    );
  }
}
