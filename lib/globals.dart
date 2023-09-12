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
