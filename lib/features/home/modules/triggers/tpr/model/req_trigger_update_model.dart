import 'package:ptecpos_mobile/features/home/modules/triggers/tpr/model/req_trigger_model.dart';

class ReqTriggerUpdateModel {
  String? startDate;
  String? endDate;
  dynamic reduceBy;
  String? reduceType;
  int? quantity;
  String? storeItemId;
  List<TprStoreItemPackageList>? tprStoreItemPackageList;
  String? id;

  ReqTriggerUpdateModel({
    this.startDate,
    this.endDate,
    this.reduceBy,
    this.reduceType,
    this.quantity,
    this.storeItemId,
    this.tprStoreItemPackageList,
    this.id,
  });

  factory ReqTriggerUpdateModel.fromJson(Map<String, dynamic> json) => ReqTriggerUpdateModel(
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
        id: json["Id"],
      );

  Map<String, dynamic> toJson() => {
        "StartDate": startDate,
        "EndDate": endDate,
        "ReduceBy": reduceBy,
        "ReduceType": reduceType,
        "Quantity": quantity,
        "StoreItemID": storeItemId,
        "TprStoreItemPackageList": tprStoreItemPackageList == null
            ? []
            : List<dynamic>.from(tprStoreItemPackageList!.map((x) => x.toJson())),
        "Id": id,
      };
}
