class ResDefaultModel {
  bool? error;
  bool? data;
  int? code;
  String? message;
  DateTime? timeStamp;

  ResDefaultModel({
    this.error,
    this.data,
    this.code,
    this.message,
    this.timeStamp,
  });

  factory ResDefaultModel.fromJson(Map<String, dynamic> json) => ResDefaultModel(
        error: json["Error"],
        data: json["Data"],
        code: json["Code"],
        message: json["Message"],
        timeStamp: json["TimeStamp"] == null ? null : DateTime.parse(json["TimeStamp"]),
      );

  Map<String, dynamic> toJson() => {
        "Error": error,
        "Data": data,
        "Code": code,
        "Message": message,
        "TimeStamp": timeStamp?.toIso8601String(),
      };
}
