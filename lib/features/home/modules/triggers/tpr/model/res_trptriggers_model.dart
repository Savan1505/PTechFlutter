class ResTrpTriggersModel {
  bool? error;
  TrpTriggersData? data;
  int? code;
  String? message;
  DateTime? timeStamp;

  ResTrpTriggersModel({
    this.error,
    this.data,
    this.code,
    this.message,
    this.timeStamp,
  });

  factory ResTrpTriggersModel.fromJson(Map<String, dynamic> json) => ResTrpTriggersModel(
        error: json["Error"],
        data: json["Data"] == null ? null : TrpTriggersData.fromJson(json["Data"]),
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

class TrpTriggersData {
  int? count;
  List<TrpTriggers>? list;

  TrpTriggersData({
    this.count,
    this.list,
  });

  factory TrpTriggersData.fromJson(Map<String, dynamic> json) => TrpTriggersData(
        count: json["Count"],
        list: json["List"] == null
            ? []
            : List<TrpTriggers>.from(json["List"]!.map((x) => TrpTriggers.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Count": count,
        "List": list == null ? [] : List<dynamic>.from(list!.map((x) => x.toJson())),
      };
}

class TrpTriggers {
  String? packageId;
  String? packageName;
  int? packageType;
  double? buyDown;
  double? retailPrice;
  double? unitCost;
  String? storeItemId;
  String? storeItemName;
  String? storeId;

  TrpTriggers({
    this.packageId,
    this.packageName,
    this.packageType,
    this.buyDown,
    this.retailPrice,
    this.unitCost,
    this.storeItemId,
    this.storeItemName,
    this.storeId,
  });

  factory TrpTriggers.fromJson(Map<String, dynamic> json) => TrpTriggers(
        packageId: json["PackageID"],
        packageName: json["PackageName"],
        packageType: json["PackageType"],
        buyDown: json["BuyDown"],
        retailPrice: json["RetailPrice"],
        unitCost: json["UnitCost"],
        storeItemId: json["StoreItemID"],
        storeItemName: json["StoreItemName"],
        storeId: json["StoreID"],
      );

  Map<String, dynamic> toJson() => {
        "PackageID": packageId,
        "PackageName": packageName,
        "PackageType": packageType,
        "BuyDown": buyDown,
        "RetailPrice": retailPrice,
        "UnitCost": unitCost,
        "StoreItemID": storeItemId,
        "StoreItemName": storeItemName,
        "StoreID": storeId,
      };
}
