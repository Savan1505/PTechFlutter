class ReqItemCategoryDeptModel {
  String? name;
  String? itemDeptId;
  String? storeId;

  ReqItemCategoryDeptModel({
    this.name,
    this.itemDeptId,
    this.storeId,
  });

  factory ReqItemCategoryDeptModel.fromJson(Map<String, dynamic> json) => ReqItemCategoryDeptModel(
        name: json["Name"],
        itemDeptId: json["ItemDeptID"],
        storeId: json["StoreID"],
      );

  Map<String, dynamic> toJson() => {
        "Name": name,
        "ItemDeptID": itemDeptId,
        "StoreID": storeId,
      };
}
