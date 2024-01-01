class ResAccessModel {
  bool? error;
  AccessData? data;
  int? code;
  String? message;
  DateTime? timeStamp;

  ResAccessModel({
    this.error,
    this.data,
    this.code,
    this.message,
    this.timeStamp,
  });

  factory ResAccessModel.fromJson(Map<String, dynamic> json) => ResAccessModel(
        error: json["Error"],
        data: json["Data"] == null ? null : AccessData.fromJson(json["Data"]),
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

class AccessData {
  String? id;
  String? name;
  String? description;
  bool? show;
  dynamic displaySeqNo;
  bool? favorite;
  List<StoreItem>? storeItems;

  AccessData({
    this.id,
    this.name,
    this.description,
    this.show,
    this.displaySeqNo,
    this.favorite,
    this.storeItems,
  });

  factory AccessData.fromJson(Map<String, dynamic> json) => AccessData(
        id: json["ID"],
        name: json["Name"],
        description: json["Description"],
        show: json["Show"],
        displaySeqNo: json["DisplaySeqNo"],
        favorite: json["Favorite"],
        storeItems: json["StoreItems"] == null
            ? []
            : List<StoreItem>.from(json["StoreItems"]!.map((x) => StoreItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "Name": name,
        "Description": description,
        "Show": show,
        "DisplaySeqNo": displaySeqNo,
        "Favorite": favorite,
        "StoreItems": storeItems == null ? [] : List<dynamic>.from(storeItems!.map((x) => x.toJson())),
      };
}

class StoreItem {
  String? id;
  String? storeItemId;
  String? name;

  StoreItem({
    this.id,
    this.storeItemId,
    this.name,
  });

  factory StoreItem.fromJson(Map<String, dynamic> json) => StoreItem(
        id: json["ID"],
        storeItemId: json["StoreItemID"],
        name: json["Name"],
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "StoreItemID": storeItemId,
        "Name": name,
      };
}
