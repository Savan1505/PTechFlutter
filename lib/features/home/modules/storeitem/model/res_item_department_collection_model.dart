class ResItemDepartmentCollectionModel {
  bool? error;
  ItemDepartmentCollection? data;
  int? code;
  String? message;
  DateTime? timeStamp;

  ResItemDepartmentCollectionModel({
    this.error,
    this.data,
    this.code,
    this.message,
    this.timeStamp,
  });

  factory ResItemDepartmentCollectionModel.fromJson(Map<String, dynamic> json) =>
      ResItemDepartmentCollectionModel(
        error: json["Error"],
        data: json["Data"] == null ? null : ItemDepartmentCollection.fromJson(json["Data"]),
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

class ItemDepartmentCollection {
  int? count;
  List<DepartmentCollection>? list;

  ItemDepartmentCollection({
    this.count,
    this.list,
  });

  factory ItemDepartmentCollection.fromJson(Map<String, dynamic> json) => ItemDepartmentCollection(
        count: json["Count"],
        list: json["List"] == null
            ? []
            : List<DepartmentCollection>.from(
                json["List"]!.map((x) => DepartmentCollection.fromJson(x)),
              ),
      );

  Map<String, dynamic> toJson() => {
        "Count": count,
        "List": list == null ? [] : List<dynamic>.from(list!.map((x) => x.toJson())),
      };
}

class DepartmentCollection {
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

  DepartmentCollection({
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

  factory DepartmentCollection.fromJson(Map<String, dynamic> json) => DepartmentCollection(
        ageCheck: json["AgeCheck"],
        favorite: json["Favorite"],
        taxSlabIdList:
            json["TaxSlabIdList"] == null ? [] : List<String>.from(json["TaxSlabIdList"]!.map((x) => x)),
        id: json["ID"],
        name: json["Name"],
        displaySeqNo: json["DisplaySeqNo"],
        surcharge: json["Surcharge"]?.toDouble(),
        allowFoodStamp: json["AllowFoodStamp"],
        marginMarkup: json["MarginMarkup"],
        mValue: json["MValue"]?.toDouble(),
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
