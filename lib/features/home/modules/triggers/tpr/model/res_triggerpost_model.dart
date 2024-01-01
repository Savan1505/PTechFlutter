class ResTriggerPostModel {
  bool? error;
  TriggerPostData? data;
  int? code;
  String? message;
  DateTime? timeStamp;

  ResTriggerPostModel({
    this.error,
    this.data,
    this.code,
    this.message,
    this.timeStamp,
  });

  factory ResTriggerPostModel.fromJson(Map<String, dynamic> json) => ResTriggerPostModel(
        error: json["Error"],
        data: json["Data"] == null ? null : TriggerPostData.fromJson(json["Data"]),
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

class TriggerPostData {
  String? id;
  dynamic quantity;
  DateTime? startDate;
  DateTime? endDate;
  int? reduceType;
  dynamic reduceBy;
  List<TprStoreItemPackageList>? tprStoreItemPackageList;
  String? storeId;
  String? storeItemId;

  TriggerPostData({
    this.id,
    this.quantity,
    this.startDate,
    this.endDate,
    this.reduceType,
    this.reduceBy,
    this.tprStoreItemPackageList,
    this.storeId,
    this.storeItemId,
  });

  factory TriggerPostData.fromJson(Map<String, dynamic> json) => TriggerPostData(
        id: json["ID"],
        quantity: json["Quantity"],
        startDate: json["StartDate"] == null ? null : DateTime.parse(json["StartDate"]),
        endDate: json["EndDate"] == null ? null : DateTime.parse(json["EndDate"]),
        reduceType: json["ReduceType"],
        reduceBy: json["ReduceBy"],
        tprStoreItemPackageList: json["TprStoreItemPackageList"] == null
            ? []
            : List<TprStoreItemPackageList>.from(
                json["TprStoreItemPackageList"]!.map((x) => TprStoreItemPackageList.fromJson(x)),
              ),
        storeId: json["StoreID"],
        storeItemId: json["StoreItemID"],
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "Quantity": quantity,
        "StartDate": startDate?.toIso8601String(),
        "EndDate": endDate?.toIso8601String(),
        "ReduceType": reduceType,
        "ReduceBy": reduceBy,
        "TprStoreItemPackageList": tprStoreItemPackageList == null
            ? []
            : List<dynamic>.from(tprStoreItemPackageList!.map((x) => x.toJson())),
        "StoreID": storeId,
        "StoreItemID": storeItemId,
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
