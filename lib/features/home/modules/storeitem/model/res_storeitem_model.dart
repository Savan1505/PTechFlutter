class ResStoreItemModel {
  bool? error;
  StoreItemData? data;
  int? code;
  String? message;
  DateTime? timeStamp;

  ResStoreItemModel({
    this.error,
    this.data,
    this.code,
    this.message,
    this.timeStamp,
  });

  factory ResStoreItemModel.fromJson(Map<String, dynamic> json) => ResStoreItemModel(
        error: json["Error"],
        data: json["Data"] == null ? null : StoreItemData.fromJson(json["Data"]),
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

class StoreItemData {
  int? count;
  List<StoreItemElement>? list;

  StoreItemData({
    this.count,
    this.list,
  });

  factory StoreItemData.fromJson(Map<String, dynamic> json) => StoreItemData(
        count: json["Count"],
        list: json["List"] == null
            ? []
            : List<StoreItemElement>.from(json["List"]!.map((x) => StoreItemElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Count": count,
        "List": list == null ? [] : List<dynamic>.from(list!.map((x) => x.toJson())),
      };
}

class StoreItemElement {
  String? distributorId;
  String? regionId;
  String? imagePhysicalName;
  String? taxSlabId;
  String? id;
  String? name;
  String? sku;
  String? itemId;
  String? storeId;
  String? itemDeptId;
  String? itemCatId;
  String? itemTypeId;
  String? typeName;
  String? itemSubCatId;
  dynamic ageId;
  bool? inActive;
  dynamic groupId;
  DateTime? createdOn;

  StoreItemElement({
    this.distributorId,
    this.regionId,
    this.imagePhysicalName,
    this.taxSlabId,
    this.id,
    this.name,
    this.sku,
    this.itemId,
    this.storeId,
    this.itemDeptId,
    this.itemCatId,
    this.itemTypeId,
    this.typeName,
    this.itemSubCatId,
    this.ageId,
    this.inActive,
    this.groupId,
    this.createdOn,
  });

  factory StoreItemElement.fromJson(Map<String, dynamic> json) => StoreItemElement(
        distributorId: json["DistributorID"],
        regionId: json["RegionID"],
        imagePhysicalName: json["ImagePhysicalName"],
        taxSlabId: json["TaxSlabID"],
        id: json["Id"],
        name: json["Name"],
        sku: json["SKU"],
        itemId: json["ItemID"],
        storeId: json["StoreID"],
        itemDeptId: json["ItemDeptID"],
        itemCatId: json["ItemCatID"],
        itemTypeId: json["ItemTypeID"],
        typeName: json["TypeName"],
        itemSubCatId: json["ItemSubCatID"],
        ageId: json["AgeID"],
        inActive: json["InActive"],
        groupId: json["GroupID"],
        createdOn: json["CreatedOn"] == null ? null : DateTime.parse(json["CreatedOn"]),
      );

  Map<String, dynamic> toJson() => {
        "DistributorID": distributorId,
        "RegionID": regionId,
        "ImagePhysicalName": imagePhysicalName,
        "TaxSlabID": taxSlabId,
        "Id": id,
        "Name": name,
        "SKU": sku,
        "ItemID": itemId,
        "StoreID": storeId,
        "ItemDeptID": itemDeptId,
        "ItemCatID": itemCatId,
        "ItemTypeID": itemTypeId,
        "TypeName": typeName,
        "ItemSubCatID": itemSubCatId,
        "AgeID": ageId,
        "InActive": inActive,
        "GroupID": groupId,
        "CreatedOn": createdOn?.toIso8601String(),
      };
}
