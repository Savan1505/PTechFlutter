class ResItemSuppliersModel {
  bool? error;
  ItemSuppliersData? data;
  int? code;
  String? message;
  DateTime? timeStamp;

  ResItemSuppliersModel({
    this.error,
    this.data,
    this.code,
    this.message,
    this.timeStamp,
  });

  factory ResItemSuppliersModel.fromJson(Map<String, dynamic> json) => ResItemSuppliersModel(
        error: json["Error"],
        data: json["Data"] == null ? null : ItemSuppliersData.fromJson(json["Data"]),
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

class ItemSuppliersData {
  int? count;
  List<ItemSuppliers>? list;

  ItemSuppliersData({
    this.count,
    this.list,
  });

  factory ItemSuppliersData.fromJson(Map<String, dynamic> json) => ItemSuppliersData(
        count: json["Count"],
        list: json["List"] == null
            ? []
            : List<ItemSuppliers>.from(json["List"]!.map((x) => ItemSuppliers.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Count": count,
        "List": list == null ? [] : List<dynamic>.from(list!.map((x) => x.toJson())),
      };
}

class ItemSuppliers {
  String? id;
  String? name;

  ItemSuppliers({
    this.id,
    this.name,
  });

  factory ItemSuppliers.fromJson(Map<String, dynamic> json) => ItemSuppliers(
        id: json["ID"],
        name: json["Name"],
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "Name": name,
      };
}
