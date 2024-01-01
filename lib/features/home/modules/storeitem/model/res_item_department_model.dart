class ResItemDepartmentModel {
  bool? error;
  ItemDepartmentData? data;
  int? code;
  String? message;
  DateTime? timeStamp;

  ResItemDepartmentModel({
    this.error,
    this.data,
    this.code,
    this.message,
    this.timeStamp,
  });

  factory ResItemDepartmentModel.fromJson(Map<String, dynamic> json) => ResItemDepartmentModel(
        error: json["Error"],
        data: json["Data"] == null ? null : ItemDepartmentData.fromJson(json["Data"]),
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

class ItemDepartmentData {
  int? count;
  List<ItemDepartment>? list;

  ItemDepartmentData({
    this.count,
    this.list,
  });

  factory ItemDepartmentData.fromJson(Map<String, dynamic> json) => ItemDepartmentData(
        count: json["Count"],
        list: json["List"] == null
            ? []
            : List<ItemDepartment>.from(json["List"]!.map((x) => ItemDepartment.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Count": count,
        "List": list == null ? [] : List<dynamic>.from(list!.map((x) => x.toJson())),
      };
}

class ItemDepartment {
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

  ItemDepartment({
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

  factory ItemDepartment.fromJson(Map<String, dynamic> json) => ItemDepartment(
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
