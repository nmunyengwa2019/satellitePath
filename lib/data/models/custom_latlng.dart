import 'package:latlong2/latlong.dart';

class CustomLatLng extends LatLng {
  CustomLatLng(double latitude, double longitude) : super(latitude, longitude);

  @override
  String toString() {
    return 'LatLng(${latitude.toStringAsFixed(5)}, ${longitude.toStringAsFixed(6)})';
  }
}