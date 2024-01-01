class ResItemSkuModel {
  bool? error;
  ItemSkuData? data;
  int? code;
  String? message;
  DateTime? timeStamp;

  ResItemSkuModel({
    this.error,
    this.data,
    this.code,
    this.message,
    this.timeStamp,
  });

  factory ResItemSkuModel.fromJson(Map<String, dynamic> json) => ResItemSkuModel(
        error: json["Error"],
        data: json["Data"] == null ? null : ItemSkuData.fromJson(json["Data"]),
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

class ItemSkuData {
  List<SkuSeed>? skuSeedData;
  bool? generationNeeded;

  ItemSkuData({
    this.skuSeedData,
    this.generationNeeded,
  });

  factory ItemSkuData.fromJson(Map<String, dynamic> json) => ItemSkuData(
        skuSeedData: json["SkuSeedData"] == null
            ? []
            : List<SkuSeed>.from(json["SkuSeedData"]!.map((x) => SkuSeed.fromJson(x))),
        generationNeeded: json["GenerationNeeded"],
      );

  Map<String, dynamic> toJson() => {
        "SkuSeedData":
            skuSeedData == null ? [] : List<dynamic>.from(skuSeedData!.map((x) => x.toJson())),
        "GenerationNeeded": generationNeeded,
      };
}

class SkuSeed {
  String? id;
  String? sku;

  SkuSeed({
    this.id,
    this.sku,
  });

  factory SkuSeed.fromJson(Map<String, dynamic> json) => SkuSeed(
        id: json["ID"],
        sku: json["SKU"],
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "SKU": sku,
      };
}
