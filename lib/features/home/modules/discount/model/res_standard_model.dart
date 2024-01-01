class ResStandardModel {
  bool? error;
  List<Standard>? data;
  int? code;
  String? message;
  DateTime? timeStamp;

  ResStandardModel({
    this.error,
    this.data,
    this.code,
    this.message,
    this.timeStamp,
  });

  factory ResStandardModel.fromJson(Map<String, dynamic> json) => ResStandardModel(
        error: json["Error"],
        data: json["Data"] == null ? [] : List<Standard>.from(json["Data"]!.map((x) => Standard.fromJson(x))),
        code: json["Code"],
        message: json["Message"],
        timeStamp: json["TimeStamp"] == null ? null : DateTime.parse(json["TimeStamp"]),
      );

  Map<String, dynamic> toJson() => {
        "Error": error,
        "Data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
        "Code": code,
        "Message": message,
        "TimeStamp": timeStamp?.toIso8601String(),
      };
}

class Standard {
  String? id;
  String? name;
  double? percentage;

  Standard({
    this.id,
    this.name,
    this.percentage,
  });

  factory Standard.fromJson(Map<String, dynamic> json) => Standard(
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
