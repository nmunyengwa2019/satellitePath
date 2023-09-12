import 'package:flutter/material.dart';

import '../../constants.dart';
import 'package:sat_tracker/globals.dart' as globals;

import 'presentation/screens/search_screen.dart';

class SatelliteGroups extends StatefulWidget {
  static String routeName = "/group_names_screen";
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
            ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => SearchScreen(
                                satelliteNames: [],
                              )),
                      ModalRoute.withName('/download_screen'));
                },
                child: Text("NAV")),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: globals.satelliteGroupNames.length,
                itemBuilder: (context, i) {
                  // dismissLoader();
                  return MenuLineSimpleWithArgs(
                      title: globals.satelliteGroupNames[i],
                      routeName: SearchScreen.routeName,
                      args: const {
                        // "name": globals.satelliteGroupCatRange[i],
                        // "firstLineElement": "val",
                        // "secondLineElement": "val2"
                      },
                      callback: () {
                        globals.selectedGroupIndex = i;
                        return true;
                      });
                },
              ),
            ),
          ],
        )),
      ),
    );
  }
}
