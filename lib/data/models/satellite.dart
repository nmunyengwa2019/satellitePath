import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:sgp4_sdp4/sgp4_sdp4.dart';
import 'package:latlong2/latlong.dart';


class TrackSatellite {

  Future<List<LatLng>> calculatePositions(String name, String tleLine1, String tleLine2) async {
    final Site myLocation = Site.fromLatLngAlt(23.1359405517578, -82.3583297729492, 59 / 1000.0); // TODO my location replace
    CoordGeo myLocation1 = CoordGeo(lat:23.1359405517578, lon: -82.3583297729492, alt: 0.0);
    final TLE tle = TLE(name, tleLine1, tleLine2);
    final orbit = Orbit(tle);
    final now = DateTime.now();
    final positions = <LatLng>[];

    final initialTime = Julian.fromFullDate(now.year, now.month, now.day, now.hour, now.minute).getDate() + 4 / 24.0;
    final Eci eciPos = orbit.getPosition((initialTime - orbit.epoch().getDate()) * MIN_PER_DAY);

    final CoordGeo coord = eciPos.toGeo(); ///Get the current lat, lng of the satellite
    if (coord.lon > PI) coord.lon -= TWOPI;
    CoordTopo topo = myLocation.getLookAngle(eciPos);

    final eccentricity = orbit.eccentricity();
    final inclination = rad2deg(orbit.inclination());
    final argumentOfPerigee = rad2deg(orbit.argPerigee());
    final  raan = rad2deg(orbit.raan());
    final  meanMotion = orbit.meanMotion();
    final  meanAnomaly = rad2deg(orbit.meanAnomaly());

    final intialPosition = LatLng(rad2deg(coord.lat), rad2deg(coord.lon));
    final intialHeight =  coord.alt;
    final initialAzimuth = rad2deg(topo.az);
    final initialElevation = rad2deg(topo.el) ;
    final initialRange = topo.range;
    final intialOrbitalPeriod = (orbit.period() / 60.0).round();
    //const intialOrbitalPeriod = 5;

    for(int minute = 0; minute < intialOrbitalPeriod; minute++)
      {
        final timeOffset = (initialTime - orbit.epoch().getDate()) * MIN_PER_DAY + minute;
        final currentMeanAnomaly = meanAnomaly + meanMotion * timeOffset;
        final currentEccentricAnomaly = calculateEccentricAnomaly(currentMeanAnomaly, eccentricity);
        final currentTrueAnomaly = calculateTrueAnomaly(currentEccentricAnomaly, eccentricity);
        final currentRadius = calculateRadius(currentTrueAnomaly, eccentricity);
        final currentArgumentOfLatitude = calculateArgumentOfLatitude(currentTrueAnomaly, argumentOfPerigee);
        final currentLongitudeOfAscendingNode = calculateLongitudeOfAscendingNode(raan);
        final currentLongitude = calculateLongitude(currentArgumentOfLatitude, currentLongitudeOfAscendingNode, myLocation1);
        final currentLatitude = calculateLatitude(inclination, currentLongitudeOfAscendingNode, currentArgumentOfLatitude,myLocation1);
        //final currentPosition = LatLng(currentLatitude, currentLongitude);

        // Store or output the calculated position and other information
        final currentHeight = intialHeight;
        final currentAzimuth = initialAzimuth;
        final currentElevation = initialElevation;
        final currentRange = initialRange;

        positions.add(LatLng(currentLatitude, currentLongitude));

        if (kDebugMode) {
          //print('Position ${minute + 1}: ${positions[minute].latitude}, ${positions[minute].longitude}');
        }
      }
    return positions;
  }

  double calculateEccentricAnomaly(double currentMeanAnomaly, double eccentricity)
  {
    const double epsilon = 1e-8; // Desired accuracy
    double delta = 1.0;

    final M = deg2rad(currentMeanAnomaly); // Convert mean anomaly to radians
    double E = M; // Initialize the eccentric anomaly as the mean anomaly

    // Iterate using Newton's method to improve the approximation
    while (delta.abs() > epsilon)
    {
      final double eNext = E - (E - eccentricity * sin(E) - M) / (1.0 - eccentricity * cos(E));
      delta = eNext - E;
      E = eNext;
    }
    return rad2deg(E); // Convert eccentric anomaly back to degrees
  }

  double calculateTrueAnomaly(double currentEccentricAnomaly, double eccentricity)
  {
    final E = deg2rad(currentEccentricAnomaly); // Convert eccentric anomaly to radians

    // Calculate the numerator and denominator of the tangent half-angle formula
    final double numerator = sqrt(1 + eccentricity) * sin(E / 2.0);
    final double denominator = sqrt(1 - eccentricity) * cos(E / 2.0);
    // Calculate the tangent half-angle and convert it to the true anomaly
    final double tanHalfAngle = numerator / denominator;
    final double trueAnomaly = 2.0 * atan(tanHalfAngle);

    return rad2deg(trueAnomaly); // Convert true anomaly back to degrees
  }

  double calculateRadius(double currentTrueAnomaly, double eccentricity)
  {
    final V = deg2rad(currentTrueAnomaly);   // Convert true anomaly to radians
    final double radius = (1 - eccentricity * eccentricity) / (1 + eccentricity * cos(V)); // Calculate the radius using Kepler's equation

    return radius;
  }

  double calculateArgumentOfLatitude(double currentTrueAnomaly, double argumentOfPerigee)
  {
    // Convert true anomaly and argument of perigee to radians
    final V = deg2rad(currentTrueAnomaly);
    final W = deg2rad(argumentOfPerigee);

    final double U = V + W; // Calculate the argument of latitude by adding the true anomaly and the argument of perigee
    final double normalizedU = U % 360.0; // Normalize the argument of latitude to the range [0, 360)
    final double positiveU = normalizedU < 0 ? normalizedU + 360.0 : normalizedU;

    return positiveU;
  }

  double calculateLongitudeOfAscendingNode(double raan)
  {
    final O = deg2rad(raan);  // Convert RAAN to radians

    final double normalizedO = O % 360.0; // Normalize the longitude of the ascending node to the range [0, 360)
    final double positiveO = normalizedO < 0 ? normalizedO + 360.0 : normalizedO;

    return positiveO;
  }

  double calculateLongitude(double currentArgumentOfLatitude, double currentLongitudeOfAscendingNode,CoordGeo myLocation)
  {
    //Convert myLocation coordinates to radians
    final double myLat = deg2rad(myLocation.lat);
    final double myLon = deg2rad(myLocation.lon);

    //Convert currentArgumentOfLatitude, currentLongitudeOfAscendingNode to radians
    final U = deg2rad(currentArgumentOfLatitude);
    final Ohm = deg2rad(currentLongitudeOfAscendingNode);

    final double sigma = atan2(sin(U + myLon - Ohm) * cos(myLat), cos(U + myLon - Ohm)); //Calculate the satellite's longitude relative to the ascending node

    //Calculate the geodetic longitude by adding the satellite's relative longitude to your location's longitude
    final double geodeticLongitude = rad2deg(Ohm + sigma);

    final double normalizedLongitude = (geodeticLongitude + 180.0) % 360.0 - 180.0;  //Normalize the geodetic longitude to the range [-180, 180)

    return normalizedLongitude;
  }

  double calculateLatitude(double inclination, double currentLongitudeOfAscendingNode, double currentArgumentOfLatitude, CoordGeo myLocation)
  {
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