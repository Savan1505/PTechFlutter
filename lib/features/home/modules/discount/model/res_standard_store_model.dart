class ResStandardStoresModel {
  bool? error;
  StandardStoresData? data;
  int? code;
  String? message;
  DateTime? timeStamp;

  ResStandardStoresModel({
    this.error,
    this.data,
    this.code,
    this.message,
    this.timeStamp,
  });

  factory ResStandardStoresModel.fromJson(Map<String, dynamic> json) => ResStandardStoresModel(
        error: json["Error"],
        data: json["Data"] == null ? null : StandardStoresData.fromJson(json["Data"]),
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

class StandardStoresData {
  int? count;
  List<StandardStores>? list;

  StandardStoresData({
    this.count,
    this.list,
  });

  factory StandardStoresData.fromJson(Map<String, dynamic> json) => StandardStoresData(
        count: json["Count"],
        list: json["List"] == null
            ? []
            : List<StandardStores>.from(json["List"]!.map((x) => StandardStores.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Count": count,
        "List": list == null ? [] : List<dynamic>.from(list!.map((x) => x.toJson())),
      };
}

class StandardStores {
  String? id;
  String? name;
  String? inStoreTimezone;
  String? dayEndTime;

  StandardStores({
    this.id,
    this.name,
    this.inStoreTimezone,
    this.dayEndTime,
  });

  factory StandardStores.fromJson(Map<String, dynamic> json) => StandardStores(
        id: json["ID"],
        name: json["Name"],
        inStoreTimezone: json["InStoreTimezone"],
        dayEndTime: json["DayEndTime"],
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "Name": name,
        "InStoreTimezone": inStoreTimezone,
        "DayEndTime": dayEndTime,
      };
}
