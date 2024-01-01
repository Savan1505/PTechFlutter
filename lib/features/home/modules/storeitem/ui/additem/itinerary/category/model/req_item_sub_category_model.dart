class ReqItemSubCategoryModel {
  String? name;
  String? categoryId;
  String? storeId;

  ReqItemSubCategoryModel({
    this.name,
    this.categoryId,
    this.storeId,
  });

  factory ReqItemSubCategoryModel.fromJson(Map<String, dynamic> json) => ReqItemSubCategoryModel(
        name: json["Name"],
        categoryId: json["CategoryID"],
        storeId: json["StoreID"],
      );

  Map<String, dynamic> toJson() => {
        "Name": name,
        "CategoryID": categoryId,
        "StoreID": storeId,
      };
}
