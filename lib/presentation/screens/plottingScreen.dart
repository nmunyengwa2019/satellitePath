import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatefulWidget {
  final String title;
  final List<LatLng> positions;

  const MapScreen({Key? key, required this.title, required this.positions})
      : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  List<LatLng> finalLatLong = [
    LatLng(38.73, -9.14),
    LatLng(51.50, -0.12),
    LatLng(52.37, 4.90)
  ];
  List<Marker> _markers = [];
  void setMarkers() async {
    List<Marker> markers = widget.positions.map((n) {
      LatLng point = LatLng(n.latitude, n.longitude);

      return Marker(
        width: 80.0,
        height: 80.0,
        point: point,
        builder: (context) => Icon(
          Icons.location_on,
          color: Color.fromARGB(255, 238, 40, 5),
          size: 30,
        ),
      );
    }).toList();

    print("Markers >>> $markers");

    setState(() {
      _markers.clear();
      _markers = markers;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setMarkers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Test View'),
      ),
      body: FlutterMap(
        options: MapOptions(
          center: finalLatLong.first,
          zoom: 3.0,
        ),
        layers: [
          TileLayerOptions(
            urlTemplate:
                'https://stamen-tiles.a.ssl.fastly.net/terrain/{z}/{x}/{y}.jpg',
            userAgentPackageName: 'com.example.app',
          ),
          PolylineLayerOptions(
            polylines: [
              Polyline(
                isDotted: true,
                strokeCap: StrokeCap.round,
                points: finalLatLong,
                color: Color.fromARGB(255, 243, 82, 33),
                strokeWidth: 5,
              ),
            ],
          ),
          MarkerLayerOptions(markers: _markers),
        ],
      ),
    );
  }
}
