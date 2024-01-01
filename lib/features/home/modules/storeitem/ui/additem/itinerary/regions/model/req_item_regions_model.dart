class ReqItemRegionsModel {
  String? name;
  String? description;
  List<String>? storeIdList;

  ReqItemRegionsModel({
    this.name,
    this.description,
    this.storeIdList,
  });

  factory ReqItemRegionsModel.fromJson(Map<String, dynamic> json) => ReqItemRegionsModel(
        name: json["Name"],
        description: json["Description"],
        storeIdList:
            json["StoreIDList"] == null ? [] : List<String>.from(json["StoreIDList"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "Name": name,
        "Description": description,
        "StoreIDList": storeIdList == null ? [] : List<dynamic>.from(storeIdList!.map((x) => x)),
      };
}
