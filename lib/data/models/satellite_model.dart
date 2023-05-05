class DataModel {
  String? cCSDSOMMVERS;
  String? cOMMENT;
  String? cREATIONDATE;
  String? oRIGINATOR;
  String? oBJECTNAME;
  String? oBJECTID;
  String? cENTERNAME;
  String? rEFFRAME;
  String? tIMESYSTEM;
  String? mEANELEMENTTHEORY;
  String? ePOCH;
  String? mEANMOTION;
  String? eCCENTRICITY;
  String? iNCLINATION;
  String? rAOFASCNODE;
  String? aRGOFPERICENTER;
  String? mEANANOMALY;
  String? ePHEMERISTYPE;
  String? cLASSIFICATIONTYPE;
  String? nORADCATID;
  String? eLEMENTSETNO;
  String? rEVATEPOCH;
  String? bSTAR;
  String? mEANMOTIONDOT;
  String? mEANMOTIONDDOT;
  String? sEMIMAJORAXIS;
  String? pERIOD;
  String? aPOAPSIS;
  String? pERIAPSIS;
  String? oBJECTTYPE;
  String? rCSSIZE;
  String? cOUNTRYCODE;
  String? lAUNCHDATE;
  String? sITE;
  String? fILE;
  String? gPID;
  String? tLELINE0;
  String? tLELINE1;
  String? tLELINE2;

  DataModel.empty(){}

  DataModel({
      this.cCSDSOMMVERS,
      this.cOMMENT,
      this.cREATIONDATE,
      this.oRIGINATOR,
      this.oBJECTNAME,
      this.oBJECTID,
      this.cENTERNAME,
      this.rEFFRAME,
      this.tIMESYSTEM,
      this.mEANELEMENTTHEORY,
      this.ePOCH,
      this.mEANMOTION,
      this.eCCENTRICITY,
      this.iNCLINATION,
      this.rAOFASCNODE,
      this.aRGOFPERICENTER,
      this.mEANANOMALY,
      this.ePHEMERISTYPE,
      this.cLASSIFICATIONTYPE,
      this.nORADCATID,
      this.eLEMENTSETNO,
      this.rEVATEPOCH,
      this.bSTAR,
      this.mEANMOTIONDOT,
      this.mEANMOTIONDDOT,
      this.sEMIMAJORAXIS,
      this.pERIOD,
      this.aPOAPSIS,
      this.pERIAPSIS,
      this.oBJECTTYPE,
      this.rCSSIZE,
      this.cOUNTRYCODE,
      this.lAUNCHDATE,
      this.sITE,
      this.fILE,
      this.gPID,
      this.tLELINE0,
      this.tLELINE1,
      this.tLELINE2});

  DataModel.fromJson(Map<String, dynamic> json) {
    cCSDSOMMVERS = json['CCSDS_OMM_VERS'];
    cOMMENT = json['COMMENT'];
    cREATIONDATE = json['CREATION_DATE'];
    oRIGINATOR = json['ORIGINATOR'];
    oBJECTNAME = json['OBJECT_NAME'];
    oBJECTID = json['OBJECT_ID'];
    cENTERNAME = json['CENTER_NAME'];
    rEFFRAME = json['REF_FRAME'];
    tIMESYSTEM = json['TIME_SYSTEM'];
    mEANELEMENTTHEORY = json['MEAN_ELEMENT_THEORY'];
    ePOCH = json['EPOCH'];
    mEANMOTION = json['MEAN_MOTION'];
    eCCENTRICITY = json['ECCENTRICITY'];
    iNCLINATION = json['INCLINATION'];
    rAOFASCNODE = json['RA_OF_ASC_NODE'];
    aRGOFPERICENTER = json['ARG_OF_PERICENTER'];
    mEANANOMALY = json['MEAN_ANOMALY'];
    ePHEMERISTYPE = json['EPHEMERIS_TYPE'];
    cLASSIFICATIONTYPE = json['CLASSIFICATION_TYPE'];
    nORADCATID = json['NORAD_CAT_ID'];
    eLEMENTSETNO = json['ELEMENT_SET_NO'];
    rEVATEPOCH = json['REV_AT_EPOCH'];
    bSTAR = json['BSTAR'];
    mEANMOTIONDOT = json['MEAN_MOTION_DOT'];
    mEANMOTIONDDOT = json['MEAN_MOTION_DDOT'];
    sEMIMAJORAXIS = json['SEMIMAJOR_AXIS'];
    pERIOD = json['PERIOD'];
    aPOAPSIS = json['APOAPSIS'];
    pERIAPSIS = json['PERIAPSIS'];
    oBJECTTYPE = json['OBJECT_TYPE'];
    rCSSIZE = json['RCS_SIZE'];
    cOUNTRYCODE = json['COUNTRY_CODE'];
    lAUNCHDATE = json['LAUNCH_DATE'];
    sITE = json['SITE'];
    fILE = json['FILE'];
    gPID = json['GP_ID'];
    tLELINE0 = json['TLE_LINE0'];
    tLELINE1 = json['TLE_LINE1'];
    tLELINE2 = json['TLE_LINE2'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['CCSDS_OMM_VERS'] = cCSDSOMMVERS;
    data['COMMENT'] = cOMMENT;
    data['CREATION_DATE'] = cREATIONDATE;
    data['ORIGINATOR'] = oRIGINATOR;
    data['OBJECT_NAME'] = oBJECTNAME;
    data['OBJECT_ID'] = oBJECTID;
    data['CENTER_NAME'] = cENTERNAME;
    data['REF_FRAME'] = rEFFRAME;
    data['TIME_SYSTEM'] = tIMESYSTEM;
    data['MEAN_ELEMENT_THEORY'] = mEANELEMENTTHEORY;
    data['EPOCH'] = ePOCH;
    data['MEAN_MOTION'] = mEANMOTION;
    data['ECCENTRICITY'] = eCCENTRICITY;
    data['INCLINATION'] = iNCLINATION;
    data['RA_OF_ASC_NODE'] = rAOFASCNODE;
    data['ARG_OF_PERICENTER'] = aRGOFPERICENTER;
    data['MEAN_ANOMALY'] = mEANANOMALY;
    data['EPHEMERIS_TYPE'] = ePHEMERISTYPE;
    data['CLASSIFICATION_TYPE'] = cLASSIFICATIONTYPE;
    data['NORAD_CAT_ID'] = nORADCATID;
    data['ELEMENT_SET_NO'] = eLEMENTSETNO;
    data['REV_AT_EPOCH'] = rEVATEPOCH;
    data['BSTAR'] = bSTAR;
    data['MEAN_MOTION_DOT'] = mEANMOTIONDOT;
    data['MEAN_MOTION_DDOT'] = mEANMOTIONDDOT;
    data['SEMIMAJOR_AXIS'] = sEMIMAJORAXIS;
    data['PERIOD'] = pERIOD;
    data['APOAPSIS'] = aPOAPSIS;
    data['PERIAPSIS'] = pERIAPSIS;
    data['OBJECT_TYPE'] = oBJECTTYPE;
    data['RCS_SIZE'] = rCSSIZE;
    data['COUNTRY_CODE'] = cOUNTRYCODE;
    data['LAUNCH_DATE'] = lAUNCHDATE;
    data['SITE'] = sITE;
    data['FILE'] = fILE;
    data['GP_ID'] = gPID;
    data['TLE_LINE0'] = tLELINE0;
    data['TLE_LINE1'] = tLELINE1;
    data['TLE_LINE2'] = tLELINE2;
    return data;
  }
}
