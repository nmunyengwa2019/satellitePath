import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:sat_tracker/globals.dart' as globals;
import 'package:awesome_dialog/awesome_dialog.dart';

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
  List<LatLng> finalLatLong = globals.positions.toList();
  // List<LatLng>

  List<Marker> _markers = [];
  void setMarkers() async {
    List<Marker> markers = globals.positions.map((n) {
      LatLng point = LatLng(n.latitude, n.longitude);

      return Marker(
        width: 80.0,
        height: 80.0,
        point: point,
        builder: (context) => GestureDetector(
          onTap: () {
            print("Location data $point \n");
            AwesomeDialog(
              context: context,
              dialogType: DialogType.infoReverse,
              headerAnimationLoop: true,
              animType: AnimType.bottomSlide,
              title: 'INFO',
              reverseBtnOrder: true,
              btnOkOnPress: () {},
              desc:
                  'Latitude: ${point.latitude}\n Longitude: ${point.longitude}',
            ).show();
          },
          child: Icon(
            Icons.location_on,
            color: Color.fromARGB(255, 238, 40, 5),
            size: 30,
          ),
        ),
      );
    }).toList();

    print("FINAL LATLONG >>> $finalLatLong");

    setState(() {
      _markers.clear();
      _markers = markers;
    });
  }

  @override
  void initState() {
    print(">>>>Globals values>>>");

    print(globals.positions);
    print(">>>>Done printing>>>");
    // TODO: implement initState
    super.initState();
    setMarkers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(globals.satelliteName),
      ),
      body: FlutterMap(
        options: MapOptions(
          center: finalLatLong.first,
          zoom: 3.0,
        ),
        layers: [
          TileLayerOptions(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.app',
          ),
          PolylineLayerOptions(
            polylines: [
              Polyline(
                isDotted: false,
                strokeCap: StrokeCap.round,
                points: finalLatLong,
                color: Color.fromARGB(255, 243, 82, 33),
                strokeWidth: 2,
              ),
            ],
          ),
          MarkerLayerOptions(markers: _markers),
        ],
      ),
    );
  }
}
