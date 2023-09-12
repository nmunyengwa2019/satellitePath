import 'package:flutter/material.dart';
import 'package:sat_tracker/constants.dart';

import 'default_button.dart';
import 'globals.dart' as globals;
import 'presentation/screens/downloadScreen.dart';

class LandingPage extends StatefulWidget {
  static String routeName = "/landing_screen";
  const LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          StyleAppBar(title: "Satellite Tracker"),
          DefaultButton(
              text: "Irridium Satellites",
              press: () {
                Navigator.pushNamed(context, DownloadScreen.routeName);
              }),
          DefaultButton(
              text: "Weather Satellites",
              press: () {
                Navigator.pushNamed(context, DownloadScreen.routeName);
                setState(() {
                  globals.isIrridium = false;
                  globals.minCatId = 1000;
                  globals.maxCatId = 1999;
                });
              }),
          DefaultButton(
              text: "Radar Satellites",
              press: () {
                Navigator.pushNamed(context, DownloadScreen.routeName);
                setState(() {
                  globals.isIrridium = false;
                  globals.minCatId = 2000;
                  globals.maxCatId = 2999;
                });
              }),
          DefaultButton(
              text: "Communication Satellite",
              press: () {
                Navigator.pushNamed(context, DownloadScreen.routeName);
                setState(() {
                  globals.isIrridium = false;
                  globals.minCatId = 3000;
                  globals.maxCatId = 3999;
                });
              }),
          DefaultButton(
              text: "Navigation Satellites (GPS)",
              press: () {
                Navigator.pushNamed(context, DownloadScreen.routeName);
                setState(() {
                  globals.isIrridium = false;
                  globals.minCatId = 5000;
                  globals.maxCatId = 5999;
                });
              }),
          DefaultButton(
              text: "Earth Observation Satellites",
              press: () {
                Navigator.pushNamed(context, DownloadScreen.routeName);
                setState(() {
                  globals.isIrridium = false;
                  globals.minCatId = 4000;
                  globals.maxCatId = 4999;
                });
              }),
        ],
      )),
    );
  }
}
