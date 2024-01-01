class ResItemFlavourModel {
  bool? error;
  ItemFlavourData? data;
  int? code;
  String? message;
  DateTime? timeStamp;

  ResItemFlavourModel({
    this.error,
    this.data,
    this.code,
    this.message,
    this.timeStamp,
  });

  factory ResItemFlavourModel.fromJson(Map<String, dynamic> json) => ResItemFlavourModel(
        error: json["Error"],
        data: json["Data"] == null ? null : ItemFlavourData.fromJson(json["Data"]),
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

class ItemFlavourData {
  int? count;
  List<ItemFlavour>? list;

  ItemFlavourData({
    this.count,
    this.list,
  });

  factory ItemFlavourData.fromJson(Map<String, dynamic> json) => ItemFlavourData(
        count: json["Count"],
        list: json["List"] == null
            ? []
            : List<ItemFlavour>.from(json["List"]!.map((x) => ItemFlavour.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Count": count,
        "List": list == null ? [] : List<dynamic>.from(list!.map((x) => x.toJson())),
      };
}

class ItemFlavour {
  String? id;
  String? name;
  String? description;

  ItemFlavour({
    this.id,
    this.name,
    this.description,
  });

  factory ItemFlavour.fromJson(Map<String, dynamic> json) => ItemFlavour(
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
