class ResItemCountryModel {
  bool? error;
  ItemCountryData? data;
  int? code;
  String? message;
  DateTime? timeStamp;

  ResItemCountryModel({
    this.error,
    this.data,
    this.code,
    this.message,
    this.timeStamp,
  });

  factory ResItemCountryModel.fromJson(Map<String, dynamic> json) => ResItemCountryModel(
        error: json["Error"],
        data: json["Data"] == null ? null : ItemCountryData.fromJson(json["Data"]),
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

class ItemCountryData {
  int? count;
  List<ItemCountry>? list;

  ItemCountryData({
    this.count,
    this.list,
  });

  factory ItemCountryData.fromJson(Map<String, dynamic> json) => ItemCountryData(
        count: json["Count"],
        list: json["List"] == null
            ? []
            : List<ItemCountry>.from(json["List"]!.map((x) => ItemCountry.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Count": count,
        "List": list == null ? [] : List<dynamic>.from(list!.map((x) => x.toJson())),
      };
}

class ItemCountry {
  int? id;
  String? countryName;

  ItemCountry({
    this.id,
    this.countryName,
  });

  factory ItemCountry.fromJson(Map<String, dynamic> json) => ItemCountry(
        id: json["Id"],
        countryName: json["CountryName"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "CountryName": countryName,
      };
}
