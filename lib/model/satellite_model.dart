import 'dart:ffi';

class DataModel
{
  double? meanMotion;
  double? eccentricity;
  double? inclination;
  double? raOfAscNode;
  double? argOfPericenter;
  double? meanAnomaly;
  double? semiMajorAxis;
  double? period;
  String? tleLine0;
  String? tleLine1;
  String? tleLine2;

  DataModel({this.meanMotion, this.eccentricity,
    this.inclination, this.raOfAscNode,
    this.argOfPericenter, this.meanAnomaly,
    this.semiMajorAxis, this.period,
    this.tleLine0, this.tleLine1, this.tleLine2});

  DataModel.fromJson(Map<String, dynamic> data){
    meanMotion: data['MEAN_MOTION'];
    eccentricity: data['ECCENTRICITY'];
    inclination: data['INCLINATION'];
    raOfAscNode: data['RA_OF_ASC_NODE'];
    argOfPericenter: data['ARG_OF_PERICENTER'];
    meanAnomaly: data['MEAN_ANOMALY'];
    semiMajorAxis: data['SEMIMAJOR_AXIS'];
    period: data['PERIOD'];
    tleLine0: data['TLE_LINE0'];
    tleLine1: data['TLE_LINE1'];
    tleLine2: data['TLE_LINE2'];
  }
}
