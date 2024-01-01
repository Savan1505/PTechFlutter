class ReqStandardModel {
  String? name;
  double? percentage;
  List<String>? storeIdList;

  ReqStandardModel({
    this.name,
    this.percentage,
    this.storeIdList,
  });

  factory ReqStandardModel.fromJson(Map<String, dynamic> json) => ReqStandardModel(
        name: json["Name"],
        percentage: json["Percentage"],
        storeIdList:
            json["StoreIDList"] == null ? [] : List<String>.from(json["StoreIDList"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "Name": name,
        "Percentage": percentage,
        "StoreIDList": storeIdList == null ? [] : List<dynamic>.from(storeIdList!.map((x) => x)),
      };
}
