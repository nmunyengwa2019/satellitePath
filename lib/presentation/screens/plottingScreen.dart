import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';


class MapScreen extends StatelessWidget
{
  final String title;
  final List<LatLng> positions;

  const MapScreen({Key? key, required this.title, required this.positions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Test View'),
          ),
          body: FlutterMap(
            options: MapOptions(
              center: positions.first,
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
                    points: positions,
                    color: Colors.blue,
                    strokeWidth: 2,
                  ),
                ],
              ),
              MarkerLayerOptions(
                markers: [
                  Marker(
                    point: positions.first,
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