import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sat_tracker/presentation/NavBar.dart';
import 'package:flutter_map/flutter_map.dart';

void main() async
{
  WidgetsFlutterBinding.ensureInitialized();
// Allow permissions to save data locally
  if (!kIsWeb) {
    await Permission.storage.request();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget
{
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context)
  {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Tracker'),
    );
  }
}

class MyHomePage extends StatefulWidget
{
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavBar(satellites: [],),
      appBar: AppBar(
        title: const Text('SideBar'),
      ),
      body: FlutterMap(
        options: MapOptions(
          center: LatLng(51.5, -0.09),
          zoom: 1.0,
        ),
        layers: [
          TileLayerOptions(
            //urlTemplate: 'http://maps.stamen.com/m2i/image/20230420/toner-lite_TrS8Uisw4TA',
            urlTemplate: 'https://stamen-tiles.a.ssl.fastly.net/terrain/{z}/{x}/{y}.jpg',
            userAgentPackageName: 'com.example.app',
          ),
          PolylineLayerOptions(
            polylines: [
              Polyline(
                points: [
                  LatLng(55.64, -156.14), //
                  LatLng(58.73, -105.14), //
                  LatLng(39.30, -67.54), //
                  LatLng(-4.90, -26.70), //
                  LatLng(-41.73, 7.74), //
                  LatLng(-49.73, 37.83), //
                  LatLng(-43.24, 88.45), //
                  LatLng(10.59, 145.50), //
                  //LatLng(46.87, -172.39), //
                  //LatLng(57.20, -140.23), //
                  //LatLng(63.60, -101.20), //
                ],
                color: Colors.blue,
                strokeWidth: 2,
              ),
            ],
          )
        ],
      )
    );
  }
}
