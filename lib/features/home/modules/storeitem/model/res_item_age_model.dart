class ResItemAgeModel {
  bool? error;
  ItemAgeData? data;
  int? code;
  String? message;
  DateTime? timeStamp;

  ResItemAgeModel({
    this.error,
    this.data,
    this.code,
    this.message,
    this.timeStamp,
  });

  factory ResItemAgeModel.fromJson(Map<String, dynamic> json) => ResItemAgeModel(
        error: json["Error"],
        data: json["Data"] == null ? null : ItemAgeData.fromJson(json["Data"]),
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

class ItemAgeData {
  int? count;
  List<ItemAge>? list;

  ItemAgeData({
    this.count,
    this.list,
  });

  factory ItemAgeData.fromJson(Map<String, dynamic> json) => ItemAgeData(
        count: json["Count"],
        list: json["List"] == null
            ? []
            : List<ItemAge>.from(json["List"]!.map((x) => ItemAge.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Count": count,
        "List": list == null ? [] : List<dynamic>.from(list!.map((x) => x.toJson())),
      };
}

class ItemAge {
  String? name;
  int? limit;
  String? message;
  String? id;
  String? createdBy;
  DateTime? createdOn;
  String? updatedBy;
  DateTime? updatedOn;
  bool? active;

  ItemAge({
    this.name,
    this.limit,
    this.message,
    this.id,
    this.createdBy,
    this.createdOn,
    this.updatedBy,
    this.updatedOn,
    this.active,
  });

  factory ItemAge.fromJson(Map<String, dynamic> json) => ItemAge(
        name: json["Name"],
        limit: json["Limit"],
        message: json["Message"],
        id: json["ID"],
        createdBy: json["CreatedBy"],
        createdOn: json["CreatedOn"] == null ? null : DateTime.parse(json["CreatedOn"]),
        updatedBy: json["UpdatedBy"],
        updatedOn: json["UpdatedOn"] == null ? null : DateTime.parse(json["UpdatedOn"]),
        active: json["Active"],
      );

  Map<String, dynamic> toJson() => {
        "Name": name,
        "Limit": limit,
        "Message": message,
        "ID": id,
        "CreatedBy": createdBy,
        "CreatedOn": createdOn?.toIso8601String(),
        "UpdatedBy": updatedBy,
        "UpdatedOn": updatedOn?.toIso8601String(),
        "Active": active,
      };
}
