import 'package:flutter/material.dart';
// import 'package:sat_tracker/default_button.dart';

import '../../constants.dart';
import 'package:sat_tracker/globals.dart' as globals;

import 'presentation/screens/downloadScreen.dart';
import 'presentation/screens/search_screen.dart';

class SatelliteGroups extends StatefulWidget {
  static String routeName = "/home";
  const SatelliteGroups({Key? key}) : super(key: key);

  @override
  State<SatelliteGroups> createState() => _SatelliteGroupsState();
}

class _SatelliteGroupsState extends State<SatelliteGroups> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
            child: Column(
          children: [
            const StyleAppBar(
              title: 'Satellite Groups',
            ),

            // ElevatedButton(
            //     onPressed: () {
            //       Navigator.pushAndRemoveUntil(
            //           context,
            //           MaterialPageRoute(
            //               builder: (BuildContext context) => SearchScreen(
            //                     satelliteNames: [],
            //                   )),
            //           ModalRoute.withName('/download_screen'));
            //     },

            //     child: const Text("NAV.."),
            //     ),
            DefaultButton(
                text: "Irridium",
                press: () {
                  globals.isIrridium = true;
                  globals.displayName = "Irridium";
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DownloadScreen()),
                  );
                  // Navigator.pushAndRemoveUntil(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (BuildContext context) => DownloadScreen(
                  //               satelliteNames: const [],
                  //             )),
                  //     ModalRoute.withName('/download_screen'));
                }),

            DefaultButton(
                text: "Weather Satellites",
                press: () {
                  globals.isIrridium = false;
                  globals.displayName = "Weather Satellites";
                  globals.minCatId = 1000;
                  globals.maxCatId = 1999;
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DownloadScreen()),
                  );
                }),
            DefaultButton(
                text: "Radar Satellites",
                press: () {
                  globals.isIrridium = false;
                  globals.displayName = "Radar Satellites";
                  globals.minCatId = 2000;
                  globals.maxCatId = 2999;
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DownloadScreen()),
                  );
                }),
            DefaultButton(
                text: "Communication Satellite",
                press: () {
                  globals.isIrridium = false;
                  globals.displayName = "Communication Satellite";
                  globals.minCatId = 3000;
                  globals.maxCatId = 3999;
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DownloadScreen()),
                  );
                }),
            DefaultButton(
                text: "Navigation Satellites (GPS)",
                press: () {
                  globals.isIrridium = false;
                  globals.displayName = "Navigation Satellites (GPS)";
                  globals.minCatId = 5000;
                  globals.maxCatId = 5999;
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DownloadScreen()),
                  );
                }),
            DefaultButton(
                text: "Earth Observation Satellites",
                press: () {
                  globals.isIrridium = false;
                  globals.displayName = "Earth Observation";
                  globals.minCatId = 4000;
                  globals.maxCatId = 4999;
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DownloadScreen()),
                  );
                }),
          ],
        )),
      ),
    );
  }
}
