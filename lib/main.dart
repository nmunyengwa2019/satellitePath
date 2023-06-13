import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_map/flutter_map.dart';

import 'data/dataproviders/loaddata.dart';
import 'data/models/satellite.dart';
//import 'package:sgp4dart/sgp4dart.dart';

void main() async
{
  WidgetsFlutterBinding.ensureInitialized();
  final loadData = LoadData();
  await loadData.loadSatellites();
// Allow permissions to save data locally
  if (!kIsWeb) {
    await Permission.storage.request();
  }

  runApp(MyApp(loadData: loadData));
}

class MyApp extends StatefulWidget {
  final LoadData loadData;

  const MyApp({Key? key, required this.loadData}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late List<Satellite> _satellites;

  @override
  void initState() {
    super.initState();
    _loadSatellites();
  }

  Future<void> _loadSatellites() async {
    try {
      await widget.loadData.loadSatellites();
      setState(() {
        _satellites = widget.loadData.satellites;
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error loading satellites: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_satellites == null) {
      return const CircularProgressIndicator();
    }
    return MaterialApp(
      title: 'Satellite Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MapScreen(title: 'Tracker', satellite: _satellites.first),
    );
  }
}

class MapScreen extends StatefulWidget
{
  final Satellite satellite;
  final String title;

  const MapScreen({Key? key, required this.title, required this.satellite}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late List<LatLng> _positions;

  @override
  void initState() {
    super.initState();
    _calculatePositions();
  }

  Future<void> _calculatePositions() async {
    final tleLine1 = widget.satellite.tleLine1;
    final tleLine2 = widget.satellite.tleLine2;
    final satellite = Satellite.fromTle(tleLine1, tleLine2);

    setState(() {
      _positions = satellite.positions;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_positions == null) {
      return const CircularProgressIndicator();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.satellite.name),
      ),
      body: FlutterMap(
        options: MapOptions(
          center: _positions.first,
          zoom: 3.0,
        ),
        layers: [
          TileLayerOptions(
            urlTemplate: 'https://stamen-tiles.a.ssl.fastly.net/terrain/{z}/{x}/{y}.jpg',
            userAgentPackageName: 'com.example.app',
          ),
          PolylineLayerOptions(
            polylines: [
              Polyline(
                points: _positions,
                color: Colors.blue,
                strokeWidth: 2,
              ),
            ],
          ),
          MarkerLayerOptions(
            markers: [
              Marker(
                point: _positions.first,
                builder: (context) => const Icon(
                  Icons.location_on,
                  color: Colors.red,
                  size: 40,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
