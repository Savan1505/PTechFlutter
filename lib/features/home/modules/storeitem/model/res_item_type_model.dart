class ResItemTypeModel {
  bool? error;
  ItemTypeData? data;
  int? code;
  String? message;
  DateTime? timeStamp;

  ResItemTypeModel({
    this.error,
    this.data,
    this.code,
    this.message,
    this.timeStamp,
  });

  factory ResItemTypeModel.fromJson(Map<String, dynamic> json) => ResItemTypeModel(
        error: json["Error"],
        data: json["Data"] == null ? null : ItemTypeData.fromJson(json["Data"]),
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

class ItemTypeData {
  int? count;
  List<ItemType>? list;

  ItemTypeData({
    this.count,
    this.list,
  });

  factory ItemTypeData.fromJson(Map<String, dynamic> json) => ItemTypeData(
        count: json["Count"],
        list: json["List"] == null
            ? []
            : List<ItemType>.from(json["List"]!.map((x) => ItemType.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Count": count,
        "List": list == null ? [] : List<dynamic>.from(list!.map((x) => x.toJson())),
      };
}

class ItemType {
  String? id;
  String? name;
  String? code;

  ItemType({
    this.id,
    this.name,
    this.code,
  });

  factory ItemType.fromJson(Map<String, dynamic> json) => ItemType(
        id: json["ID"],
        name: json["Name"],
        code: json["Code"],
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "Name": name,
        "Code": code,
      };
}
