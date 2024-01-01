class ResItemTaxLabModel {
  bool? error;
  ItemTaxLabData? data;
  int? code;
  String? message;
  DateTime? timeStamp;

  ResItemTaxLabModel({
    this.error,
    this.data,
    this.code,
    this.message,
    this.timeStamp,
  });

  factory ResItemTaxLabModel.fromJson(Map<String, dynamic> json) => ResItemTaxLabModel(
        error: json["Error"],
        data: json["Data"] == null ? null : ItemTaxLabData.fromJson(json["Data"]),
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

class ItemTaxLabData {
  String? id;
  String? name;
  String? description;
  double? taxSlab;
  List<String>? storeIdList;

  ItemTaxLabData({
    this.id,
    this.name,
    this.description,
    this.taxSlab,
    this.storeIdList,
  });

  factory ItemTaxLabData.fromJson(Map<String, dynamic> json) => ItemTaxLabData(
        id: json["Id"],
        name: json["Name"],
        description: json["Description"],
        taxSlab: json["TaxSlab"],
        storeIdList:
            json["StoreIdList"] == null ? [] : List<String>.from(json["StoreIdList"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "Name": name,
        "Description": description,
        "TaxSlab": taxSlab,
        "StoreIdList": storeIdList == null ? [] : List<dynamic>.from(storeIdList!.map((x) => x)),
      };
}
