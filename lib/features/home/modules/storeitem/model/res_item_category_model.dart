class ResItemCategoryModel {
  bool? error;
  ItemCategoryData? data;
  int? code;
  String? message;
  DateTime? timeStamp;

  ResItemCategoryModel({
    this.error,
    this.data,
    this.code,
    this.message,
    this.timeStamp,
  });

  factory ResItemCategoryModel.fromJson(Map<String, dynamic> json) => ResItemCategoryModel(
        error: json["Error"],
        data: json["Data"] == null ? null : ItemCategoryData.fromJson(json["Data"]),
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

class ItemCategoryData {
  int? count;
  List<ItemCategory>? list;

  ItemCategoryData({
    this.count,
    this.list,
  });

  factory ItemCategoryData.fromJson(Map<String, dynamic> json) => ItemCategoryData(
        count: json["Count"],
        list: json["List"] == null
            ? []
            : List<ItemCategory>.from(json["List"]!.map((x) => ItemCategory.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Count": count,
        "List": list == null ? [] : List<dynamic>.from(list!.map((x) => x.toJson())),
      };
}

class ItemCategory {
  String? id;
  String? name;
  String? itemDeptId;

  ItemCategory({
    this.id,
    this.name,
    this.itemDeptId,
  });

  factory ItemCategory.fromJson(Map<String, dynamic> json) => ItemCategory(
        id: json["ID"],
        name: json["Name"],
        itemDeptId: json["ItemDeptID"],
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "Name": name,
        "ItemDeptID": itemDeptId,
      };
}
