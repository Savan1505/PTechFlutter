class ResItemCategoryDeptModel {
  bool? error;
  ItemCategoryDeptData? data;
  int? code;
  String? message;
  DateTime? timeStamp;

  ResItemCategoryDeptModel({
    this.error,
    this.data,
    this.code,
    this.message,
    this.timeStamp,
  });

  factory ResItemCategoryDeptModel.fromJson(Map<String, dynamic> json) => ResItemCategoryDeptModel(
        error: json["Error"],
        data: json["Data"] == null ? null : ItemCategoryDeptData.fromJson(json["Data"]),
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

class ItemCategoryDeptData {
  String? name;
  DateTime? nameUpdatedOn;
  dynamic itemDeptId;
  DateTime? itemDeptIdUpdatedOn;
  String? storeId;
  String? id;
  String? createdBy;
  DateTime? createdOn;
  String? updatedBy;
  DateTime? updatedOn;
  bool? active;

  ItemCategoryDeptData({
    this.name,
    this.nameUpdatedOn,
    this.itemDeptId,
    this.itemDeptIdUpdatedOn,
    this.storeId,
    this.id,
    this.createdBy,
    this.createdOn,
    this.updatedBy,
    this.updatedOn,
    this.active,
  });

  factory ItemCategoryDeptData.fromJson(Map<String, dynamic> json) => ItemCategoryDeptData(
        name: json["Name"],
        nameUpdatedOn: json["Name_UpdatedOn"] == null ? null : DateTime.parse(json["Name_UpdatedOn"]),
        itemDeptId: json["ItemDeptID"],
        itemDeptIdUpdatedOn:
            json["ItemDeptID_UpdatedOn"] == null ? null : DateTime.parse(json["ItemDeptID_UpdatedOn"]),
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
        "ItemDeptID": itemDeptId,
        "ItemDeptID_UpdatedOn": itemDeptIdUpdatedOn?.toIso8601String(),
        "StoreID": storeId,
        "ID": id,
        "CreatedBy": createdBy,
        "CreatedOn": createdOn?.toIso8601String(),
        "UpdatedBy": updatedBy,
        "UpdatedOn": updatedOn?.toIso8601String(),
        "Active": active,
      };
}
