class ResZipModel {
  bool? error;
  ZipData? data;
  int? code;
  String? message;
  DateTime? timeStamp;

  ResZipModel({
    this.error,
    this.data,
    this.code,
    this.message,
    this.timeStamp,
  });

  factory ResZipModel.fromJson(Map<String, dynamic> json) => ResZipModel(
        error: json["Error"],
        data: json["Data"] == null ? null : ZipData.fromJson(json["Data"]),
        code: json["Code"],
        message: json["Message"],
        timeStamp: json["TimeStamp"] == null ? null : DateTime.parse(json["TimeStamp"]),
      );

  Map<String, dynamic> toJson() => {
        "Error": error,
        "Data": data?.toJson(),
        "Code": code,
        "Message": message,
        "TimeStamp": timeStamp?.toIso8601String(),
      };
}

class ZipData {
  String? zip;
  String? city;
  String? state;
  String? country;
  String? countryShortName;
  dynamic county;

  ZipData({
    this.zip,
    this.city,
    this.state,
    this.country,
    this.countryShortName,
    this.county,
  });

  factory ZipData.fromJson(Map<String, dynamic> json) => ZipData(
        zip: json["Zip"],
        city: json["City"],
        state: json["State"],
        country: json["Country"],
        countryShortName: json["CountryShortName"],
        county: json["County"],
      );

  Map<String, dynamic> toJson() => {
        "Zip": zip,
        "City": city,
        "State": state,
        "Country": country,
        "CountryShortName": countryShortName,
        "County": county,
      };
}
