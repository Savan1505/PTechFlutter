class ResTriggerModel {
  bool? error;
  ResTriggerData? data;
  int? code;
  String? message;
  DateTime? timeStamp;

  ResTriggerModel({
    this.error,
    this.data,
    this.code,
    this.message,
    this.timeStamp,
  });

  factory ResTriggerModel.fromJson(Map<String, dynamic> json) => ResTriggerModel(
        error: json["Error"],
        data: json["Data"] == null ? null : ResTriggerData.fromJson(json["Data"]),
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

class ResTriggerData {
  int? count;
  List<Trigger>? list;

  ResTriggerData({
    this.count,
    this.list,
  });

  factory ResTriggerData.fromJson(Map<String, dynamic> json) => ResTriggerData(
        count: json["Count"],
        list: json["List"] == null
            ? []
            : List<Trigger>.from(json["List"]!.map((x) => Trigger.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Count": count,
        "List": list == null ? [] : List<dynamic>.from(list!.map((x) => x.toJson())),
      };
}

class Trigger {
  String? id;
  String? packageId;
  String? storeItemId;
  int? packReferenceType;
  DateTime? startDate;
  DateTime? endDate;
  double? reduceBy;
  int? reduceType;
  String? storeItemName;
  String? packageName;
  double? quantity;
  bool? isExpired;

  Trigger({
    this.id,
    this.packageId,
    this.storeItemId,
    this.packReferenceType,
    this.startDate,
    this.endDate,
    this.reduceBy,
    this.reduceType,
    this.storeItemName,
    this.packageName,
    this.quantity,
    this.isExpired,
  });

  factory Trigger.fromJson(Map<String, dynamic> json) => Trigger(
        id: json["ID"],
        packageId: json["PackageID"],
        storeItemId: json["StoreItemID"],
        packReferenceType: json["PackReferenceType"],
        startDate: json["StartDate"] == null ? null : DateTime.parse(json["StartDate"]),
        endDate: json["EndDate"] == null ? null : DateTime.parse(json["EndDate"]),
        reduceBy: json["ReduceBy"],
        reduceType: json["ReduceType"],
        storeItemName: json["StoreItemName"],
        packageName: json["PackageName"],
        quantity: json["Quantity"],
        isExpired: json["is_expired"],
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "PackageID": packageId,
        "StoreItemID": storeItemId,
        "PackReferenceType": packReferenceType,
        "StartDate": startDate?.toIso8601String(),
        "EndDate": endDate?.toIso8601String(),
        "ReduceBy": reduceBy,
        "ReduceType": reduceType,
        "StoreItemName": storeItemName,
        "PackageName": packageName,
        "Quantity": quantity,
        "is_expired": isExpired,
      };
}
