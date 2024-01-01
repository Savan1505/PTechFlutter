class ResItemAbvModel {
  bool? error;
  ItemAbvData? data;
  int? code;
  String? message;
  DateTime? timeStamp;

  ResItemAbvModel({
    this.error,
    this.data,
    this.code,
    this.message,
    this.timeStamp,
  });

  factory ResItemAbvModel.fromJson(Map<String, dynamic> json) => ResItemAbvModel(
        error: json["Error"],
        data: json["Data"] == null ? null : ItemAbvData.fromJson(json["Data"]),
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

class ItemAbvData {
  int? count;
  List<ItemAbv>? list;

  ItemAbvData({
    this.count,
    this.list,
  });

  factory ItemAbvData.fromJson(Map<String, dynamic> json) => ItemAbvData(
        count: json["Count"],
        list: json["List"] == null
            ? []
            : List<ItemAbv>.from(json["List"]!.map((x) => ItemAbv.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Count": count,
        "List": list == null ? [] : List<dynamic>.from(list!.map((x) => x.toJson())),
      };
}

class ItemAbv {
  String? name;
  String? description;
  String? storeId;
  String? id;
  String? createdBy;
  DateTime? createdOn;
  String? updatedBy;
  DateTime? updatedOn;
  bool? active;

  ItemAbv({
    this.name,
    this.description,
    this.storeId,
    this.id,
    this.createdBy,
    this.createdOn,
    this.updatedBy,
    this.updatedOn,
    this.active,
  });

  factory ItemAbv.fromJson(Map<String, dynamic> json) => ItemAbv(
        name: json["Name"],
        description: json["Description"],
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
        "Description": description,
        "StoreID": storeId,
        "ID": id,
        "CreatedBy": createdBy,
        "CreatedOn": createdOn?.toIso8601String(),
        "UpdatedBy": updatedBy,
        "UpdatedOn": updatedOn?.toIso8601String(),
        "Active": active,
      };
}
