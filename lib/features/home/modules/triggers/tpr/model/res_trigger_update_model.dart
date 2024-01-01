class ResTriggerUpdateModel {
  bool? error;
  TriggerUpdateData? data;
  int? code;
  String? message;
  DateTime? timeStamp;

  ResTriggerUpdateModel({
    this.error,
    this.data,
    this.code,
    this.message,
    this.timeStamp,
  });

  factory ResTriggerUpdateModel.fromJson(Map<String, dynamic> json) => ResTriggerUpdateModel(
        error: json["Error"],
        data: json["Data"] == null ? null : TriggerUpdateData.fromJson(json["Data"]),
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

class TriggerUpdateData {
  String? id;
  double? quantity;
  DateTime? startDate;
  DateTime? endDate;
  int? reduceType;
  dynamic reduceBy;
  String? storeItemId;
  String? storeItemName;
  String? packReferenceId;
  int? packReferenceType;
  String? packReferenceName;

  TriggerUpdateData({
    this.id,
    this.quantity,
    this.startDate,
    this.endDate,
    this.reduceType,
    this.reduceBy,
    this.storeItemId,
    this.storeItemName,
    this.packReferenceId,
    this.packReferenceType,
    this.packReferenceName,
  });

  factory TriggerUpdateData.fromJson(Map<String, dynamic> json) => TriggerUpdateData(
        id: json["Id"],
        quantity: json["Quantity"],
        startDate: json["StartDate"] == null ? null : DateTime.parse(json["StartDate"]),
        endDate: json["EndDate"] == null ? null : DateTime.parse(json["EndDate"]),
        reduceType: json["ReduceType"],
        reduceBy: json["ReduceBy"],
        storeItemId: json["StoreItemID"],
        storeItemName: json["StoreItemName"],
        packReferenceId: json["PackReferenceID"],
        packReferenceType: json["PackReferenceType"],
        packReferenceName: json["PackReferenceName"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "Quantity": quantity,
        "StartDate": startDate?.toIso8601String(),
        "EndDate": endDate?.toIso8601String(),
        "ReduceType": reduceType,
        "ReduceBy": reduceBy,
        "StoreItemID": storeItemId,
        "StoreItemName": storeItemName,
        "PackReferenceID": packReferenceId,
        "PackReferenceType": packReferenceType,
        "PackReferenceName": packReferenceName,
      };
}
