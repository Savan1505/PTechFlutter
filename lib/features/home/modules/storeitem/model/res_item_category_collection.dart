class ResItemCategoryCollectionModel {
  bool? error;
  CategoryCollectionData? data;
  int? code;
  String? message;
  DateTime? timeStamp;

  ResItemCategoryCollectionModel({
    this.error,
    this.data,
    this.code,
    this.message,
    this.timeStamp,
  });

  factory ResItemCategoryCollectionModel.fromJson(Map<String, dynamic> json) =>
      ResItemCategoryCollectionModel(
        error: json["Error"],
        data: json["Data"] == null ? null : CategoryCollectionData.fromJson(json["Data"]),
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

class CategoryCollectionData {
  int? count;
  List<CategoryCollection>? list;

  CategoryCollectionData({
    this.count,
    this.list,
  });

  factory CategoryCollectionData.fromJson(Map<String, dynamic> json) => CategoryCollectionData(
        count: json["Count"],
        list: json["List"] == null
            ? []
            : List<CategoryCollection>.from(json["List"]!.map((x) => CategoryCollection.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Count": count,
        "List": list == null ? [] : List<dynamic>.from(list!.map((x) => x.toJson())),
      };
}

class CategoryCollection {
  String? id;
  String? name;
  String? itemDeptId;

  CategoryCollection({
    this.id,
    this.name,
    this.itemDeptId,
  });

  factory CategoryCollection.fromJson(Map<String, dynamic> json) => CategoryCollection(
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
