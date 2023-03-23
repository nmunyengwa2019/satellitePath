import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:sat_tracker/presentation/NavBar.dart';
import 'package:flutter_map/flutter_map.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Tracker'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavBar(),
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
            urlTemplate: "https://api.mapbox.com/styles/v1/posodraxy07/clffu65ku000p01n4xfcjajw6/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoicG9zb2RyYXh5MDciLCJhIjoiY2xmZTA4Z3MxMTQzMDN3bjE0b2F0d2U3MyJ9.kIqo5BZGehAJbdr5s3C5_Q",
            additionalOptions: const {
              "access_token": "pk.eyJ1IjoicG9zb2RyYXh5MDciLCJhIjoiY2xmZTA4Z3MxMTQzMDN3bjE0b2F0d2U3MyJ9.kIqo5BZGehAJbdr5s3C5_Q",
              "id": "mapbox.satellite",
            },
            userAgentPackageName: 'com.example.app',
          ),
        ],
      )
    );
  }
}