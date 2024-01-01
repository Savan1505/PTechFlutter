class ResponseModel {
  final bool? error;
  final dynamic data;
  final num? code;
  final String? message;
  final DateTime? timeStamp;

  ResponseModel({
    this.error,
    this.data,
    this.code,
    this.message,
    this.timeStamp,
  });

  factory ResponseModel.fromJson(Map<String, dynamic> json) => ResponseModel(
        error: json["Error"],
        data: json["Data"],
        code: json["Code"],
        message: json["Message"],
        timeStamp: json["TimeStamp"] == null
            ? null
            : DateTime.parse(json["TimeStamp"]),
      );

  Map<String, dynamic> toJson() => {
        "Error": error,
        "Data": data?.toJson(),
        "Code": code,
        "Message": message,
        "TimeStamp": timeStamp?.toIso8601String(),
      };
}
