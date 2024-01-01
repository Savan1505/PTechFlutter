class ResDeptTaxSlabModel {
  bool? error;
  TaxSlabData? data;
  int? code;
  String? message;
  DateTime? timeStamp;

  ResDeptTaxSlabModel({
    this.error,
    this.data,
    this.code,
    this.message,
    this.timeStamp,
  });

  factory ResDeptTaxSlabModel.fromJson(Map<String, dynamic> json) => ResDeptTaxSlabModel(
        error: json["Error"],
        data: json["Data"] == null ? null : TaxSlabData.fromJson(json["Data"]),
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

class TaxSlabData {
  int? count;
  List<TaxSlab>? list;

  TaxSlabData({
    this.count,
    this.list,
  });

  factory TaxSlabData.fromJson(Map<String, dynamic> json) => TaxSlabData(
        count: json["Count"],
        list: json["List"] == null
            ? []
            : List<TaxSlab>.from(json["List"]!.map((x) => TaxSlab.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Count": count,
        "List": list == null ? [] : List<dynamic>.from(list!.map((x) => x.toJson())),
      };
}

class TaxSlab {
  String? id;
  String? name;
  String? description;
  double? taxSlab;
  int? displaySeqNo;
  String? storeId;

  TaxSlab({
    this.id,
    this.name,
    this.description,
    this.taxSlab,
    this.displaySeqNo,
    this.storeId,
  });

  factory TaxSlab.fromJson(Map<String, dynamic> json) => TaxSlab(
        id: json["Id"],
        name: json["Name"],
        description: json["Description"],
        taxSlab: json["TaxSlab"],
        displaySeqNo: json["DisplaySeqNo"],
        storeId: json["StoreID"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "Name": name,
        "Description": description,
        "TaxSlab": taxSlab,
        "DisplaySeqNo": displaySeqNo,
        "StoreID": storeId,
      };
}
