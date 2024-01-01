class ResPriceModel {
  bool? error;
  PriceData? data;
  int? code;
  String? message;
  DateTime? timeStamp;

  ResPriceModel({
    this.error,
    this.data,
    this.code,
    this.message,
    this.timeStamp,
  });

  factory ResPriceModel.fromJson(Map<String, dynamic> json) => ResPriceModel(
        error: json["Error"],
        data: json["Data"] == null ? null : PriceData.fromJson(json["Data"]),
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

class PriceData {
  String? id;
  String? name;
  dynamic rate;
  dynamic type;
  int? rateType;
  bool? rateAdd;

  PriceData({
    this.id,
    this.name,
    this.rate,
    this.type,
    this.rateType,
    this.rateAdd,
  });

  factory PriceData.fromJson(Map<String, dynamic> json) => PriceData(
        id: json["ID"],
        name: json["Name"],
        rate: json["Rate"],
        type: json["Type"],
        rateType: json["RateType"],
        rateAdd: json["RateAdd"],
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "Name": name,
        "Rate": rate,
        "Type": type,
        "RateType": rateType,
        "RateAdd": rateAdd,
      };
}
