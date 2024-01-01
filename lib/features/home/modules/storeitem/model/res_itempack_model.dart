class ResItemPackModel {
  bool? error;
  ItemPackData? data;
  int? code;
  String? message;
  DateTime? timeStamp;

  ResItemPackModel({
    this.error,
    this.data,
    this.code,
    this.message,
    this.timeStamp,
  });

  factory ResItemPackModel.fromJson(Map<String, dynamic> json) => ResItemPackModel(
        error: json["Error"],
        data: json["Data"] == null ? null : ItemPackData.fromJson(json["Data"]),
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

class ItemPackData {
  int? count;
  List<ItemPack>? list;

  ItemPackData({
    this.count,
    this.list,
  });

  factory ItemPackData.fromJson(Map<String, dynamic> json) => ItemPackData(
        count: json["Count"],
        list: json["List"] == null
            ? []
            : List<ItemPack>.from(json["List"]!.map((x) => ItemPack.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Count": count,
        "List": list == null ? [] : List<dynamic>.from(list!.map((x) => x.toJson())),
      };
}

class ItemPack {
  String? name;
  int? displaySeqNo;
  int? unitsInPack;
  String? id;
  String? createdBy;
  DateTime? createdOn;
  String? updatedBy;
  DateTime? updatedOn;
  bool? active;

  ItemPack({
    this.name,
    this.displaySeqNo,
    this.unitsInPack,
    this.id,
    this.createdBy,
    this.createdOn,
    this.updatedBy,
    this.updatedOn,
    this.active,
  });

  factory ItemPack.fromJson(Map<String, dynamic> json) => ItemPack(
        name: json["Name"],
        displaySeqNo: json["DisplaySeqNo"],
        unitsInPack: json["UnitsInPack"],
        id: json["ID"],
        createdBy: json["CreatedBy"],
        createdOn: json["CreatedOn"] == null ? null : DateTime.parse(json["CreatedOn"]),
        updatedBy: json["UpdatedBy"],
        updatedOn: json["UpdatedOn"] == null ? null : DateTime.parse(json["UpdatedOn"]),
        active: json["Active"],
      );

  Map<String, dynamic> toJson() => {
        "Name": name,
        "DisplaySeqNo": displaySeqNo,
        "UnitsInPack": unitsInPack,
        "ID": id,
        "CreatedBy": createdBy,
        "CreatedOn": createdOn?.toIso8601String(),
        "UpdatedBy": updatedBy,
        "UpdatedOn": updatedOn?.toIso8601String(),
        "Active": active,
      };
}
