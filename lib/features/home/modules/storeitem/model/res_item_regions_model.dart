class ResItemRegionsModel {
  bool? error;
  ItemRegionsData? data;
  int? code;
  String? message;
  DateTime? timeStamp;

  ResItemRegionsModel({
    this.error,
    this.data,
    this.code,
    this.message,
    this.timeStamp,
  });

  factory ResItemRegionsModel.fromJson(Map<String, dynamic> json) => ResItemRegionsModel(
        error: json["Error"],
        data: json["Data"] == null ? null : ItemRegionsData.fromJson(json["Data"]),
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

class ItemRegionsData {
  int? count;
  List<ItemRegions>? list;

  ItemRegionsData({
    this.count,
    this.list,
  });

  factory ItemRegionsData.fromJson(Map<String, dynamic> json) => ItemRegionsData(
        count: json["Count"],
        list: json["List"] == null
            ? []
            : List<ItemRegions>.from(json["List"]!.map((x) => ItemRegions.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Count": count,
        "List": list == null ? [] : List<dynamic>.from(list!.map((x) => x.toJson())),
      };
}

class ItemRegions {
  String? id;
  String? name;
  String? description;

  ItemRegions({
    this.id,
    this.name,
    this.description,
  });

  factory ItemRegions.fromJson(Map<String, dynamic> json) => ItemRegions(
        id: json["ID"],
        name: json["Name"],
        description: json["Description"],
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "Name": name,
        "Description": description,
      };
}
