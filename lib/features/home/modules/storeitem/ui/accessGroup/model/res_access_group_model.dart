class ResAccessGroupModel {
  bool? error;
  AccessGroupData? data;
  int? code;
  String? message;
  DateTime? timeStamp;

  ResAccessGroupModel({
    this.error,
    this.data,
    this.code,
    this.message,
    this.timeStamp,
  });

  factory ResAccessGroupModel.fromJson(Map<String, dynamic> json) => ResAccessGroupModel(
        error: json["Error"],
        data: json["Data"] == null ? null : AccessGroupData.fromJson(json["Data"]),
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

class AccessGroupData {
  int? count;
  List<AccessGroup>? list;

  AccessGroupData({
    this.count,
    this.list,
  });

  factory AccessGroupData.fromJson(Map<String, dynamic> json) => AccessGroupData(
        count: json["Count"],
        list: json["List"] == null
            ? []
            : List<AccessGroup>.from(json["List"]!.map((x) => AccessGroup.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Count": count,
        "List": list == null ? [] : List<dynamic>.from(list!.map((x) => x.toJson())),
      };
}

class AccessGroup {
  String? id;
  String? name;
  int? itemCount;
  bool? active;

  AccessGroup({
    this.id,
    this.name,
    this.itemCount,
    this.active,
  });

  factory AccessGroup.fromJson(Map<String, dynamic> json) => AccessGroup(
        id: json["ID"],
        name: json["Name"],
        itemCount: json["ItemCount"],
        active: json["Active"],
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "Name": name,
        "ItemCount": itemCount,
        "Active": active,
      };
}
