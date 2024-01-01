class ResStoreItemTypeCollectionModel {
  bool? error;
  CollectionData? data;
  int? code;
  String? message;
  DateTime? timeStamp;

  ResStoreItemTypeCollectionModel({
    this.error,
    this.data,
    this.code,
    this.message,
    this.timeStamp,
  });

  factory ResStoreItemTypeCollectionModel.fromJson(Map<String, dynamic> json) =>
      ResStoreItemTypeCollectionModel(
        error: json["Error"],
        data: json["Data"] == null ? null : CollectionData.fromJson(json["Data"]),
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

  ResStoreItemTypeCollectionModel fromJsonData(Map<String, dynamic> json) {
    return ResStoreItemTypeCollectionModel(
      error: json["Error"],
      data: json["Data"] == null ? null : CollectionData.fromJson(json["Data"]),
      code: json["Code"],
      message: json["Message"],
      timeStamp: json["TimeStamp"] == null ? null : DateTime.parse(json["TimeStamp"]),
    );
  }
}

class CollectionData {
  int? count;
  List<ItemTypeCollection>? list;

  CollectionData({
    this.count,
    this.list,
  });

  factory CollectionData.fromJson(Map<String, dynamic> json) => CollectionData(
        count: json["Count"],
        list: json["List"] == null
            ? []
            : List<ItemTypeCollection>.from(json["List"]!.map((x) => ItemTypeCollection.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Count": count,
        "List": list == null ? [] : List<dynamic>.from(list!.map((x) => x.toJson())),
      };
}

class ItemTypeCollection {
  String? id;
  String? name;
  String? code;

  ItemTypeCollection({
    this.id,
    this.name,
    this.code,
  });

  factory ItemTypeCollection.fromJson(Map<String, dynamic> json) => ItemTypeCollection(
        id: json["ID"],
        name: json["Name"],
        code: json["Code"],
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "Name": name,
        "Code": code,
      };
}
