import 'package:fluro/fluro.dart';
import 'package:fluro/fluro.dart' as fluro;
import 'package:flutter/material.dart';
// import 'package:sat_tracker/presentation/screens/groupNames.dart';

import 'main.dart';

import 'presentation/screens/downloadScreen.dart';
import 'presentation/screens/plottingScreen.dart';
import 'presentation/screens/search_screen.dart';

//final sessionStateStream = StreamController<SessionState>();
class SateliteRouter {
  static const defaultPath = '/home';
  //static fluro.Router router= fluro.Router();
  static final router = FluroRouter();

  //router = Router();
  static var routes = {
    defaultPath: (context) => MyApp(),
    SearchScreen.routeName: (context) => SearchScreen(
          satelliteNames: [],
        ),
    DownloadScreen.routeName: (context) => DownloadScreen(),
    MapScreen.routeName: (context) => MapScreen(
          positions: [],
          title: '',
        ),
    // DownloadScreen.routeName: (context) => DownloadScreen(),
    // SatelliteGroups.routeName: (context) => SatelliteGroups(),
  };
  static final List<Map> _routeDefinitionList = [
    {
      "name": defaultPath,
      "handler": _setUpHandler(
        MyApp(),
      )
    },
    {
      "name": MyApp.routeName,
      "handler": _setUpHandler(
        MyApp(),
      )
    },
  ];

  static void setupRouter() {
    _routeDefinitionList.forEach((item) {
      print(item['name']);
      router.define(item['name'],
          handler: item['handler'],
          transitionType: fluro.TransitionType.native);
    });
  }

  // var usersHandler = Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  //   return UsersScreen(params["id"][0]);
  // });

  static fluro.Handler _setUpHandler(Widget? screen) => fluro.Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) =>
          screen);
}
