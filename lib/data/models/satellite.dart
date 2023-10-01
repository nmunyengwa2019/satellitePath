import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:sgp4_sdp4/sgp4_sdp4.dart';
import 'package:latlong2/latlong.dart';
import 'custom_latlng.dart';
import 'package:sat_tracker/globals.dart' as globals;

class TrackSatellite {
  Future<List<LatLng>> calculatePositions(
      String name, String line1, String line2) async {
    print("DIE DUMB");
    print("Name $name Line 1$line1 Line 2 $line2");
    globals.positions.clear();

    //................Fix time issues............

    final datetimeStart = DateTime.now();
    final datetimeList = [];

    DateTime x = datetimeStart;

    datetimeList.add(
        Julian.fromFullDate(x.year, x.month, x.day, x.hour, x.minute)
            .getDate());

    const dayTMins = 1440;
    const hoursPerWeek = 168;

    for (int i = 1; i < hoursPerWeek; i++) {
      x = x.add(const Duration(hours: 4));

      final y = Julian.fromFullDate(x.year, x.month, x.day, x.hour, x.minute)
              .getDate() +
          5 / 24.0;

      datetimeList.add(y);
    }
    print(" DateTime ${datetimeList.toList()}");

    //...........................................

    /// Get the current date and time
    final dateTime = DateTime.now();
    // final positions = <Eci>[];
    List<LatLng> newLatLong = [];
    final Site myLocation = Site.fromLatLngAlt(23.1359405517578,
        -82.3583297729492, 59 / 1000.0); // TODO my location replace
    CoordGeo myLocation1 =
        CoordGeo(lat: 23.1359405517578, lon: -82.3583297729492, alt: 0.0);
    final initialTime = Julian.fromFullDate(dateTime.year, dateTime.month,
                dateTime.day, dateTime.hour, dateTime.minute)
            .getDate() +
        4 / 24.0;

    /// Parse the TLE
    final TLE tleSGP4 = TLE(name, line1, line2);

    ///Create a orbit object and print if is
    ///SGP4, for "near-Earth" objects, or SDP4 for "deep space" objects.
    final Orbit orbit = Orbit(tleSGP4);

    print("Orbit period >>${orbit.period()}");
    print("is SGP4: ${orbit.period() < 255 * 60}");

    /// get the utc time in Julian Day
    ///  + 4/24 need it, diferent time zone (Cuba -4 hrs )

    final positions = <CustomLatLng>[];
    // final Eci eciPos =
    //     orbit.getPosition((utcTime - orbit.epoch().getDateR()) * MIN_PER_DAY);
    int date_time_mins = 86400;

    for (int i = 0; i < datetimeList.length; i++) {
      final double utcTime = Julian.fromFullDate(dateTime.year, dateTime.month,
                  dateTime.day, dateTime.hour + i, dateTime.minute)
              .getDate() +
          4 / 24.0;
      // print("EPO TIME ${orbit.epoch().getDate()}");
      final Eci eciPos = orbit.getPosition(
          (datetimeList[i] - orbit.epoch().getDate()) * HR_PER_DAY);

      ///Get the current lat, ng of the satellite

      final CoordGeo coord = eciPos.toGeo();
      if (coord.lon > PI) coord.lon -= TWOPI;
      CoordTopo topo = myLocation.getLookAngle(eciPos);
      var Latitude = rad2deg(coord.lat);
      var Longitude = rad2deg(coord.lon);

      newLatLong.add(LatLng(Latitude, Longitude));

      //....................................................................................
      final eccentricity = orbit.eccentricity();
      final inclination = rad2deg(orbit.inclination());
      final argumentOfPerigee = rad2deg(orbit.argPerigee());
      final raan = rad2deg(orbit.raan());
      final meanMotion = orbit.meanMotion();
      final meanAnomaly = rad2deg(orbit.meanAnomaly());

      //final intialPosition = LatLng(rad2deg(coord.lat), rad2deg(coord.lon));
      final intialHeight = coord.alt;
      final initialAzimuth = rad2deg(topo.az);
      final initialElevation = rad2deg(topo.el);
      final initialRange = topo.range;

      final intialOrbitalPeriod = (orbit.period() / 60.0).round();
      final timeOffset =
          (datetimeList[i] - orbit.epoch().getDate()) * MIN_PER_DAY + i;
      final currentMeanAnomaly = meanAnomaly + meanMotion * timeOffset;
      final currentEccentricAnomaly =
          calculateEccentricAnomaly(currentMeanAnomaly, eccentricity);
      final currentTrueAnomaly =
          calculateTrueAnomaly(currentEccentricAnomaly, eccentricity);
      final currentRadius = calculateRadius(currentTrueAnomaly, eccentricity);
      final currentArgumentOfLatitude =
          calculateArgumentOfLatitude(currentTrueAnomaly, argumentOfPerigee);
      final currentLongitudeOfAscendingNode =
          calculateLongitudeOfAscendingNode(raan);
      final currentLongitude = calculateLongitude(currentArgumentOfLatitude,
          currentLongitudeOfAscendingNode, myLocation1);
      final currentLatitude = calculateLatitude(
          inclination,
          currentLongitudeOfAscendingNode,
          currentArgumentOfLatitude,
          myLocation1);
      final currentPosition = LatLng(currentLatitude, currentLongitude);
      // final currentPosition =
      //     LatLng(Latitude.roundToDouble(), Longitude.roundToDouble());

      // newLatLong.add(currentPosition);
      // print("NEW LAT LONG $i >< ${newLatLong}");
    }

    print("NEW LAT LONG  >< ${newLatLong}");
    return newLatLong;
  }

