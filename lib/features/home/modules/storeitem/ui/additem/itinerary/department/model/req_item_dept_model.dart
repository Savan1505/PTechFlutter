class ReqItemDeptModel {
  String? id;
  String? name;
  dynamic surcharge;
  bool? allowFoodStamp;
  int? marginMarkup;
  String? mValue;
  List<String>? taxSlabIdList;
  bool? ageCheck;
  bool? favorite;
  String? storeId;

  ReqItemDeptModel({
    this.id,
    this.name,
    this.surcharge,
    this.allowFoodStamp,
    this.marginMarkup,
    this.mValue,
    this.taxSlabIdList,
    this.ageCheck,
    this.favorite,
    this.storeId,
  });

  factory ReqItemDeptModel.fromJson(Map<String, dynamic> json) => ReqItemDeptModel(
        id: json["ID"],
        name: json["Name"],
        surcharge: json["Surcharge"],
        allowFoodStamp: json["AllowFoodStamp"],
        marginMarkup: json["MarginMarkup"],
        mValue: json["MValue"],
        taxSlabIdList:
            json["TaxSlabIdList"] == null ? [] : List<String>.from(json["TaxSlabIdList"]!.map((x) => x)),
        ageCheck: json["Agecheck"],
        favorite: json["Favorite"],
        storeId: json["StoreID"],
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "Name": name,
        "Surcharge": surcharge,
        "AllowFoodStamp": allowFoodStamp,
        "MarginMarkup": marginMarkup,
        "MValue": mValue,
        "TaxSlabIdList": taxSlabIdList == null ? [] : List<dynamic>.from(taxSlabIdList!.map((x) => x)),
        "Agecheck": ageCheck,
        "Favorite": favorite,
        "StoreID": storeId,
      };
}
