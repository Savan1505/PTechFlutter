import 'package:ptecpos_mobile/features/home/modules/discount/model/res_standard_model.dart';

class ResStandardDetailModel {
  bool? error;
  Standard? data;
  int? code;
  String? message;
  DateTime? timeStamp;

  ResStandardDetailModel({
    this.error,
    this.data,
    this.code,
    this.message,
    this.timeStamp,
  });

  factory ResStandardDetailModel.fromJson(Map<String, dynamic> json) => ResStandardDetailModel(
        error: json["Error"],
        data: json["Data"] == null ? null : Standard.fromJson(json["Data"]),
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