  double calculateEccentricAnomaly(
      double currentMeanAnomaly, double eccentricity) {
    const double epsilon = 1e-8; // Desired accuracy
    double delta = 1.0;

    final M = deg2rad(currentMeanAnomaly); // Convert mean anomaly to radians

    double E = M; // Initialize the eccentric anomaly as the mean anomaly

    // Iterate using Newton's method to improve the approximation
    while (delta.abs() > epsilon) {
      final double eNext =
          E - (E - eccentricity * sin(E) - M) / (1.0 - eccentricity * cos(E));
      delta = eNext - E;
      E = eNext;
    }
    return rad2deg(E); // Convert eccentric anomaly back to degrees
  }

  double calculateTrueAnomaly(
      double currentEccentricAnomaly, double eccentricity) {
    final E = deg2rad(
        currentEccentricAnomaly); // Convert eccentric anomaly to radians

    // Calculate the numerator and denominator of the tangent half-angle formula
    final double numerator = sqrt(1 + eccentricity) * sin(E / 2.0);
    final double denominator = sqrt(1 - eccentricity) * cos(E / 2.0);
    // Calculate the tangent half-angle and convert it to the true anomaly
    final double tanHalfAngle = numerator / denominator;
    final double trueAnomaly = 2.0 * atan(tanHalfAngle);

    return rad2deg(trueAnomaly); // Convert true anomaly back to degrees
  }

  double calculateRadius(double currentTrueAnomaly, double eccentricity) {
    final V = deg2rad(currentTrueAnomaly); // Convert true anomaly to radians
    final double radius = (1 - eccentricity * eccentricity) /
        (1 +
            eccentricity *
                cos(V)); // Calculate the radius using Kepler's equation

    return radius;
  }

  double calculateArgumentOfLatitude(
      double currentTrueAnomaly, double argumentOfPerigee) {
    // Convert true anomaly and argument of perigee to radians
    final V = deg2rad(currentTrueAnomaly);
    final W = deg2rad(argumentOfPerigee);

    final double U = V +
        W; // Calculate the argument of latitude by adding the true anomaly and the argument of perigee
    final double normalizedU =
        U % 360.0; // Normalize the argument of latitude to the range [0, 360)
    final double positiveU =
        normalizedU < 0 ? normalizedU + 360.0 : normalizedU;

    return positiveU;
  }

  double calculateLongitudeOfAscendingNode(double raan) {
    final O = deg2rad(raan); // Convert RAAN to radians

    final double normalizedO = O %
        360.0; // Normalize the longitude of the ascending node to the range [0, 360)
    final double positiveO =
        normalizedO < 0 ? normalizedO + 360.0 : normalizedO;

    return positiveO;
  }

  double calculateLongitude(double currentArgumentOfLatitude,
      double currentLongitudeOfAscendingNode, CoordGeo myLocation) {
    //Convert myLocation coordinates to radians
    final double myLat = deg2rad(myLocation.lat);
    final double myLon = deg2rad(myLocation.lon);

    //Convert currentArgumentOfLatitude, currentLongitudeOfAscendingNode to radians
    final U = deg2rad(currentArgumentOfLatitude);
    final Ohm = deg2rad(currentLongitudeOfAscendingNode);

    final double sigma = atan2(
        sin(U + myLon - Ohm) * cos(myLat),
        cos(U +
            myLon -
            Ohm)); //Calculate the satellite's longitude relative to the ascending node

    //Calculate the geodetic longitude by adding the satellite's relative longitude to your location's longitude
    final double geodeticLongitude = rad2deg(Ohm + sigma);

    final double normalizedLongitude = (geodeticLongitude + 180.0) % 360.0 -
        180.0; //Normalize the geodetic longitude to the range [-180, 180)

    return normalizedLongitude;
  }

  double calculateLatitude(
      double inclination,
      double currentLongitudeOfAscendingNode,
      double currentArgumentOfLatitude,
      CoordGeo myLocation) {
    //Convert myLocation coordinates to radians
    final double myLat = deg2rad(myLocation.lat);
    final double myLon = deg2rad(myLocation.lon);

    // Convert inclination, currentLongitudeOfAscendingNode, currentArgumentOfLatitude to radians
    final double I = deg2rad(inclination);
    final double Ohm = deg2rad(currentLongitudeOfAscendingNode);
    final double U = deg2rad(currentArgumentOfLatitude);

    // Calculate the satellite's latitude relative to the ascending node
    final double deltaPhi = atan2(sin(U - Ohm) * cos(I), cos(U - Ohm));

    // Calculate the geodetic latitude by adding the satellite's relative latitude to your location's latitude
    final double geodeticLatitude = rad2deg(deltaPhi + myLat);

    return geodeticLatitude;
  }
}
