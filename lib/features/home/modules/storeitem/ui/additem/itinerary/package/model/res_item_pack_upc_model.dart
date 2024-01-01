class ResItemPackUpcModel {
  bool? error;
  ItemPackUpcData? data;
  int? code;
  String? message;
  DateTime? timeStamp;

  ResItemPackUpcModel({
    this.error,
    this.data,
    this.code,
    this.message,
    this.timeStamp,
  });

  factory ResItemPackUpcModel.fromJson(Map<String, dynamic> json) => ResItemPackUpcModel(
        error: json["Error"],
        data: json["Data"] == null ? null : ItemPackUpcData.fromJson(json["Data"]),
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

class ItemPackUpcData {
  List<ItemPackUpc>? upcSeedData;
  bool? generationNeeded;

  ItemPackUpcData({
    this.upcSeedData,
    this.generationNeeded,
  });

  factory ItemPackUpcData.fromJson(Map<String, dynamic> json) => ItemPackUpcData(
        upcSeedData: json["UpcSeedData"] == null
            ? []
            : List<ItemPackUpc>.from(json["UpcSeedData"]!.map((x) => ItemPackUpc.fromJson(x))),
        generationNeeded: json["GenerationNeeded"],
      );

  Map<String, dynamic> toJson() => {
        "UpcSeedData":
            upcSeedData == null ? [] : List<dynamic>.from(upcSeedData!.map((x) => x.toJson())),
        "GenerationNeeded": generationNeeded,
      };
}

class ItemPackUpc {
  String? id;
  String? upc;

  ItemPackUpc({
    this.id,
    this.upc,
  });

  factory ItemPackUpc.fromJson(Map<String, dynamic> json) => ItemPackUpc(
        id: json["ID"],
        upc: json["UPC"],
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "UPC": upc,
      };
}
