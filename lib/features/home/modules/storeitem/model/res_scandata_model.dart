class ResScanDataModel {
  bool? error;
  ScanData? data;
  int? code;
  String? message;
  DateTime? timeStamp;

  ResScanDataModel({
    this.error,
    this.data,
    this.code,
    this.message,
    this.timeStamp,
  });

  factory ResScanDataModel.fromJson(Map<String, dynamic> json) => ResScanDataModel(
        error: json["Error"],
        data: json["Data"] == null ? null : ScanData.fromJson(json["Data"]),
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

class ScanData {
  int? count;
  List<Scan>? list;

  ScanData({
    this.count,
    this.list,
  });

  factory ScanData.fromJson(Map<String, dynamic> json) => ScanData(
        count: json["Count"],
        list: json["List"] == null ? [] : List<Scan>.from(json["List"]!.map((x) => Scan.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Count": count,
        "List": list == null ? [] : List<dynamic>.from(list!.map((x) => x.toJson())),
      };
}

class Scan {
  dynamic storeId;
  String? name;
  String? manufacturer;
  dynamic type;
  String? id;
  String? createdBy;
  DateTime? createdOn;
  String? updatedBy;
  DateTime? updatedOn;
  bool? active;

  Scan({
    this.storeId,
    this.name,
    this.manufacturer,
    this.type,
    this.id,
    this.createdBy,
    this.createdOn,
    this.updatedBy,
    this.updatedOn,
    this.active,
  });

  factory Scan.fromJson(Map<String, dynamic> json) => Scan(
        storeId: json["StoreID"],
        name: json["Name"],
        manufacturer: json["Manufacturer"],
        type: json["Type"],
        id: json["ID"],
        createdBy: json["CreatedBy"],
        createdOn: json["CreatedOn"] == null ? null : DateTime.parse(json["CreatedOn"]),
        updatedBy: json["UpdatedBy"],
        updatedOn: json["UpdatedOn"] == null ? null : DateTime.parse(json["UpdatedOn"]),
        active: json["Active"],
      );

  Map<String, dynamic> toJson() => {
        "StoreID": storeId,
        "Name": name,
        "Manufacturer": manufacturer,
        "Type": type,
        "ID": id,
        "CreatedBy": createdBy,
        "CreatedOn": createdOn?.toIso8601String(),
        "UpdatedBy": updatedBy,
        "UpdatedOn": updatedOn?.toIso8601String(),
        "Active": active,
      };
}
