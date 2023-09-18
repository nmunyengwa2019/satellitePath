import 'package:flutter/material.dart';
import 'package:sat_tracker/presentation/screens/downloadScreen.dart';
import 'package:open_app_settings/open_app_settings.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'landing_page.dart';
import 'sat_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  static final _navigatorKey = GlobalKey<NavigatorState>();
  NavigatorState get _navigator => _navigatorKey.currentState!;

  static String routeName = "/home";
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _permissionsGranted = false;
  bool _permissionsRequested = false;

  @override
  void initState() {
    super.initState();
    requestStoragePermissions();
  }

  Future<void> requestStoragePermissions() async {
    var status = await Permission.storage.request();
    if (status.isGranted) {
      setState(() {
        _permissionsGranted = true;
        print("permission granted");
      });
    } else if (!_permissionsRequested) {
      setState(() {
        _permissionsRequested = true;
      });

      // Request permissions again after a slight delay
      Future.delayed(const Duration(milliseconds: 500), () {
        requestStoragePermissions();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_permissionsGranted) {
      if (!_permissionsRequested) {
        return MaterialApp(
          initialRoute: DownloadScreen.routeName,
          routes: SateliteRouter.routes,
          // debugShowCheckedModeBanner: false,
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            backgroundColor: Colors.blue,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  SpinKitDoubleBounce(
                    color: Colors.white,
                    size: 50.0,
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Requesting Permissions...',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      } else {
        return MaterialApp(
          initialRoute: DownloadScreen.routeName,
          routes: SateliteRouter.routes,
          home: Scaffold(
            backgroundColor: Colors.blue,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Permissions Required',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      OpenAppSettings.openAppSettings();
                    },
                    child: const Text('Open Settings'),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    } else {
      return MaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: DownloadScreen.routeName,
          routes: SateliteRouter.routes,
          title: 'Satellite Tracker',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const DownloadScreen());
    }
  }
}
