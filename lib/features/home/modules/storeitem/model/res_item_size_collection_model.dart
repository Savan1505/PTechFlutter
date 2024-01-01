class ResItemSizeCollectionModel {
  bool? error;
  ItemSizeData? data;
  int? code;
  String? message;
  DateTime? timeStamp;

  ResItemSizeCollectionModel({
    this.error,
    this.data,
    this.code,
    this.message,
    this.timeStamp,
  });

  factory ResItemSizeCollectionModel.fromJson(Map<String, dynamic> json) => ResItemSizeCollectionModel(
        error: json["Error"],
        data: json["Data"] == null ? null : ItemSizeData.fromJson(json["Data"]),
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

class ItemSizeData {
  int? count;
  List<ItemSizeElement>? list;

  ItemSizeData({
    this.count,
    this.list,
  });

  factory ItemSizeData.fromJson(Map<String, dynamic> json) => ItemSizeData(
        count: json["Count"],
        list: json["List"] == null
            ? []
            : List<ItemSizeElement>.from(json["List"]!.map((x) => ItemSizeElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Count": count,
        "List": list == null ? [] : List<dynamic>.from(list!.map((x) => x.toJson())),
      };
}

class ItemSizeElement {
  String? id;
  String? name;
  int? displaySeqNo;

  ItemSizeElement({
    this.id,
    this.name,
    this.displaySeqNo,
  });

  factory ItemSizeElement.fromJson(Map<String, dynamic> json) => ItemSizeElement(
        id: json["ID"],
        name: json["Name"],
        displaySeqNo: json["DisplaySeqNo"],
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "Name": name,
        "DisplaySeqNo": displaySeqNo,
      };
}
