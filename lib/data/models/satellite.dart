import 'package:flutter/foundation.dart';
import 'package:sgp4_sdp4/sgp4_sdp4.dart';
import 'package:latlong2/latlong.dart';

class Satellite {
  final String name;
  final String tleLine1;
  final String tleLine2;
  final Orbit orbit;
  late final List<LatLng> positions;
  bool selected = false; // new property

  Satellite({required this.name, required this.tleLine1, required this.tleLine2})
      : orbit = Orbit(TLE(name, tleLine1, tleLine2)) {
    calculatePositions();
  }

  factory Satellite.fromJson(Map<String, dynamic> json) {
    return Satellite(
      name: json['OBJECT_NAME'],
      tleLine1: json['TLE_LINE1'],
      tleLine2: json['TLE_LINE2'],
    );
  }

  factory Satellite.fromTle(String tleLine1, String tleLine2) {
    final satelliteNumber = tleLine1.substring(2, 7).trim();
    return Satellite(
      name: satelliteNumber,
      tleLine1: tleLine1,
      tleLine2: tleLine2,
    );
  }

  Future<void> calculatePositions() async {
    final myLocation = Site.fromLatLngAlt(0, 0, 0);

    positions = [];

    for (int i = 0; i < 24; i++) {
      final dateTime = DateTime.now().add(Duration(hours: i));
      final double utcTime =
          Julian.fromFullDate(dateTime.year, dateTime.month, dateTime.day, dateTime.hour, dateTime.minute)
              .getDate() +
              6 / 24.0;

      final Eci eciPos =
      orbit.getPosition((utcTime - orbit.epoch().getDate()) * MIN_PER_DAY);

      final CoordGeo coord = eciPos.toGeo();
      if (coord.lon > PI) coord.lon -= TWOPI;

      positions.add(LatLng(rad2deg(coord.lat), rad2deg(coord.lon)));
    }
    if (kDebugMode) {
      print('Positions for satellite $name:');
    }
    for (int i = 0; i < 24; i++) {
      if (kDebugMode) {
        print('Position ${i + 1}: ${positions[i].latitude}, ${positions[i].longitude}');
      }
    }
  }

  Eci propagate(DateTime dateTime) {
    final double utcTime =
        Julian.fromFullDate(dateTime.year, dateTime.month, dateTime.day, dateTime.hour, dateTime.minute)
            .getDate() +
            6 / 24.0;

    return orbit.getPosition((utcTime - orbit.epoch().getDate()) * MIN_PER_DAY);
  }
}