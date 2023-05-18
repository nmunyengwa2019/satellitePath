class DataModel {
  String? oBJECTNAME;
  String? tLELINE0;
  String? tLELINE1;
  String? tLELINE2;


  DataModel.empty(){}

  DataModel({
      this.oBJECTNAME,
      this.tLELINE0,
      this.tLELINE1,
      this.tLELINE2});

  DataModel.fromJson(Map<String, dynamic> json) {
    oBJECTNAME = json['OBJECT_NAME'];
    tLELINE0 = json['TLE_LINE0'];
    tLELINE1 = json['TLE_LINE1'];
    tLELINE2 = json['TLE_LINE2'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['OBJECT_NAME'] = oBJECTNAME;
    data['TLE_LINE0'] = tLELINE0;
    data['TLE_LINE1'] = tLELINE1;
    data['TLE_LINE2'] = tLELINE2;
    return data;
  }
}
