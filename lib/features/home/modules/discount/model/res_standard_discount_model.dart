class ResStandardDiscountModel {
  bool? error;
  StandardDiscountData? data;
  int? code;
  String? message;
  DateTime? timeStamp;

  ResStandardDiscountModel({
    this.error,
    this.data,
    this.code,
    this.message,
    this.timeStamp,
  });

  factory ResStandardDiscountModel.fromJson(Map<String, dynamic> json) => ResStandardDiscountModel(
        error: json["Error"],
        data: json["Data"] == null ? null : StandardDiscountData.fromJson(json["Data"]),
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

class StandardDiscountData {
  int? count;
  List<StandardDiscount>? list;

  StandardDiscountData({
    this.count,
    this.list,
  });

  factory StandardDiscountData.fromJson(Map<String, dynamic> json) => StandardDiscountData(
        count: json["Count"],
        list: json["List"] == null
            ? []
            : List<StandardDiscount>.from(json["List"]!.map((x) => StandardDiscount.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Count": count,
        "List": list == null ? [] : List<dynamic>.from(list!.map((x) => x.toJson())),
      };
}

class StandardDiscount {
  String? id;
  String? name;
  double? percentage;

  StandardDiscount({
    this.id,
    this.name,
    this.percentage,
  });

  factory StandardDiscount.fromJson(Map<String, dynamic> json) => StandardDiscount(
        id: json["ID"],
        name: json["Name"],
        percentage: json["Percentage"],
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "Name": name,
        "Percentage": percentage,
      };
}
