class ResItemSubCategoryModel {
  bool? error;
  ItemSubCategoryData? data;
  int? code;
  String? message;
  DateTime? timeStamp;

  ResItemSubCategoryModel({
    this.error,
    this.data,
    this.code,
    this.message,
    this.timeStamp,
  });

  factory ResItemSubCategoryModel.fromJson(Map<String, dynamic> json) => ResItemSubCategoryModel(
        error: json["Error"],
        data: json["Data"] == null ? null : ItemSubCategoryData.fromJson(json["Data"]),
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

class ItemSubCategoryData {
  String? name;
  DateTime? nameUpdatedOn;
  String? categoryId;
  DateTime? categoryIdUpdatedOn;
  String? storeId;
  String? id;
  String? createdBy;
  DateTime? createdOn;
  String? updatedBy;
  DateTime? updatedOn;
  bool? active;

  ItemSubCategoryData({
    this.name,
    this.nameUpdatedOn,
    this.categoryId,
    this.categoryIdUpdatedOn,
    this.storeId,
    this.id,
    this.createdBy,
    this.createdOn,
    this.updatedBy,
    this.updatedOn,
    this.active,
  });

  factory ItemSubCategoryData.fromJson(Map<String, dynamic> json) => ItemSubCategoryData(
        name: json["Name"],
        nameUpdatedOn: json["Name_UpdatedOn"] == null ? null : DateTime.parse(json["Name_UpdatedOn"]),
        categoryId: json["CategoryID"],
        categoryIdUpdatedOn:
            json["CategoryID_UpdatedOn"] == null ? null : DateTime.parse(json["CategoryID_UpdatedOn"]),
        storeId: json["StoreID"],
        id: json["ID"],
        createdBy: json["CreatedBy"],
        createdOn: json["CreatedOn"] == null ? null : DateTime.parse(json["CreatedOn"]),
        updatedBy: json["UpdatedBy"],
        updatedOn: json["UpdatedOn"] == null ? null : DateTime.parse(json["UpdatedOn"]),
        active: json["Active"],
      );

  Map<String, dynamic> toJson() => {
        "Name": name,
        "Name_UpdatedOn": nameUpdatedOn?.toIso8601String(),
        "CategoryID": categoryId,
        "CategoryID_UpdatedOn": categoryIdUpdatedOn?.toIso8601String(),
        "StoreID": storeId,
        "ID": id,
        "CreatedBy": createdBy,
        "CreatedOn": createdOn?.toIso8601String(),
        "UpdatedBy": updatedBy,
        "UpdatedOn": updatedOn?.toIso8601String(),
        "Active": active,
      };
}
