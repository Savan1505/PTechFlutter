class ReqEditStandardModel {
  String? id;
  String? name;
  double? percentage;
  List<String>? storeIdList;

  ReqEditStandardModel({
    this.id,
    this.name,
    this.percentage,
    this.storeIdList,
  });

  factory ReqEditStandardModel.fromJson(Map<String, dynamic> json) => ReqEditStandardModel(
        id: json["ID"],
        name: json["Name"],
        percentage: json["Percentage"],
        storeIdList:
            json["StoreIDList"] == null ? [] : List<String>.from(json["StoreIDList"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "Name": name,
        "Percentage": percentage,
        "StoreIDList": storeIdList == null ? [] : List<dynamic>.from(storeIdList!.map((x) => x)),
      };
}
