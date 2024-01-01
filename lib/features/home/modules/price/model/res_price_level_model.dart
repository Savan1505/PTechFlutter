class ResPriceLevelModel {
  bool? error;
  PriceLevelData? data;
  int? code;
  String? message;
  DateTime? timeStamp;

  ResPriceLevelModel({
    this.error,
    this.data,
    this.code,
    this.message,
    this.timeStamp,
  });

  factory ResPriceLevelModel.fromJson(Map<String, dynamic> json) => ResPriceLevelModel(
        error: json["Error"],
        data: json["Data"] == null ? null : PriceLevelData.fromJson(json["Data"]),
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

class PriceLevelData {
  int? count;
  List<PriceLevel>? list;

  PriceLevelData({
    this.count,
    this.list,
  });

  factory PriceLevelData.fromJson(Map<String, dynamic> json) => PriceLevelData(
        count: json["Count"],
        list: json["List"] == null
            ? []
            : List<PriceLevel>.from(json["List"]!.map((x) => PriceLevel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Count": count,
        "List": list == null ? [] : List<dynamic>.from(list!.map((x) => x.toJson())),
      };
}

class PriceLevel {
  String? name;
  double? rate;
  int? type;
  int? rateType;
  bool? rateAdd;
  String? storeId;
  String? id;
  String? createdBy;
  DateTime? createdOn;
  String? updatedBy;
  DateTime? updatedOn;
  bool? active;

  PriceLevel({
    this.name,
    this.rate,
    this.type,
    this.rateType,
    this.rateAdd,
    this.storeId,
    this.id,
    this.createdBy,
    this.createdOn,
    this.updatedBy,
    this.updatedOn,
    this.active,
  });

  factory PriceLevel.fromJson(Map<String, dynamic> json) => PriceLevel(
        name: json["Name"],
        rate: json["Rate"],
        type: json["Type"],
        rateType: json["RateType"],
        rateAdd: json["RateAdd"],
        storeId: json["StoreID"],
        id: json["ID"],
        createdBy: json["CreatedBy"],
        createdOn: json["CreatedOn"] == null ? null : DateTime.parse(json["CreatedOn"]),
        updatedBy: json["UpdatedBy"],
        updatedOn: json["UpdatedOn"] == null ? null : DateTime.parse(json["UpdatedOn"]),
        active: json["Active"],
      );

  Map<String, dynamic> toJson() => {
        "Name": name,
        "Rate": rate,
        "Type": type,
        "RateType": rateType,
        "RateAdd": rateAdd,
        "StoreID": storeId,
        "ID": id,
        "CreatedBy": createdBy,
        "CreatedOn": createdOn?.toIso8601String(),
        "UpdatedBy": updatedBy,
        "UpdatedOn": updatedOn?.toIso8601String(),
        "Active": active,
      };
}
