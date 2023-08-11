import 'package:flutter/material.dart';
import '../../data/models/satellite.dart';
import '../../main.dart';

class SatelliteScreen extends StatefulWidget {
  final String selectedSatelliteName;
  final String selectedSatelliteTleLine1;
  final String selectedSatelliteTleLine2;

  const SatelliteScreen({
    Key? key,
    required this.selectedSatelliteName,
    required this.selectedSatelliteTleLine1,
    required this.selectedSatelliteTleLine2,
  }) : super(key: key);

  @override
  _SatelliteScreenState createState() => _SatelliteScreenState();
}

class _SatelliteScreenState extends State<SatelliteScreen> {
  late Satellite _satellite;

  @override
  void initState() {
    super.initState();
    _satellite = Satellite(
      name: widget.selectedSatelliteName,
      tleLine1: widget.selectedSatelliteTleLine1,
      tleLine2: widget.selectedSatelliteTleLine2,
    );
    //_satellite.calculatePositions(selectedSatelliteName: widget.selectedSatelliteName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.selectedSatelliteName),
      ),
      body: MapScreen(
        satellite: _satellite, title: '',
      ),
    );
  }
}