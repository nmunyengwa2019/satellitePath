class SatelliteData {
  String? TLE_LINE0;
  String? TLE_LINE1;
  String? TLE_LINE2;

  SatelliteData.empty(){}

  SatelliteData({
      this.TLE_LINE0,
      this.TLE_LINE1,
      this.TLE_LINE2});

  factory SatelliteData.fromJson(Map<String, dynamic> json){
    return SatelliteData(
        TLE_LINE0: json['TLE_LINE0'],
        TLE_LINE1: json['TLE_LINE1'],
        TLE_LINE2: json['TLE_LINE2'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['TLE_LINE0'] = TLE_LINE0;
    data['TLE_LINE1'] = TLE_LINE1;
    data['TLE_LINE2'] = TLE_LINE2;
    return data;
  }
}
