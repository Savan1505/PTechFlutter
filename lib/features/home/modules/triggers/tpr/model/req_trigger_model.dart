class ReqTriggerModel {
  String? startDate;
  String? endDate;
  String? reduceBy;
  String? reduceType;
  String? quantity;
  String? storeId;
  String? storeItemId;
  List<TprStoreItemPackageList>? tprStoreItemPackageList;

  ReqTriggerModel({
    this.startDate,
    this.endDate,
    this.reduceBy,
    this.reduceType,
    this.quantity,
    this.storeItemId,
    this.tprStoreItemPackageList,
    this.storeId,
  });

  factory ReqTriggerModel.fromJson(Map<String, dynamic> json) => ReqTriggerModel(
        startDate: json["StartDate"],
        endDate: json["EndDate"],
        reduceBy: json["ReduceBy"],
        reduceType: json["ReduceType"],
        quantity: json["Quantity"],
        storeItemId: json["StoreItemID"],
        tprStoreItemPackageList: json["TprStoreItemPackageList"] == null
            ? []
            : List<TprStoreItemPackageList>.from(
                json["TprStoreItemPackageList"]!.map((x) => TprStoreItemPackageList.fromJson(x)),
              ),
      );

  Map<String, dynamic> toJson() => {
        "StartDate": startDate,
        "EndDate": endDate,
        "ReduceBy": reduceBy,
        "ReduceType": reduceType,
        "Quantity": quantity,
        "StoreItemID": storeItemId,
        "StoreID": storeId,
        "TprStoreItemPackageList": tprStoreItemPackageList == null
            ? []
            : List<dynamic>.from(tprStoreItemPackageList!.map((x) => x.toJson())),
      };
}

class TprStoreItemPackageList {
  String? packReferenceId;
  int? packReferenceType;

  TprStoreItemPackageList({
    this.packReferenceId,
    this.packReferenceType,
  });

  factory TprStoreItemPackageList.fromJson(Map<String, dynamic> json) => TprStoreItemPackageList(
        packReferenceId: json["PackReferenceID"],
        packReferenceType: json["PackReferenceType"],
      );

  Map<String, dynamic> toJson() => {
        "PackReferenceID": packReferenceId,
        "PackReferenceType": packReferenceType,
      };
}
