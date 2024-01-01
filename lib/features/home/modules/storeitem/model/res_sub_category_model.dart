class ResSubCategoryModel {
  bool? error;
  SubcategoryData? data;
  int? code;
  String? message;
  DateTime? timeStamp;

  ResSubCategoryModel({
    this.error,
    this.data,
    this.code,
    this.message,
    this.timeStamp,
  });

  factory ResSubCategoryModel.fromJson(Map<String, dynamic> json) => ResSubCategoryModel(
        error: json["Error"],
        data: json["Data"] == null ? null : SubcategoryData.fromJson(json["Data"]),
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

class SubcategoryData {
  int? count;
  List<Subcategory>? list;

  SubcategoryData({
    this.count,
    this.list,
  });

  factory SubcategoryData.fromJson(Map<String, dynamic> json) => SubcategoryData(
        count: json["Count"],
        list: json["List"] == null
            ? []
            : List<Subcategory>.from(json["List"]!.map((x) => Subcategory.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Count": count,
        "List": list == null ? [] : List<dynamic>.from(list!.map((x) => x.toJson())),
      };
}

class Subcategory {
  String? id;
  String? name;
  String? categoryId;
  String? categoryName;
  bool? active;

  Subcategory({
    this.id,
    this.name,
    this.categoryId,
    this.categoryName,
    this.active,
  });

  factory Subcategory.fromJson(Map<String, dynamic> json) => Subcategory(
        id: json["ID"],
        name: json["Name"],
        categoryId: json["CategoryID"],
        categoryName: json["CategoryName"],
        active: json["Active"],
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "Name": name,
        "CategoryID": categoryId,
        "CategoryName": categoryName,
        "Active": active,
      };
}
