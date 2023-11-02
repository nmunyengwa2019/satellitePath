import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:sat_tracker/globals.dart' as globals;

import '../../constants.dart';

class MapScreen extends StatefulWidget {
  static String routeName = "/plotting_screen";
  final String title;
  final List<LatLng> positions;

  const MapScreen({Key? key, required this.title, required this.positions})
      : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  List<LatLng> finalLatLong = [...globals.positions];

  List<Marker> _markers = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            StyleAppBar(
              title: globals.displayName,
            ),
            Flexible(
              child: FlutterMap(
                options: MapOptions(
                  center: finalLatLong.isNotEmpty
                      ? finalLatLong.first
                      : LatLng(0, 0),
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
                        isDotted: false,
                        strokeCap: StrokeCap.round,
                        strokeJoin: StrokeJoin.round,
                        points: finalLatLong,
                        color: Color.fromARGB(255, 243, 82, 33),
                        strokeWidth: 3,
                      ),
                    ],
                  ),
                  MarkerLayerOptions(markers: _markers),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
