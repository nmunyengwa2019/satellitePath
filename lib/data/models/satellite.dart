class Satellite {
  final String name;
  final String tleLine1;
  final String tleLine2;

  Satellite({required this.name, required this.tleLine1, required this.tleLine2});

  factory Satellite.fromJson(Map<String, dynamic> json) {
    return Satellite(
      name: json['OBJECT_NAME'],
      tleLine1: json['TLE_LINE1'],
      tleLine2: json['TLE_LINE2'],
    );
  }
}
