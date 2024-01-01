class ResDeptModel {
  bool? error;
  DeptData? data;
  int? code;
  String? message;
  DateTime? timeStamp;

  ResDeptModel({
    this.error,
    this.data,
    this.code,
    this.message,
    this.timeStamp,
  });

  factory ResDeptModel.fromJson(Map<String, dynamic> json) => ResDeptModel(
        error: json["Error"],
        data: json["Data"] == null ? null : DeptData.fromJson(json["Data"]),
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

class DeptData {
  bool? ageCheck;
  bool? favorite;
  List<String>? taxSlabIdList;
  String? id;
  String? name;
  int? displaySeqNo;
  double? surcharge;
  bool? allowFoodStamp;
  int? marginMarkup;
  double? mValue;

  DeptData({
    this.ageCheck,
    this.favorite,
    this.taxSlabIdList,
    this.id,
    this.name,
    this.displaySeqNo,
    this.surcharge,
    this.allowFoodStamp,
    this.marginMarkup,
    this.mValue,
  });

  factory DeptData.fromJson(Map<String, dynamic> json) => DeptData(
        ageCheck: json["AgeCheck"],
        favorite: json["Favorite"],
        taxSlabIdList:
            json["TaxSlabIdList"] == null ? [] : List<String>.from(json["TaxSlabIdList"]!.map((x) => x)),
        id: json["ID"],
        name: json["Name"],
        displaySeqNo: json["DisplaySeqNo"],
        surcharge: json["Surcharge"],
        allowFoodStamp: json["AllowFoodStamp"],
        marginMarkup: json["MarginMarkup"],
        mValue: json["MValue"],
      );

  Map<String, dynamic> toJson() => {
        "AgeCheck": ageCheck,
        "Favorite": favorite,
        "TaxSlabIdList": taxSlabIdList == null ? [] : List<dynamic>.from(taxSlabIdList!.map((x) => x)),
        "ID": id,
        "Name": name,
        "DisplaySeqNo": displaySeqNo,
        "Surcharge": surcharge,
        "AllowFoodStamp": allowFoodStamp,
        "MarginMarkup": marginMarkup,
        "MValue": mValue,
      };
}
