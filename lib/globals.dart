import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

List<LatLng> positions = [];
String satelliteName = "";

List<String> satelliteGroupNames = [
  "Weather Satellites",
  "Radar Satellites",
  "Communication Satellite",
  "Navigation Satellites (GPS)",
  "Earth Observation Satellites"
];

List<String> satelliteGroupCatRange = [
  "1000--1999",
  " 2000--2999",
  "3000--3999",
  "5000--5999",
  " 4000--4999"
];

int selectedGroupIndex = 0;

bool isIrridium = true;

int minCatId = 10000;

int maxCatId = 20000;

final List<LatLng> satellitePath = [
  LatLng(0.0, 0.0),
  LatLng(10.0, 10.0),
  LatLng(20.0, 20.0),
  LatLng(30.0, 30.0),
  LatLng(40.0, 40.0),
  LatLng(50.0, 50.0),
  LatLng(60.0, 60.0),
  LatLng(70.0, 70.0),
  LatLng(80.0, 80.0),
  LatLng(90.0, 90.0),
  LatLng(80.0, 80.0),
  LatLng(70.0, 70.0),
  LatLng(60.0, 60.0),
  LatLng(50.0, 50.0),
  LatLng(40.0, 40.0),
  LatLng(30.0, 30.0),
  LatLng(20.0, 20.0),
  LatLng(10.0, 10.0),
  LatLng(0.0, 0.0),
  LatLng(-10.0, -10.0),
  LatLng(-20.0, -20.0),
  LatLng(-30.0, -30.0),
  LatLng(-40.0, -40.0),
  LatLng(-50.0, -50.0),
  LatLng(-60.0, -60.0),
  LatLng(-70.0, -70.0),
  LatLng(-80.0, -80.0),
  LatLng(-90.0, -90.0),
  LatLng(-80.0, -80.0),
  LatLng(-70.0, -70.0),
  LatLng(-60.0, -60.0),
  LatLng(-50.0, -50.0),
  LatLng(-40.0, -40.0),
  LatLng(-30.0, -30.0),
  LatLng(-20.0, -20.0),
  LatLng(-10.0, -10.0),
  LatLng(0.0, 0.0),
];
